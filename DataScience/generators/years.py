import random
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

from config.settings import DEPT_IDS, YEAR_LEVELS, ACADEMIC_YEARS, LOG_SENTENCES


def generate(output_dir: Path):
    print("\n[4/18] Years...")

    rows = []
    yid  = 1

    for acad in ACADEMIC_YEARS:
        for dept in DEPT_IDS:
            for level in YEAR_LEVELS:
                start = datetime(acad, 9, 1)
                end   = datetime(acad + 1, 6, 30)

                total_courses = random.randint(5, 8)
                total_hours   = random.randint(450, 800)

                if random.random() < 0.10: total_courses, total_hours = 0, 0
                if random.random() < 0.10: end   = start - timedelta(days=random.randint(10, 60))
                if random.random() < 0.10: start = start + timedelta(days=400)

                created_at = start - timedelta(days=random.randint(30, 200))

                rows.append({
                    "Id":           yid,
                    "Name":         level,
                    "Description":  f"{level} for Department {dept}",
                    "DepartmentId": dept,
                    "AcademicYear": acad,
                    "IsArchived":   random.choice([True, False]),
                    "CreatedById":  1,
                    "StartDate":    start,
                    "EndDate":      end,
                    "TotalCourses": total_courses,
                    "TotalHours":   total_hours,
                    "CreatedAt":    created_at,
                    "UpdatedAt":    created_at + timedelta(days=random.randint(1, 100)),
                })
                yid += 1

    for row in random.sample(rows, 8):
        dup       = row.copy()
        dup["Id"] = yid
        rows.append(dup)
        yid += 1

    df = pd.DataFrame(rows).sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "years_dataset.csv", index=False)

    valid_year_ids = df["Id"].tolist()
    print(f"   done — {len(df):,} rows")
    return df, valid_year_ids
