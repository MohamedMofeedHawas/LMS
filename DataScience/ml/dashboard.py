import numpy as np
import pandas as pd
from features.feature_utils import load
from ml.ml_utils import OUT_DIR


def run(df: pd.DataFrame, results: dict) -> None:
    students  = load("students")
    courses   = load("courses")
    course_ft = _load_csv(OUT_DIR.parent / "features" / "course_features.csv")

    # ── merge all student-level signals ───────────────────────────────────
    base = df[["StudentId","DepartmentId","YearId","SquadronId",
               "CompletionRate","AvgScore","FailureRatio","LateRate",
               "AbandonRate","LearningVelocity","SocialIsolationScore",
               "StudyConsistency"]].copy()

    for key in ["2_dropout_probabilities","3_atrisk_probabilities","4_highperf_probabilities"]:
        if key in results:
            base = base.merge(results[key], on="StudentId", how="left")

    if "1_3_student_clusters" in results:
        base = base.merge(results["1_3_student_clusters"][["StudentId","ClusterLabel"]],
                          on="StudentId", how="left")

    if "6_1_anomaly_students" in results:
        anom = results["6_1_anomaly_students"][["StudentId","AnomalyType"]].copy()
        anom["IsAnomaly"] = 1
        base = base.merge(anom, on="StudentId", how="left")
        base["IsAnomaly"]   = base["IsAnomaly"].fillna(0).astype(int)
        base["AnomalyType"] = base["AnomalyType"].fillna("")

    # add department name if available
    if not students.empty and "DepartmentName" in students.columns:
        dept = students[["Id","DepartmentName"]].rename(columns={"Id":"StudentId"})
        base = base.merge(dept, on="StudentId", how="left")

    base = base.fillna(0)

    # ── 1. Top risky students ──────────────────────────────────────────────
    risk_cols = [c for c in ["Dropout_Probability","AtRisk_Probability"] if c in base.columns]
    if risk_cols:
        base["CombinedRiskScore"] = base[risk_cols].mean(axis=1).round(4)
        top_risky = (
            base[base["CombinedRiskScore"] > 0]
            .sort_values("CombinedRiskScore", ascending=False)
            .head(200)
            [[c for c in ["StudentId","DepartmentName","ClusterLabel",
                           "CombinedRiskScore","Dropout_Probability",
                           "AtRisk_Probability","CompletionRate","AvgScore",
                           "FailureRatio","LateRate","IsAnomaly","AnomalyType"]
              if c in base.columns]]
        )
        results["dash_top_risky_students"] = top_risky.round(4)


    # ── 2. Department risk summary ─────────────────────────────────────────
    if "DepartmentName" in base.columns and "CombinedRiskScore" in base.columns:
        dept_risk = (
            base.groupby("DepartmentName")
            .agg(
                Students          =("StudentId",           "count"),
                AvgRiskScore      =("CombinedRiskScore",   "mean"),
                DropoutCount      =("Dropout_Predicted",   "sum")
                    if "Dropout_Predicted" in base.columns else ("StudentId","count"),
                AvgCompletion     =("CompletionRate",      "mean"),
                AvgScore          =("AvgScore",            "mean"),
            )
            .round(3).reset_index()
            .sort_values("AvgRiskScore", ascending=False)
        )
        results["dash_dept_risk_summary"] = dept_risk


    # ── 3. Cluster engagement patterns ────────────────────────────────────
    if "ClusterLabel" in base.columns:
        eng_cols = [c for c in ["CompletionRate","AvgScore","FailureRatio",
                                 "LateRate","AbandonRate","LearningVelocity",
                                 "StudyConsistency","SocialIsolationScore"]
                    if c in base.columns]
        cluster_patterns = (
            base.groupby("ClusterLabel")[eng_cols + ["StudentId"]]
            .agg({**{c:"mean" for c in eng_cols}, "StudentId":"count"})
            .rename(columns={"StudentId":"StudentCount"})
            .round(3).reset_index()
            .sort_values("StudentCount", ascending=False)
        )
        results["dash_cluster_engagement"] = cluster_patterns


    # ── 4. Course difficulty dashboard ────────────────────────────────────
    if not course_ft.empty:
        diff_cols = [c for c in ["CourseId","DepartmentId","CreditHours",
                                  "CompletionRate","DropoutRate","AvgQuizScore",
                                  "QuizPassRate","AvgAttempts","CourseDifficultyIndex",
                                  "AssignLateRate","EnrolledStudents"]
                     if c in course_ft.columns]
        if diff_cols:
            if not courses.empty and "Title" in courses.columns:
                titles = courses[["Id","Title"]].rename(columns={"Id":"CourseId"})
                diff_df = course_ft[diff_cols].merge(titles, on="CourseId", how="left")
            else:
                diff_df = course_ft[diff_cols].copy()

            if "CourseDifficultyIndex" in diff_df.columns:
                has_data = diff_df["CourseDifficultyIndex"] > 0
                scored   = diff_df.loc[has_data, "CourseDifficultyIndex"]
                diff_df["DifficultyLabel"] = "No Data"
                if len(scored) >= 3:
                    p50 = scored.quantile(0.50)
                    p75 = scored.quantile(0.75)
                    m1 = has_data & (diff_df["CourseDifficultyIndex"] <= p50)
                    m2 = has_data & (diff_df["CourseDifficultyIndex"] > p50) & (diff_df["CourseDifficultyIndex"] <= p75)
                    m3 = has_data & (diff_df["CourseDifficultyIndex"] > p75)
                    diff_df.loc[m1, "DifficultyLabel"] = "Easy"
                    diff_df.loc[m2, "DifficultyLabel"] = "Medium"
                    diff_df.loc[m3, "DifficultyLabel"] = "Hard"
            results["dash_course_difficulty"] = diff_df.sort_values(
                "CourseDifficultyIndex", ascending=False
            ).round(3)
            label_dist = diff_df["DifficultyLabel"].value_counts().to_dict() if "DifficultyLabel" in diff_df.columns else {}


    # ── 5. Weekly engagement patterns ─────────────────────────────────────
    if "5_1_weekly_signals" in results:
        weekly = results["5_1_weekly_signals"]
        weekly_summary = (
            weekly.groupby("Week")
            .agg(
                Students      =("StudentId",    "count"),
                AvgScore      =("AvgScore",      "mean"),
                EarlyRiskCount=("EarlyRisk",     "sum"),
                AvgPassRate   =("PassRate",       "mean"),
            )
            .round(3).reset_index()
        )
        weekly_summary["EarlyRiskPct"] = (
            weekly_summary["EarlyRiskCount"] / weekly_summary["Students"] * 100
        ).round(1)
        results["dash_weekly_engagement"] = weekly_summary


    # ── 6. Student full profile (combined view) ────────────────────────────
    results["dash_student_full_profile"] = base.round(4)
    print(f"  {len(results)} dashboard tables")


def _load_csv(path) -> pd.DataFrame:
    try:
        return pd.read_csv(path, low_memory=False)
    except Exception:
        return pd.DataFrame()
