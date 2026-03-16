import pickle

import numpy as np
import pandas as pd
from sklearn.preprocessing import MinMaxScaler, LabelEncoder

from pipeline_config import DOMAIN, SCALER_DIR
from pipeline.logger import log, record_audit


class ScalerStore:
    def __init__(self, directory):
        self.directory = directory
        self._cache    = {}

    def fit_transform(self, name, data):
        scaler = MinMaxScaler()
        result = scaler.fit_transform(data)
        self._cache[name] = scaler
        with open(self.directory / f"{name}.pkl", "wb") as f:
            pickle.dump(scaler, f)
        return result

    def transform(self, name, data):
        if name not in self._cache:
            path = self.directory / f"{name}.pkl"
            if not path.exists():
                raise FileNotFoundError(f"No scaler saved for '{name}'")
            with open(path, "rb") as f:
                self._cache[name] = pickle.load(f)
        return self._cache[name].transform(data)


scalers = ScalerStore(SCALER_DIR)


def group_agg_features(df, enroll, group_col):
    if group_col not in enroll.columns or "CreditHours" not in enroll.columns:
        return df
    valid = enroll.dropna(subset=[group_col])
    if valid.empty:
        return df
    agg = (
        valid.groupby(group_col)
        .agg(avg_credit=("CreditHours", "mean"), total_enroll=("StudentProfileId", "count"))
        .reset_index()
    )
    prefix = group_col.replace("Id", "")
    agg = agg.rename(columns={
        "avg_credit":   f"{prefix}_AvgCreditLoad",
        "total_enroll": f"{prefix}_TotalEnrollments",
    })
    return df.merge(agg, on=group_col, how="left")


def transform_students(df, enroll):
    log.info("[students] Transforming...")

    if "CreatedAt" in df.columns:
        df["CreatedAt_Year"]    = df["CreatedAt"].dt.year
        df["CreatedAt_Month"]   = df["CreatedAt"].dt.month
        df["CreatedAt_Weekday"] = df["CreatedAt"].dt.dayofweek
        df["AccountAgeDays"]    = (pd.Timestamp.now() - df["CreatedAt"]).dt.days.clip(lower=0)
    else:
        df["AccountAgeDays"] = 0

    if "StudentProfileId" in enroll.columns and "CourseId" in enroll.columns:
        course_count = (
            enroll.groupby("StudentProfileId")["CourseId"].count()
            .rename("EnrolledCourseCount").reset_index()
            .rename(columns={"StudentProfileId": "Id"})
        )
        df = df.merge(course_count, on="Id", how="left")
        df["EnrolledCourseCount"] = df["EnrolledCourseCount"].fillna(0).astype(int)

    if "StudentProfileId" in enroll.columns and "CreditHours" in enroll.columns:
        credit_sum = (
            enroll.groupby("StudentProfileId")["CreditHours"].sum()
            .rename("TotalCreditLoad").reset_index()
            .rename(columns={"StudentProfileId": "Id"})
        )
        df = df.merge(credit_sum, on="Id", how="left")
        df["TotalCreditLoad"] = df["TotalCreditLoad"].fillna(0).astype(int)
    else:
        df["TotalCreditLoad"]     = 0
        df["EnrolledCourseCount"] = df.get("EnrolledCourseCount", pd.Series(0, index=df.index))

    for group_col in ["DepartmentId", "YearId", "SquadronId"]:
        if group_col in df.columns:
            enroll_g = enroll.merge(
                df[["Id", group_col]].rename(columns={"Id": "StudentProfileId"}),
                on="StudentProfileId", how="left"
            )
            df = group_agg_features(df, enroll_g, group_col)

    for col in ["DepartmentId", "YearId", "SquadronId"]:
        if col in df.columns:
            df[f"{col}_Enc"] = LabelEncoder().fit_transform(df[col].astype(str))

    if "AdmissionYear" in df.columns:
        df["AdmissionYear_Norm"]  = scalers.fit_transform("stu_admission_year", df[["AdmissionYear"]].astype(float))
    df["AccountAgeDays_Norm"]  = scalers.fit_transform("stu_account_age",    df[["AccountAgeDays"]].astype(float))
    df["TotalCreditLoad_Norm"] = scalers.fit_transform("stu_credit_load",    df[["TotalCreditLoad"]].astype(float))

    df["RiskFlag_NoEnrollment"]  = (df["EnrolledCourseCount"] == 0).astype(int)
    df["RiskFlag_LowCreditLoad"] = (df["TotalCreditLoad"] < DOMAIN["risk_low_credit_threshold"]).astype(int)
    df["RiskScore"] = (
        df["RiskFlag_NoEnrollment"]  * 0.5 +
        df["RiskFlag_LowCreditLoad"] * 0.5
    ).clip(0, 1)

    if "DepartmentId" in df.columns:
        df["DepartmentName"] = df["DepartmentId"].map(DOMAIN["department_names"])
    if "YearId" in df.columns:
        df["YearLevelName"] = df["YearId"].map(DOMAIN["year_level_names"])

    record_audit("students", "transform", len(df))
    return df


