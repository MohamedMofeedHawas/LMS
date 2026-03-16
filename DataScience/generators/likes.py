import random
from datetime import datetime
from pathlib import Path

import pandas as pd

from utils.helpers import rand_date


def generate(output_dir: Path, all_user_ids: list, valid_comment_ids: list):
    print("\n[17/18] Comment Likes...")

    rows    = []
    like_id = 1

    for comment_id in random.sample(valid_comment_ids, min(2000, len(valid_comment_ids))):
        n_likes = random.randint(1, 10)
        likers  = random.sample(all_user_ids, min(n_likes, len(all_user_ids)))
        for uid in likers:
            rows.append({
                "Id":        like_id,
                "CommentId": comment_id,
                "UserId":    uid,
                "CreatedAt": rand_date(datetime(2022, 6, 1), datetime(2026, 3, 7)),
            })
            like_id += 1

    for d in random.sample(rows[:200], 50):
        dup       = d.copy()
        dup["Id"] = like_id
        rows.append(dup)
        like_id += 1

    df = pd.DataFrame(rows).sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "comment_likes_dataset.csv", index=False, sep=";")
    print(f"   done — {len(df):,} rows")
    return df
