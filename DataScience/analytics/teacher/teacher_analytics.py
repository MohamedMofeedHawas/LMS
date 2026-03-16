import numpy as np
import pandas as pd


def run(tables: dict, results: dict) -> None:
    print("\n" + "="*65 + "\n  2 · Teacher Dashboard\n" + "="*65)

    courses        = tables["courses"]
    activities     = tables["activities"]
    progress       = tables["progress"]
    submissions    = tables["submissions"]
    enrollments    = tables["enrollments"]
    questions      = tables["questions"]
    answers        = tables["answers"]
    course_metrics = tables["course_metrics"]
    attempts       = tables["attempts"]
    student_perf   = tables["student_performance"]

    if not courses.empty and "InstructorId" in courses.columns:
        instructor_courses = courses[courses["InstructorId"].notna()].copy()
        instructor_courses["InstructorId"] = instructor_courses["InstructorId"].astype(int)
        INSTRUCTOR_IDS = sorted(instructor_courses["InstructorId"].unique())
        print(f"  {len(INSTRUCTOR_IDS)} instructors")
    else:
        instructor_courses = pd.DataFrame()
        INSTRUCTOR_IDS     = []

    # ── Course Overview ───────────────────────────────────────────────────────
    print("\n  [2.1] Course Overview")
    if not instructor_courses.empty and not course_metrics.empty:
        teacher_overview = instructor_courses.merge(
            course_metrics.rename(columns={"CourseId":"Id"}), on="Id", how="left", suffixes=("","_cm"),
        )
        keep = [c for c in ["InstructorId","Id","Title","DepartmentName","ActualEnrolledCount",
                              "CreditHours","AvgQuizScore","QuizPassRate","CompletionRate","TotalAttempts"]
                if c in teacher_overview.columns]
        results["teacher"]["course_overview"] = teacher_overview[keep].round(2)
        print(f"  {len(teacher_overview)} records")

    # ── Content Effectiveness ─────────────────────────────────────────────────
    print("\n  [2.2] Content Effectiveness")
    if not activities.empty and "CreatedById" in activities.columns and not progress.empty:
        if "ActivityId" in progress.columns:
            prog_agg = (
                progress.groupby("ActivityId")
                .agg(TotalStudents=("StudentId","count"), CompletionRate=("IsCompleted","mean"),
                     AvgProgress=("ProgressPercent","mean"), AvgTimeMinutes=("TotalTimeSpentMinutes","mean"))
                .reset_index().rename(columns={"ActivityId":"Id"})
            )
            content_eff = activities.merge(prog_agg, on="Id", how="left")
            if "EstimatedCompletionMinutes" in content_eff.columns and "AvgTimeMinutes" in content_eff.columns:
                est = content_eff["EstimatedCompletionMinutes"].replace(0, np.nan)
                content_eff["TimeEfficiencyRatio"] = (content_eff["AvgTimeMinutes"] / est).round(2)
            keep = [c for c in ["CreatedById","Id","Title","ActivityType","DifficultyLevel",
                                  "TotalStudents","CompletionRate","AvgProgress","AvgTimeMinutes","TimeEfficiencyRatio"]
                    if c in content_eff.columns]
            results["teacher"]["content_effectiveness"] = content_eff[keep].round(3)
            print(f"  {len(content_eff)} activities")

    # ── Grading Workload ──────────────────────────────────────────────────────
    print("\n  [2.3] Grading Workload")
    if not submissions.empty and "GradedById" in submissions.columns:
        _subs = submissions[submissions["GradedById"].isin(set(INSTRUCTOR_IDS))] if INSTRUCTOR_IDS else submissions
        grading = (
            _subs.groupby("GradedById")
            .agg(TotalGraded=("Id","count"), AvgGrade=("Grade","mean"),
                 AvgTurnaround=("GradingTurnAroundDays","mean"), LateCount=("IsLate","sum"))
            .round(2).reset_index().rename(columns={"GradedById":"InstructorId"})
        )
        if not instructor_courses.empty and not enrollments.empty:
            ungraded = (
                _subs[_subs["Status"] == "Submitted"]
                .merge(enrollments[["StudentProfileId","CourseId"]], left_on="StudentId", right_on="StudentProfileId", how="left")
                .merge(instructor_courses[["Id","InstructorId"]].rename(columns={"Id":"CourseId"}), on="CourseId", how="left")
                .groupby("InstructorId").agg(UngradedSubmissions=("Id","count")).reset_index()
            )
            grading = grading.merge(ungraded, on="InstructorId", how="left")
            grading["UngradedSubmissions"] = grading["UngradedSubmissions"].fillna(0).astype(int)
        results["teacher"]["grading_workload"] = grading
        print(f"  {len(grading)} instructors")

    # ── Question Difficulty ───────────────────────────────────────────────────
    print("\n  [2.4] Question Difficulty")
    if not questions.empty and not activities.empty and not answers.empty:
        if "IsCorrect" in answers.columns and "QuestionId" in answers.columns:
            q_stats = (
                answers[answers["IsCorrect"].isin([0,1])]
                .groupby("QuestionId")
                .agg(TimesAnswered=("IsCorrect","count"), CorrectCount=("IsCorrect","sum"))
                .reset_index()
            )
            q_stats["CorrectRate"]     = (q_stats["CorrectCount"] / q_stats["TimesAnswered"]).round(3)
            q_stats["DifficultyIndex"] = (1 - q_stats["CorrectRate"]).round(3)
            q_enriched = questions.merge(q_stats.rename(columns={"QuestionId":"Id"}), on="Id", how="left")
        else:
            q_enriched = questions.copy()
        quiz_acts = activities[activities["ActivityType"] == "Quiz"][["Id","CourseId","CreatedById"]].rename(columns={"Id":"QuizId"})
        q_full = q_enriched.merge(quiz_acts, on="QuizId", how="left").sort_values("DifficultyIndex", ascending=False)
        keep = [c for c in ["CreatedById","CourseId","Id","QuestionText","QuestionType",
                              "Marks","DifficultyIndex","CorrectRate","TimesAnswered"] if c in q_full.columns]
        results["teacher"]["question_difficulty"] = q_full[keep].round(3)
        print(f"  {len(q_full)} questions ranked")

    # ── Student Progress per Course ───────────────────────────────────────────
    print("\n  [2.5] Student Progress per Course")
    if not instructor_courses.empty and not progress.empty and not enrollments.empty:
        inst_ids = set(instructor_courses["Id"])
        enroll_f = enrollments[enrollments["CourseId"].isin(inst_ids)].copy()
        act_f    = activities[activities["CourseId"].isin(inst_ids)][["Id","CourseId"]].rename(columns={"Id":"ActivityId"})
        inst_progress = (
            enroll_f
            .merge(instructor_courses[["Id","InstructorId","Title"]].rename(columns={"Id":"CourseId"}), on="CourseId", how="inner")
            .merge(act_f, on="CourseId", how="left")
            .merge(progress[["StudentId","ActivityId","ProgressPercent","IsCompleted"]], on="ActivityId", how="left")
            .groupby(["InstructorId","CourseId","Title"])
            .agg(Students=("StudentProfileId","nunique"), AvgProgress=("ProgressPercent","mean"), CompletionRate=("IsCompleted","mean"))
            .round(3).reset_index()
        )
        results["teacher"]["student_progress_per_course"] = inst_progress
        print(f"  {len(inst_progress)} records")

    # ── Late Submissions ──────────────────────────────────────────────────────
    print("\n  [2.6] Late Submissions")
    if not submissions.empty and "IsLate" in submissions.columns and not instructor_courses.empty:
        late_by_course = (
            submissions
            .merge(enrollments[["StudentProfileId","CourseId"]].rename(columns={"StudentProfileId":"StudentId"}), on="StudentId", how="left")
            .merge(instructor_courses[["Id","InstructorId","Title"]].rename(columns={"Id":"CourseId"}), on="CourseId", how="inner")
            .groupby(["InstructorId","CourseId","Title"])
            .agg(TotalSubmissions=("Id","count"), LateCount=("IsLate","sum"), AvgGrade=("Grade","mean"))
            .round(2).reset_index()
        )
        late_by_course["LateRate"] = (late_by_course["LateCount"] / late_by_course["TotalSubmissions"] * 100).round(1)
        results["teacher"]["late_submissions"] = late_by_course
        print("  Done")

    # ── Instructor Effectiveness ──────────────────────────────────────────────
    print("\n  [2.7] Instructor Effectiveness")
    if not instructor_courses.empty and not course_metrics.empty:
        _cm_cols = [c for c in ["CourseId","ActualEnrolledCount","CompletionRate","AvgQuizScore","QuizPassRate"] if c in course_metrics.columns]
        _merged  = instructor_courses.merge(course_metrics[_cm_cols].rename(columns={"CourseId":"Id"}), on="Id", how="left")
        _agg = {"Courses": ("Id","count")}
        for col in ["CompletionRate","AvgQuizScore","QuizPassRate","ActualEnrolledCount"]:
            if col in _merged.columns:
                _agg[f"Avg_{col}" if col != "ActualEnrolledCount" else "TotalStudents"] = (col, "mean" if col != "ActualEnrolledCount" else "sum")
        inst_eff = _merged.groupby("InstructorId").agg(**_agg).round(3).reset_index()
        norm_inputs = [(c, 1 if "Rate" in c or "Completion" in c else 100) for c in ["Avg_CompletionRate","Avg_AvgQuizScore","Avg_QuizPassRate"] if c in inst_eff.columns]
        if norm_inputs:
            inst_eff["EffectivenessScore"] = sum((inst_eff[c] / n).clip(0,1) for c, n in norm_inputs).div(len(norm_inputs)).round(3)
            inst_eff = inst_eff.sort_values("EffectivenessScore", ascending=False)
        results["teacher"]["instructor_effectiveness"] = inst_eff
        print(f"  {len(inst_eff)} instructors")

    # ── Quiz Attempt Behavior per Instructor ──────────────────────────────────
    print("\n  [2.8] Quiz Attempt Behavior")
    if not attempts.empty and not instructor_courses.empty and not activities.empty:
        quiz_course = (
            activities[activities["ActivityType"] == "Quiz"][["Id","CourseId"]]
            .rename(columns={"Id":"QuizId"})
        )
        att_inst = (
            attempts.merge(quiz_course, on="QuizId", how="left")
            .merge(instructor_courses[["Id","InstructorId"]].rename(columns={"Id":"CourseId"}), on="CourseId", how="left")
            .dropna(subset=["InstructorId"])
        )
        attempt_behavior = (
            att_inst.groupby("InstructorId")
            .agg(
                TotalAttempts   =("Id",            "count"),
                AvgAttemptsPerQ =("AttemptNumber",  "mean"),
                PassRate        =("Passed",          "mean"),
                AvgScore        =("ScorePercent",    "mean"),
                RetriesCount    =("AttemptNumber",   lambda x: (x > 1).sum()),
            )
            .round(3).reset_index()
        )
        results["teacher"]["quiz_attempt_behavior"] = attempt_behavior
        print(f"  {len(attempt_behavior)} instructors")

    print(f"\n  ✅ Teacher: {len(results['teacher'])} tables")