def transform_users(df):
    log.info("[users] Transforming...")

    if "CreatedAt" in df.columns:
        df["AccountAgeDays"] = (pd.Timestamp.now() - df["CreatedAt"]).dt.days.clip(lower=0)

    if "LastLoginAt" in df.columns and "CreatedAt" in df.columns:
        df["DaysSinceLastLogin"] = (pd.Timestamp.now() - df["LastLoginAt"]).dt.days.clip(lower=0)
        df["DaysSinceLastLogin"] = df["DaysSinceLastLogin"].fillna(-1).astype(int)

    if "LastLoginAt" in df.columns:
        df["HasLoggedIn"] = df["LastLoginAt"].notna().astype(int)

    if "AccessFailedCount" in df.columns:
        df["IsLockedOut"] = (df["AccessFailedCount"] >= 3).astype(int)

    if "Gender" in df.columns:
        df["Gender_Enc"] = LabelEncoder().fit_transform(df["Gender"].fillna("Unknown"))

    record_audit("users", "transform", len(df))
    return df


def transform_activity_log(df):
    log.info("[activity_log] Transforming...")

    if "Timestamp" in df.columns:
        df["Timestamp_Year"]    = df["Timestamp"].dt.year
        df["Timestamp_Month"]   = df["Timestamp"].dt.month
        df["Timestamp_Weekday"] = df["Timestamp"].dt.dayofweek
        df["Timestamp_Hour"]    = df["Timestamp"].dt.hour
        df["IsBusinessHours"]   = df["Timestamp_Hour"].between(8, 18).astype(int)
        try:
            df["Timestamp_Week"] = df["Timestamp"].dt.isocalendar().week.astype(int)
        except Exception:
            df["Timestamp_Week"] = 0
    else:
        df["IsBusinessHours"] = 0

    if "TokenExpiresAt" in df.columns and "Timestamp" in df.columns:
        df["TokenExpiresAt"] = pd.to_datetime(df["TokenExpiresAt"], errors="coerce")
        df["SessionDurationHrs"] = (
            (df["TokenExpiresAt"] - df["Timestamp"]).dt.total_seconds() / 3600
        ).clip(lower=0).fillna(0)
    else:
        df["SessionDurationHrs"] = 0

    if "ActionName" in df.columns:
        df["IsLogin"]        = df["ActionName"].isin(["UserLoggedIn", "LoginFailed"]).astype(int)
        df["IsProfile"]      = (df["ActionName"] == "ProfileViewed").astype(int)
        df["IsBulk"]         = (df["ActionName"] == "BulkImportStudents").astype(int)
        df["ActionName_Enc"] = LabelEncoder().fit_transform(df["ActionName"])
    else:
        df["IsLogin"] = df["IsProfile"] = df["IsBulk"] = df["ActionName_Enc"] = 0

    if "ProcessingTimeMs" in df.columns:
        df["ProcessingTimeMs_Norm"] = scalers.fit_transform("log_processing_ms", df[["ProcessingTimeMs"]])

    if "UserId" in df.columns:
        real = df[df["UserId"] != DOMAIN["guest_user_id"]].copy()
        user_stats = real.groupby("UserId").agg(
            ActionCount    =("Id",                "count"),
            LoginCount     =("IsLogin",           "sum"),
            BizHours       =("IsBusinessHours",   "sum"),
            AvgProcessingMs=("ProcessingTimeMs",  "mean"),
        ).reset_index()

        vol = scalers.fit_transform("log_engagement_volume", user_stats[["ActionCount"]])[:, 0]
        spd = scalers.fit_transform("log_engagement_speed",  1 / (user_stats[["AvgProcessingMs"]] + 1))[:, 0]
        user_stats["EngagementIndex"] = (
            vol * DOMAIN["engagement_activity_weight"] + spd * DOMAIN["engagement_speed_weight"]
        ).clip(0, 1)

        df = df.merge(user_stats[["UserId", "EngagementIndex", "ActionCount"]], on="UserId", how="left")
        df["EngagementIndex"] = df["EngagementIndex"].fillna(0.0)
        df["ActionCount"]     = df["ActionCount"].fillna(0).astype(int)
    else:
        df["EngagementIndex"] = 0.0
        df["ActionCount"]     = 0

    df_analytics = df.copy()
    df_ml = df.drop(columns=["UserAgent", "Metadata", "TokenExpiresAt", "IpAddress", "Description"], errors="ignore")

    record_audit("activity_log", "transform", len(df))
    return df_ml, df_analytics


