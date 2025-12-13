import json
import logging
import os
import time
from typing import Any, Dict, Iterable, List, Tuple

import psycopg2
import psycopg2.extras
import pymysql
from decimal import Decimal


logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO"),
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger("dw-etl")


def env(key: str, default: str) -> str:
    return os.getenv(key, default)


# --- Warehouse connection ---
WAREHOUSE_URL = env(
    "WAREHOUSE_URL",
    "postgresql://warehouse_user:warehouse_password@warehouse-db:5432/warehouse_db",
)
RUN_INTERVAL = int(env("DW_ETL_INTERVAL_SECONDS", "900"))


# --- Source definitions (reuse existing service envs) ---
POSTGRES_SOURCES = [
    dict(
        name="users",
        host=env("USER_DB_HOST", "postgres-users"),
        port=int(env("USER_DB_PORT", "5432")),
        db=env("USER_DB_NAME", "users_db"),
        user=env("USER_DB_USER", "postgres"),
        password=env("USER_DB_PASSWORD", "postgres"),
    ),
    dict(
        name="ghostai",
        host=env("GHOSTAI_POSTGRES_HOST", "postgres-ghostai"),
        port=5432,
        db=env("GHOSTAI_POSTGRES_DB", "ghostai"),
        user=env("GHOSTAI_POSTGRES_USER", "arina"),
        password=env("GHOSTAI_POSTGRES_PASSWORD", "MySuperPar0la"),
    ),
    dict(
        name="shop",
        host=env("SHOP_POSTGRES_HOST", "shop_db"),
        port=5432,
        db=env("SHOP_POSTGRES_DB", "shop_service"),
        user=env("SHOP_POSTGRES_USER", "postgres"),
        password=env("SHOP_POSTGRES_PASSWORD", "12345"),
    ),
    dict(
        name="journal",
        host=env("JOURNAL_POSTGRES_HOST", "journal_db"),
        port=5432,
        db=env("JOURNAL_POSTGRES_DB", "journal_db"),
        user=env("JOURNAL_POSTGRES_USER", "postgres"),
        password=env("JOURNAL_POSTGRES_PASSWORD", "12345"),
    ),
    dict(
        name="lobby",
        host=env("LOBBY_POSTGRES_HOST", "lobby_postgres"),
        port=5432,
        db=env("LOBBY_DB_NAME", "LobbyDb"),
        user=env("LOBBY_DB_USER", "postgres"),
        password=env("LOBBY_DB_PASSWORD", "SED465lobby!"),
    ),
    dict(
        name="map",
        host=env("MAP_DB_HOST", "map_postgres"),
        port=5432,
        db=env("MAP_DB_NAME", "mapdb"),
        user=env("MAP_DB_USER", "postgres"),
        password=env("MAP_DB_PASSWORD", "SED465az!"),
    ),
    dict(
        name="ghost",
        host=env("GHOST_POSTGRES_HOST", "ghost_postgres"),
        port=5432,
        db=env("GHOST_POSTGRES_DB", "ghostHuntersDB"),
        user=env("GHOST_POSTGRES_USER", "ghostHunters"),
        password=env("GHOST_POSTGRES_PASSWORD", "ghostHunters"),
    ),
]

MYSQL_SOURCES = [
    dict(
        name="inventory",
        host=env("MYSQL_HOST", "mysql_db"),
        port=int(env("MYSQL_PORT", "3306")),
        db=env("MYSQL_DATABASE", "ghosthunters"),
        user=env("MYSQL_USER", "app"),
        password=env("MYSQL_PASSWORD", "mysql"),
    ),
    dict(
        name="chat",
        host=env("CHAT_MYSQL_HOST", "mysql_db_chat"),
        port=3306,
        db=env("CHAT_MYSQL_DATABASE", "ghosthunters_chat"),
        user=env("CHAT_MYSQL_USER", "app"),
        password=env("CHAT_MYSQL_PASSWORD", "mysql2"),
    ),
]


def get_pg_conn(url_or_host, port=None, db=None, user=None, password=None):
    if port is None:
        return psycopg2.connect(url_or_host)
    return psycopg2.connect(
        host=url_or_host, port=port, dbname=db, user=user, password=password
    )


def ensure_warehouse(conn):
    with conn.cursor() as cur:
        cur.execute("CREATE SCHEMA IF NOT EXISTS dw;")
        cur.execute(
            """
            CREATE TABLE IF NOT EXISTS dw.raw_events (
                id BIGSERIAL PRIMARY KEY,
                service TEXT NOT NULL,
                source_table TEXT NOT NULL,
                payload JSONB NOT NULL,
                extracted_at TIMESTAMPTZ NOT NULL DEFAULT now()
            );
            """
        )
        cur.execute(
            "CREATE INDEX IF NOT EXISTS idx_raw_events_service_table ON dw.raw_events(service, source_table);"
        )
    conn.commit()


