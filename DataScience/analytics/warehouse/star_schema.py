import pandas as pd

from analytics.loader import save_schema, SCHEMA_DIR


def run(tables: dict) -> None:
    print("\n" + "="*65 + "\n  6 · Star Schema\n" + "="*65)

    students    = tables["students"]
    courses     = tables["courses"]
    activities  = tables["activities"]
    enrollments = tables["enrollments"]
    attempts    = tables["attempts"]
    submissions = tables["submissions"]
    progress    = tables["progress"]
    student_perf = tables["student_performance"]

    if not students.empty:
        dim_cols = [c for c in ["Id","DepartmentId","DepartmentName","YearId","SquadronId","TotalCreditLoad"] if c in students.columns]
        save_schema(students[dim_cols].rename(columns={"Id":"StudentId"}), "Dim_Student")
        print(f"  Dim_Student        : {len(students):,}")

    if not courses.empty:
        dim_cols = [c for c in ["Id","Title","DepartmentName","InstructorId","CreditHours","IsArchived"] if c in courses.columns]
        save_schema(courses[dim_cols].rename(columns={"Id":"CourseId"}), "Dim_Course")
        print(f"  Dim_Course         : {len(courses):,}")

    if not activities.empty:
        dim_cols = [c for c in ["Id","CourseId","Title","ActivityType","DifficultyLevel","MaxGrade"] if c in activities.columns]
        save_schema(activities[dim_cols].rename(columns={"Id":"ActivityId"}), "Dim_Activity")
        print(f"  Dim_Activity       : {len(activities):,}")

    if not enrollments.empty and "EnrollmentDate" in enrollments.columns:
        all_dates = pd.concat([
            enrollments["EnrollmentDate"].dropna(),
            attempts["StartedAt"].dropna()     if "StartedAt"   in attempts.columns   else pd.Series(dtype="datetime64[ns]"),
            submissions["SubmittedAt"].dropna() if "SubmittedAt" in submissions.columns else pd.Series(dtype="datetime64[ns]"),
        ]).dt.normalize().drop_duplicates().sort_values()
        dim_date = pd.DataFrame({"Date": all_dates})
        dim_date["Year"]    = dim_date["Date"].dt.year
        dim_date["Month"]   = dim_date["Date"].dt.month
        dim_date["Quarter"] = dim_date["Date"].dt.quarter
        dim_date["Weekday"] = dim_date["Date"].dt.day_name()
        save_schema(dim_date, "Dim_Date")
        print(f"  Dim_Date           : {len(dim_date):,}")

    if not student_perf.empty:
        fact_sp = student_perf.copy()
        if not students.empty:
            fact_sp = fact_sp.merge(
                students[["Id","DepartmentId","YearId","SquadronId"]].rename(columns={"Id":"StudentId"}),
                on="StudentId", how="left",
            )
        save_schema(fact_sp, "Fact_StudentPerformance")
        print(f"  Fact_StudentPerf   : {len(fact_sp):,}")

    if not attempts.empty:
        fact_att = attempts.copy()
        if "StartedAt" in fact_att.columns:
            fact_att["Date"] = fact_att["StartedAt"].dt.normalize()
        save_schema(fact_att, "Fact_QuizAttempts")
        print(f"  Fact_QuizAttempts  : {len(fact_att):,}")

    if not submissions.empty:
        fact_sub = submissions.copy()
        if "SubmittedAt" in fact_sub.columns:
            fact_sub["Date"] = fact_sub["SubmittedAt"].dt.normalize()
        save_schema(fact_sub, "Fact_Submissions")
        print(f"  Fact_Submissions   : {len(fact_sub):,}")

    if not progress.empty:
        save_schema(progress, "Fact_ActivityProgress")
        print(f"  Fact_Progress      : {len(progress):,}")

    print(f"\n  ✅ Star schema → {SCHEMA_DIR}")
