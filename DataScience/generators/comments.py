import random
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

from config.settings import COMMENT_TEXTS, REPLY_TEXTS
from utils.helpers import rand_date, maybe_null


def generate(output_dir: Path, all_user_ids: list, valid_act_ids: list):
    print("\n[16/18] Comments...")

    rows = []
    c_id = 1

    for act_id_c in random.sample(valid_act_ids, min(300, len(valid_act_ids))):
        n_comments    = random.randint(0, 12)
        top_level_ids = []

        for _ in range(n_comments):
            uid     = maybe_null(random.choice(all_user_ids), 0.03)
            created = rand_date(datetime(2022, 6, 1), datetime(2026, 3, 7))
            is_del  = random.choice([0, 0, 0, 0, 1])
            content = "[deleted]" if is_del else random.choice(COMMENT_TEXTS)

            rows.append({
                "Id":              c_id,
                "ActivityId":      act_id_c,
                "UserId":          uid,
                "Content":         content,
                "ParentCommentId": None,
                "LikeCount":       random.randint(0, 50),
                "CreatedAt":       created,
                "UpdatedAt":       maybe_null(created + timedelta(hours=random.randint(1, 48)), 0.60),
                "IsDeleted":       is_del,
            })
            top_level_ids.append(c_id)
            c_id += 1

        for parent_id in top_level_ids:
            for _ in range(random.randint(0, 3)):
                uid     = maybe_null(random.choice(all_user_ids), 0.03)
                created = rand_date(datetime(2022, 6, 1), datetime(2026, 3, 7))
                is_del  = random.choice([0, 0, 0, 1])
                content = "[deleted]" if is_del else random.choice(REPLY_TEXTS)

                rows.append({
                    "Id":              c_id,
                    "ActivityId":      act_id_c,
                    "UserId":          uid,
                    "Content":         content,
                    "ParentCommentId": parent_id,
                    "LikeCount":       random.randint(0, 15),
                    "CreatedAt":       created,
                    "UpdatedAt":       maybe_null(created + timedelta(hours=random.randint(1, 24)), 0.70),
                    "IsDeleted":       is_del,
                })
                c_id += 1

    for _ in range(20):
        rows.append({
            "Id": c_id, "ActivityId": None, "UserId": random.choice(all_user_ids),
            "Content": "Orphan comment", "ParentCommentId": None,
            "LikeCount": 0, "CreatedAt": datetime(2024, 1, 1),
            "UpdatedAt": None, "IsDeleted": 0,
        })
        c_id += 1

    for d in random.sample(rows[:100], 30):
        dup       = d.copy()
        dup["Id"] = c_id
        rows.append(dup)
        c_id += 1

    df = pd.DataFrame(rows).sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "comments_dataset.csv", index=False, sep=";")

    valid_comment_ids = [r["Id"] for r in rows if not r["IsDeleted"]]
    print(f"   done — {len(df):,} rows")
    return df, valid_comment_ids
