import random
import uuid
from datetime import datetime, timedelta

from config.settings import DATE_RANGES


def rand_date(start: datetime, end: datetime) -> datetime:
    delta = int((end - start).total_seconds())
    return start + timedelta(seconds=random.randint(0, max(delta, 1)))


def maybe_null(value, p: float = 0.07):
    return None if random.random() < p else value


def rand_uuid() -> str:
    return str(uuid.uuid4())


def rand_ipv4() -> str:
    return ".".join(str(random.randint(1, 254)) for _ in range(4))


def rand_national_id():
    r = random.random()
    if r < 0.05: return None
    if r < 0.08: return str(random.randint(10**9, 10**10))
    if r < 0.10: return "0" * 14
    century = random.choice(["2", "3"])
    year    = str(random.randint(0, 99)).zfill(2)
    month   = str(random.randint(1, 12)).zfill(2)
    day     = str(random.randint(1, 28)).zfill(2)
    gov     = str(random.randint(1, 35)).zfill(2)
    seq     = str(random.randint(100, 9999)).zfill(4)
    check   = str(random.randint(0, 9))
    return century + year + month + day + gov + seq + check
