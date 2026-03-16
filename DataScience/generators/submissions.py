import random
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

from config.settings import INSTRUCTOR_IDS, FEEDBACK_SAMPLES
from utils.helpers import rand_date, maybe_null, rand_uuid


SUB_STATUSES = ["Submitted", "Submitted", "Submitted", "Graded", "Late", "Draft", "Missing"]


def generate(output_dir: Path, valid_student_ids: list, valid_assign_ids: list, assign_meta: dict):
    print("\n[13/18] Assignment Submissions...")

    rows   = []
    sub_id = 1

    sample_students = random.sample(valid_student_ids, min(2000, len(valid_student_ids)))
    sample_assigns  = random.sample(valid_assign_ids,  min(150,  len(valid_assign_ids)))

    for student_id in sample_students:
        chosen = random.sample(sample_assigns, min(random.randint(1, 6), len(sample_assigns)))
        for aid in chosen:
            assign    = assign_meta.get(aid, {})
            max_grade = assign.get("MaxGrade") or 100
            due_date  = assign.get("DueDate")
            created   = assign.get("CreatedAt") or datetime(2023, 1, 1)

            sub_base = created + timedelta(days=random.randint(1, 30))
            sub_at   = rand_date(sub_base, sub_base + timedelta(days=20))
            is_late  = 1 if (due_date and isinstance(due_date, datetime) and sub_at > due_date) else 0
            status   = "Late" if (is_late and random.random() > 0.3) else random.choice(SUB_STATUSES[:4])

            grade = None; feedback = None; graded_by = None; graded_at = None
            if status == "Graded" or random.random() < 0.45:
                grade     = round(random.uniform(0, max_grade), 1)
                feedback  = random.choice(FEEDBACK_SAMPLES)
                graded_by = random.choice(INSTRUCTOR_IDS)
                graded_at = sub_at + timedelta(days=random.randint(1, 14))
                if random.random() < 0.04: grade = max_grade + random.randint(5, 30)
                if random.random() < 0.03: grade = -random.randint(1, 10)

            rows.append({
                "Id":            sub_id,
                "AssignmentId":  aid if random.random() > 0.03 else random.randint(9000, 9999),
                "StudentId":     student_id,
                "FileUrl":       f"/uploads/submissions/{rand_uuid()}.pdf" if random.random() > 0.08 else None,
                "FileName":      f"submission_{student_id}_{aid}.pdf" if random.random() > 0.08 else None,
                "FileSizeBytes": maybe_null(random.randint(50_000, 15_000_000), 0.05),
                "SubmittedAt":   sub_at if random.random() > 0.05 else None,
                "Grade":         grade,
                "Feedback":      feedback,
                "GradedById":    graded_by,
                "GradedAt":      graded_at,
                "Status":        status,
                "IsLate":        is_late,
            })
            sub_id += 1

    for _ in range(40):
        rows.append({
            "Id": sub_id, "AssignmentId": random.choice(sample_assigns),
            "StudentId": None, "FileUrl": None, "FileName": None, "FileSizeBytes": None,
            "SubmittedAt": None, "Grade": None, "Feedback": None,
            "GradedById": None, "GradedAt": None, "Status": "Missing", "IsLate": 0,
        })
        sub_id += 1

    for d in random.sample(rows[:200], 50):
        dup       = d.copy()
        dup["Id"] = sub_id
        rows.append(dup)
        sub_id += 1

    df = pd.DataFrame(rows).sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "assignment_submissions_dataset.csv", index=False, sep=";")
    print(f"   done — {len(df):,} rows")
    return df
