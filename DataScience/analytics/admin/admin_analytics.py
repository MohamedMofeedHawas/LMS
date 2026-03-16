import functools
import operator

import pandas as pd

from analytics.loader import pct


def run(tables: dict, results: dict) -> None:
    print("\n" + "="*65 + "\n  1 · Admin Dashboard\n" + "="*65)

    students       = tables["students"]
    users          = tables["users"]
    courses        = tables["courses"]
    enrollments    = tables["enrollments"]
    attempts       = tables["attempts"]
    submissions    = tables["submissions"]
    progress       = tables["progress"]
    activity_log   = tables["activity_log"]
    engagement     = tables["engagement"]
    student_perf   = tables["student_performance"]
    course_metrics = tables["course_metrics"]
    squadrons      = tables["squadrons"]

    # ── Platform Health Score ─────────────────────────────────────────────────
    print("\n  [1.1] Platform Health Score")
    _h: dict = {}
    if not students.empty:
        _h["enrolled_students_pct"] = pct(
            len(students[students["EnrolledCourseCount"] > 0]) if "EnrolledCourseCount" in students.columns else len(students),
            len(students),
        )
    if not courses.empty and "HasStudents" in courses.columns:
        _h["active_courses_pct"] = pct(int((courses["HasStudents"] == 1).sum()), len(courses))

    completion_rate = 0.0
    if not progress.empty and "IsCompleted" in progress.columns:
        completion_rate = round(float(progress["IsCompleted"].mean()) * 100, 1)
        _h["overall_completion_rate"] = completion_rate

    pass_rate = 0.0
    if not attempts.empty and "Passed" in attempts.columns:
        pass_rate = round(float(attempts["Passed"].mean()) * 100, 1)
        _h["overall_quiz_pass_rate"] = pass_rate

    if not users.empty and "IsActive" in users.columns:
        _h["active_users_pct"] = pct(int(users["IsActive"].sum()), len(users))

    _weights = {
        "enrolled_students_pct":   0.25, "active_courses_pct":      0.20,
        "overall_completion_rate": 0.25, "overall_quiz_pass_rate":  0.20,
        "active_users_pct":        0.10,
    }
    platform_score = round(sum(_h.get(k, 0) * w for k, w in _weights.items()), 1)
    _h["PlatformHealthScore"] = platform_score
    health_df = pd.DataFrame([_h]).T.reset_index()
    health_df.columns = ["Metric", "Value"]
    results["admin"]["platform_health"] = health_df
    print(f"  Score: {platform_score} / 100")

    # ── KPI Summary ───────────────────────────────────────────────────────────
    print("\n  [1.2] KPI Summary")
    kpi = {
        "TotalStudents":         len(students),
        "TotalUsers":            len(users),
        "ActiveUsers":           int(users["IsActive"].sum()) if "IsActive" in users.columns else 0,
        "TotalCourses":          len(courses),
        "ActiveCourses":         int((courses["HasStudents"] == 1).sum()) if "HasStudents" in courses.columns else 0,
        "TotalEnrollments":      len(enrollments),
        "TotalQuizAttempts":     len(attempts),
        "TotalSubmissions":      len(submissions),
        "OverallCompletionRate": completion_rate,
        "OverallQuizPassRate":   pass_rate,
        "PlatformHealthScore":   platform_score,
    }
    kpi_df = pd.DataFrame([kpi]).T.reset_index()
    kpi_df.columns = ["KPI", "Value"]
    results["admin"]["kpi_summary"] = kpi_df
    print(f"  {len(kpi)} KPIs")

    # ── Department Comparison ─────────────────────────────────────────────────
    print("\n  [1.3] Department Comparison")
    if not students.empty and "DepartmentName" in students.columns:
        dept_base = students.groupby("DepartmentName").agg(
            Students     =("Id",             "count"),
            AvgCreditLoad=("TotalCreditLoad", "mean"),
        ).reset_index()
        if not student_perf.empty:
            dept_perf = (
                student_perf
                .merge(students[["Id","DepartmentName"]].rename(columns={"Id":"StudentId"}), on="StudentId", how="left")
                .groupby("DepartmentName")
                .agg(AvgQuizScore=("AvgQuizScore","mean"), AvgGrade=("AvgGrade","mean"),
                     QuizPassRate=("QuizPassRate","mean"), CompletionRate=("CompletionRate","mean"))
                .round(2).reset_index()
            )
            dept_base = dept_base.merge(dept_perf, on="DepartmentName", how="left")
        results["admin"]["department_comparison"] = dept_base.round(2)
        print(f"  {len(dept_base)} departments")

    # ── Squadron Performance ──────────────────────────────────────────────────
    print("\n  [1.4] Squadron Performance")
    if not students.empty and "SquadronId" in students.columns:
        _sqd = students[["Id","SquadronId"]].copy()
        if not squadrons.empty and "Name" in squadrons.columns:
            _sqd = _sqd.merge(squadrons[["Id","Name"]].rename(columns={"Id":"SquadronId","Name":"SquadronName"}), on="SquadronId", how="left")
        sqd_summary = _sqd.groupby("SquadronId").agg(StudentCount=("Id","count")).reset_index()
        if "SquadronName" in _sqd.columns:
            sqd_summary = sqd_summary.merge(_sqd[["SquadronId","SquadronName"]].drop_duplicates(), on="SquadronId", how="left")
        if not student_perf.empty:
            sqd_perf = (
                student_perf
                .merge(_sqd[["Id","SquadronId"]].rename(columns={"Id":"StudentId"}), on="StudentId", how="left")
                .groupby("SquadronId")
                .agg(AvgQuizScore=("AvgQuizScore","mean"), QuizPassRate=("QuizPassRate","mean"), CompletionRate=("CompletionRate","mean"))
                .round(2).reset_index()
            )
            sqd_summary = sqd_summary.merge(sqd_perf, on="SquadronId", how="left")
        score_cols = [c for c in ["AvgQuizScore","QuizPassRate","CompletionRate"] if c in sqd_summary.columns]
        if score_cols:
            sqd_summary["OverallScore"] = sqd_summary[score_cols].mean(axis=1).round(2)
            sqd_summary = sqd_summary.sort_values("OverallScore", ascending=False).reset_index(drop=True)
            sqd_summary["Rank"] = range(1, len(sqd_summary) + 1)
        results["admin"]["squadron_performance"] = sqd_summary.round(2)
        print(f"  {len(sqd_summary)} squadrons ranked")

    # ── At-Risk Students ──────────────────────────────────────────────────────
    print("\n  [1.5] At-Risk Students")
    if not engagement.empty and not student_perf.empty:
        _eng_c  = [c for c in ["StudentId","ActionCount","CompletionRate"] if c in engagement.columns]
        _perf_c = [c for c in ["StudentId","AvgQuizScore","QuizPassRate"]  if c in student_perf.columns]
        _rm = engagement[_eng_c].merge(student_perf[_perf_c], on="StudentId", how="inner")
        is_active = (_rm["ActionCount"] > 0) | (_rm["CompletionRate"] > 0) | (_rm["AvgQuizScore"] > 0)
        _rm_active = _rm[is_active].copy()
        flags = []
        if "ActionCount"    in _rm_active.columns: flags.append((_rm_active["ActionCount"].rank(pct=True, method="first")    < 0.25).astype(int))
        if "CompletionRate" in _rm_active.columns: flags.append((_rm_active["CompletionRate"].rank(pct=True, method="first") < 0.25).astype(int))
        if "AvgQuizScore"   in _rm_active.columns: flags.append((_rm_active["AvgQuizScore"].rank(pct=True, method="first")   < 0.25).astype(int))
        if flags:
            _rm_active["RiskSignalCount"] = functools.reduce(operator.add, flags)
            _rm_active["AtRiskFlag"]      = (_rm_active["RiskSignalCount"] >= 2).astype(int)
            risk_summary = _rm_active.groupby("RiskSignalCount").agg(Students=("StudentId","count")).reset_index()
            risk_summary["AtRiskFlagged"] = (risk_summary["RiskSignalCount"] >= 2).astype(int)
            risk_summary["CumPct"] = (risk_summary["Students"].cumsum() / len(_rm_active) * 100).round(1)
            results["admin"]["at_risk_summary"] = risk_summary
            if not students.empty and "DepartmentName" in students.columns:
                risk_dept = (
                    _rm_active[_rm_active["AtRiskFlag"] == 1]
                    .merge(students[["Id","DepartmentName"]].rename(columns={"Id":"StudentId"}), on="StudentId", how="left")
                    .groupby("DepartmentName").agg(AtRiskCount=("StudentId","count")).reset_index()
                )
                total_dept = students.groupby("DepartmentName").size().rename("Total").reset_index()
                risk_dept  = risk_dept.merge(total_dept, on="DepartmentName", how="left")
                risk_dept["AtRiskPct"] = (risk_dept["AtRiskCount"] / risk_dept["Total"] * 100).round(1)
                results["admin"]["at_risk_by_dept"] = risk_dept.sort_values("AtRiskPct", ascending=False)
            n_risk = int(_rm_active["AtRiskFlag"].sum())
            print(f"  {n_risk:,} at-risk from {len(_rm_active):,} active students ({pct(n_risk, len(_rm_active))}%)")
    else:
        print("  Skipped — engagement or student_performance not available")

    # ── Inactive Users ────────────────────────────────────────────────────────
    print("\n  [1.6] Inactive Users")
    if not users.empty and "LastLoginAt" in users.columns:
        users = users.copy()
        users["LastLoginAt"] = pd.to_datetime(users["LastLoginAt"], errors="coerce")
        users["DaysSinceLogin"] = (pd.Timestamp.now() - users["LastLoginAt"]).dt.days
        inactive_summary = pd.DataFrame([{
            "NeverLoggedIn":  int(users["LastLoginAt"].isna().sum()),
            "Inactive30Days": int((users["DaysSinceLogin"] > 30).sum()),
            "Inactive90Days": int((users["DaysSinceLogin"] > 90).sum()),
            "Inactive180Days":int((users["DaysSinceLogin"] > 180).sum()),
        }]).T.reset_index()
        inactive_summary.columns = ["Category","Count"]
        inactive_summary["Pct"] = (inactive_summary["Count"] / len(users) * 100).round(1)
        results["admin"]["inactive_users"] = inactive_summary
        for _, r in inactive_summary.iterrows():
            print(f"  {r['Category']}: {int(r['Count']):,} ({r['Pct']}%)")

    # ── System Alerts ─────────────────────────────────────────────────────────
    print("\n  [1.7] System Alerts")
    alerts = []
    if not courses.empty:
        n = int(courses["InstructorId"].isna().sum()) if "InstructorId" in courses.columns else 0
        if n: alerts.append({"Alert":"Courses without instructor",    "Count":n, "Severity":"High"})
        n = int((courses["HasStudents"] == 0).sum()) if "HasStudents" in courses.columns else 0
        if n: alerts.append({"Alert":"Courses with no students",      "Count":n, "Severity":"Medium"})
    if not students.empty and "EnrolledCourseCount" in students.columns:
        n = int((students["EnrolledCourseCount"] == 0).sum())
        if n: alerts.append({"Alert":"Students with zero enrollments","Count":n, "Severity":"High"})
    if not submissions.empty and "Status" in submissions.columns:
        n = int((submissions["Status"] == "Submitted").sum())
        if n: alerts.append({"Alert":"Ungraded submissions pending",  "Count":n, "Severity":"Medium"})
    results["admin"]["system_alerts"] = pd.DataFrame(alerts) if alerts else pd.DataFrame(columns=["Alert","Count","Severity"])
    print(f"  {len(alerts)} alerts")

    # ── Top & Hardest Courses ─────────────────────────────────────────────────
    print("\n  [1.8] Course Overview")
    if not course_metrics.empty:
        _cm = course_metrics.copy()
        if "ActualEnrolledCount" in _cm.columns:
            results["admin"]["top_popular_courses"] = _cm.nlargest(10,"ActualEnrolledCount")[
                [c for c in ["CourseId","Title","DepartmentName","ActualEnrolledCount","CompletionRate","AvgQuizScore"] if c in _cm.columns]
            ].round(2)
        if "QuizPassRate" in _cm.columns and "TotalAttempts" in _cm.columns:
            results["admin"]["top_hardest_courses"] = (
                _cm[_cm["TotalAttempts"] > 10].nsmallest(10,"QuizPassRate")[
                    [c for c in ["CourseId","Title","DepartmentName","QuizPassRate","AvgQuizScore","TotalAttempts"] if c in _cm.columns]
                ].round(3)
            )
        print("  Done")

    # ── Enrollment Trend ──────────────────────────────────────────────────────
    print("\n  [1.9] Enrollment Trend")
    if not enrollments.empty and "EnrollmentDate" in enrollments.columns:
        results["admin"]["enrollment_trend"] = (
            enrollments.dropna(subset=["EnrollmentDate"])
            .assign(Year=lambda d: d["EnrollmentDate"].dt.year, Month=lambda d: d["EnrollmentDate"].dt.month)
            .groupby(["Year","Month"]).size().reset_index(name="Enrollments")
            .sort_values(["Year","Month"])
        )
        print("  Done")

    # ── Cohort Analysis ───────────────────────────────────────────────────────
    print("\n  [1.10] Cohort Analysis")
    if not students.empty and "AdmissionYear" in students.columns and not student_perf.empty:
        cohort = (
            students[["Id","AdmissionYear","DepartmentName"]].rename(columns={"Id":"StudentId"})
            .merge(student_perf[["StudentId","AvgQuizScore","CompletionRate","QuizPassRate"]], on="StudentId", how="left")
            .groupby("AdmissionYear")
            .agg(
                Students      =("StudentId",      "count"),
                AvgQuizScore  =("AvgQuizScore",   "mean"),
                CompletionRate=("CompletionRate",  "mean"),
                QuizPassRate  =("QuizPassRate",    "mean"),
            )
            .round(2).reset_index()
            .sort_values("AdmissionYear")
        )
        results["admin"]["cohort_analysis"] = cohort
        print(f"  {len(cohort)} cohorts")

    # ── Peak Activity Hours ───────────────────────────────────────────────────
    print("\n  [1.11] Peak Activity Hours")
    if not activity_log.empty and "Timestamp" in activity_log.columns:
        activity_log = activity_log.copy()
        activity_log["Hour"]    = activity_log["Timestamp"].dt.hour
        activity_log["Weekday"] = activity_log["Timestamp"].dt.day_name()
        results["admin"]["peak_hours"]   = activity_log.groupby("Hour").size().reset_index(name="ActionCount")
        results["admin"]["peak_weekday"] = activity_log.groupby("Weekday").size().reset_index(name="ActionCount")
        print("  Done")

    # ── Learning Funnel ───────────────────────────────────────────────────────
    print("\n  [1.12] Learning Funnel")
    funnel_data = [
        {"Stage":"1. Registered",         "Count": len(students)},
        {"Stage":"2. Enrolled",            "Count": int((students["EnrolledCourseCount"] > 0).sum()) if "EnrolledCourseCount" in students.columns else 0},
        {"Stage":"3. Started Activity",    "Count": int(progress[progress["ProgressPercent"] > 0]["StudentId"].nunique()) if not progress.empty and "ProgressPercent" in progress.columns else 0},
        {"Stage":"4. Completed Activity",  "Count": int(progress[progress["IsCompleted"] == 1]["StudentId"].nunique()) if not progress.empty and "IsCompleted" in progress.columns else 0},
        {"Stage":"5. Passed Quiz",         "Count": int(attempts[attempts["Passed"] == 1]["StudentId"].nunique()) if not attempts.empty and "Passed" in attempts.columns else 0},
        {"Stage":"6. Submitted Assignment","Count": int(submissions["StudentId"].nunique()) if not submissions.empty else 0},
    ]
    funnel_df = pd.DataFrame(funnel_data)
    funnel_df["DropFromPrev"] = funnel_df["Count"].diff().fillna(0).astype(int)
    funnel_df["RetentionPct"] = (funnel_df["Count"] / funnel_df["Count"].iloc[0] * 100).round(1)
    results["admin"]["learning_funnel"] = funnel_df
    print(f"  {funnel_df.iloc[0]['Count']:,} → {funnel_df.iloc[-1]['Count']:,}")

    # ── Weekly Engagement Trend ───────────────────────────────────────────────
    print("\n  [1.13] Weekly Engagement Trend")
    if not activity_log.empty and "Timestamp" in activity_log.columns:
        _log = activity_log.copy()
        _log["Week"] = _log["Timestamp"].dt.to_period("W").astype(str)
        weekly = (
            _log.groupby("Week")
            .agg(TotalActions=("Id","count"), UniqueUsers=("UserId","nunique"))
            .reset_index()
        )
        results["admin"]["weekly_engagement_trend"] = weekly
        print(f"  {len(weekly)} weeks")

    print(f"\n  ✅ Admin: {len(results['admin'])} tables")
