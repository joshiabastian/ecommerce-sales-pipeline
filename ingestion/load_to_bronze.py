import os
import logging
import pandas as pd
import numpy as np
import psycopg2
from dotenv import load_dotenv

load_dotenv()

# Logging setup
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler("ingestion.log")
    ]
)
logger = logging.getLogger(__name__)


# Database connection
def get_connection():
    try:
        conn = psycopg2.connect(
            host=os.getenv("POSTGRES_HOST"),
            port=os.getenv("POSTGRES_PORT"),
            dbname=os.getenv("POSTGRES_DB"),
            user=os.getenv("POSTGRES_USER"),
            password=os.getenv("POSTGRES_PASSWORD")
        )
        logger.info("Database connection established")
        return conn
    except Exception as e:
        logger.error(f"Failed to connect to database: {e}")
        raise


# Load CSV to bronze table
def load_csv_to_bronze(file_path, table_name, conn):
    try:
        logger.info(f"Loading {file_path} -> bronze.{table_name}")
        df = pd.read_csv(file_path)
        logger.info(f"Read {len(df)} rows from {file_path}")

        cursor = conn.cursor()

        for _, row in df.iterrows():
            # Replace NaN/NaT with None per value
            values = [None if pd.isna(v) else v for v in row]

            placeholders = ", ".join(["%s"] * len(values))
            columns = ", ".join(row.index)
            sql = f"INSERT INTO bronze.{table_name} ({columns}) VALUES ({placeholders})"
            cursor.execute(sql, values)

        conn.commit()
        cursor.close()
        logger.info(f"Done: {len(df)} rows loaded into bronze.{table_name}")

    except Exception as e:
        conn.rollback()
        logger.error(f"Failed to load {table_name}: {e}")
        raise


def main():
    logger.info("Starting bronze ingestion")

    conn = get_connection()

    base_path = "data"

    files = {
        "orders": "olist_orders_dataset.csv",
        "order_items": "olist_order_items_dataset.csv",
        "order_payments": "olist_order_payments_dataset.csv",
        "customers": "olist_customers_dataset.csv",
        "sellers": "olist_sellers_dataset.csv",
        "products": "olist_products_dataset.csv",
        "order_reviews": "olist_order_reviews_dataset.csv",
        "geolocation": "olist_geolocation_dataset.csv",
        "product_category_translation": "product_category_name_translation.csv"
    }

    for table_name, file_name in files.items():
        file_path = os.path.join(base_path, file_name)
        load_csv_to_bronze(file_path, table_name, conn)

    conn.close()
    logger.info("Bronze ingestion completed successfully")


if __name__ == "__main__":
    main()