def transform_courses(df, enroll):
    log.info("[courses] Transforming...")

    if "CreatedAt" in df.columns:
        df["CreatedAt_Year"]  = df["CreatedAt"].dt.year
        df["CreatedAt_Month"] = df["CreatedAt"].dt.month

    if "CourseId" in enroll.columns and "StudentProfileId" in enroll.columns:
        actual = (
            enroll.groupby("CourseId")["StudentProfileId"].count()
            .rename("ActualEnrolledCount").reset_index()
            .rename(columns={"CourseId": "Id"})
        )
        df = df.merge(actual, on="Id", how="left")
        df["ActualEnrolledCount"] = df["ActualEnrolledCount"].fillna(0).astype(int)
    else:
        df["ActualEnrolledCount"] = 0

    if "EnrolledStudentsCount" in df.columns:
        df["EnrollCountDiscrepancy"] = (df["EnrolledStudentsCount"] - df["ActualEnrolledCount"]).abs()
    df["HasStudents"] = (df["ActualEnrolledCount"] > 0).astype(int)

    if "DepartmentId" in df.columns:
        dept_agg = (
            df.groupby("DepartmentId")
            .agg(
                Dept_AvgCreditHours=("CreditHours",         "mean"),
                Dept_TotalEnrolled= ("ActualEnrolledCount",  "sum"),
                Dept_CourseCount=   ("Id",                   "count"),
            )
            .reset_index()
        )
        df = df.merge(dept_agg, on="DepartmentId", how="left")
        df["DepartmentName"] = df["DepartmentId"].map(DOMAIN["department_names"])

    if "CreditHours" in df.columns:
        df["CreditHours_Norm"] = scalers.fit_transform("crs_credit_hours", df[["CreditHours"]].astype(float))
    df["ActualEnrolledCount_Norm"] = scalers.fit_transform("crs_enrolled_count", df[["ActualEnrolledCount"]].astype(float))

    record_audit("courses", "transform", len(df))
    return df


