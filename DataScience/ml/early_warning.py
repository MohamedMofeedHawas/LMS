import numpy as np
import pandas as pd
from features.feature_utils import load, parse_dates


def run(df: pd.DataFrame, results: dict) -> None:
    attempts = load("attempts")
    progress = load("progress")

    if attempts.empty and progress.empty:
        print("  Skipped — no data available")
        return

    weekly_rows = []

    if not attempts.empty:
        attempts = parse_dates(attempts, ["StartedAt"])
        attempts["Date"] = attempts["StartedAt"].dt.date
        anchor = (
            attempts.dropna(subset=["StudentId","StartedAt"])
            .groupby("StudentId")["StartedAt"].min()
            .rename("StartDate").reset_index()
        )
        att = attempts.merge(anchor, on="StudentId", how="left")
        att["DaysSinceStart"] = (att["StartedAt"] - att["StartDate"]).dt.days

        for week, (d0, d1) in enumerate([(0,7),(7,14),(14,21)], start=1):
            w = (
                att[att["DaysSinceStart"].between(d0, d1-1)]
                .groupby("StudentId")
                .agg(
                    QuizAttempts =("Id",            "count"),
                    AvgScore     =("ScorePercent",  "mean"),
                    PassRate     =("Passed",        "mean"),
                    FailureRatio =("Passed",        lambda x: (x==0).mean()),
                )
                .round(3).reset_index()
            )
            w["Week"] = week
            weekly_rows.append(w)

    if not progress.empty:
        progress = parse_dates(progress, ["FirstAccessedAt"])
        anchor_p = (
            progress.dropna(subset=["StudentId","FirstAccessedAt"])
            .groupby("StudentId")["FirstAccessedAt"].min()
            .rename("StartDate").reset_index()
        )
        prog = progress.merge(anchor_p, on="StudentId", how="left")
        prog["DaysSinceStart"] = (prog["FirstAccessedAt"] - prog["StartDate"]).dt.days

        for week, (d0, d1) in enumerate([(0,7),(7,14),(14,21)], start=1):
            wp = (
                prog[prog["DaysSinceStart"].between(d0, d1-1)]
                .groupby("StudentId")
                .agg(
                    ActivitiesAccessed =("ActivityId",     "count"),
                    AvgProgress        =("ProgressPercent","mean"),
                    CompletedInWeek    =("IsCompleted",    "sum"),
                )
                .round(3).reset_index()
            )
            wp["Week"] = week
            if weekly_rows:
                for i, r in enumerate(weekly_rows):
                    if not r.empty and r["Week"].iloc[0] == week:
                        weekly_rows[i] = r.merge(wp, on=["StudentId","Week"], how="outer")
                        break
            else:
                weekly_rows.append(wp)

    if not weekly_rows:
        print("  Skipped — no weekly data")
        return

    weekly_df = pd.concat(weekly_rows, ignore_index=True).fillna(0)

    # composite risk score per student per week — percentile-based
    score_components = []
    if "FailureRatio"   in weekly_df.columns: score_components.append(weekly_df["FailureRatio"])
    if "AvgScore"       in weekly_df.columns: score_components.append(1 - weekly_df["AvgScore"].clip(0,100)/100)
    if "PassRate"       in weekly_df.columns: score_components.append(1 - weekly_df["PassRate"].clip(0,1))

    if score_components:
        weekly_df["RawRiskScore"] = sum(score_components) / len(score_components)
        # flag top 20% within each week as early-risk (percentile-based)
        weekly_df["EarlyRisk"] = 0
        for week in weekly_df["Week"].unique():
            mask  = weekly_df["Week"] == week
            week_scores = weekly_df.loc[mask, "RawRiskScore"]
            active_mask = mask & (weekly_df.get("QuizAttempts", pd.Series(0, index=weekly_df.index)) > 0)
            if active_mask.sum() > 0:
                threshold = weekly_df.loc[active_mask, "RawRiskScore"].quantile(0.80)
                weekly_df.loc[active_mask & (weekly_df["RawRiskScore"] >= threshold), "EarlyRisk"] = 1
    else:
        weekly_df["EarlyRisk"] = 0

    final_labels = df[["StudentId","Dropout","AtRisk","HighPerformer"]].copy()
    weekly_df    = weekly_df.merge(final_labels, on="StudentId", how="left")

    results["5_1_weekly_signals"] = weekly_df.round(3)

    w1 = weekly_df[weekly_df["Week"] == 1]
    if not w1.empty and "Dropout" in w1.columns and "EarlyRisk" in w1.columns:
        w1_outcome = (
            w1.groupby("EarlyRisk")
            .agg(
                Students    =("StudentId", "count"),
                AvgScore    =("AvgScore",  "mean"),
                DropoutRate =("Dropout",   "mean"),
                AtRiskRate  =("AtRisk",    "mean"),
            )
            .round(3).reset_index()
        )
        w1_outcome["EarlyRisk"] = w1_outcome["EarlyRisk"].map({0:"Safe", 1:"Early-Risk"})
        results["5_2_week1_vs_outcome"] = w1_outcome

    print(f"  {len(weekly_df):,} student-week records")
    for w in [1,2,3]:
        wr = weekly_df[weekly_df["Week"] == w]
        if "EarlyRisk" in wr.columns:
            n   = int(wr["EarlyRisk"].sum())
            pct = round(n / len(wr) * 100, 1) if len(wr) > 0 else 0
            print(f"    Week {w}: {n} early-risk ({pct}%)")
