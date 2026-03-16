import random
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

from config.settings import CITIES, FIRST_NAMES, LAST_NAMES
from utils.helpers import rand_date, maybe_null, rand_uuid, rand_national_id


def generate(output_dir: Path, n: int = 2000):
    print("\n[2/18] Users (AspNetUsers)...")

    rows    = []
    user_id = 1

    for _ in range(n):
        name       = f"{random.choice(FIRST_NAMES)} {random.choice(LAST_NAMES)}"
        username   = name.lower().replace(" ", ".") + str(random.randint(1, 999))
        email      = username + "@" + random.choice(["gmail.com", "yahoo.com", "outlook.com", "student.edu.eg", "hotmail.com"])
        dob        = datetime(random.randint(1990, 2007), random.randint(1, 12), random.randint(1, 28))
        created_at = rand_date(datetime(2022, 1, 1), datetime(2026, 3, 1))
        updated_at = created_at + timedelta(days=random.randint(0, 400))
        last_login = maybe_null(rand_date(created_at, min(updated_at + timedelta(days=30), datetime(2026, 3, 7))), 0.20)
        lockout_end = maybe_null(rand_date(datetime(2024, 1, 1), datetime(2026, 6, 1)), 0.93)

        if random.random() < 0.03:
            email = email.upper()

        rows.append({
            "Id":                 user_id,
            "FullName":           name,
            "NationalId":         rand_national_id(),
            "DateOfBirth":        dob if random.random() > 0.06 else None,
            "Gender":             random.choices(["Male", "Female", None], weights=[0.55, 0.40, 0.05])[0],
            "City":               random.choice(CITIES),
            "ProfileImageUrl":    f"/uploads/users/{rand_uuid()}.jpg" if random.random() > 0.15 else None,
            "IsActive":           1 if random.random() > 0.08 else 0,
            "CreatedAt":          created_at,
            "UpdatedAt":          updated_at if random.random() > 0.05 else None,
            "LastLoginAt":        last_login,
            "UserName":           username,
            "NormalizedUserName": username.upper(),
            "Email":              email,
            "NormalizedEmail":    email.upper(),
            "EmailConfirmed":     random.choice([1, 1, 1, 0]),
            "PasswordHash":       f"AQAAAAIAAYagAAAAE{rand_uuid().replace('-', '')}==",
            "SecurityStamp":      rand_uuid().replace("-", "").upper()[:32],
            "ConcurrencyStamp":   rand_uuid(),
            "TwoFactorEnabled":   random.choice([0, 0, 0, 1]),
            "LockoutEnd":         lockout_end,
            "LockoutEnabled":     1,
            "AccessFailedCount":  random.choice([0] * 10 + [1, 2, 3, 5, 10]),
            "IsActivated":        random.choice([1, 1, 1, 0]),
        })
        user_id += 1

    for d in random.sample(rows, 60):
        dup          = d.copy()
        dup["Id"]    = user_id
        dup["Email"] = "dup_" + d["Email"]
        rows.append(dup)
        user_id += 1

    df = pd.DataFrame(rows)

    null_idx = random.sample(range(len(df)), 25)
    df.loc[null_idx, "FullName"] = None

    df = df.sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "aspnetusers_dataset.csv", index=False, sep=";")

    all_user_ids     = list(df["Id"].unique())
    student_user_ids = random.sample(all_user_ids, int(len(all_user_ids) * 0.80))

    print(f"   done — {len(df):,} rows")
    return df, all_user_ids, student_user_ids