def transform_enrollments(df, courses):
    log.info("[enrollments] Transforming...")

    if "EnrollmentDate" in df.columns:
        df["EnrollmentDate_Year"]    = df["EnrollmentDate"].dt.year
        df["EnrollmentDate_Month"]   = df["EnrollmentDate"].dt.month
        df["EnrollmentDate_Weekday"] = df["EnrollmentDate"].dt.dayofweek
        df["DaysSinceEnrollment"]    = (pd.Timestamp.now() - df["EnrollmentDate"]).dt.days.clip(lower=0)
    else:
        df["DaysSinceEnrollment"] = 0

    merge_cols = [c for c in ["Id", "CreditHours", "DepartmentId", "IsArchived"] if c in courses.columns]
    if "Id" in merge_cols and "CourseId" in df.columns:
        df = df.merge(
            courses[merge_cols].rename(columns={"Id": "CourseId"}),
            on="CourseId", how="left"
        )
        df["CreditHours"]  = df.get("CreditHours",  pd.Series(0, index=df.index)).fillna(0).astype(int)
        df["DepartmentId"] = df.get("DepartmentId", pd.Series(-1, index=df.index)).fillna(-1).astype(int)
        df["IsArchived"]   = df.get("IsArchived",   pd.Series(False, index=df.index)).fillna(False)

    if "StudentProfileId" in df.columns and "CreditHours" in df.columns:
        credit = df.groupby("StudentProfileId")["CreditHours"].sum().rename("TotalCreditLoad").reset_index()
        df = df.merge(credit, on="StudentProfileId", how="left")

    if "DepartmentId" in df.columns:
        df["DepartmentName"] = df["DepartmentId"].map(DOMAIN["department_names"])

    record_audit("enrollments", "transform", len(df))
    return df


def transform_activities(df):
    log.info("[activities] Transforming...")

    if "CreatedAt" in df.columns:
        df["CreatedAt_Year"]    = df["CreatedAt"].dt.year
        df["CreatedAt_Month"]   = df["CreatedAt"].dt.month
        df["CreatedAt_Weekday"] = df["CreatedAt"].dt.dayofweek

    if "DueDate" in df.columns and "CreatedAt" in df.columns:
        df["DaysUntilDue"] = (df["DueDate"] - df["CreatedAt"]).dt.days.clip(lower=0)
        df["DaysUntilDue"] = df["DaysUntilDue"].fillna(-1)

    if "ActivityType" in df.columns:
        df["IsQuiz"]           = (df["ActivityType"] == "Quiz").astype(int)
        df["IsAssignment"]     = (df["ActivityType"] == "Assignment").astype(int)
        df["IsLecture"]        = (df["ActivityType"] == "Lecture").astype(int)
        df["ActivityType_Enc"] = LabelEncoder().fit_transform(df["ActivityType"].fillna("Unknown"))

    if "MaxGrade" in df.columns:
        quiz_assign = df["ActivityType"].isin(["Quiz", "Assignment"])
        df.loc[quiz_assign, "MaxGrade_Norm"] = scalers.fit_transform(
            "act_max_grade", df.loc[quiz_assign, ["MaxGrade"]].fillna(0)
        )

    if "IsAiGenerated" in df.columns:
        df["AiContent_Flag"] = df["IsAiGenerated"].fillna(0).astype(int)

    record_audit("activities", "transform", len(df))
    return df


def transform_attempts(df):
    log.info("[attempts] Transforming...")

    if "StartedAt" in df.columns:
        df["StartedAt_Hour"]    = df["StartedAt"].dt.hour
        df["StartedAt_Weekday"] = df["StartedAt"].dt.dayofweek
        df["StartedAt_Month"]   = df["StartedAt"].dt.month
        df["IsNightAttempt"]    = (df["StartedAt_Hour"] < 6).astype(int)

    if "TimeSpentSeconds" in df.columns:
        df["TimeSpentMinutes"] = (df["TimeSpentSeconds"] / 60).clip(lower=0).round(1)
        df["TimeSpent_Norm"]   = scalers.fit_transform("att_time_spent", df[["TimeSpentSeconds"]])

    if "Score" in df.columns and "MaxScore" in df.columns:
        has_score = df["Score"].notna() & df["MaxScore"].notna() & (df["MaxScore"] > 0)
        df["PassRatePct"] = np.nan
        df.loc[has_score, "PassRatePct"] = df.loc[has_score, "ScorePercent"]
        df["Passed"] = (df["ScorePercent"] >= 50).astype(int)

    if "AttemptNumber" in df.columns:
        df["IsFirstAttempt"] = (df["AttemptNumber"] == 1).astype(int)
        df["IsRetry"]        = (df["AttemptNumber"] > 1).astype(int)

    record_audit("attempts", "transform", len(df))
    return df


