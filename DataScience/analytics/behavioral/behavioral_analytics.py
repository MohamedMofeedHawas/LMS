import pandas as pd


def run(tables: dict, results: dict) -> None:
    print("\n" + "="*65 + "\n  4 · Behavioral Analytics\n" + "="*65)

    students       = tables["students"]
    courses        = tables["courses"]
    activities     = tables["activities"]
    attempts       = tables["attempts"]
    progress       = tables["progress"]
    activity_log   = tables["activity_log"]
    enrollments    = tables["enrollments"]
    comments       = tables["comments"]
    engagement     = tables["engagement"]
    student_perf   = tables["student_performance"]
    course_metrics = tables["course_metrics"]

    if not courses.empty and "InstructorId" in courses.columns:
        instructor_courses = courses[courses["InstructorId"].notna()].copy()
        instructor_courses["InstructorId"] = instructor_courses["InstructorId"].astype(int)
    else:
        instructor_courses = pd.DataFrame()

    # ── Early Dropout Signals ─────────────────────────────────────────────────
    print("\n  [4.1] Early Dropout Signals")
    if not activity_log.empty and not enrollments.empty and not students.empty:
        _sids = set(students["Id"])
        _log  = activity_log[activity_log["UserId"].isin(_sids)].copy()
        if not _log.empty and "EnrollmentDate" in enrollments.columns:
            enroll_start = (
                enrollments.groupby("StudentProfileId")["EnrollmentDate"].min()
                .reset_index().rename(columns={"StudentProfileId":"StudentId","EnrollmentDate":"StartDate"})
            )
            _log = _log.merge(enroll_start.rename(columns={"StudentId":"UserId"}), on="UserId", how="left")
            _log["DaysSinceStart"] = (_log["Timestamp"] - _log["StartDate"]).dt.days
            first_week = (
                _log[_log["DaysSinceStart"].between(0,7)]
                .groupby("UserId").size().reset_index(name="FirstWeekActions")
                .rename(columns={"UserId":"StudentId"})
            )
            if not student_perf.empty:
                dropout_signals = first_week.merge(
                    student_perf[["StudentId","AvgQuizScore","CompletionRate","QuizPassRate"]],
                    on="StudentId", how="inner",
                )
                dropout_signals["FirstWeekBucket"] = pd.cut(
                    dropout_signals["FirstWeekActions"],
                    bins=[-1,0,3,10,9999], labels=["Zero","Low 1-3","Medium 4-10","High 10+"],
                )
                results["admin"]["early_dropout_signals"] = (
                    dropout_signals.groupby("FirstWeekBucket")
                    .agg(Students=("StudentId","count"), AvgQuizScore=("AvgQuizScore","mean"),
                         CompletionRate=("CompletionRate","mean"), QuizPassRate=("QuizPassRate","mean"))
                    .round(3).reset_index()
                )
                print(f"  {len(dropout_signals):,} students")
    else:
        print("  Skipped")

    # ── Course Difficulty Index ───────────────────────────────────────────────
    print("\n  [4.2] Course Difficulty Index")
    if not course_metrics.empty and all(c in course_metrics.columns for c in ["QuizPassRate","CompletionRate","AvgQuizScore"]):
        _cm = course_metrics.copy()
        _cm["CourseDifficultyIndex"] = (
            (1 - _cm["QuizPassRate"].clip(0,1))         * 0.4 +
            (1 - _cm["CompletionRate"].clip(0,1))        * 0.3 +
            (1 - _cm["AvgQuizScore"].clip(0,100) / 100) * 0.3
        ).round(3)
        keep = [c for c in ["CourseId","Title","DepartmentName","CourseDifficultyIndex",
                              "QuizPassRate","CompletionRate","AvgQuizScore","TotalAttempts"] if c in _cm.columns]
        results["admin"]["course_difficulty_index"] = _cm[keep].sort_values("CourseDifficultyIndex", ascending=False).round(3)
        print(f"  {len(_cm)} courses")

    # ── Learning Path ─────────────────────────────────────────────────────────
    print("\n  [4.3] Learning Path")
    if not attempts.empty and not progress.empty and "StartedAt" in attempts.columns:
        first_act = (
            progress
            .merge(activities[["Id","CourseId"]].rename(columns={"Id":"ActivityId"}), on="ActivityId", how="left")
            .dropna(subset=["FirstAccessedAt","CourseId"])
            .groupby(["StudentId","CourseId"])["FirstAccessedAt"].min().reset_index()
            .rename(columns={"FirstAccessedAt":"FirstActivityAt"})
        )
        first_quiz = (
            attempts.dropna(subset=["StartedAt"])
            .merge(activities[["Id","CourseId"]].rename(columns={"Id":"QuizId"}), on="QuizId", how="left")
            .dropna(subset=["CourseId"])
            .groupby(["StudentId","CourseId"])["StartedAt"].min().reset_index()
            .rename(columns={"StartedAt":"FirstQuizAt"})
        )
        lp = first_act.merge(first_quiz, on=["StudentId","CourseId"], how="inner")
        lp["StudiedFirst"] = (lp["FirstActivityAt"] <= lp["FirstQuizAt"]).astype(int)
        _sp_lp = student_perf[["StudentId","AvgQuizScore","QuizPassRate"]] if not student_perf.empty else pd.DataFrame(columns=["StudentId","AvgQuizScore","QuizPassRate"])
        results["admin"]["learning_path"] = (
            lp.merge(_sp_lp, on="StudentId", how="left")
            .groupby("StudiedFirst")
            .agg(Students=("StudentId","count"), AvgQuizScore=("AvgQuizScore","mean"), PassRate=("QuizPassRate","mean"))
            .round(2).reset_index()
            .assign(Label=lambda d: d["StudiedFirst"].map({1:"Studied first",0:"Quiz first"}))
        )
        print(f"  {len(lp):,} pairs")

    # ── Social Learning Impact ────────────────────────────────────────────────
    print("\n  [4.4] Social Learning Impact")
    if not engagement.empty and not student_perf.empty and "CommentsCount" in engagement.columns:
        social = engagement.merge(student_perf[["StudentId","AvgQuizScore","QuizPassRate"]], on="StudentId", how="inner")
        social["CommentBucket"] = pd.cut(social["CommentsCount"], bins=[-1,0,3,10,9999], labels=["None","Low 1-3","Medium 4-10","High 10+"])
        results["admin"]["social_learning_impact"] = (
            social.groupby("CommentBucket")
            .agg(Students=("StudentId","count"), AvgQuizScore=("AvgQuizScore","mean"), PassRate=("QuizPassRate","mean"))
            .round(3).reset_index()
        )
        print("  Done")

    # ── Burnout Pattern ───────────────────────────────────────────────────────
    print("\n  [4.5] Burnout Pattern")
    if not progress.empty and "StudentId" in progress.columns and "LastAccessedAt" in progress.columns:
        _prg = progress.dropna(subset=["StudentId","LastAccessedAt"]).copy()
        _prg["Month"] = _prg["LastAccessedAt"].dt.to_period("M").astype(str)
        monthly_act  = _prg.groupby(["StudentId","Month"]).size().reset_index(name="Activities").sort_values(["StudentId","Month"])
        active_months = monthly_act.groupby("StudentId")["Month"].nunique()
        burnout_data  = monthly_act[monthly_act["StudentId"].isin(active_months[active_months >= 4].index)].copy()
        if not burnout_data.empty:
            half = burnout_data.groupby("StudentId").apply(
                lambda g: pd.Series({
                    "FirstHalfAvg":  g.iloc[:len(g)//2]["Activities"].mean(),
                    "SecondHalfAvg": g.iloc[len(g)//2:]["Activities"].mean(),
                    "ActiveMonths":  len(g),
                })
            ).reset_index()
            half["ActivityDrop"] = (half["FirstHalfAvg"] - half["SecondHalfAvg"]).round(2)
            half["BurnoutFlag"]  = ((half["FirstHalfAvg"] > 0) & (half["ActivityDrop"] > half["FirstHalfAvg"] * 0.4)).astype(int)
            results["admin"]["burnout_summary"] = pd.DataFrame([{
                "TotalStudentsAnalysed": len(half),
                "BurnoutCount":          int(half["BurnoutFlag"].sum()),
                "BurnoutPct":            round(half["BurnoutFlag"].mean() * 100, 1),
                "AvgActivityDrop":       round(half["ActivityDrop"].mean(), 2),
            }]).T.reset_index().rename(columns={0:"Value","index":"Metric"})
            print(f"  {int(half['BurnoutFlag'].sum())} / {len(half)} students flagged")

    # ── Assignment vs Quiz Pattern ────────────────────────────────────────────
    print("\n  [4.6] Assignment vs Quiz Pattern")
    if not student_perf.empty and all(c in student_perf.columns for c in ["AvgGrade","AvgQuizScore"]):
        aq = student_perf[["StudentId","AvgGrade","AvgQuizScore"]].dropna().copy()
        aq["AssignmentBucket"] = pd.cut(aq["AvgGrade"],     bins=[-1,49,74,101], labels=["Low","Mid","High"])
        aq["QuizBucket"]       = pd.cut(aq["AvgQuizScore"], bins=[-1,49,74,101], labels=["Low","Mid","High"])
        aq_cross = aq.groupby(["AssignmentBucket","QuizBucket"]).size().reset_index(name="StudentCount")
        aq_cross["Pattern"] = aq_cross.apply(
            lambda r:
            "Strong Assignments / Weak Quizzes" if r["AssignmentBucket"]=="High" and r["QuizBucket"]=="Low"
            else "Weak Assignments / Strong Quizzes" if r["AssignmentBucket"]=="Low" and r["QuizBucket"]=="High"
            else "Balanced", axis=1,
        )
        results["admin"]["assignment_vs_quiz"] = aq_cross
        print("  Done")

    # ── Comment Sentiment ─────────────────────────────────────────────────────
    print("\n  [4.7] Comment Sentiment")
    if not comments.empty and "Content" in comments.columns:
        try:
            from textblob import TextBlob
            _c = comments.copy()
            _c["Polarity"] = _c["Content"].dropna().apply(lambda t: TextBlob(str(t)).sentiment.polarity)
            _c["SentimentLabel"] = pd.cut(_c["Polarity"], bins=[-1.01,-0.1,0.1,1.01], labels=["Negative","Neutral","Positive"])
            if "CourseId" in _c.columns:
                course_sentiment = (
                    _c.groupby("CourseId")
                    .agg(AvgPolarity=("Polarity","mean"), CommentCount=("Id","count"),
                         NegativeCount=("SentimentLabel", lambda x: (x == "Negative").sum()),
                         PositiveCount=("SentimentLabel", lambda x: (x == "Positive").sum()))
                    .round(3).reset_index().sort_values("AvgPolarity")
                )
                if "Title" in courses.columns:
                    course_sentiment = course_sentiment.merge(courses[["Id","Title"]].rename(columns={"Id":"CourseId"}), on="CourseId", how="left")
                results["admin"]["course_sentiment"] = course_sentiment
                if not course_metrics.empty and all(c in course_metrics.columns for c in ["QuizPassRate","CompletionRate","AvgQuizScore"]):
                    _cm_diff = course_metrics[["CourseId","QuizPassRate","CompletionRate","AvgQuizScore"]].copy()
                    _cm_diff["CourseDifficultyIndex"] = (
                        (1 - _cm_diff["QuizPassRate"].clip(0,1))         * 0.4 +
                        (1 - _cm_diff["CompletionRate"].clip(0,1))        * 0.3 +
                        (1 - _cm_diff["AvgQuizScore"].clip(0,100) / 100) * 0.3
                    ).round(3)
                    _cm_diff["DifficultyBucket"] = pd.cut(_cm_diff["CourseDifficultyIndex"], bins=[-0.01,0.33,0.66,1.01], labels=["Easy","Medium","Hard"])
                    results["admin"]["sentiment_vs_difficulty"] = (
                        course_sentiment[["CourseId","AvgPolarity","CommentCount"]]
                        .merge(_cm_diff[["CourseId","CourseDifficultyIndex","DifficultyBucket"]], on="CourseId", how="inner")
                        .groupby("DifficultyBucket")
                        .agg(Courses=("CourseId","count"), AvgPolarity=("AvgPolarity","mean"),
                             TotalComments=("CommentCount","sum"), AvgDifficulty=("CourseDifficultyIndex","mean"))
                        .round(3).reset_index()
                    )
            print(f"  {len(_c):,} comments analysed")
        except ImportError:
            print("  ⚠  textblob not installed — run: pip install textblob")

    # ── Student Retention by Cohort ───────────────────────────────────────────
    print("\n  [4.8] Student Retention by Cohort")
    if not students.empty and "AdmissionYear" in students.columns and not progress.empty:
        cohort_prog = (
            students[["Id","AdmissionYear"]].rename(columns={"Id":"StudentId"})
            .merge(progress[["StudentId","IsCompleted","ActivityId"]], on="StudentId", how="left")
        )
        retention = (
            cohort_prog.groupby("AdmissionYear")
            .agg(
                TotalStudents   =("StudentId",   "nunique"),
                ActiveStudents  =("ActivityId",  lambda x: x.notna().sum()),
                CompletedSomething=("IsCompleted","sum"),
            )
            .reset_index()
        )
        retention["RetentionRate"] = (retention["ActiveStudents"] / retention["TotalStudents"] * 100).round(1)
        results["admin"]["retention_by_cohort"] = retention.sort_values("AdmissionYear")
        print(f"  {len(retention)} cohorts")

    # ── Grade Distribution ────────────────────────────────────────────────────
    print("\n  [4.9] Grade Distribution")
    if not tables["submissions"].empty and "Grade" in tables["submissions"].columns:
        _sub = tables["submissions"].dropna(subset=["Grade"])
        _sub = _sub.copy()
        _sub["GradeBucket"] = pd.cut(_sub["Grade"], bins=[0,50,70,85,100,float("inf")],
                                      labels=["F (<50)","C (50-70)","B (70-85)","A (85-100)","A+ (>100)"])
        grade_dist = _sub.groupby("GradeBucket").agg(Count=("Id","count"), AvgGrade=("Grade","mean")).round(2).reset_index()
        grade_dist["Pct"] = (grade_dist["Count"] / len(_sub) * 100).round(1)
        results["admin"]["grade_distribution"] = grade_dist
        print("  Done")

    # ── Learning Time Patterns ────────────────────────────────────────────────
    print("\n  [4.10] Learning Time Patterns")
    if not attempts.empty and "StartedAt_Hour" in attempts.columns:
        _att = attempts.copy()

        _att["TimeSlot"] = pd.cut(
            _att["StartedAt_Hour"],
            bins=[-1, 5, 11, 17, 21, 24],
            labels=["Night (0-5)", "Morning (6-11)", "Afternoon (12-17)", "Evening (18-21)", "Late Night (22-23)"],
        )
        _att["IsWeekend"] = _att["StartedAt_Weekday"].isin([5, 6]).astype(int) if "StartedAt_Weekday" in _att.columns else 0

        time_perf = (
            _att.groupby("TimeSlot")
            .agg(
                Attempts     =("Id",           "count"),
                Students     =("StudentId",    "nunique"),
                AvgScore     =("ScorePercent", "mean"),
                PassRate     =("Passed",       "mean"),
            )
            .round(3).reset_index()
        )
        results["admin"]["learning_time_patterns"] = time_perf

        weekend_perf = (
            _att.groupby("IsWeekend")
            .agg(Attempts=("Id","count"), AvgScore=("ScorePercent","mean"), PassRate=("Passed","mean"))
            .round(3).reset_index()
            .assign(IsWeekend=lambda d: d["IsWeekend"].map({0:"Weekday", 1:"Weekend"}))
        )
        results["admin"]["weekend_vs_weekday"] = weekend_perf
        print("  Done")

    # ── Knowledge Gap Detection ───────────────────────────────────────────────
    print("\n  [4.11] Knowledge Gap Detection")
    if not tables["answers"].empty and not tables["questions"].empty and not attempts.empty:
        _ans = (
            tables["answers"]
            .merge(attempts[["Id","StudentId"]].rename(columns={"Id":"QuizAttemptId"}), on="QuizAttemptId", how="left")
            .merge(tables["questions"][["Id","QuestionType"]].rename(columns={"Id":"QuestionId"}), on="QuestionId", how="left")
        )
        if "QuestionType" in _ans.columns and "IsCorrect" in _ans.columns:
            gap = (
                _ans[_ans["IsCorrect"].isin([0,1])]
                .groupby(["StudentId","QuestionType"])
                .agg(Answered=("IsCorrect","count"), Correct=("IsCorrect","sum"))
                .reset_index()
            )
            gap["CorrectRate"] = (gap["Correct"] / gap["Answered"]).round(3)
            gap_pivot = gap.pivot_table(index="StudentId", columns="QuestionType", values="CorrectRate").reset_index()
            gap_pivot.columns.name = None

            q_types = [c for c in gap_pivot.columns if c != "StudentId"]
            if len(q_types) >= 2:
                for qt in q_types:
                    gap_pivot[f"{qt}_gap"] = (gap_pivot[qt] < 0.5).astype(int)

                gap_pivot["TotalGaps"] = gap_pivot[[f"{qt}_gap" for qt in q_types]].sum(axis=1)
                gap_pivot["HasKnowledgeGap"] = (gap_pivot["TotalGaps"] >= 1).astype(int)
                results["student"]["knowledge_gap"] = gap_pivot.round(3)
                print(f"  {int(gap_pivot['HasKnowledgeGap'].sum())} students with knowledge gaps")
            else:
                print("  Not enough question types")

    # ── Engagement Segmentation ───────────────────────────────────────────────
    print("\n  [4.12] Engagement Segmentation")
    if not engagement.empty and not student_perf.empty:
        _eng = engagement.merge(
            student_perf[["StudentId","AvgQuizScore","CompletionRate","QuizPassRate"]]
            .rename(columns={"CompletionRate":"SP_CompletionRate"}),
            on="StudentId", how="left"
        )

        comm_col = "CommentsCount" if "CommentsCount" in _eng.columns else None

        def segment(row):
            score      = row.get("AvgQuizScore", 0)           or 0
            completion = row.get("SP_CompletionRate", 0)      or 0
            actions    = row.get("ActionCount", 0)             or 0
            comments   = row.get(comm_col, 0) if comm_col else 0

            if score >= 60 and completion >= 0.7 and actions >= _eng["ActionCount"].quantile(0.75):
                return "Super Learner"
            if comm_col and comments >= _eng[comm_col].quantile(0.75):
                return "Social Learner"
            if actions <= _eng["ActionCount"].quantile(0.25) and completion < 0.3:
                return "Dropout Risk"
            if actions <= _eng["ActionCount"].quantile(0.25):
                return "Passive Learner"
            return "Active Learner"

        _eng["EngagementSegment"] = _eng.apply(segment, axis=1)

        seg_summary = (
            _eng.groupby("EngagementSegment")
            .agg(
                Students      =("StudentId",         "count"),
                AvgScore      =("AvgQuizScore",       "mean"),
                CompletionRate=("SP_CompletionRate",  "mean"),
                AvgActions    =("ActionCount",        "mean"),
            )
            .round(2).reset_index()
        )
        seg_summary["Pct"] = (seg_summary["Students"] / len(_eng) * 100).round(1)
        results["student"]["engagement_segments"] = seg_summary
        results["student"]["student_engagement_labels"] = _eng[["StudentId","EngagementSegment"]].copy()
        print(f"  {len(seg_summary)} segments")

    print("\n  ✅ Behavioral: done")
