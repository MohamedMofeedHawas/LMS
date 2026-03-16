import random
from datetime import timedelta
from pathlib import Path

import pandas as pd

from config.settings import DEPT_IDS, COURSE_TITLES, LOG_SENTENCES
from utils.helpers import rand_date, maybe_null, rand_uuid, DATE_RANGES


def generate(output_dir: Path, valid_year_ids: list, n: int = 200):
    print("\n[6/18] Courses...")

    rows = []

    for cid in range(1, n + 1):
        dr         = random.choice(DATE_RANGES)
        created_at = rand_date(dr[0], dr[1])

        if   random.random() < 0.05: credit_h = random.choice([0, 0, 20, 150])
        elif random.random() < 0.10: credit_h = 1
        else:                         credit_h = random.randint(2, 4)

        if   random.random() < 0.10: enrolled = 0
        elif random.random() < 0.05: enrolled = random.randint(500, 1200)
        else:                         enrolled = random.randint(5, 250)

        dp      = random.random()
        dept_id = random.choice(DEPT_IDS) if dp < 0.75 else (7 if dp < 0.88 else None)

        yp      = random.random()
        year_id = (random.choice(valid_year_ids[:12]) if yp < 0.70
                   else (random.randint(200, 999) if yp < 0.85 else None))

        rows.append({
            "Id":                    cid,
            "Title":                 random.choice(COURSE_TITLES),
            "Description":           maybe_null(random.choice(LOG_SENTENCES), 0.05),
            "ImageUrl":              f"/uploads/courses/{rand_uuid()}.png",
            "CreditHours":           credit_h,
            "EnrolledStudentsCount": enrolled,
            "DepartmentId":          dept_id,
            "YearId":                year_id,
            "CreatedById":           random.choice([1, 2, 3]),
            "IsArchived":            random.choice([True, False]),
            "InstructorId":          maybe_null(random.randint(1, 15), 0.05),
            "CreatedAt":             created_at,
            "UpdatedAt":             created_at + timedelta(days=random.randint(0, 120)),
        })

    df = pd.DataFrame(rows)
    df.to_csv(output_dir / "courses_dataset.csv", index=False)

    valid_course_ids = [r["Id"] for r in rows if r["DepartmentId"] in DEPT_IDS]
    course_date_map  = {r["Id"]: (r["CreatedAt"], r["CreatedAt"] + timedelta(days=365)) for r in rows}

    print(f"   done — {len(df):,} rows")
    return df, valid_course_ids, course_date_map
