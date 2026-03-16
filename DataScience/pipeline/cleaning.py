import numpy as np
import pandas as pd

from pipeline_config import DOMAIN
from pipeline.logger import log, record_audit


# ── Helpers ───────────────────────────────────────────────────────────────────

def dedup(df, table, subset=None):
    before = len(df)
    if subset:
        subset = [c for c in subset if c in df.columns]
    df = df.drop_duplicates(subset=subset or None, keep="first").reset_index(drop=True)
    removed = before - len(df)
    if removed:
        log.info("[%s] Removed %d duplicate rows", table, removed)
    record_audit(table, "drop_duplicates", removed)
    return df, removed


def impute_nulls(df, table, strategies):
    total = 0
    for col, strategy in strategies.items():
        if col not in df.columns:
            continue
        n = int(df[col].isnull().sum())
        if n == 0:
            continue
        if strategy == "mean":
            fill = df[col].mean()
        elif strategy == "median":
            fill = df[col].median()
        elif strategy == "mode":
            fill = df[col].mode().iloc[0] if not df[col].mode().empty else "Unknown"
        elif strategy == "ffill":
            df[col] = df[col].ffill().bfill()
            total += n
            continue
        else:
            fill = strategy
        df[col] = df[col].fillna(fill)
        log.info("[%s] Imputed %s → %s (%d values)", table, col, fill, n)
        total += n
    return df, total


def drop_if_null(df, table, cols):
    before  = len(df)
    present = [c for c in cols if c in df.columns]
    df = df.dropna(subset=present).reset_index(drop=True)
    dropped = before - len(df)
    if dropped:
        log.info("[%s] Dropped %d rows with null in %s", table, dropped, present)
    return df, dropped


def fix_timestamp_order(df, table, created, updated):
    if created not in df.columns or updated not in df.columns:
        return df, 0
    bad   = df[updated] < df[created]
    count = int(bad.sum())
    if count:
        df.loc[bad, updated] = df.loc[bad, created]
        log.info("[%s] Fixed %d rows where %s < %s", table, count, updated, created)
    return df, count


def clip_to_range(df, table, col, lo, hi):
    if col not in df.columns:
        return df, 0
    bad   = ~df[col].between(lo, hi)
    count = int(bad.sum())
    if count:
        df[col] = df[col].clip(lo, hi)
        log.info("[%s] Clipped %d values in %s to [%s, %s]", table, count, col, lo, hi)
    return df, count


def cap_at_percentile(df, table, col, pct=0.99):
    if col not in df.columns:
        return df, 0, 0.0
    cap   = df[col].quantile(pct)
    bad   = df[col] > cap
    count = int(bad.sum())
    if count:
        df.loc[bad, col] = int(cap) if df[col].dtype.kind == "i" else cap
        log.info("[%s] Capped %d extreme values in %s at p%.0f=%.1f", table, count, col, pct * 100, cap)
    return df, count, float(cap)


def fix_invalid_fk(df, table, col, valid_set):
    if col not in df.columns:
        return df, 0
    bad   = ~df[col].isin(valid_set)
    count = int(bad.sum())
    if count:
        fill = df[col].mode().iloc[0]
        df.loc[bad, col] = fill
        log.info("[%s] Fixed %d invalid values in %s → mode=%s", table, count, col, fill)
    return df, count


def validate_fk_column(df, table, col, reference_df, ref_col="Id"):
    if col not in df.columns or ref_col not in reference_df.columns:
        return df, 0
    valid_set = set(reference_df[ref_col].dropna().unique())
    bad   = ~df[col].isin(valid_set) & df[col].notna()
    count = int(bad.sum())
    if count:
        fill = df[col].mode().iloc[0]
        df.loc[bad, col] = fill
        log.info("[%s] FK fix: %d invalid %s → mode=%s", table, count, col, fill)
        record_audit(table, f"fk_fix_{col}", count, f"ref={ref_col}, fill={fill}")
    return df, count


