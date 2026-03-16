import pandas as pd

from pipeline_config import DOMAIN
from pipeline.logger import log


def build_feature_tables(transformed):
    log.info("--- Stage 5.5: Building Feature Tables ---")

    students    = transformed.get("students",               pd.DataFrame())
    enrollments = transformed.get("enrollments",            pd.DataFrame())
    courses     = transformed.get("courses",                pd.DataFrame())
    activities  = transformed.get("activities",             pd.DataFrame())
    attempts    = transformed.get("attempts",               pd.DataFrame())
    submissions = transformed.get("submissions",            pd.DataFrame())
    progress    = transformed.get("progress",               pd.DataFrame())
    logs        = transformed.get("activity_log_analytics", pd.DataFrame())
    comments    = transformed.get("comments",               pd.DataFrame())
    likes       = transformed.get("likes",                  pd.DataFrame())

    feat = {}

    if not students.empty and "Id" in students.columns:
        eng = students[["Id"]].rename(columns={"Id": "StudentId"}).copy()

        if not logs.empty and "UserId" in logs.columns:
            log_agg = (
                logs[logs["UserId"] != DOMAIN.get("guest_user_id", -1)]
                .groupby("UserId")
                .agg(ActionCount=("Id", "count"), LoginCount=("IsLogin", "sum"))
                .reset_index().rename(columns={"UserId": "StudentId"})
            )
            eng = eng.merge(log_agg, on="StudentId", how="left")

        if not comments.empty and "UserId" in comments.columns:
            comm_agg = (
                comments.groupby("UserId").size()
                .rename("CommentsCount").reset_index()
                .rename(columns={"UserId": "StudentId"})
            )
            eng = eng.merge(comm_agg, on="StudentId", how="left")

        if not likes.empty and "UserId" in likes.columns:
            likes_agg = (
                likes.groupby("UserId").size()
                .rename("LikesGiven").reset_index()
                .rename(columns={"UserId": "StudentId"})
            )
            eng = eng.merge(likes_agg, on="StudentId", how="left")

        if not progress.empty and "StudentId" in progress.columns:
            prog_agg = (
                progress.groupby("StudentId")
                .agg(
                    ActivitiesCompleted=("IsCompleted",     "sum"),
                    CompletionRate     =("IsCompleted",     "mean"),
                    AvgProgressPct     =("ProgressPercent", "mean"),
                )
                .reset_index()
            )
            eng = eng.merge(prog_agg, on="StudentId", how="left")

        for c in ["ActionCount", "LoginCount", "CommentsCount", "LikesGiven",
                  "ActivitiesCompleted", "CompletionRate", "AvgProgressPct"]:
            if c in eng.columns:
                eng[c] = eng[c].fillna(0)

        feat["engagement"] = eng
        log.info("  engagement: %d rows", len(eng))

    if not students.empty and "Id" in students.columns:
        sp = students[["Id"]].rename(columns={"Id": "StudentId"}).copy()

        if not attempts.empty and "StudentId" in attempts.columns:
            att_agg = (
                attempts.groupby("StudentId")
                .agg(
                    QuizAttempts=("Id",          "count"),
                    AvgQuizScore=("ScorePercent", "mean"),
                    QuizPassRate=("Passed",       "mean"),
                )
                .reset_index()
            )
            sp = sp.merge(att_agg, on="StudentId", how="left")

        if not submissions.empty and "StudentId" in submissions.columns:
            sub_agg = (
                submissions.groupby("StudentId")
                .agg(Submissions=("Id", "count"), AvgGrade=("Grade", "mean"))
                .reset_index()
            )
            sp = sp.merge(sub_agg, on="StudentId", how="left")

        if not progress.empty and "StudentId" in progress.columns:
            prog_sp = (
                progress.groupby("StudentId")
                .agg(CompletionRate=("IsCompleted", "mean"))
                .reset_index()
            )
            sp = sp.merge(prog_sp, on="StudentId", how="left")

        for c in ["QuizAttempts", "AvgQuizScore", "QuizPassRate", "Submissions", "AvgGrade", "CompletionRate"]:
            if c in sp.columns:
                sp[c] = sp[c].fillna(0)

        feat["student_performance"] = sp.round(4)
        log.info("  student_performance: %d rows", len(sp))

    if not courses.empty and "Id" in courses.columns:
        cm = courses[["Id"]].rename(columns={"Id": "CourseId"}).copy()
        for col in ["Title", "DepartmentName", "InstructorId", "ActualEnrolledCount"]:
            if col in courses.columns:
                cm[col] = courses[col].values

        if not activities.empty and "CourseId" in activities.columns:
            act_agg = (
                activities.groupby("CourseId")
                .agg(
                    TotalActivities=("Id",           "count"),
                    QuizCount      =("IsQuiz",        "sum"),
                    AssignmentCount=("IsAssignment",  "sum"),
                )
                .reset_index()
            )
            cm = cm.merge(act_agg, on="CourseId", how="left")

        if not attempts.empty and "QuizId" in attempts.columns and not activities.empty:
            quiz_course = (
                activities[activities["ActivityType"] == "Quiz"][["Id", "CourseId"]]
                .rename(columns={"Id": "QuizId"})
            )
            att_course = attempts.merge(quiz_course, on="QuizId", how="left")
            att_agg = (
                att_course.groupby("CourseId")
                .agg(
                    TotalAttempts=("Id",          "count"),
                    AvgQuizScore =("ScorePercent", "mean"),
                    QuizPassRate =("Passed",       "mean"),
                )
                .reset_index()
            )
            cm = cm.merge(att_agg, on="CourseId", how="left")

        if not progress.empty and not activities.empty and "ActivityId" in progress.columns:
            act_course  = activities[["Id", "CourseId"]].rename(columns={"Id": "ActivityId"})
            prog_course = progress.merge(act_course, on="ActivityId", how="left")
            prog_agg = (
                prog_course.groupby("CourseId")
                .agg(CompletionRate=("IsCompleted", "mean"))
                .reset_index()
            )
            cm = cm.merge(prog_agg, on="CourseId", how="left")

        for c in ["TotalActivities", "QuizCount", "AssignmentCount", "TotalAttempts",
                  "AvgQuizScore", "QuizPassRate", "CompletionRate"]:
            if c in cm.columns:
                cm[c] = cm[c].fillna(0)

        feat["course_metrics"] = cm.round(4)
        log.info("  course_metrics: %d rows", len(cm))

    if "student_performance" in feat and "engagement" in feat:
        ml = feat["student_performance"].merge(
            feat["engagement"].drop(columns=["CompletionRate"], errors="ignore"),
            on="StudentId", how="left",
        )

        if not students.empty:
            extra_cols = [c for c in ["EnrolledCourseCount", "TotalCreditLoad", "AdmissionYear", "DepartmentId"] if c in students.columns]
            ml = ml.merge(
                students[["Id"] + extra_cols].rename(columns={"Id": "StudentId"}),
                on="StudentId", how="left",
            )

        f1 = 1 - (ml["AvgQuizScore"].clip(0, 100) / 100) if "AvgQuizScore"   in ml.columns else pd.Series(0.5, index=ml.index)
        f2 = 1 - ml["CompletionRate"].clip(0, 1)          if "CompletionRate" in ml.columns else pd.Series(0.5, index=ml.index)
        f3 = 1 - ml["QuizPassRate"].clip(0, 1)            if "QuizPassRate"   in ml.columns else pd.Series(0.5, index=ml.index)
        if "Submissions" in ml.columns:
            max_sub = ml["Submissions"].max()
            f4 = 1 - (ml["Submissions"] / (max_sub + 1)) if max_sub > 0 else pd.Series(0.5, index=ml.index)
        else:
            f4 = pd.Series(0.5, index=ml.index)

        ml["EnhancedRiskScore"] = ((f1 + f2 + f3 + f4) / 4).round(4)
        ml["AtRisk"] = (ml["EnhancedRiskScore"] >= 0.7).astype(int)
        ml = ml.drop(columns=["UserId", "FullName", "Email", "NationalId", "DateOfBirth",
                               "PhoneNumber", "ProfileImageUrl"], errors="ignore")

        feat["ml_features_dataset"] = ml.round(4)
        log.info("  ml_features_dataset: %d rows, AtRisk=%d", len(ml), int(ml["AtRisk"].sum()))

    return feat
