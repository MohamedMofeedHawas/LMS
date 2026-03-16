import numpy as np
import pandas as pd
from features.feature_utils import load, parse_dates, safe_divide, normalize_minmax


def _performance(attempts: pd.DataFrame) -> pd.DataFrame:
    if attempts.empty or "StudentId" not in attempts.columns:
        return pd.DataFrame(columns=["StudentId"])

    attempts = parse_dates(attempts, ["StartedAt"])
    attempts["Date"] = attempts["StartedAt"].dt.date

    g = (
        attempts.groupby("StudentId")
        .agg(
            QuizAttempts           =("Id",               "count"),
            AvgScore               =("ScorePercent",     "mean"),
            MinScore               =("ScorePercent",     "min"),
            ScoreStd               =("ScorePercent",     "std"),
            PassRate               =("Passed",           "mean"),
            AvgAttemptsPerQuiz     =("AttemptNumber",    "mean"),
            AvgTimePerQuizMin      =("TimeSpentMinutes", "mean"),
            ActiveDays             =("Date",             "nunique"),
            NightAttemptsCount     =("IsNightAttempt",   "sum"),
            WeekendAttemptsCount   =("StartedAt_Weekday",lambda x: (x >= 5).sum()),
            FailedAttempts         =("Passed",           lambda x: (x == 0).sum()),
            RetriesRaw             =("IsRetry",          "sum"),
        )
        .round(4).reset_index()
    )

    g["AvgAttemptsBeforeSuccess"] = (
        attempts[attempts["Passed"] == 1]
        .groupby("StudentId")["AttemptNumber"].mean()
        .reindex(g["StudentId"]).values
    )
    g["AvgAttemptsBeforeSuccess"] = g["AvgAttemptsBeforeSuccess"].fillna(1)
    g["ScoreStd"]                 = g["ScoreStd"].fillna(0)

    g["NightActivityRatio"]  = safe_divide(g["NightAttemptsCount"],   g["QuizAttempts"]).round(4)
    g["WeekendRatio"]        = safe_divide(g["WeekendAttemptsCount"], g["QuizAttempts"]).round(4)
    g["DaytimeActivityRatio"]= (1 - g["NightActivityRatio"]).round(4)
    g["FailureRatio"]        = safe_divide(g["FailedAttempts"],       g["QuizAttempts"]).round(4)
    g["DifficultyExposure"]  = safe_divide(g["RetriesRaw"],           g["QuizAttempts"]).round(4)
    g["EngagementPerDay"]    = safe_divide(g["QuizAttempts"],         g["ActiveDays"]).round(4)

    weekly = (
        attempts.assign(WeekBucket=lambda d: d.groupby("StudentId").cumcount() // 5)
        .groupby(["StudentId","WeekBucket"]).size().reset_index(name="WeeklyAtt")
    )
    consistency = (
        weekly.groupby("StudentId")["WeeklyAtt"]
        .std().fillna(0).rename("StudyConsistency").reset_index()
    )
    g = g.merge(consistency, on="StudentId", how="left")

    g.drop(columns=["NightAttemptsCount","WeekendAttemptsCount","FailedAttempts","RetriesRaw"], inplace=True)
    return g


def _progress(progress: pd.DataFrame, activities: pd.DataFrame) -> pd.DataFrame:
    if progress.empty or "StudentId" not in progress.columns:
        return pd.DataFrame(columns=["StudentId"])

    progress = parse_dates(progress, ["FirstAccessedAt","LastAccessedAt"])

    g = (
        progress.groupby("StudentId")
        .agg(
            CompletionRate      =("IsCompleted",           "mean"),
            ActivitiesCompleted =("IsCompleted",           "sum"),
            TotalActivities     =("ActivityId",            "count"),
            TotalTimeMinutes    =("TotalTimeSpentMinutes",  "sum"),
            AvgTimePerActivity  =("TotalTimeSpentMinutes",  "mean"),
        )
        .round(4).reset_index()
    )

    in_prog = (
        progress[progress["IsInProgress"] == 1]
        .groupby("StudentId").size()
        .rename("StartedNotFinished").reset_index()
    )
    g = g.merge(in_prog, on="StudentId", how="left")
    g["StartedNotFinished"]  = g["StartedNotFinished"].fillna(0)
    g["AbandonRate"]         = safe_divide(g["StartedNotFinished"], g["TotalActivities"]).round(4)
    g["RemainingActivities"] = (g["TotalActivities"] - g["ActivitiesCompleted"]).clip(lower=0)

    span = (
        progress.groupby("StudentId")
        .agg(First=("FirstAccessedAt","min"), Last=("LastAccessedAt","max"))
        .reset_index()
    )
    span["SpanDays"] = (span["Last"] - span["First"]).dt.days.clip(lower=1).fillna(1)
    g = g.merge(span[["StudentId","SpanDays"]], on="StudentId", how="left")
    g["LearningVelocity"]   = safe_divide(g["ActivitiesCompleted"], g["SpanDays"].fillna(1)).round(4)
    g["ProgressEfficiency"] = safe_divide(g["CompletionRate"],      g["TotalTimeMinutes"]).round(6)

    # clip extreme values caused by near-zero TotalTimeMinutes
    g["LearningVelocity"]   = g["LearningVelocity"].clip(upper=g["LearningVelocity"].quantile(0.99))
    g["ProgressEfficiency"] = g["ProgressEfficiency"].clip(upper=g["ProgressEfficiency"].quantile(0.99))

    g.drop(columns=["SpanDays","TotalActivities","StartedNotFinished"], inplace=True)

    if not activities.empty and "CourseId" in activities.columns:
        act_map   = activities[["Id","CourseId"]].rename(columns={"Id":"ActivityId"})
        prog_c    = progress.merge(act_map, on="ActivityId", how="left").dropna(subset=["CourseId"])
        course_cr = (
            prog_c.groupby(["StudentId","CourseId"])
            .agg(Done=("IsCompleted","sum"), Total=("ActivityId","count"))
            .reset_index()
        )
        course_cr["CR"] = safe_divide(course_cr["Done"], course_cr["Total"])
        c_done    = course_cr[course_cr["CR"] >= 0.70].groupby("StudentId").size().rename("CoursesCompleted")
        c_dropped = course_cr[course_cr["CR"] <  0.30].groupby("StudentId").size().rename("CoursesDropped")
        g = g.merge(c_done.reset_index(),    on="StudentId", how="left")
        g = g.merge(c_dropped.reset_index(), on="StudentId", how="left")
        g["CoursesCompleted"] = g["CoursesCompleted"].fillna(0).astype(int)
        g["CoursesDropped"]   = g["CoursesDropped"].fillna(0).astype(int)

    return g


def _behavior(submissions: pd.DataFrame, comments: pd.DataFrame, likes: pd.DataFrame) -> pd.DataFrame:
    result = pd.DataFrame()

    if not submissions.empty and "StudentId" in submissions.columns:
        sub = (
            submissions.groupby("StudentId")
            .agg(
                Submissions    =("Id",      "count"),
                AvgGrade       =("Grade",   "mean"),
                LateCount      =("IsLate",  "sum"),
            )
            .reset_index()
        )
        sub["LateRate"] = safe_divide(sub["LateCount"], sub["Submissions"]).round(4)
        sub.drop(columns=["LateCount"], inplace=True)

        if "SubmittedAt_Hour" in submissions.columns:
            avg_hour = (
                submissions.groupby("StudentId")["SubmittedAt_Hour"]
                .mean().rename("AvgSubmitHour").reset_index()
            )
            sub = sub.merge(avg_hour, on="StudentId", how="left")
        result = sub

    comm = pd.DataFrame()
    if not comments.empty and "UserId" in comments.columns:
        comm = (
            comments.groupby("UserId").size()
            .rename("CommentsCount").reset_index()
            .rename(columns={"UserId":"StudentId"})
        )

    lks = pd.DataFrame()
    if not likes.empty and "UserId" in likes.columns:
        lks = (
            likes.groupby("UserId").size()
            .rename("LikesGiven").reset_index()
            .rename(columns={"UserId":"StudentId"})
        )

    if not comm.empty:
        result = result.merge(comm, on="StudentId", how="outer") if not result.empty else comm
    if not lks.empty:
        result = result.merge(lks, on="StudentId", how="outer") if not result.empty else lks

    if result.empty:
        return pd.DataFrame(columns=["StudentId"])

    for col in ["CommentsCount","LikesGiven"]:
        if col not in result.columns:
            result[col] = 0

    result["SocialIsolationScore"] = (
        1.0 / (result["CommentsCount"].fillna(0) + result["LikesGiven"].fillna(0) + 1)
    ).round(4)

    return result


def _derived(feat: pd.DataFrame) -> pd.DataFrame:
    if "TotalTimeMinutes" in feat.columns and "EnrolledCourseCount" in feat.columns:
        feat["WorkloadPressure"] = safe_divide(
            feat["TotalTimeMinutes"], feat["EnrolledCourseCount"]
        ).round(4)
        feat["WorkloadPressure"] = feat["WorkloadPressure"].clip(
            upper=feat["WorkloadPressure"].quantile(0.99)
        )

    return feat


def _validate(feat: pd.DataFrame) -> tuple:
    label_cols   = {"Dropout","AtRisk","HighPerformer","CompositeScore","StudentId"}
    feature_cols = [c for c in feat.columns if c not in label_cols]
    report_rows  = []

    # drop zero-variance
    for col in feature_cols[:]:
        var  = feat[col].var()
        miss = feat[col].isna().mean()
        corr_dropout = feat[col].corr(feat["Dropout"]) if "Dropout" in feat.columns else 0
        report_rows.append({
            "Feature":        col,
            "Missing_Pct":    round(miss * 100, 2),
            "Variance":       round(var, 6),
            "Corr_Dropout":   round(corr_dropout, 4),
            "Skewness":       round(feat[col].skew(), 3),
            "Outliers_Pct":   round(((feat[col] - feat[col].mean()).abs() > 3 * feat[col].std()).mean() * 100, 2),
            "Dropped":        False,
            "Drop_Reason":    "",
        })

    low_var_cols = [r["Feature"] for r in report_rows if r["Variance"] < 1e-5]
    if low_var_cols:
        print(f"  [validation] Zero-variance removed: {low_var_cols}")
        feat.drop(columns=low_var_cols, inplace=True)
        for r in report_rows:
            if r["Feature"] in low_var_cols:
                r["Dropped"] = True
                r["Drop_Reason"] = "zero_variance"

    feature_cols = [c for c in feat.columns if c not in label_cols]
    num_cols     = [c for c in feature_cols if feat[c].dtype in ["float64","int64","int32","float32"]]
    corr_matrix  = feat[num_cols].corr().abs()
    upper        = corr_matrix.where(np.triu(np.ones(corr_matrix.shape), k=1).astype(bool))
    high_corr    = [c for c in upper.columns if any(upper[c] > 0.95)]
    if high_corr:
        print(f"  [validation] High-corr (>0.95) removed: {high_corr}")
        feat.drop(columns=high_corr, inplace=True)
        for r in report_rows:
            if r["Feature"] in high_corr:
                r["Dropped"] = True
                r["Drop_Reason"] = "high_correlation"

    report = pd.DataFrame(report_rows)
    return feat, report


def _labels(students: pd.DataFrame, prog_feat: pd.DataFrame, perf_feat: pd.DataFrame) -> pd.DataFrame:
    lbl = students[["Id"]].rename(columns={"Id":"StudentId"}).copy()
    lbl = lbl.merge(prog_feat[["StudentId","CompletionRate","ActivitiesCompleted"]], on="StudentId", how="left")
    lbl = lbl.merge(perf_feat[["StudentId","AvgScore","PassRate","QuizAttempts"]],  on="StudentId", how="left")

    for col in ["CompletionRate","ActivitiesCompleted","AvgScore","PassRate","QuizAttempts"]:
        lbl[col] = lbl[col].fillna(0)

    is_active = (lbl["QuizAttempts"] > 0) | (lbl["ActivitiesCompleted"] > 0)

    lbl["Dropout"] = (is_active & (lbl["CompletionRate"] < 0.25)).astype(int)

    lbl["AtRisk"] = (
        is_active &
        (lbl["CompletionRate"] >= 0.25) &
        (lbl["CompletionRate"] <  0.50)
    ).astype(int)

    has_quizzes = lbl["QuizAttempts"] > 0
    quiz_idx    = lbl[has_quizzes].index
    composite   = (
        lbl.loc[quiz_idx, "AvgScore"].rank(pct=True) * 0.6 +
        lbl.loc[quiz_idx, "PassRate"].rank(pct=True) * 0.4
    )
    top20_mask  = composite >= 0.80
    lbl["HighPerformer"] = 0
    lbl.loc[quiz_idx[top20_mask], "HighPerformer"] = 1

    lbl["CompositeScore"] = (
        normalize_minmax(lbl["AvgScore"])       * 0.40 +
        normalize_minmax(lbl["CompletionRate"]) * 0.35 +
        normalize_minmax(lbl["PassRate"])        * 0.25
    ).round(4)

    return lbl[["StudentId","Dropout","AtRisk","HighPerformer","CompositeScore"]]


def build_all() -> tuple:
    print("Building student features...")

    students    = load("students")
    attempts    = load("attempts")
    progress    = load("progress")
    activities  = load("activities")
    submissions = load("submissions")
    comments    = load("comments")
    likes       = load("likes")

    print("  [1] Performance + temporal features...")
    perf = _performance(attempts)

    print("  [2] Progress features...")
    prog = _progress(progress, activities)

    print("  [3] Behavior + social features...")
    beh  = _behavior(submissions, comments, likes)

    print("  [4] Labels...")
    lbl  = _labels(students, prog, perf)

    print("  [5] Merging...")
    base = students[[
        "Id","DepartmentId","YearId","SquadronId",
        "AdmissionYear","EnrolledCourseCount","TotalCreditLoad"
    ]].rename(columns={"Id":"StudentId"})

    feat = (
        base
        .merge(perf, on="StudentId", how="left")
        .merge(prog, on="StudentId", how="left")
        .merge(beh,  on="StudentId", how="left")
        .merge(lbl,  on="StudentId", how="left")
    )

    feat = feat.fillna(0)

    print("  [6] Derived features...")
    feat = _derived(feat)

    print("  [7] Feature validation + report...")
    feat, report = _validate(feat)

    print(f"\n  Done: {len(feat):,} students × {len(feat.columns)} features")
    return feat, report
