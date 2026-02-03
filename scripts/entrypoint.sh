#!/usr/bin/env sh
set -e

echo "Waiting for database ${DB_HOST:-db}:${DB_PORT:-3306}..."
python <<'PY'
import os
import time
import sys

import pymysql
from pymysql.err import OperationalError

host = os.getenv("DB_HOST", "db")
port = int(os.getenv("DB_PORT", "3306"))
user = os.getenv("DB_USER", "libuser")
password = os.getenv("DB_PASSWORD", "libpass")
db = os.getenv("DB_NAME", "libapartado")

for attempt in range(30):
    try:
        conn = pymysql.connect(host=host, port=port, user=user, password=password, database=db)
        conn.close()
        print("Database connection successful.")
        break
    except OperationalError as exc:
        wait_time = 2
        print(f"DB not ready (attempt {attempt + 1}/30): {exc}; retrying in {wait_time}s...")
        time.sleep(wait_time)
else:
    sys.exit("Database is not reachable, aborting.")
PY

python manage.py migrate --noinput
python manage.py collectstatic --noinput

exec "$@"