def transform_submissions(df):
    log.info("[submissions] Transforming...")

    if "SubmittedAt" in df.columns:
        df["SubmittedAt_Month"]   = df["SubmittedAt"].dt.month
        df["SubmittedAt_Weekday"] = df["SubmittedAt"].dt.dayofweek
        df["SubmittedAt_Hour"]    = df["SubmittedAt"].dt.hour
        df["LastMinuteSubmit"]    = (df["SubmittedAt_Hour"] >= 22).astype(int)

    if "SubmittedAt" in df.columns and "GradedAt" in df.columns:
        df["GradingTurnAroundDays"] = (df["GradedAt"] - df["SubmittedAt"]).dt.days.clip(lower=0)
        df["GradingTurnAroundDays"] = df["GradingTurnAroundDays"].fillna(-1)

    if "Grade" in df.columns:
        df["Grade_Norm"] = scalers.fit_transform("sub_grade", df[["Grade"]].fillna(0))

    if "FileSizeBytes" in df.columns:
        df["FileSizeMB"] = (df["FileSizeBytes"] / 1_048_576).round(2)

    record_audit("submissions", "transform", len(df))
    return df


def transform_progress(df):
    log.info("[progress] Transforming...")

    if "FirstAccessedAt" in df.columns and "LastAccessedAt" in df.columns:
        df["LearningSpanDays"] = (df["LastAccessedAt"] - df["FirstAccessedAt"]).dt.days.clip(lower=0)
        df["LearningSpanDays"] = df["LearningSpanDays"].fillna(0)

    if "TotalTimeSpentSeconds" in df.columns:
        df["TotalTimeSpentMinutes"] = (df["TotalTimeSpentSeconds"] / 60).round(1)
        df["TimeSpent_Norm"]        = scalers.fit_transform("prg_time_spent", df[["TotalTimeSpentSeconds"]].fillna(0))

    if "ProgressPercent" in df.columns:
        df["ProgressPercent_Norm"] = scalers.fit_transform("prg_progress", df[["ProgressPercent"]].astype(float))

    if "Status" in df.columns:
        df["IsCompleted"]  = (df["Status"] == "Completed").astype(int)
        df["IsInProgress"] = (df["Status"] == "InProgress").astype(int)
        df["Status_Enc"]   = LabelEncoder().fit_transform(df["Status"].fillna("Unknown"))

    record_audit("progress", "transform", len(df))
    return df


def transform_all(cleaned):
    log.info("--- Stage 3: Transformation ---")

    enrollments = transform_enrollments(cleaned["enrollments"].copy(), cleaned["courses"].copy())
    students    = transform_students(cleaned["students"].copy(), enrollments)
    log_ml, log_analytics = transform_activity_log(cleaned["activity_log"].copy())
    courses     = transform_courses(cleaned["courses"].copy(), enrollments)
    users       = transform_users(cleaned["users"].copy())
    activities  = transform_activities(cleaned["activities"].copy())
    attempts    = transform_attempts(cleaned["attempts"].copy())
    submissions = transform_submissions(cleaned["submissions"].copy())
    progress    = transform_progress(cleaned["progress"].copy())

    log.info("Transformation complete.")
    return {
        "students":               students,
        "activity_log_ml":        log_ml,
        "activity_log_analytics": log_analytics,
        "courses":                courses,
        "enrollments":            enrollments,
        "users":                  users,
        "activities":             activities,
        "attempts":               attempts,
        "submissions":            submissions,
        "progress":               progress,
        "years":                  cleaned["years"],
        "squadrons":              cleaned["squadrons"],
        "departments":            cleaned["departments"],
        "questions":              cleaned["questions"],
        "options":                cleaned["options"],
        "answers":                cleaned["answers"],
        "notifications":          cleaned["notifications"],
        "comments":               cleaned["comments"],
        "likes":                  cleaned["likes"],
    }
