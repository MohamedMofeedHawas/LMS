import json
import random
from datetime import datetime, timedelta
from pathlib import Path

import numpy as np
import pandas as pd

from utils.helpers import rand_date, maybe_null, rand_ipv4
from config.settings import USER_AGENTS, LOG_SENTENCES


ACTIONS_WEIGHTED = (
    ["UserLoggedIn"]        * 30 +
    ["ProfileViewed"]       * 25 +
    ["LoginFailed"]         * 15 +
    ["AuthCreated"]         * 10 +
    ["SquadronUpdated"]     *  8 +
    ["SquadronCreated"]     *  7 +
    ["BulkImportStudents"]  *  5
)

LOG_USERS = [
    {"id": 1, "name": "System Administrator", "role": "Admin"},
    {"id": 2, "name": "Ahmed Ali",            "role": "Student"},
    {"id": 3, "name": "Sara Mohamed",         "role": "Student"},
    {"id": 4, "name": "Omar Hassan",          "role": "Instructor"},
    {"id": 5, "name": "Nour Khalil",          "role": "Student"},
    {"id": 6, "name": "Youssef Adel",         "role": "Student"},
    {"id": 7, "name": "Mona Samir",           "role": "Admin"},
    {"id": 8, "name": "Kareem Fathy",         "role": "Instructor"},
]

TS_RANGES  = [
    (datetime(2022, 1, 1), datetime(2022, 12, 31)),
    (datetime(2023, 1, 1), datetime(2023, 12, 31)),
    (datetime(2024, 1, 1), datetime(2024, 12, 31)),
    (datetime(2025, 1, 1), datetime(2025, 6, 30)),
]
TS_WEIGHTS  = [0.10, 0.20, 0.45, 0.25]
ENTITY_NAMES = ["Auth", "Squadron", "StudentImport", "Enrollment", None]


def generate(output_dir: Path, n: int = 15_000):
    print("\n[8/18] Activity Log...")

    rows = []
    for i in range(1, n + 1):
        action = random.choice(ACTIONS_WEIGHTED)
        usr    = random.choice(LOG_USERS + [None, None])
        ts_s, ts_e = TS_RANGES[np.random.choice(len(TS_RANGES), p=TS_WEIGHTS)]
        ts = rand_date(ts_s, ts_e)

        proc_ms = abs(int(np.random.normal(300, 150)))
        if   random.random() < 0.12: proc_ms = None
        elif random.random() < 0.03: proc_ms = random.choice([5000, 9999, 15000])

        if random.random() < 0.05:
            meta = None
        elif random.random() < 0.08:
            meta = "CORRUPTED_JSON"
        else:
            meta = json.dumps({
                "statusCode": random.choice([200, 200, 200, 400, 401, 500]),
                "ip":         rand_ipv4(),
                "browser":    random.choice(["Chrome", "Firefox", "Safari", "Edge"]),
            })

        rows.append({
            "Id":               i,
            "ActionName":       action,
            "EntityName":       random.choice(ENTITY_NAMES),
            "EntityId":         maybe_null(random.randint(1, 50), 0.35),
            "Description":      maybe_null(random.choice(LOG_SENTENCES), 0.08),
            "UserId":           usr["id"] if usr else None,
            "IpAddress":        rand_ipv4() if random.random() > 0.05 else None,
            "UserAgent":        random.choice(USER_AGENTS) if random.random() > 0.03 else None,
            "TokenExpiresAt":   (ts + timedelta(hours=random.choice([1, 2, 6, 24]))) if action == "UserLoggedIn" else None,
            "Metadata":         meta,
            "Timestamp":        ts,
            "ProcessingTimeMs": proc_ms,
            "UserFullName":     usr["name"] if usr else "Guest user",
        })

    for d in random.sample(rows, 200):
        rows.append(d.copy())

    df = pd.DataFrame(rows).sample(frac=1).reset_index(drop=True)
    df.to_csv(output_dir / "activity_log_dataset.csv", index=False)
    print(f"   done — {len(df):,} rows")
    return df
