import random
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

from config.settings import LECTURE_TITLES, INSTRUCTOR_IDS
from utils.helpers import rand_date, maybe_null, rand_uuid


ACT_TYPES         = ["Lecture", "Quiz", "Assignment"]
ACT_WEIGHTS       = [0.55, 0.25, 0.20]
CONTENT_TYPES     = ["Pdf", "Video", "Pdf", "Pdf", None]
DIFFICULTY_LEVELS = ["Easy", "Medium", "Hard", None]
GRADING_MODES     = ["Auto", "Manual", None]
QUIZ_SCOPES       = ["FullCourse", "SingleLecture", "MultiLecture", None]
SUMMARY_STATUSES  = ["Done", "Pending", "Failed", None]


def generate(output_dir: Path, n_courses: int = 200, course_date_map: dict = None):
    print("\n[9/18] Activities (Lectures / Quizzes / Assignments)...")

    if course_date_map is None:
        course_date_map = {}

    rows   = []
    act_id = 1

    for course_id in range(1, n_courses + 1):
        course_start = course_date_map.get(course_id, (datetime(2022, 1, 1), datetime(2023, 1, 1)))[0]
        sort_order   = 0

        for _ in range(random.randint(3, 18)):
            atype      = random.choices(ACT_TYPES, weights=ACT_WEIGHTS)[0]
            title      = random.choice(LECTURE_TITLES)
            created    = rand_date(course_start, course_start + timedelta(days=365))
            is_quiz    = atype == "Quiz"
            is_assign  = atype == "Assignment"
            is_lec     = atype == "Lecture"
            max_grade  = random.choice([10, 20, 25, 50, 100]) if (is_quiz or is_assign) else None
            passing_sc = round(max_grade * random.uniform(0.45, 0.65), 1) if max_grade else None
            sort_order += random.randint(1, 3)

            if random.random() < 0.04 and max_grade:
                max_grade = random.choice([-5, 0, 999])

            rows.append({
                "Id":                         act_id,
                "CourseId":                   course_id if random.random() > 0.03 else random.randint(500, 999),
                "Title":                      title if random.random() > 0.04 else None,
                "Description":                maybe_null(f"Description for {title}", 0.25),
                "SortOrder":                  sort_order,
                "IsVisible":                  random.choice([1, 1, 1, 0]),
                "DueDate":                    maybe_null(created + timedelta(days=random.randint(7, 60)), 0.40),
                "TargetSquadronId":           maybe_null(random.randint(1, 79), 0.65),
                "CreatedById":                random.choice(INSTRUCTOR_IDS),
                "CreatedAt":                  created,
                "UpdatedAt":                  maybe_null(created + timedelta(days=random.randint(1, 90)), 0.12),
                "ActivityType":               atype,
                "AdditionalFileUrls":         maybe_null(f"/uploads/extra/{rand_uuid()}.pdf", 0.80),
                "AiPromptUsed":               maybe_null("Summarize this lecture", 0.75),
                "AiSummary":                  maybe_null(f"AI summary for {title}", 0.60),
                "ContentType":                random.choice(CONTENT_TYPES) if is_lec else None,
                "DifficultyLevel":            random.choice(DIFFICULTY_LEVELS) if is_quiz else None,
                "FileUrl":                    f"/uploads/lectures/{course_id}/{rand_uuid()}.pdf" if is_lec else None,
                "GradingMode":                random.choice(GRADING_MODES) if is_assign else None,
                "Instructions":               maybe_null(f"Please complete the {atype.lower()} carefully.", 0.30) if not is_lec else None,
                "MaxGrade":                   max_grade,
                "PassingScore":               passing_sc,
                "QuizScope":                  random.choice(QUIZ_SCOPES) if is_quiz else None,
                "SourceLectureIds":           maybe_null(str([random.randint(1, act_id)] * random.randint(1, 3)), 0.70) if is_quiz else None,
                "ThumbnailUrl":               maybe_null(f"/uploads/thumbnails/{rand_uuid()}.jpg", 0.70),
                "TotalMarks":                 max_grade if is_quiz else None,
                "Transcript":                 maybe_null("Auto-generated transcript...", 0.85),
                "AllowLateSubmission":        random.choice([1, 0, None]) if is_assign else None,
                "TranscriptGeneratedAt":      maybe_null(created + timedelta(days=1), 0.80),
                "SummaryGeneratedAt":         maybe_null(created + timedelta(days=2), 0.75),
                "TimeLimitMinutes":           random.choice([15, 20, 30, 45, 60, 90, None]) if is_quiz else None,
                "MaxAttempts":                random.choice([1, 2, 3, None]) if is_quiz else None,
                "ShuffleQuestions":           random.choice([1, 0]) if is_quiz else None,
                "ShowCorrectAnswers":         random.choice([1, 0]) if is_quiz else None,
                "ShowExplanations":           random.choice([1, 0]) if is_quiz else None,
                "IsAiGenerated":              random.choice([1, 0, 0, 0]),
                "EstimatedCompletionMinutes": random.choice([5, 10, 15, 20, 30, 45, 60, None]),
                "SummaryStatus":              random.choice(SUMMARY_STATUSES),
                "AssignmentFileUrls":         maybe_null(f"/uploads/assignments/{rand_uuid()}.pdf", 0.70) if is_assign else None,
            })
            act_id += 1

    for d in random.sample(rows, 80):
        dup       = d.copy()
        dup["Id"] = act_id
        rows.append(dup)
        act_id += 1

    df = pd.DataFrame(rows).sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "activities_dataset.csv", index=False, sep=";")

    valid_act_ids    = [r["Id"] for r in rows]
    valid_quiz_ids   = [r["Id"] for r in rows if r["ActivityType"] == "Quiz"]
    valid_assign_ids = [r["Id"] for r in rows if r["ActivityType"] == "Assignment"]
    quiz_meta        = {r["Id"]: r for r in rows if r["ActivityType"] == "Quiz"}
    assign_meta      = {r["Id"]: r for r in rows if r["ActivityType"] == "Assignment"}

    print(f"   done — {len(df):,} rows  ({len(valid_quiz_ids)} quizzes | {len(valid_assign_ids)} assignments)")
    return df, valid_act_ids, valid_quiz_ids, valid_assign_ids, quiz_meta, assign_meta