def serialize_row(row: Dict[str, Any]) -> Dict[str, Any]:
    def convert(val: Any) -> Any:
        if isinstance(val, Decimal):
            return float(val)
        if isinstance(val, (bytes, bytearray)):
            return val.decode(errors="replace")
        if hasattr(val, "isoformat"):
            try:
                return val.isoformat()
            except Exception:
                return str(val)
        if isinstance(val, memoryview):
            return val.tobytes().decode(errors="replace")
        return val

    return {k: convert(v) for k, v in row.items()}


def load_rows(
    wh_conn,
    service: str,
    source_table: str,
    rows: Iterable[Dict[str, Any]],
):
    rows_list = list(rows)
    if not rows_list:
        return 0
    with wh_conn.cursor() as cur:
        cur.execute(
            "DELETE FROM dw.raw_events WHERE service=%s AND source_table=%s",
            (service, source_table),
        )
        psycopg2.extras.execute_batch(
            cur,
            "INSERT INTO dw.raw_events(service, source_table, payload) VALUES (%s,%s,%s)",
            [(service, source_table, json.dumps(serialize_row(r))) for r in rows_list],
            page_size=1000,
        )
    wh_conn.commit()
    return len(rows_list)


def extract_postgres(src, wh_conn) -> None:
    logger.info("Extracting from postgres source=%s", src["name"])
    for attempt in range(1, 4):
        try:
            with get_pg_conn(src["host"], src["port"], src["db"], src["user"], src["password"]) as conn:
                with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                    cur.execute(
                        """
                        SELECT table_schema, table_name
                        FROM information_schema.tables
                        WHERE table_type='BASE TABLE'
                          AND table_schema NOT IN ('pg_catalog','information_schema');
                        """
                    )
                    tables = cur.fetchall()
                    for t in tables:
                        schema = t["table_schema"]
                        table = t["table_name"]
                        full_table = f"{schema}.{table}"
                        cur.execute(f'SELECT * FROM "{schema}"."{table}"')
                        rows = cur.fetchall()
                        inserted = load_rows(wh_conn, src["name"], full_table, rows)
                        logger.info(
                            "Loaded %s rows from %s.%s into warehouse", inserted, src["name"], full_table
                        )
            return
        except Exception as exc:
            logger.warning(
                "Postgres extraction failed for %s (attempt %s/3): %s",
                src["name"],
                attempt,
                exc,
            )
            time.sleep(5)
    logger.error("Postgres extraction failed for %s after retries", src["name"])


def extract_mysql(src, wh_conn) -> None:
    logger.info("Extracting from mysql source=%s", src["name"])
    for attempt in range(1, 4):
        try:
            conn = pymysql.connect(
                host=src["host"],
                port=src["port"],
                user=src["user"],
                password=src["password"],
                database=src["db"],
                cursorclass=pymysql.cursors.DictCursor,
            )
            with conn:
                with conn.cursor() as cur:
                    cur.execute(
                        """
                        SELECT table_schema, table_name
                        FROM information_schema.tables
                        WHERE table_type='BASE TABLE'
                          AND table_schema=%s;
                        """,
                        (src["db"],),
                    )
                    tables = cur.fetchall()
                    for t in tables:
                        schema = t["table_schema"]
                        table = t["table_name"]
                        cur.execute(f"SELECT * FROM `{schema}`.`{table}`")
                        rows = cur.fetchall()
                        inserted = load_rows(wh_conn, src["name"], f"{schema}.{table}", rows)
                        logger.info(
                            "Loaded %s rows from %s.%s into warehouse", inserted, src["name"], table
                        )
            return
        except Exception as exc:
            logger.warning(
                "MySQL extraction failed for %s (attempt %s/3): %s",
                src["name"],
                attempt,
                exc,
            )
            time.sleep(5)
    logger.error("MySQL extraction failed for %s after retries", src["name"])


def run_cycle():
    logger.info("Starting ETL cycle")
    with get_pg_conn(WAREHOUSE_URL) as wh_conn:
        ensure_warehouse(wh_conn)

        for src in POSTGRES_SOURCES:
            extract_postgres(src, wh_conn)

        for src in MYSQL_SOURCES:
            extract_mysql(src, wh_conn)

    logger.info("ETL cycle finished")


def main():
    while True:
        run_cycle()
        logger.info("Sleeping for %s seconds", RUN_INTERVAL)
        time.sleep(RUN_INTERVAL)


if __name__ == "__main__":
    main()
