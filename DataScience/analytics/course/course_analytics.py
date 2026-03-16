import functools

import numpy as np
import pandas as pd


def run(tables: dict, results: dict) -> None:
    print("\n" + "="*65 + "\n  5 · Course-Level Analytics\n" + "="*65)

    courses      = tables["courses"]
    enrollments  = tables["enrollments"]
    engagement   = tables["engagement"]
    student_perf = tables["student_performance"]
    progress     = tables["progress"]
    attempts     = tables["attempts"]
    activities   = tables["activities"]

    if courses.empty:
        print("  Skipped — no courses")
        return

    title_map = courses[["Id","Title"]].rename(columns={"Id":"CourseId"}) if "Title" in courses.columns else pd.DataFrame(columns=["CourseId","Title"])

    def add_title(df):
        if "CourseId" in df.columns and not title_map.empty:
            return df.merge(title_map, on="CourseId", how="left")
        return df

    # ── Course Overview ───────────────────────────────────────────────────────
    print("\n  [5.1] Course Overview")
    _parts = []
    if not enrollments.empty:
        _parts.append(enrollments.groupby("CourseId").agg(StudentCount=("StudentProfileId","nunique")).reset_index())
    if not progress.empty and "IsCompleted" in progress.columns:
        _pc = progress.merge(activities[["Id","CourseId"]].rename(columns={"Id":"ActivityId"}), on="ActivityId", how="left").dropna(subset=["CourseId"])
        _parts.append(_pc.groupby("CourseId").agg(CompletionRate=("IsCompleted","mean"), AvgProgressPct=("ProgressPercent","mean")).round(3).reset_index())
    if not student_perf.empty and not enrollments.empty:
        _sp = (
            student_perf[["StudentId","AvgQuizScore","QuizPassRate","AvgGrade"]]
            .merge(enrollments[["StudentProfileId","CourseId"]].rename(columns={"StudentProfileId":"StudentId"}), on="StudentId", how="inner")
            .groupby("CourseId").agg(AvgQuizScore=("AvgQuizScore","mean"), QuizPassRate=("QuizPassRate","mean"), AvgGrade=("AvgGrade","mean"))
            .round(3).reset_index()
        )
        _parts.append(_sp)
    if not engagement.empty and not enrollments.empty:
        eng_cols = [c for c in ["ActionCount","LoginCount"] if c in engagement.columns]
        if eng_cols:
            _eng = (
                engagement[["StudentId"] + eng_cols]
                .merge(enrollments[["StudentProfileId","CourseId"]].rename(columns={"StudentProfileId":"StudentId"}), on="StudentId", how="inner")
                .groupby("CourseId").mean().round(2).reset_index()
            )
            _parts.append(_eng)
    if _parts:
        overview = functools.reduce(lambda a, b: a.merge(b, on="CourseId", how="outer"), _parts)
        results["course"]["course_overview"] = add_title(overview).round(3)
        print(f"  {len(overview)} courses")

    # ── Engagement Stats + Inequality ─────────────────────────────────────────
    print("\n  [5.2] Engagement + Inequality")
    eng_cols = [c for c in ["ActionCount","LoginCount","CommentsCount","LikesGiven"] if not engagement.empty and c in engagement.columns]
    if eng_cols and not enrollments.empty:
        _eng2 = (
            engagement[["StudentId"] + eng_cols]
            .merge(enrollments[["StudentProfileId","CourseId"]].rename(columns={"StudentProfileId":"StudentId"}), on="StudentId", how="inner")
        )
        eng_detail = (
            _eng2.groupby("CourseId")[eng_cols].mean().round(2).add_prefix("Avg_")
            .join(_eng2.groupby("CourseId")[eng_cols].std().round(2).add_prefix("Std_"))
        ).reset_index()
        if "Avg_ActionCount" in eng_detail.columns and "Std_ActionCount" in eng_detail.columns:
            eng_detail["EngagementCV"] = (eng_detail["Std_ActionCount"] / eng_detail["Avg_ActionCount"].replace(0, np.nan)).round(3)
            eng_detail["EngagementBalance"] = pd.cut(eng_detail["EngagementCV"], bins=[-0.01,0.5,1.0,9999], labels=["Balanced","Moderate Inequality","High Inequality"])
        results["course"]["engagement_stats"] = add_title(eng_detail)
        print(f"  {len(eng_detail)} courses")

    # ── Completion & Dropout ──────────────────────────────────────────────────
    print("\n  [5.3] Completion & Dropout")
    if not progress.empty and not activities.empty:
        _pc = progress.merge(activities[["Id","CourseId"]].rename(columns={"Id":"ActivityId"}), on="ActivityId", how="left").dropna(subset=["CourseId"])
        comp_course = (
            _pc.groupby("CourseId")
            .agg(TotalStudents=("StudentId","nunique"), TotalActivities=("ActivityId","nunique"),
                 CompletionRate=("IsCompleted","mean"), AvgProgressPct=("ProgressPercent","mean"))
            .round(3).reset_index()
        )
        comp_course["DropoutRate"]      = (1 - comp_course["CompletionRate"]).round(3)
        comp_course["CompletionStatus"] = pd.cut(comp_course["CompletionRate"], bins=[-0.01,0.4,0.7,1.01], labels=["Low (<40%)","Medium (40-70%)","High (>70%)"])
        results["course"]["completion_dropout"] = add_title(comp_course).sort_values("DropoutRate", ascending=False)
        print(f"  {len(comp_course)} courses")

    # ── Difficulty Indicator ──────────────────────────────────────────────────
    print("\n  [5.4] Difficulty Indicator")
    if not attempts.empty and not activities.empty:
        _quiz_acts = activities[activities["ActivityType"] == "Quiz"][["Id","CourseId"]].rename(columns={"Id":"QuizId"}) if "ActivityType" in activities.columns else pd.DataFrame(columns=["QuizId","CourseId"])
        if not _quiz_acts.empty:
            _att = attempts.merge(_quiz_acts, on="QuizId", how="inner").dropna(subset=["CourseId"])
            diff_course = _att.groupby("CourseId").agg(
                TotalAttempts=("Id","count"), AvgScore=("ScorePercent","mean"),
                PassRate=("Passed","mean"), RetryRate=("AttemptNumber", lambda x: (x > 1).mean()),
            ).round(3).reset_index()
            diff_course["DifficultyIndex"] = ((1 - diff_course["PassRate"].clip(0,1)) * 0.5 + (1 - diff_course["AvgScore"].clip(0,100)/100) * 0.5).round(3)
            p33 = diff_course["DifficultyIndex"].quantile(0.33)
            p66 = diff_course["DifficultyIndex"].quantile(0.66)
            diff_course["DifficultyLabel"] = pd.cut(
                diff_course["DifficultyIndex"],
                bins=[-0.01, p33, p66, 1.01],
                labels=["Easy","Medium","Hard"],
                duplicates="drop",
            )
            results["course"]["difficulty_indicator"] = add_title(diff_course).sort_values("DifficultyIndex", ascending=False)
            h = int((diff_course["DifficultyLabel"]=="Hard").sum())
            m = int((diff_course["DifficultyLabel"]=="Medium").sum())
            e = int((diff_course["DifficultyLabel"]=="Easy").sum())
            print(f"  Hard: {h}  Medium: {m}  Easy: {e}")

    # ── Engagement–Performance Correlation ────────────────────────────────────
    print("\n  [5.5] Engagement–Performance Correlation")
    if not engagement.empty and not student_perf.empty and not enrollments.empty:
        _corr_base = (
            engagement[["StudentId"] + [c for c in ["ActionCount","LoginCount"] if c in engagement.columns]]
            .merge(student_perf[["StudentId","AvgQuizScore","CompletionRate"]], on="StudentId", how="inner")
            .merge(enrollments[["StudentProfileId","CourseId"]].rename(columns={"StudentProfileId":"StudentId"}), on="StudentId", how="inner")
        )
        corr_rows = []
        for course_id, grp in _corr_base.groupby("CourseId"):
            if len(grp) < 5:
                continue
            row = {"CourseId": course_id, "StudentCount": len(grp)}
            for ec in [c for c in ["ActionCount","LoginCount"] if c in grp.columns]:
                for pc in ["AvgQuizScore","CompletionRate"]:
                    if pc in grp.columns and grp[ec].std() > 0 and grp[pc].std() > 0:
                        row[f"r_{ec}_vs_{pc}"] = round(grp[ec].corr(grp[pc]), 3)
            corr_rows.append(row)
        if corr_rows:
            corr_df = pd.DataFrame(corr_rows)
            if "r_ActionCount_vs_AvgQuizScore" in corr_df.columns:
                corr_df["EngagementImpact"] = pd.cut(corr_df["r_ActionCount_vs_AvgQuizScore"], bins=[-1.01,-0.3,0.3,1.01], labels=["Negative","Weak / None","Positive"])
            results["course"]["engagement_performance_corr"] = add_title(corr_df).round(3)
            print(f"  {len(corr_df)} courses")

    # ── Top Students per Course ───────────────────────────────────────────────
    print("\n  [5.6] Top Students per Course")
    if not student_perf.empty and not enrollments.empty:
        _top = (
            student_perf[["StudentId","AvgQuizScore","AvgGrade","CompletionRate","QuizPassRate"]]
            .merge(enrollments[["StudentProfileId","CourseId"]].rename(columns={"StudentProfileId":"StudentId"}), on="StudentId", how="inner")
        )
        _top["CompositeScore"] = (_top["AvgQuizScore"].clip(0,100)/100*0.5 + _top["CompletionRate"].clip(0,1)*0.3 + _top["AvgGrade"].clip(0,100)/100*0.2).round(4)
        top_students = _top.sort_values("CompositeScore", ascending=False).groupby("CourseId").head(10).reset_index(drop=True)
        top_students["RankInCourse"] = top_students.groupby("CourseId")["CompositeScore"].rank(ascending=False, method="min").astype(int)
        if not title_map.empty:
            top_students = top_students.merge(title_map, on="CourseId", how="left")
        results["course"]["top_students_per_course"] = top_students.round(4)
        print(f"  Top-10 per course  ({len(top_students)} rows)")

    # ── Course Risk Distribution ──────────────────────────────────────────────
    print("\n  [5.7] Course Risk Distribution")
    if not student_perf.empty and not engagement.empty and not enrollments.empty:
        _risk = (
            student_perf[["StudentId","AvgQuizScore","CompletionRate"]]
            .merge(engagement[["StudentId","ActionCount"]], on="StudentId", how="inner")
        )
        is_active = (_risk["AvgQuizScore"] > 0) | (_risk["CompletionRate"] > 0) | (_risk["ActionCount"].fillna(0) > 0)
        _risk_a = _risk[is_active].copy()

        def _pct_rank(s):
            return s.rank(pct=True).fillna(0.5)

        f1 = 1 - _pct_rank(_risk_a["AvgQuizScore"])
        f2 = 1 - _pct_rank(_risk_a["CompletionRate"])
        f3 = 1 - _pct_rank(_risk_a["ActionCount"].fillna(0))
        _risk_a["RiskScore"] = (f1*0.40 + f2*0.35 + f3*0.25).round(4)
        _risk_a["AtRiskFlag"] = (_risk_a["RiskScore"] > 0.60).astype(int)
        _risk = _risk_a
        _risk_course = (
            _risk.merge(enrollments[["StudentProfileId","CourseId"]].rename(columns={"StudentProfileId":"StudentId"}), on="StudentId", how="inner")
            .groupby("CourseId").agg(TotalStudents=("StudentId","nunique"), AtRiskCount=("AtRiskFlag","sum")).reset_index()
        )
        _risk_course["AtRiskPct"] = (_risk_course["AtRiskCount"] / _risk_course["TotalStudents"] * 100).round(1)
        _p33 = _risk_course["AtRiskPct"].quantile(0.33)
        _p66 = _risk_course["AtRiskPct"].quantile(0.66)
        _risk_course["RiskLevel"] = pd.cut(
            _risk_course["AtRiskPct"],
            bins=[-0.01, _p33, _p66, 100],
            labels=["Low", "Medium", "High"],
            duplicates="drop",
        )
        results["course"]["risk_distribution"] = add_title(_risk_course).sort_values("AtRiskPct", ascending=False)
        n_high = int((_risk_course["RiskLevel"] == "High").sum())
        print(f"  {len(_risk_course)} courses  |  {n_high} high-risk")

    # ── Activity Difficulty per Course ────────────────────────────────────────
    print("\n  [5.8] Activity Difficulty per Course")
    if not attempts.empty and not activities.empty:
        act_att = (
            attempts.merge(activities[["Id","CourseId","ActivityType"]].rename(columns={"Id":"QuizId"}), on="QuizId", how="left")
            .dropna(subset=["CourseId"])
        )
        act_diff = (
            act_att.groupby(["CourseId","QuizId"])
            .agg(Attempts=("Id","count"), AvgScore=("ScorePercent","mean"), PassRate=("Passed","mean"))
            .round(3).reset_index()
        )
        if not activities.empty and "Title" in activities.columns:
            act_diff = act_diff.merge(activities[["Id","Title"]].rename(columns={"Id":"QuizId"}), on="QuizId", how="left")
        act_diff = add_title(act_diff).sort_values(["CourseId","AvgScore"])
        results["course"]["activity_difficulty"] = act_diff
        print(f"  {len(act_diff)} quiz-level records")


    # ── Student Confusion Heatmap ─────────────────────────────────────────────
    print("\n  [5.9] Student Confusion Heatmap")
    if not attempts.empty and not activities.empty:
        quiz_acts = activities[activities["ActivityType"] == "Quiz"][["Id","CourseId","Title"]].rename(columns={"Id":"QuizId","Title":"ActivityTitle"})
        confusion = (
            attempts.merge(quiz_acts, on="QuizId", how="inner")
            .groupby(["CourseId","QuizId","ActivityTitle"])
            .agg(
                TotalAttempts =("Id",            "count"),
                FailCount     =("Passed",        lambda x: (x == 0).sum()),
                AvgAttempts   =("AttemptNumber", "mean"),
                AvgScore      =("ScorePercent",  "mean"),
            )
            .reset_index()
        )
        confusion["FailRate"] = (confusion["FailCount"] / confusion["TotalAttempts"]).round(3)
        confusion = add_title(confusion).sort_values(["CourseId","FailRate"], ascending=[True,False])
        results["course"]["confusion_heatmap"] = confusion.round(3)
        print(f"  {len(confusion)} quiz-activity records")

    # ── Dropoff per Lesson ────────────────────────────────────────────────────
    print("\n  [5.10] Dropoff per Lesson")
    if not progress.empty and not activities.empty:
        act_order = activities[["Id","CourseId","SortOrder","Title","ActivityType"]].rename(columns={"Id":"ActivityId"}) if "SortOrder" in activities.columns else activities[["Id","CourseId","Title","ActivityType"]].rename(columns={"Id":"ActivityId"})
        lesson_prog = (
            progress.merge(act_order, on="ActivityId", how="left")
            .dropna(subset=["CourseId"])
        )
        sort_col = "SortOrder" if "SortOrder" in lesson_prog.columns else "ActivityId"
        dropoff = (
            lesson_prog.groupby(["CourseId","ActivityId","Title",sort_col])
            .agg(
                StudentsReached   =("StudentId",      "nunique"),
                StudentsCompleted =("IsCompleted",    "sum"),
                AvgProgress       =("ProgressPercent","mean"),
            )
            .reset_index()
            .sort_values(["CourseId", sort_col])
        )
        dropoff["CompletionRate"] = (dropoff["StudentsCompleted"] / dropoff["StudentsReached"]).round(3)
        dropoff["DropoffFromPrev"] = dropoff.groupby("CourseId")["StudentsReached"].diff().fillna(0).astype(int)
        results["course"]["dropoff_per_lesson"] = add_title(dropoff).round(3)
        print(f"  {len(dropoff)} lesson-level records")

    # ── Course Bottlenecks ────────────────────────────────────────────────────
    print("\n  [5.11] Course Bottlenecks")
    if not progress.empty and not activities.empty:
        act_info = activities[["Id","CourseId","Title","ActivityType"]].rename(columns={"Id":"ActivityId"})
        bottleneck = (
            progress.merge(act_info, on="ActivityId", how="left")
            .dropna(subset=["CourseId"])
            .groupby(["CourseId","ActivityId","Title","ActivityType"])
            .agg(
                Students      =("StudentId",      "nunique"),
                Completed     =("IsCompleted",    "sum"),
                AvgProgress   =("ProgressPercent","mean"),
                AvgTimeMinutes=("TotalTimeSpentMinutes","mean"),
            )
            .reset_index()
        )
        bottleneck["CompletionRate"] = (bottleneck["Completed"] / bottleneck["Students"]).round(3)
        bottleneck["IsBottleneck"]   = (bottleneck["CompletionRate"] < 0.4).astype(int)
        bottleneck = add_title(bottleneck).sort_values(["CourseId","CompletionRate"])
        results["course"]["course_bottlenecks"] = bottleneck.round(3)
        n_bottleneck = int(bottleneck["IsBottleneck"].sum())
        print(f"  {n_bottleneck} bottleneck activities identified")

    print(f"\n  ✅ Course: {len(results['course'])} tables")
