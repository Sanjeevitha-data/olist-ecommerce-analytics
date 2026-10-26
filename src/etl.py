from pathlib import Path
import getpass

import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL


# 1. Project folders
PROJECT_DIR = Path(__file__).resolve().parents[1]
RAW_DIR = PROJECT_DIR / "data" / "raw"
PROCESSED_DIR = PROJECT_DIR / "data" / "processed"

PROCESSED_DIR.mkdir(parents=True, exist_ok=True)


# 2. Source CSV files
FILES = {
    "orders": "olist_orders_dataset.csv",
    "customers": "olist_customers_dataset.csv",
    "items": "olist_order_items_dataset.csv",
    "payments": "olist_order_payments_dataset.csv",
    "reviews": "olist_order_reviews_dataset.csv",
    "products": "olist_products_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "category_translation": "product_category_name_translation.csv",
}


# 3. Date columns
DATE_COLUMNS = {
    "orders": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],
    "reviews": [
        "review_creation_date",
        "review_answer_timestamp",
    ],
}


# 4. Unique-key checks
UNIQUE_KEYS = {
    "orders": ["order_id"],
    "customers": ["customer_id"],
    "products": ["product_id"],
    "sellers": ["seller_id"],
}


# 5. PostgreSQL settings
DB_USER = "postgres"
DB_HOST = "localhost"
DB_PORT = 5432
DB_NAME = "ecommerce_analytics"


def clean_column_names(df):
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
        .str.replace("-", "_")
    )
    return df


def run_etl():
    print("Starting E-Commerce ETL...\n")

    # Connect to PostgreSQL
    password = getpass.getpass(
        "Enter your PostgreSQL password: "
    )

    db_url = URL.create(
        drivername="postgresql+psycopg",
        username=DB_USER,
        password=password,
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
    )

    engine = create_engine(db_url)

    try:
        with engine.connect() as connection:
            connection.exec_driver_sql("SELECT 1")

        print("Database connection successful!\n")

        # Process each source CSV
        for table_name, filename in FILES.items():
            file_path = RAW_DIR / filename

            if not file_path.exists():
                raise FileNotFoundError(
                    f"Source file not found: {file_path}"
                )

            df = pd.read_csv(file_path)
            row_count = len(df)

            # Clean column names
            df = clean_column_names(df)

            # Convert date columns
            for column in DATE_COLUMNS.get(table_name, []):
                if column in df.columns:
                    df[column] = pd.to_datetime(
                        df[column], errors="coerce"
                    )

            # Validate unique identifiers
            for column in UNIQUE_KEYS.get(table_name, []):
                if df[column].isna().any():
                    raise ValueError(
                        f"{table_name}: missing values in {column}"
                    )

                if df[column].duplicated().any():
                    raise ValueError(
                        f"{table_name}: duplicate values in {column}"
                    )

            # Save processed CSV
            output_path = PROCESSED_DIR / f"{table_name}.csv"
            df.to_csv(output_path, index=False)

            # Load into PostgreSQL
            df.to_sql(
                name=table_name,
                con=engine,
                if_exists="replace",
                index=False,
                chunksize=1000,
            )

            print(
                f"{table_name}: {row_count:,} rows processed "
                "and loaded into PostgreSQL."
            )

        print("\nETL completed successfully!")

    finally:
        engine.dispose()


if __name__ == "__main__":
    run_etl()
