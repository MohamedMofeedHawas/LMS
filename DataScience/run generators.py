import random
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).parent))

from config.settings import SEED
np.random.seed(SEED)
random.seed(SEED)

OUTPUT_DIR = Path(__file__).parent / "data" / "raw"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

from generators.departments      import generate as gen_departments
from generators.users            import generate as gen_users
from generators.students         import generate as gen_students
from generators.years            import generate as gen_years
from generators.squadrons        import generate as gen_squadrons
from generators.courses          import generate as gen_courses
from generators.enrollments      import generate as gen_enrollments
from generators.activity_log     import generate as gen_activity_log
from generators.activities       import generate as gen_activities
from generators.questions_options import generate as gen_questions_options
from generators.attempts_answers  import generate as gen_attempts_answers
from generators.submissions      import generate as gen_submissions
from generators.progress         import generate as gen_progress
from generators.notifications    import generate as gen_notifications
from generators.comments         import generate as gen_comments
from generators.likes            import generate as gen_likes


print("=" * 65)
print("   Generating all tables — this might take a few seconds")
print("=" * 65)

df_departments                                          = gen_departments(OUTPUT_DIR)
df_users, all_user_ids, student_user_ids                = gen_users(OUTPUT_DIR)
df_students, valid_student_ids                          = gen_students(OUTPUT_DIR, all_user_ids, student_user_ids)
df_years, valid_year_ids                                = gen_years(OUTPUT_DIR)
df_squadrons                                            = gen_squadrons(OUTPUT_DIR)
df_courses, valid_course_ids, course_date_map           = gen_courses(OUTPUT_DIR, valid_year_ids)
df_enrollments                                          = gen_enrollments(OUTPUT_DIR, valid_student_ids, valid_course_ids, course_date_map)
df_logs                                                 = gen_activity_log(OUTPUT_DIR)
df_activities, valid_act_ids, valid_quiz_ids, valid_assign_ids, quiz_meta, assign_meta = gen_activities(OUTPUT_DIR, n_courses=200, course_date_map=course_date_map)
df_questions, df_options, opt_map, valid_q_ids, questions_rows = gen_questions_options(OUTPUT_DIR, valid_quiz_ids)
df_attempts, df_answers                                 = gen_attempts_answers(OUTPUT_DIR, valid_student_ids, valid_quiz_ids, quiz_meta, questions_rows, opt_map)
df_submissions                                          = gen_submissions(OUTPUT_DIR, valid_student_ids, valid_assign_ids, assign_meta)
df_progress                                             = gen_progress(OUTPUT_DIR, valid_student_ids, valid_act_ids)
df_notifications                                        = gen_notifications(OUTPUT_DIR, all_user_ids, valid_act_ids)
df_comments, valid_comment_ids                          = gen_comments(OUTPUT_DIR, all_user_ids, valid_act_ids)
df_likes                                                = gen_likes(OUTPUT_DIR, all_user_ids, valid_comment_ids)


print("\n[18/18] Wrapping up...")

all_tables = [
    ("departments_dataset.csv",               df_departments),
    ("aspnetusers_dataset.csv",               df_users),
    ("students_profile_dataset.csv",          df_students),
    ("years_dataset.csv",                     df_years),
    ("squadrons_dataset.csv",                 df_squadrons),
    ("courses_dataset.csv",                   df_courses),
    ("enrollments_dataset.csv",               df_enrollments),
    ("activity_log_dataset.csv",              df_logs),
    ("activities_dataset.csv",                df_activities),
    ("questions_dataset.csv",                 df_questions),
    ("question_options_dataset.csv",          df_options),
    ("quiz_attempts_dataset.csv",             df_attempts),
    ("student_answers_dataset.csv",           df_answers),
    ("assignment_submissions_dataset.csv",    df_submissions),
    ("student_activity_progress_dataset.csv", df_progress),
    ("notifications_dataset.csv",             df_notifications),
    ("comments_dataset.csv",                  df_comments),
    ("comment_likes_dataset.csv",             df_likes),
]

total_rows = sum(len(df) for _, df in all_tables)

print("\n" + "=" * 65)
print("   All files saved to:", OUTPUT_DIR)
print("=" * 65)
for fname, df in all_tables:
    print(f"   {fname:<48}  {len(df):>8,} rows")
print(f"   {'─' * 48}  {'─' * 8}")
print(f"   {'TOTAL':48}  {total_rows:>8,} rows")
print("=" * 65)
