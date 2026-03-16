import random
from datetime import datetime
from pathlib import Path

import pandas as pd

from utils.helpers import rand_date, maybe_null


def generate(output_dir: Path, valid_student_ids: list, valid_course_ids: list, course_date_map: dict):
    print("\n[7/18] Enrollments...")

    rows      = []
    enroll_id = 1

    heavy_students = random.sample(valid_student_ids, 50)
    for sid in heavy_students:
        chosen = random.sample(valid_course_ids, min(random.randint(8, 15), len(valid_course_ids)))
        for cid in chosen:
            cs, ce = course_date_map[cid]
            rows.append({
                "Id":               enroll_id,
                "StudentProfileId": sid,
                "CourseId":         cid,
                "EnrolledById":     random.choice([1, 2, 3]),
                "EnrollmentDate":   rand_date(cs, ce),
            })
            enroll_id += 1

    while len(rows) < 10_000:
        sid  = random.choice(valid_student_ids)
        cid  = random.choice(valid_course_ids)
        cs, ce = course_date_map[cid]
        rows.append({
            "Id":               enroll_id,
            "StudentProfileId": sid,
            "CourseId":         cid,
            "EnrolledById":     maybe_null(random.choice([1, 2, 3]), 0.10),
            "EnrollmentDate":   rand_date(cs, ce),
        })
        enroll_id += 1

    for row in random.sample(rows[:500], 150):
        dup       = row.copy()
        dup["Id"] = enroll_id
        rows.append(dup)
        enroll_id += 1

    for _ in range(30):
        cid  = random.choice(valid_course_ids)
        cs, ce = course_date_map[cid]
        rows.append({"Id": enroll_id, "StudentProfileId": None, "CourseId": cid,
                     "EnrolledById": 1, "EnrollmentDate": rand_date(cs, ce)})
        enroll_id += 1

    for _ in range(20):
        rows.append({"Id": enroll_id, "StudentProfileId": random.choice(valid_student_ids),
                     "CourseId": random.choice([9999, 8888, 7777]),
                     "EnrolledById": 1, "EnrollmentDate": datetime(2024, 6, 1)})
        enroll_id += 1

    df = pd.DataFrame(rows).sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "enrollments_dataset.csv", index=False)
    print(f"   done — {len(df):,} rows")
    return df
