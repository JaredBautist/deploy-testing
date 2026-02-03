import os
import sys
import time

import pymysql


def wait_for_db() -> None:
    # Usar variables Railway MYSQL* directamente
    host = os.environ.get("MYSQLHOST", "localhost")
    user = os.environ.get("MYSQLUSER", "root")
    password = os.environ.get("MYSQLPASSWORD", "")
    db = os.environ.get("MYSQLDATABASE", "railway")
    port = int(os.environ.get("MYSQLPORT", 3306))

    for attempt in range(30):
        try:
            conn = pymysql.connect(
                host=host,
                user=user,
                password=password,
                database=db,
                port=port,
                connect_timeout=5,
            )
            conn.close()
            return
        except Exception as exc:  # noqa: BLE001
            print(
                f"Waiting for DB {host}:{port}... ({attempt + 1}/30) {exc}",
                flush=True,
            )
            time.sleep(2)

    sys.exit("DB not ready")


if __name__ == "__main__":
    wait_for_db()
