import pandas as pd

from pipeline_config import DOMAIN
from pipeline.logger import log


def compute_analytics(transformed):
    log.info("--- Stage 5: Analytics ---")

    students    = transformed["students"]
    enrollments = transformed["enrollments"]
    courses     = transformed["courses"]
    logs        = transformed["activity_log_analytics"]
    activities  = transformed["activities"]
    attempts    = transformed["attempts"]
    submissions = transformed["submissions"]
    progress    = transformed["progress"]
    users       = transformed["users"]
    results     = {}

    results["kpi_summary"] = pd.DataFrame([{
        "TotalStudents":         len(students),
        "AtRiskStudents":        int((students["RiskScore"] > 0.5).sum()) if "RiskScore" in students.columns else 0,
        "TotalUsers":            len(users),
        "ActiveUsers":           int(users["IsActive"].sum()) if "IsActive" in users.columns else 0,
        "TotalCourses":          len(courses),
        "ActiveCourses":         int((~courses["IsArchived"]).sum()) if "IsArchived" in courses.columns else 0,
        "DeadCourses":           int((courses["HasStudents"] == 0).sum()) if "HasStudents" in courses.columns else 0,
        "TotalEnrollments":      len(enrollments),
        "TotalActivityLogs":     len(logs),
        "TotalActivities":       len(activities),
        "TotalQuizAttempts":     len(attempts),
        "TotalSubmissions":      len(submissions),
        "AvgProcessingTimeMs":   round(logs["ProcessingTimeMs"].mean(), 2) if "ProcessingTimeMs" in logs.columns else 0,
        "OverallCompletionRate": round((progress["Status"] == "Completed").mean() * 100, 1) if "Status" in progress.columns else 0,
    }])
    log.info("KPIs:\n%s", results["kpi_summary"].T.to_string(header=False))

    if "DepartmentId" in students.columns and "DepartmentName" in students.columns:
        results["department_distribution"] = (
            students.groupby(["DepartmentId", "DepartmentName"])
            .agg(StudentCount=("Id", "count"), AvgCreditLoad=("TotalCreditLoad", "mean"))
            .reset_index()
        )

    if "RiskScore" in students.columns:
        at_risk_cols = [c for c in [
            "Id", "UserId", "DepartmentId", "DepartmentName", "YearId",
            "YearLevelName", "SquadronId", "AdmissionYear",
            "EnrolledCourseCount", "TotalCreditLoad", "RiskScore",
        ] if c in students.columns]
        results["at_risk_students"] = (
            students[students["RiskScore"] > 0.5][at_risk_cols]
            .sort_values("RiskScore", ascending=False)
        )
        log.info("At-risk students: %d / %d", len(results["at_risk_students"]), len(students))

    if "HasStudents" in courses.columns:
        dead_cols = [c for c in ["Id", "Title", "DepartmentId", "DepartmentName", "IsArchived", "CreditHours"] if c in courses.columns]
        results["dead_courses"] = courses[courses["HasStudents"] == 0][dead_cols]

    if "EnrollmentDate_Year" in enrollments.columns:
        results["monthly_enrollment_trend"] = (
            enrollments.groupby(["EnrollmentDate_Year", "EnrollmentDate_Month"])
            .size().reset_index(name="Enrollments")
        )

    if "ActivityType" in activities.columns:
        results["activity_type_breakdown"] = (
            activities.groupby("ActivityType")
            .agg(Count=("Id", "count"), AvgMaxGrade=("MaxGrade", "mean"))
            .reset_index()
        )

    if "ScorePercent" in attempts.columns and "Status" in attempts.columns:
        attempts_with_difficulty = attempts.merge(
            activities[["Id", "DifficultyLevel"]].rename(columns={"Id": "QuizId"}),
            on="QuizId", how="left"
        ) if "QuizId" in attempts.columns else attempts
        if "DifficultyLevel" in attempts_with_difficulty.columns:
            completed = attempts_with_difficulty[attempts_with_difficulty["Status"] == "Completed"]
            results["quiz_pass_rate_by_difficulty"] = (
                completed.groupby("DifficultyLevel")
                .agg(
                    TotalAttempts  =("Id",           "count"),
                    PassedAttempts =("Passed",        "sum"),
                    AvgScore       =("ScorePercent",  "mean"),
                )
                .assign(PassRate=lambda x: (x["PassedAttempts"] / x["TotalAttempts"] * 100).round(1))
                .reset_index()
            ) if "Passed" in completed.columns else None

    if "Grade" in submissions.columns:
        results["grade_distribution"] = (
            submissions.dropna(subset=["Grade"])
            .groupby("Status")
            .agg(AvgGrade=("Grade", "mean"), Count=("Id", "count"), LateCount=("IsLate", "sum"))
            .reset_index()
        ) if "Status" in submissions.columns else None

    if "Status" in progress.columns and "ActivityId" in progress.columns:
        results["completion_rate_by_activity"] = (
            progress.groupby("ActivityId")
            .agg(
                TotalStudents=("StudentId",             "count"),
                Completed    =("IsCompleted",           "sum"),
                AvgProgress  =("ProgressPercent",       "mean"),
                AvgTimeMin   =("TotalTimeSpentMinutes",  "mean"),
            )
            .assign(CompletionRate=lambda x: (x["Completed"] / x["TotalStudents"] * 100).round(1))
            .reset_index()
        ) if "IsCompleted" in progress.columns else None

    if "ActionName" in logs.columns and "Timestamp_Year" in logs.columns:
        results["action_frequency_by_year"] = (
            logs.groupby(["Timestamp_Year", "ActionName"]).size()
            .reset_index(name="Count")
            .sort_values(["Timestamp_Year", "Count"], ascending=[True, False])
        )

    if "ProcessingTimeMs" in logs.columns and "ActionName" in logs.columns:
        results["processing_time_by_action"] = (
            logs.groupby("ActionName")["ProcessingTimeMs"]
            .agg(["mean", "median", "std"]).round(2).reset_index()
        )

    if "UserId" in logs.columns and "EngagementIndex" in logs.columns:
        real = logs[logs["UserId"] != DOMAIN["guest_user_id"]]
        results["user_engagement_summary"] = (
            real.groupby("UserId")
            .agg(TotalActions=("Id", "count"), AvgEngagement=("EngagementIndex", "mean"), LoginCount=("IsLogin", "sum"))
            .reset_index()
            .sort_values("TotalActions", ascending=False)
        )

    corr_cols = [c for c in ["EnrolledCourseCount", "TotalCreditLoad", "AccountAgeDays", "RiskScore"] if c in students.columns]
    if len(corr_cols) > 1:
        results["correlation_matrix"] = students[corr_cols].corr().round(3)

    log.info("Analytics complete — %d result tables", len(results))
    return results
