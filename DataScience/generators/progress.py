import random
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

from utils.helpers import rand_date, maybe_null


PROG_STATUSES = ["NotStarted", "InProgress", "Completed"]
PROG_WEIGHTS  = [0.15, 0.30, 0.55]


def generate(output_dir: Path, valid_student_ids: list, valid_act_ids: list):
    print("\n[14/18] Student Activity Progress...")

    rows    = []
    prog_id = 1

    sample_students = random.sample(valid_student_ids, min(2500, len(valid_student_ids)))
    sample_acts     = random.sample(valid_act_ids,     min(500,  len(valid_act_ids)))

    for student_id in sample_students:
        chosen_acts = random.sample(sample_acts, min(random.randint(2, 20), len(sample_acts)))

        for aid in chosen_acts:
            status    = random.choices(PROG_STATUSES, weights=PROG_WEIGHTS)[0]
            first_acc = rand_date(datetime(2022, 6, 1), datetime(2026, 2, 1))
            last_acc  = maybe_null(first_acc + timedelta(days=random.randint(0, 120)), 0.10)

            if status == "Completed":
                pct     = 100
                comp_at = last_acc or first_acc + timedelta(days=random.randint(1, 30))
                total_t = random.randint(300, 7200)
            elif status == "InProgress":
                pct     = random.randint(5, 95)
                comp_at = None
                total_t = random.randint(60, 3600)
            else:
                pct = 0; comp_at = None; total_t = None
                first_acc = None; last_acc = None

            if random.random() < 0.04: pct = random.choice([-5, 101, 150, 999])
            if random.random() < 0.03 and status == "Completed": pct = random.randint(50, 99)
            if first_acc and random.random() < 0.08: total_t = None

            rows.append({
                "Id":                    prog_id,
                "ActivityId":            aid if random.random() > 0.03 else random.randint(9000, 9999),
                "StudentId":             student_id if random.random() > 0.04 else None,
                "Status":                status,
                "ProgressPercent":       pct,
                "FirstAccessedAt":       first_acc,
                "LastAccessedAt":        last_acc,
                "TotalTimeSpentSeconds": total_t,
                "CompletedAt":           comp_at,
            })
            prog_id += 1

    for d in random.sample(rows[:300], 70):
        dup       = d.copy()
        dup["Id"] = prog_id
        rows.append(dup)
        prog_id += 1

    df = pd.DataFrame(rows).sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "student_activity_progress_dataset.csv", index=False, sep=";")
    print(f"   done — {len(df):,} rows")
    return df
