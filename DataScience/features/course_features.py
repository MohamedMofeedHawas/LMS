"""
Course Feature Engineering
===========================
Builds a flat feature table per course from all related tables.

Outputs:
  pipeline_output/features/course_features.csv
"""
import numpy as np
import pandas as pd
from features.feature_utils import load, safe_divide, normalize_minmax


def build_all() -> pd.DataFrame:
    print("Building course features...")

    courses     = load("courses")
    enrollments = load("enrollments")
    attempts    = load("attempts")
    submissions = load("submissions")
    progress    = load("progress")
    activities  = load("activities")

    if courses.empty:
        return pd.DataFrame()

    base = courses[[
        "Id","DepartmentId","CreditHours","IsArchived","InstructorId"
    ]].rename(columns={"Id":"CourseId"}).copy()

    # enrollment count
    if not enrollments.empty and "CourseId" in enrollments.columns:
        enr = (
            enrollments.groupby("CourseId")
            .agg(EnrolledStudents=("StudentProfileId","nunique"))
            .reset_index()
        )
        base = base.merge(enr, on="CourseId", how="left")

    # activity composition
    if not activities.empty and "CourseId" in activities.columns:
        act = activities.copy()
        act["IsQuiz"]       = (act["ActivityType"] == "Quiz").astype(int)       if "ActivityType" in act.columns else 0
        act["IsAssignment"] = (act["ActivityType"] == "Assignment").astype(int) if "ActivityType" in act.columns else 0
        act["IsLecture"]    = (act["ActivityType"] == "Lecture").astype(int)    if "ActivityType" in act.columns else 0

        agg = (
            act.groupby("CourseId")
            .agg(
                TotalActivities  =("Id",           "count"),
                QuizCount        =("IsQuiz",        "sum"),
                AssignmentCount  =("IsAssignment",  "sum"),
                LectureCount     =("IsLecture",     "sum"),
            )
            .reset_index()
        )
        base = base.merge(agg, on="CourseId", how="left")
        base["QuizDensity"]       = safe_divide(base["QuizCount"],       base["TotalActivities"]).round(4)
        base["AssignmentDensity"] = safe_divide(base["AssignmentCount"],  base["TotalActivities"]).round(4)

    # completion & dropout
    if not progress.empty and not activities.empty and "CourseId" in activities.columns:
        act_map = activities[["Id","CourseId"]].rename(columns={"Id":"ActivityId"})
        prog_c  = progress.merge(act_map, on="ActivityId", how="left").dropna(subset=["CourseId"])
        comp = (
            prog_c.groupby("CourseId")
            .agg(
                CompletionRate  =("IsCompleted",     "mean"),
                AvgProgress     =("ProgressPercent",  "mean"),
                AvgTimeMinutes  =("TotalTimeSpentMinutes","mean"),
            )
            .round(3).reset_index()
        )
        comp["DropoutRate"] = (1 - comp["CompletionRate"]).round(3)
        base = base.merge(comp, on="CourseId", how="left")

    # quiz performance per course
    if not attempts.empty and not activities.empty and "ActivityType" in activities.columns:
        quiz_map = activities[activities["ActivityType"] == "Quiz"][["Id","CourseId"]].rename(columns={"Id":"QuizId"})
        if not quiz_map.empty:
            att_c = attempts.merge(quiz_map, on="QuizId", how="inner").dropna(subset=["CourseId"])
            qperf = (
                att_c.groupby("CourseId")
                .agg(
                    AvgQuizScore   =("ScorePercent",  "mean"),
                    QuizPassRate   =("Passed",        "mean"),
                    AvgAttempts    =("AttemptNumber", "mean"),
                    TotalAttempts  =("Id",            "count"),
                )
                .round(3).reset_index()
            )
            base = base.merge(qperf, on="CourseId", how="left")

    # assignment performance per course
    if not submissions.empty and not activities.empty and "ActivityType" in activities.columns:
        assign_map = activities[activities["ActivityType"] == "Assignment"][["Id","CourseId"]].rename(columns={"Id":"AssignmentId"})
        if not assign_map.empty:
            sub_c = submissions.merge(assign_map, on="AssignmentId", how="inner").dropna(subset=["CourseId"])
            sperf = (
                sub_c.groupby("CourseId")
                .agg(
                    AvgAssignGrade =("Grade",  "mean"),
                    AssignLateRate =("IsLate", "mean"),
                )
                .round(3).reset_index()
            )
            base = base.merge(sperf, on="CourseId", how="left")

    # course difficulty index (composite — behavior-based, not label-based)
    difficulty_parts = []
    if "QuizPassRate"   in base.columns: difficulty_parts.append(1 - base["QuizPassRate"].clip(0,1))
    if "CompletionRate" in base.columns: difficulty_parts.append(1 - base["CompletionRate"].clip(0,1))
    if "AvgQuizScore"   in base.columns: difficulty_parts.append(1 - base["AvgQuizScore"].clip(0,100)/100)
    if difficulty_parts:
        base["CourseDifficultyIndex"] = (
            sum(difficulty_parts) / len(difficulty_parts)
        ).round(4)

    base = base.fillna(0)
    print(f"  Done: {len(base):,} courses × {len(base.columns)} features")
    return base
