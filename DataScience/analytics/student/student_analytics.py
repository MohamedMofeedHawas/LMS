import numpy as np
import pandas as pd


def run(tables: dict, results: dict) -> None:
    print("\n" + "="*65 + "\n  3 · Student Dashboard\n" + "="*65)

    students     = tables["students"]
    courses      = tables["courses"]
    activities   = tables["activities"]
    attempts     = tables["attempts"]
    submissions  = tables["submissions"]
    progress     = tables["progress"]
    answers      = tables["answers"]
    questions    = tables["questions"]
    student_perf = tables["student_performance"]

    # ── Rankings ──────────────────────────────────────────────────────────────
    print("\n  [3.1] Rankings")
    if not student_perf.empty and not students.empty:
        ranked = student_perf.merge(
            students[["Id","DepartmentId","DepartmentName","YearId","SquadronId"]].rename(columns={"Id":"StudentId"}),
            on="StudentId", how="left",
        )
        quiz_norm  = (ranked["AvgQuizScore"].clip(0,100) / 100.0).fillna(0) if "AvgQuizScore"   in ranked.columns else pd.Series(0.0, index=ranked.index)
        comp_norm  =  ranked["CompletionRate"].clip(0,1).fillna(0)           if "CompletionRate" in ranked.columns else pd.Series(0.0, index=ranked.index)
        grade_norm = (ranked["AvgGrade"].clip(0,100)     / 100.0).fillna(0) if "AvgGrade"       in ranked.columns else pd.Series(0.0, index=ranked.index)

        ranked["CompositeScore"] = (quiz_norm * 0.50 + comp_norm * 0.30 + grade_norm * 0.20).round(4)
        ranked["OverallRank"]    = ranked["CompositeScore"].rank(ascending=False, method="min").astype(int)
        ranked["DeptRank"]       = ranked.groupby("DepartmentName")["CompositeScore"].rank(ascending=False, method="min").astype(int)
        ranked["SquadronRank"]   = ranked.groupby("SquadronId")["CompositeScore"].rank(ascending=False, method="min").astype(int)

        keep = [c for c in ["StudentId","OverallRank","DeptRank","SquadronRank",
                              "CompositeScore","AvgQuizScore","AvgGrade","QuizPassRate",
                              "CompletionRate","DepartmentName","SquadronId"] if c in ranked.columns]
        results["student"]["rankings"] = ranked[keep].sort_values("OverallRank").round(4)
        print(f"  {len(ranked):,} students ranked")

    # ── Class & Department Averages ───────────────────────────────────────────
    print("\n  [3.2] Benchmarks")
    if not student_perf.empty and not students.empty:
        perf_cols = [c for c in ["AvgQuizScore","AvgGrade","QuizPassRate","CompletionRate"] if c in student_perf.columns]
        _sp = student_perf[["StudentId"] + perf_cols].copy()
        for col in ["AvgGrade","CompletionRate"]:
            if col in _sp.columns:
                _sp.loc[_sp[col] == 0, col] = np.nan
        _ca = _sp[perf_cols].mean().round(2).reset_index()
        _ca.columns = ["Metric","ClassAvg"]
        results["student"]["class_avg"] = _ca
        results["student"]["dept_avg"] = (
            _sp.merge(students[["Id","DepartmentName"]].rename(columns={"Id":"StudentId"}), on="StudentId", how="left")
            .groupby("DepartmentName")[perf_cols].mean().round(2).reset_index()
        )
        print("  Done")

    # ── Improvement Trend ─────────────────────────────────────────────────────
    print("\n  [3.3] Improvement Trend")
    if not attempts.empty and "StartedAt" in attempts.columns and "ScorePercent" in attempts.columns:
        trend = (
            attempts.dropna(subset=["StudentId","StartedAt","ScorePercent"])
            .assign(Month=lambda d: d["StartedAt"].dt.to_period("M").astype(str))
            .groupby(["StudentId","Month"])
            .agg(AvgScore=("ScorePercent","mean"), Attempts=("Id","count"), PassRate=("Passed","mean"))
            .round(2).reset_index().sort_values(["StudentId","Month"])
        )
        results["student"]["improvement_trend"] = trend
        _first = trend.groupby("StudentId").first()["AvgScore"].rename("FirstScore")
        _last  = trend.groupby("StudentId").last()["AvgScore"].rename("LastScore")
        delta  = pd.concat([_first, _last], axis=1).reset_index()
        delta["ScoreDelta"] = (delta["LastScore"] - delta["FirstScore"]).round(2)
        delta["Trajectory"] = delta["ScoreDelta"].apply(lambda x: "Improving" if x > 2 else ("Declining" if x < -2 else "Stable"))
        results["student"]["score_delta"] = delta.sort_values("ScoreDelta", ascending=False)
        n_imp = int((delta["Trajectory"] == "Improving").sum())
        n_dec = int((delta["Trajectory"] == "Declining").sum())
        print(f"  ↑ {n_imp} improving  ↓ {n_dec} declining")

    # ── Time to Completion ────────────────────────────────────────────────────
    print("\n  [3.4] Time to Completion")
    if not progress.empty and "FirstAccessedAt" in progress.columns and "CompletedAt" in progress.columns:
        _pt = progress.dropna(subset=["FirstAccessedAt","CompletedAt"]).copy()
        _pt["DaysToComplete"] = (_pt["CompletedAt"] - _pt["FirstAccessedAt"]).dt.days
        _pt = _pt[_pt["DaysToComplete"] >= 0]
        if not _pt.empty:
            per_course = (
                _pt
                .merge(activities[["Id","CourseId"]].rename(columns={"Id":"ActivityId"}), on="ActivityId", how="left")
                .dropna(subset=["CourseId"])
                .groupby("CourseId")
                .agg(AvgDays=("DaysToComplete","mean"), MedianDays=("DaysToComplete","median"), StudentCount=("StudentId","nunique"))
                .round(1).reset_index()
            )
            if "Title" in courses.columns:
                per_course = per_course.merge(courses[["Id","Title"]].rename(columns={"Id":"CourseId"}), on="CourseId", how="left")
            results["student"]["time_to_completion"] = per_course.sort_values("AvgDays", ascending=False)
            print(f"  {len(_pt):,} completions analysed")

    # ── Top & Bottom Performers ───────────────────────────────────────────────
    print("\n  [3.5] Top & Bottom Performers")
    if not student_perf.empty and "AvgQuizScore" in student_perf.columns:
        _mp  = student_perf.merge(students[["Id","DepartmentName"]].rename(columns={"Id":"StudentId"}), on="StudentId", how="left")
        cols = [c for c in ["StudentId","AvgQuizScore","AvgGrade","QuizPassRate","CompletionRate","DepartmentName"] if c in _mp.columns]
        results["student"]["top_performers"]    = _mp.nlargest(20,  "AvgQuizScore")[cols].round(2)
        results["student"]["bottom_performers"] = _mp.nsmallest(20, "AvgQuizScore")[cols].round(2)
        print("  Done")

    # ── Strengths & Weaknesses by Question Type ───────────────────────────────
    print("\n  [3.6] Strengths & Weaknesses")
    if not answers.empty and not attempts.empty and not questions.empty:
        _ans = (
            answers
            .merge(attempts[["Id","StudentId"]].rename(columns={"Id":"QuizAttemptId"}), on="QuizAttemptId", how="left")
            .merge(questions[["Id","QuestionType"]].rename(columns={"Id":"QuestionId"}), on="QuestionId", how="left")
        )
        if "QuestionType" in _ans.columns and "IsCorrect" in _ans.columns:
            sw = (
                _ans[_ans["IsCorrect"].isin([0,1])]
                .groupby(["StudentId","QuestionType"])
                .agg(Answered=("IsCorrect","count"), CorrectCount=("IsCorrect","sum"))
                .reset_index()
            )
            sw["CorrectRate"] = (sw["CorrectCount"] / sw["Answered"]).round(3)
            results["student"]["strengths_weaknesses"] = sw
            print(f"  {len(sw):,} records")

    # ── Per-Course Progress ───────────────────────────────────────────────────
    print("\n  [3.7] Per-Course Progress")
    if not progress.empty and not activities.empty:
        course_prog = (
            progress
            .merge(activities[["Id","CourseId"]].rename(columns={"Id":"ActivityId"}), on="ActivityId", how="left")
            .dropna(subset=["CourseId"])
            .groupby(["StudentId","CourseId"])
            .agg(ActivitiesTotal=("ActivityId","count"), ActivitiesDone=("IsCompleted","sum"),
                 AvgProgress=("ProgressPercent","mean"), AvgTimeMinutes=("TotalTimeSpentMinutes","mean"))
            .reset_index()
        )
        course_prog["CompletionRate"] = (course_prog["ActivitiesDone"] / course_prog["ActivitiesTotal"]).round(3)
        if "Title" in courses.columns:
            course_prog = course_prog.merge(courses[["Id","Title"]].rename(columns={"Id":"CourseId"}), on="CourseId", how="left")
        results["student"]["course_progress"] = course_prog.round(3)
        print(f"  {len(course_prog):,} records")

    # ── Late Submission Impact ────────────────────────────────────────────────
    print("\n  [3.8] Late Submission Impact")
    if not submissions.empty and "IsLate" in submissions.columns and "Grade" in submissions.columns:
        results["student"]["late_submission_impact"] = (
            submissions.groupby("IsLate")
            .agg(Count=("Id","count"), AvgGrade=("Grade","mean"))
            .round(2).reset_index()
            .assign(IsLate=lambda d: d["IsLate"].map({0:"On Time",1:"Late"}))
        )
        print("  Done")

    # ── Student Segmentation (percentile-based, consistent with ML labels) ─────
    print("\n  [3.9] Student Segmentation")
    if not student_perf.empty:
        seg = student_perf.copy()
        has_quizzes = seg["QuizAttempts"] > 0
        is_active   = (seg["QuizAttempts"] > 0) | (seg["CompletionRate"] > 0)

        # composite rank score — same logic as build_features.py HighPerformer label
        composite = (
            seg["AvgQuizScore"].rank(pct=True) * 0.40 +
            seg["CompletionRate"].rank(pct=True) * 0.35 +
            seg["QuizPassRate"].rank(pct=True) * 0.25
        )
        seg["Segment"] = "Inactive"
        seg.loc[is_active,                                   "Segment"] = "At Risk"
        seg.loc[is_active & (composite >= 0.40),             "Segment"] = "Average Learner"
        seg.loc[is_active & (composite >= 0.70),             "Segment"] = "High Achiever"
        # HighPerformer = top 20% of quiz-takers (consistent with ML label)
        quiz_composite = composite[has_quizzes]
        top20_threshold = quiz_composite.quantile(0.80) if len(quiz_composite) > 0 else 999
        seg.loc[has_quizzes & (composite >= top20_threshold),"Segment"] = "Top Performer"

        seg_summary = (
            seg.groupby("Segment")
            .agg(Students=("StudentId","count"), AvgQuizScore=("AvgQuizScore","mean"),
                 CompletionRate=("CompletionRate","mean"), QuizPassRate=("QuizPassRate","mean"))
            .round(2).reset_index()
        )
        seg_summary["Pct"] = (seg_summary["Students"] / len(seg) * 100).round(1)
        results["student"]["segmentation_summary"] = seg_summary
        results["student"]["student_segments"]     = seg[["StudentId","Segment"]].copy()
        print(f"  {len(seg_summary)} segments")

    # ── Activity Abandonment ──────────────────────────────────────────────────
    print("\n  [3.10] Activity Abandonment")
    if not progress.empty and "Status" in progress.columns:
        abandon = (
            progress[progress["Status"] == "InProgress"]
            .groupby("ActivityId")
            .agg(AbandonedCount=("StudentId","count"), AvgProgressAtAbandon=("ProgressPercent","mean"))
            .round(2).reset_index()
            .sort_values("AbandonedCount", ascending=False)
        )
        if not activities.empty and "Title" in activities.columns:
            abandon = abandon.merge(activities[["Id","Title","ActivityType"]].rename(columns={"Id":"ActivityId"}), on="ActivityId", how="left")
        results["student"]["activity_abandonment"] = abandon
        print(f"  {len(abandon)} activities with abandonment data")