def add_missing_flags(df, table, cols):
    flags_added = []
    for col in cols:
        if col not in df.columns:
            continue
        flag_col = f"{col}_WasNull"
        df[flag_col] = df[col].isnull().astype(int)
        if df[flag_col].sum() > 0:
            flags_added.append(flag_col)
    if flags_added:
        log.info("[%s] Added missing-value flags: %s", table, flags_added)
    return df


def fix_invalid_category(df, table, col, valid_set):
    if col not in df.columns:
        return df, 0
    bad   = df[col].notna() & ~df[col].isin(valid_set)
    count = int(bad.sum())
    if count:
        df.loc[bad, col] = np.nan
        log.info("[%s] Nulled %d invalid category values in %s", table, count, col)
    return df, count


# ── Table cleaners ─────────────────────────────────────────────────────────────

def clean_students(df):
    log.info("[students] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "students", DOMAIN["dedup_keys"]["students"])
    df = add_missing_flags(df, "students", ["DepartmentId", "YearId", "SquadronId", "AdmissionYear"])
    df, _ = impute_nulls(df, "students", DOMAIN["null_strategies"]["students"])
    df, _ = fix_invalid_fk(df, "students", "DepartmentId", DOMAIN["valid_department_ids"])
    df, _ = fix_invalid_fk(df, "students", "SquadronId",   DOMAIN["valid_squadron_ids"])
    df, _ = clip_to_range(df, "students", "AdmissionYear",
                          DOMAIN["admission_year_min"], DOMAIN["admission_year_max"])
    df, _ = fix_timestamp_order(df, "students", "CreatedAt", "UpdatedAt")
    for col in ["DepartmentId", "YearId", "SquadronId", "AdmissionYear"]:
        if col in df.columns:
            df[col] = df[col].astype(int)
    log.info("[students] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_users(df):
    log.info("[users] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "users", DOMAIN["dedup_keys"]["users"])
    if "Email" in df.columns:
        df["Email"] = df["Email"].str.lower().str.strip()
    if "NationalId" in df.columns:
        nid_str = df["NationalId"].astype(str)
        bad_nid = df["NationalId"].notna() & ((nid_str.str.len() != 14) | (nid_str == "0" * 14))
        df.loc[bad_nid, "NationalId"] = np.nan
        if bad_nid.sum():
            log.info("[users] Nulled %d invalid NationalId values", int(bad_nid.sum()))
    df = add_missing_flags(df, "users", ["FullName", "Gender", "City"])
    df, _ = impute_nulls(df, "users", DOMAIN["null_strategies"]["users"])
    df, _ = clip_to_range(df, "users", "AccessFailedCount", 0, DOMAIN["access_failed_max"])
    if "Gender" in df.columns:
        df, _ = fix_invalid_category(df, "users", "Gender", DOMAIN["valid_genders"] | {"Unknown"})
    df, _ = fix_timestamp_order(df, "users", "CreatedAt", "UpdatedAt")
    log.info("[users] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_activity_log(df):
    log.info("[activity_log] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "activity_log", DOMAIN["dedup_keys"]["activity_log"])
    if "Metadata" in df.columns:
        df.loc[df["Metadata"] == "CORRUPTED_JSON", "Metadata"] = np.nan
    df = add_missing_flags(df, "activity_log", ["UserId", "ProcessingTimeMs", "EntityId"])
    df, _ = impute_nulls(df, "activity_log", DOMAIN["null_strategies"]["activity_log"])
    df, _, _ = cap_at_percentile(df, "activity_log", "ProcessingTimeMs", 0.99)
    if "ProcessingTimeMs" in df.columns:
        neg = df["ProcessingTimeMs"] < 0
        if neg.sum():
            df.loc[neg, "ProcessingTimeMs"] = df["ProcessingTimeMs"].median()
    if "ActionName" in df.columns and "TokenExpiresAt" in df.columns:
        wrong = (df["ActionName"] != "UserLoggedIn") & df["TokenExpiresAt"].notnull()
        df.loc[wrong, "TokenExpiresAt"] = np.nan
    log.info("[activity_log] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_courses(df):
    log.info("[courses] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "courses", DOMAIN["dedup_keys"]["courses"])
    df, _ = impute_nulls(df, "courses", DOMAIN["null_strategies"]["courses"])
    df, _ = fix_invalid_fk(df, "courses", "DepartmentId", DOMAIN["valid_department_ids"])
    df, _ = clip_to_range(df, "courses", "CreditHours",
                          DOMAIN["credit_hours_min"], DOMAIN["credit_hours_max"])
    df, _, _ = cap_at_percentile(df, "courses", "EnrolledStudentsCount", 0.99)
    df, _ = fix_timestamp_order(df, "courses", "CreatedAt", "UpdatedAt")
    for col in ["DepartmentId", "YearId", "InstructorId"]:
        if col in df.columns:
            df[col] = df[col].astype(int)
    log.info("[courses] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_enrollments(df, valid_student_ids, valid_course_ids):
    log.info("[enrollments] Cleaning...")
    rows_in = len(df)
    df, _ = drop_if_null(df, "enrollments", ["StudentProfileId", "CourseId"])
    if "CourseId" in df.columns:
        bad = df["CourseId"].isin(DOMAIN["invalid_course_fk_values"])
        if bad.sum():
            df = df[~bad].reset_index(drop=True)
            log.info("[enrollments] Removed %d invalid CourseId rows", int(bad.sum()))
    if "StudentProfileId" in df.columns and valid_student_ids:
        orphan = ~df["StudentProfileId"].isin(valid_student_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[enrollments] Dropped %d orphan student rows", int(orphan.sum()))
    if "CourseId" in df.columns and valid_course_ids:
        orphan = ~df["CourseId"].isin(valid_course_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[enrollments] Dropped %d orphan course rows", int(orphan.sum()))
    df, _ = dedup(df, "enrollments", DOMAIN["dedup_keys"]["enrollments"])
    df, _ = impute_nulls(df, "enrollments", DOMAIN["null_strategies"]["enrollments"])
    for col in ["StudentProfileId", "CourseId", "EnrolledById"]:
        if col in df.columns:
            df[col] = df[col].astype(int)
    log.info("[enrollments] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_years(df):
    log.info("[years] Cleaning...")
    df, _ = dedup(df, "years", DOMAIN["dedup_keys"]["years"])
    if "EndDate" in df.columns and "StartDate" in df.columns:
        inv = df["EndDate"] < df["StartDate"]
        if inv.sum():
            df.loc[inv, "EndDate"] = df.loc[inv, "StartDate"] + pd.Timedelta(days=270)
            log.info("[years] Fixed %d inverted date ranges", int(inv.sum()))
    if "TotalHours" in df.columns and "IsArchived" in df.columns:
        df["HoursDataQualityFlag"] = ((df["TotalHours"] == 0) & (~df["IsArchived"])).astype(int)
    return df


def clean_squadrons(df):
    log.info("[squadrons] Cleaning...")
    if "Id" in df.columns:
        over = df["Id"] > DOMAIN["max_valid_squadron_id"]
        if over.sum():
            df = df[~over].reset_index(drop=True)
            log.info("[squadrons] Removed %d oversized Id rows", int(over.sum()))
    df, _ = dedup(df, "squadrons", DOMAIN["dedup_keys"]["squadrons"])
    if "Name" in df.columns:
        blank = df["Name"].isnull() | df["Name"].isin(["", None])
        df.loc[blank, "Name"] = "Unknown"
    df, _ = impute_nulls(df, "squadrons", DOMAIN["null_strategies"]["squadrons"])
    return df


def clean_departments(df):
    log.info("[departments] Cleaning...")
    df, _ = dedup(df, "departments", DOMAIN["dedup_keys"]["departments"])
    df, _ = impute_nulls(df, "departments", DOMAIN["null_strategies"]["departments"])
    return df


def clean_activities(df, valid_course_ids):
    log.info("[activities] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "activities", DOMAIN["dedup_keys"]["activities"])
    if "CourseId" in df.columns and valid_course_ids:
        orphan = ~df["CourseId"].isin(valid_course_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[activities] Dropped %d orphan CourseId rows", int(orphan.sum()))
    if "MaxGrade" in df.columns:
        quiz_assign = df["ActivityType"].isin(["Quiz", "Assignment"])
        bad_grade   = quiz_assign & ((df["MaxGrade"] <= 0) | (df["MaxGrade"] > DOMAIN["max_grade_max"]))
        if bad_grade.sum():
            median_grade = df.loc[quiz_assign & ~bad_grade, "MaxGrade"].median()
            df.loc[bad_grade, "MaxGrade"] = median_grade
            log.info("[activities] Fixed %d invalid MaxGrade values → median=%.1f", int(bad_grade.sum()), median_grade)
    df, _ = fix_invalid_category(df, "activities", "ActivityType",   DOMAIN["valid_activity_types"])
    df, _ = fix_invalid_category(df, "activities", "DifficultyLevel",DOMAIN["valid_difficulty_levels"] | {None, np.nan})
    df, _ = fix_invalid_category(df, "activities", "SummaryStatus",  DOMAIN["valid_summary_statuses"] | {None, np.nan})
    df, _ = fix_invalid_category(df, "activities", "GradingMode",    DOMAIN["valid_grading_modes"] | {None, np.nan})
    df = add_missing_flags(df, "activities", ["Title", "MaxGrade"])
    df, _ = impute_nulls(df, "activities", DOMAIN["null_strategies"]["activities"])
    df, _ = fix_timestamp_order(df, "activities", "CreatedAt", "UpdatedAt")
    log.info("[activities] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_questions(df, valid_quiz_ids):
    log.info("[questions] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "questions", DOMAIN["dedup_keys"]["questions"])
    if "QuizId" in df.columns and valid_quiz_ids:
        orphan = ~df["QuizId"].isin(valid_quiz_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[questions] Dropped %d orphan QuizId rows", int(orphan.sum()))
    if "Marks" in df.columns:
        bad = (df["Marks"] <= 0) | (df["Marks"] > 50)
        if bad.sum():
            df.loc[bad, "Marks"] = df["Marks"].median()
            log.info("[questions] Fixed %d invalid Marks values", int(bad.sum()))
    df, _ = fix_invalid_category(df, "questions", "QuestionType", DOMAIN["valid_question_types"])
    df, _ = drop_if_null(df, "questions", ["QuestionText"])
    log.info("[questions] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_options(df, valid_question_ids):
    log.info("[options] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "options", DOMAIN["dedup_keys"]["options"])
    if "QuestionId" in df.columns and valid_question_ids:
        orphan = ~df["QuestionId"].isin(valid_question_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[options] Dropped %d orphan QuestionId rows", int(orphan.sum()))
    log.info("[options] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_attempts(df, valid_student_ids, valid_quiz_ids):
    log.info("[attempts] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "attempts", DOMAIN["dedup_keys"]["attempts"])
    df, _ = drop_if_null(df, "attempts", ["StudentId", "QuizId"])
    if valid_student_ids:
        orphan = ~df["StudentId"].isin(valid_student_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[attempts] Dropped %d orphan StudentId rows", int(orphan.sum()))
    if "Score" in df.columns and "MaxScore" in df.columns:
        over = df["Score"] > df["MaxScore"]
        if over.sum():
            df.loc[over, "Score"] = df.loc[over, "MaxScore"]
            log.info("[attempts] Clamped %d Score > MaxScore rows", int(over.sum()))
    if "Score" in df.columns and "MaxScore" in df.columns:
        has_both = df["Score"].notna() & df["MaxScore"].notna() & (df["MaxScore"] > 0)
        df.loc[has_both, "ScorePercent"] = (
            df.loc[has_both, "Score"] / df.loc[has_both, "MaxScore"] * 100
        ).round(1)
    df = add_missing_flags(df, "attempts", ["Score", "TimeSpentSeconds"])
    df, _ = impute_nulls(df, "attempts", DOMAIN["null_strategies"]["attempts"])
    df, _ = fix_invalid_category(df, "attempts", "Status", DOMAIN["valid_attempt_statuses"])
    log.info("[attempts] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_answers(df, valid_attempt_ids):
    log.info("[answers] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "answers", DOMAIN["dedup_keys"]["answers"])
    if "QuizAttemptId" in df.columns and valid_attempt_ids:
        orphan = ~df["QuizAttemptId"].isin(valid_attempt_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[answers] Dropped %d orphan QuizAttemptId rows", int(orphan.sum()))
    df, _ = impute_nulls(df, "answers", DOMAIN["null_strategies"]["answers"])
    log.info("[answers] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_submissions(df, valid_student_ids, valid_assign_ids):
    log.info("[submissions] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "submissions", DOMAIN["dedup_keys"]["submissions"])
    df, _ = drop_if_null(df, "submissions", ["StudentId", "AssignmentId"])
    if valid_student_ids:
        orphan = ~df["StudentId"].isin(valid_student_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[submissions] Dropped %d orphan StudentId rows", int(orphan.sum()))
    if valid_assign_ids:
        orphan = ~df["AssignmentId"].isin(valid_assign_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[submissions] Dropped %d orphan AssignmentId rows", int(orphan.sum()))
    if "Grade" in df.columns:
        neg = df["Grade"] < 0
        if neg.sum():
            df.loc[neg, "Grade"] = np.nan
            log.info("[submissions] Nulled %d negative Grade values", int(neg.sum()))
        over = df["Grade"] > DOMAIN["max_grade_max"]
        if over.sum():
            df.loc[over, "Grade"] = np.nan
            log.info("[submissions] Nulled %d Grade > max values", int(over.sum()))
    df = add_missing_flags(df, "submissions", ["Grade"])
    df, _ = impute_nulls(df, "submissions", DOMAIN["null_strategies"]["submissions"])
    df, _ = fix_invalid_category(df, "submissions", "Status", DOMAIN["valid_submission_statuses"])
    for col in ["StudentId", "AssignmentId"]:
        if col in df.columns:
            df[col] = df[col].astype(int)
    log.info("[submissions] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_progress(df, valid_student_ids, valid_act_ids):
    log.info("[progress] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "progress", DOMAIN["dedup_keys"]["progress"])
    df, _ = drop_if_null(df, "progress", ["StudentId", "ActivityId"])
    if valid_student_ids:
        orphan = ~df["StudentId"].isin(valid_student_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
    if valid_act_ids:
        orphan = ~df["ActivityId"].isin(valid_act_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
    df, _ = clip_to_range(df, "progress", "ProgressPercent",
                          DOMAIN["progress_pct_min"], DOMAIN["progress_pct_max"])
    if "Status" in df.columns and "ProgressPercent" in df.columns:
        bad = (df["Status"] == "Completed") & (df["ProgressPercent"] < 100)
        if bad.sum():
            df.loc[bad, "ProgressPercent"] = 100
            log.info("[progress] Fixed %d Completed rows with ProgressPercent < 100", int(bad.sum()))
    df = add_missing_flags(df, "progress", ["TotalTimeSpentSeconds"])
    df, _ = impute_nulls(df, "progress", DOMAIN["null_strategies"]["progress"])
    df, _ = fix_invalid_category(df, "progress", "Status", DOMAIN["valid_progress_statuses"])
    for col in ["StudentId", "ActivityId"]:
        if col in df.columns:
            df[col] = df[col].astype(int)
    log.info("[progress] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_notifications(df):
    log.info("[notifications] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "notifications", DOMAIN["dedup_keys"]["notifications"])
    df = add_missing_flags(df, "notifications", ["UserId"])
    df, _ = impute_nulls(df, "notifications", DOMAIN["null_strategies"]["notifications"])
    df, _ = fix_invalid_category(df, "notifications", "Type", DOMAIN["valid_notification_types"])
    log.info("[notifications] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_comments(df, valid_act_ids):
    log.info("[comments] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "comments", DOMAIN["dedup_keys"]["comments"])
    if "ActivityId" in df.columns and valid_act_ids:
        orphan = df["ActivityId"].isna() | ~df["ActivityId"].isin(valid_act_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[comments] Dropped %d orphan ActivityId rows", int(orphan.sum()))
    df = add_missing_flags(df, "comments", ["UserId"])
    df, _ = impute_nulls(df, "comments", DOMAIN["null_strategies"]["comments"])
    df, _ = fix_timestamp_order(df, "comments", "CreatedAt", "UpdatedAt")
    log.info("[comments] Done: %d → %d rows", rows_in, len(df))
    return df


def clean_likes(df, valid_comment_ids):
    log.info("[likes] Cleaning...")
    rows_in = len(df)
    df, _ = dedup(df, "likes", DOMAIN["dedup_keys"]["likes"])
    if "CommentId" in df.columns and valid_comment_ids:
        orphan = ~df["CommentId"].isin(valid_comment_ids)
        if orphan.sum():
            df = df[~orphan].reset_index(drop=True)
            log.warning("[likes] Dropped %d orphan CommentId rows", int(orphan.sum()))
    log.info("[likes] Done: %d → %d rows", rows_in, len(df))
    return df


def _get(tables, name):
    if name in tables:
        return tables[name].copy()
    log.warning("[clean_all] Table '%s' not loaded — using empty DataFrame", name)
    return pd.DataFrame()


def clean_all(tables):
    log.info("--- Stage 2: Cleaning ---")

    departments = clean_departments(_get(tables, "departments"))
    years       = clean_years(_get(tables, "years"))
    squadrons   = clean_squadrons(_get(tables, "squadrons"))
    users       = clean_users(_get(tables, "users"))
    students    = clean_students(_get(tables, "students"))
    courses     = clean_courses(_get(tables, "courses"))

    years, _    = validate_fk_column(years,    "years",    "DepartmentId", departments)
    courses, _  = validate_fk_column(courses,  "courses",  "DepartmentId", departments)
    courses, _  = validate_fk_column(courses,  "courses",  "YearId",       years)
    students, _ = validate_fk_column(students, "students", "DepartmentId", departments)

    valid_student_ids = set(students["Id"].unique()) if "Id" in students.columns else set()
    valid_course_ids  = set(courses["Id"].unique())  if "Id" in courses.columns  else set()

    activity_log = clean_activity_log(_get(tables, "activity_log"))
    enrollments  = clean_enrollments(_get(tables, "enrollments"), valid_student_ids, valid_course_ids)
    activities   = clean_activities(_get(tables, "activities"), valid_course_ids)

    valid_act_ids    = set(activities["Id"].unique()) if "Id" in activities.columns else set()
    valid_quiz_ids   = set(activities.loc[activities["ActivityType"] == "Quiz",       "Id"].unique()) if not activities.empty else set()
    valid_assign_ids = set(activities.loc[activities["ActivityType"] == "Assignment", "Id"].unique()) if not activities.empty else set()

    questions         = clean_questions(_get(tables, "questions"), valid_quiz_ids)
    valid_q_ids       = set(questions["Id"].unique()) if "Id" in questions.columns else set()
    options           = clean_options(_get(tables, "options"), valid_q_ids)
    attempts          = clean_attempts(_get(tables, "attempts"), valid_student_ids, valid_quiz_ids)
    valid_attempt_ids = set(attempts["Id"].unique()) if "Id" in attempts.columns else set()
    answers           = clean_answers(_get(tables, "answers"), valid_attempt_ids)
    submissions       = clean_submissions(_get(tables, "submissions"), valid_student_ids, valid_assign_ids)
    progress          = clean_progress(_get(tables, "progress"), valid_student_ids, valid_act_ids)
    notifications     = clean_notifications(_get(tables, "notifications"))
    comments          = clean_comments(_get(tables, "comments"), valid_act_ids)
    valid_comment_ids = set(comments["Id"].unique()) if "Id" in comments.columns else set()
    likes             = clean_likes(_get(tables, "likes"), valid_comment_ids)

    log.info("Cleaning complete.")
    return {
        "students": students, "activity_log": activity_log,
        "courses": courses, "enrollments": enrollments,
        "years": years, "squadrons": squadrons, "departments": departments,
        "users": users, "activities": activities,
        "questions": questions, "options": options,
        "attempts": attempts, "answers": answers,
        "submissions": submissions, "progress": progress,
        "notifications": notifications, "comments": comments, "likes": likes,
    }
