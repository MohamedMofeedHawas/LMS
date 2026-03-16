import random
from datetime import timedelta
from pathlib import Path

import pandas as pd

from config.settings import AVIATION_ALPHABET, LOG_SENTENCES
from utils.helpers import rand_date, maybe_null, DATE_RANGES


def generate(output_dir: Path, n: int = 79):
    print("\n[5/18] Squadrons...")

    def squadron_name(idx):
        letter = AVIATION_ALPHABET[(idx - 1) % 26]
        cycle  = (idx - 1) // 26
        return letter if cycle == 0 else f"{letter}-{cycle + 1}"

    rows = []
    for i in range(1, n + 1):
        dr         = random.choice(DATE_RANGES)
        created_at = rand_date(dr[0], dr[1])
        sq_id      = i + 1000 if random.random() < 0.10 else i

        rows.append({
            "Id":          sq_id,
            "Name":        squadron_name(i),
            "Description": maybe_null(random.choice(LOG_SENTENCES), 0.08),
            "IsActive":    random.choice([True, False]),
            "CreatedAt":   created_at,
            "UpdatedAt":   created_at + timedelta(days=random.randint(0, 150)),
        })

    df = pd.DataFrame(rows)
    df.to_csv(output_dir / "squadrons_dataset.csv", index=False)
    print(f"   done — {len(df):,} rows")
    return df
