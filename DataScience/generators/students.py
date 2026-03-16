import random
from datetime import datetime, timedelta
from pathlib import Path

import numpy as np
import pandas as pd

from utils.helpers import rand_date


def generate(output_dir: Path, all_user_ids: list, student_user_ids: list, n: int = 5000):
    print("\n[3/18] Students Profile...")

    dept_arr = np.random.choice([1, 2, 3], n, p=[0.55, 0.30, 0.15]).astype(float)
    dept_arr[np.random.choice(n, int(n * 0.08), replace=False)] = np.nan

    year_arr = np.random.choice([1, 2, 3, 4], n, p=[0.35, 0.28, 0.22, 0.15]).astype(float)
    year_arr[np.random.choice(n, int(n * 0.06), replace=False)] = np.nan

    sqd_arr = np.random.choice([1, 2, 3, 4, 5], n).astype(float)
    sqd_arr[np.random.choice(n, 20, replace=False)] = np.random.randint(10, 20, 20)
    sqd_arr[np.random.choice(n, int(n * 0.07), replace=False)] = np.nan

    adm_arr = np.random.choice([2021, 2022, 2023, 2024, 2025, 2026], n,
                                p=[0.05, 0.15, 0.25, 0.25, 0.20, 0.10]).astype(float)
    adm_arr[np.random.choice(n, 50, replace=False)] = np.nan

    created_list = [rand_date(datetime(2021, 1, 1), datetime(2026, 1, 1)) for _ in range(n)]
    updated_list = [c + timedelta(days=random.randint(0, 300)) for c in created_list]

    uid_pool = student_user_ids.copy()
    random.shuffle(uid_pool)

    assigned_uids = []
    for _ in range(n):
        r = random.random()
        if r < 0.06:
            assigned_uids.append(None)
        elif r < 0.09:
            assigned_uids.append(random.randint(9000, 9999))
        elif uid_pool:
            assigned_uids.append(uid_pool.pop())
        else:
            assigned_uids.append(random.choice(all_user_ids))

    df = pd.DataFrame({
        "Id":            np.arange(1, n + 1),
        "UserId":        assigned_uids,
        "DepartmentId":  dept_arr,
        "YearId":        year_arr,
        "SquadronId":    sqd_arr,
        "AdmissionYear": adm_arr,
        "CreatedAt":     created_list,
        "UpdatedAt":     updated_list,
    })

    df = pd.concat([df, df.sample(80)], ignore_index=True)
    df = df.sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "students_profile_dataset.csv", index=False)

    valid_student_ids = list(range(1, n + 1))
    print(f"   done — {len(df):,} rows")
    return df, valid_student_ids