# ── Learning Efficiency (score per minute spent) ───────────────────────────
    print("\n  [3.11] Learning Efficiency")
    if not attempts.empty and "ScorePercent" in attempts.columns and "TimeSpentMinutes" in attempts.columns:
        _eff = attempts[attempts["TimeSpentMinutes"] > 0].copy()
        _eff["LearningEfficiency"] = (_eff["ScorePercent"] / _eff["TimeSpentMinutes"]).round(4)
        efficiency = (
            _eff.groupby("StudentId")
            .agg(
                AvgEfficiency   =("LearningEfficiency", "mean"),
                AvgScore        =("ScorePercent",       "mean"),
                AvgTimeMinutes  =("TimeSpentMinutes",   "mean"),
                TotalAttempts   =("Id",                 "count"),
            )
            .round(3).reset_index()
        )
        efficiency["EfficiencyTier"] = pd.cut(
            efficiency["AvgEfficiency"],
            bins=[-0.01, efficiency["AvgEfficiency"].quantile(0.33),
                  efficiency["AvgEfficiency"].quantile(0.66), float("inf")],
            labels=["Low", "Medium", "High"],
            duplicates="drop",
        )
        results["student"]["learning_efficiency"] = efficiency
        print(f"  {len(efficiency):,} students")

    # ── Student Workload (submissions per week) ────────────────────────────────
    print("\n  [3.12] Student Workload")
    if not submissions.empty and "SubmittedAt" in submissions.columns:
        _sw = submissions.dropna(subset=["StudentId","SubmittedAt"]).copy()
        _sw["Week"] = _sw["SubmittedAt"].dt.to_period("W").astype(str)
        weekly_workload = (
            _sw.groupby(["StudentId","Week"])
            .agg(SubmissionsPerWeek=("Id","count"), AvgGrade=("Grade","mean"))
            .reset_index()
        )
        workload_summary = (
            weekly_workload.groupby("StudentId")
            .agg(
                AvgSubmissionsPerWeek=("SubmissionsPerWeek", "mean"),
                MaxSubmissionsInWeek =("SubmissionsPerWeek", "max"),
                ActiveWeeks          =("Week",               "nunique"),
            )
            .round(2).reset_index()
        )
        workload_summary["WorkloadTier"] = pd.cut(
            workload_summary["AvgSubmissionsPerWeek"],
            bins=[-0.01, 1, 3, float("inf")],
            labels=["Light", "Moderate", "Heavy"],
        )
        results["student"]["student_workload"] = workload_summary
        print(f"  {len(workload_summary):,} students")

    # ── Feature Engineering Table (ML-ready input) ────────────────────────────
    print("\n  [3.13] Feature Engineering Table")
    if not student_perf.empty and not tables["engagement"].empty:
        eng   = tables["engagement"]
        feats = student_perf.merge(eng[["StudentId","ActionCount","LoginCount","CommentsCount","LikesGiven"]], on="StudentId", how="left")

        if not submissions.empty and "IsLate" in submissions.columns:
            late = (
                submissions.groupby("StudentId")
                .agg(TotalSubs=("Id","count"), LateSubs=("IsLate","sum"))
                .reset_index()
            )
            late["LateRate"] = (late["LateSubs"] / late["TotalSubs"]).round(3)
            feats = feats.merge(late[["StudentId","LateRate"]], on="StudentId", how="left")

        if not students.empty:
            feats = feats.merge(
                students[["Id","EnrolledCourseCount","TotalCreditLoad","AdmissionYear","DepartmentId"]].rename(columns={"Id":"StudentId"}),
                on="StudentId", how="left"
            )

        # normalize engagement into 0-1 score
        for col in ["ActionCount","LoginCount"]:
            if col in feats.columns:
                mx = feats[col].max()
                feats[f"{col}_norm"] = (feats[col] / (mx + 1)).round(4) if mx > 0 else 0

        feats["EngagementScore"] = (
            feats.get("ActionCount_norm", 0) * 0.6 +
            feats.get("LoginCount_norm",  0) * 0.4
        ).round(4)

        # drop PII and leakage columns
        drop_cols = ["RiskScore","EnhancedRiskScore","AtRisk","FinalGrade",
                     "ActionCount_norm","LoginCount_norm"]
        feats = feats.drop(columns=[c for c in drop_cols if c in feats.columns])
        feats = feats.fillna(0)

        results["student"]["ml_feature_table"] = feats.round(4)
        print(f"  {len(feats)} students  ×  {len(feats.columns)} features")

    print(f"\n  ✅ Student: {len(results['student'])} tables")
