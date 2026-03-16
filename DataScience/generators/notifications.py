import random
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

from utils.helpers import rand_date, maybe_null


NOTIF_TYPES = ["NewLecture", "QuizAvailable", "AssignmentDue", "GradeReleased",
               "CourseEnrollment", "SystemAlert", "Reminder"]
NOTIF_W     = [0.30, 0.20, 0.20, 0.15, 0.10, 0.03, 0.02]


def generate(output_dir: Path, all_user_ids: list, valid_act_ids: list):
    print("\n[15/18] Notifications...")

    rows = []
    nid  = 1

    for user_id in random.sample(all_user_ids, min(1800, len(all_user_ids))):
        for _ in range(random.randint(1, 15)):
            ntype   = random.choices(NOTIF_TYPES, weights=NOTIF_W)[0]
            created = rand_date(datetime(2022, 1, 1), datetime(2026, 3, 7))
            is_read = random.choice([0, 0, 1, 1, 1])
            read_at = maybe_null(created + timedelta(hours=random.randint(1, 72)), 0.45) if is_read else None

            rows.append({
                "Id":                  nid,
                "UserId":              user_id,
                "Title":               f"Notification: {ntype}",
                "Body":                maybe_null(f"You have a new {ntype.lower()} available.", 0.05),
                "Type":                ntype,
                "IsRead":              is_read,
                "ReadAt":              read_at,
                "EmailSent":           random.choice([0, 1, 1]),
                "EmailSentAt":         maybe_null(created + timedelta(minutes=random.randint(1, 30)), 0.20),
                "ReferenceActivityId": maybe_null(random.choice(valid_act_ids), 0.35),
                "CreatedAt":           created,
            })
            nid += 1

    for _ in range(30):
        rows.append({
            "Id": nid, "UserId": None, "Title": None, "Body": None,
            "Type": "SystemAlert", "IsRead": 0, "ReadAt": None,
            "EmailSent": 0, "EmailSentAt": None, "ReferenceActivityId": None,
            "CreatedAt": datetime(2024, 1, 1),
        })
        nid += 1

    for d in random.sample(rows[:300], 100):
        dup       = d.copy()
        dup["Id"] = nid
        rows.append(dup)
        nid += 1

    df = pd.DataFrame(rows).sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "notifications_dataset.csv", index=False, sep=";")
    print(f"   done — {len(df):,} rows")
    return df
