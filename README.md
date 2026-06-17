# 🛒 E-Commerce Sales Analytics Pipeline

End-to-end ELT pipeline using the Brazilian Olist E-Commerce Dataset, built with Python, PostgreSQL, dbt, Docker, and Metabase, following the Medallion Architecture (Bronze → Silver → Gold).

---

## Overview

This project ingests raw e-commerce CSV data into a PostgreSQL data warehouse, transforms it through Bronze, Silver, and Gold layers using dbt, and visualizes business insights through a Metabase dashboard.

It was built as a learning project, with the goal of being adaptable to real e-commerce data (e.g. Shopee store data) in the future.

---

## Tech Stack

| Component            | Technology                |
| -------------------- | ------------------------- |
| Data Source          | CSV Files (Olist Dataset) |
| Data Ingestion       | Python (containerized)    |
| Data Warehouse       | PostgreSQL 16             |
| Data Transformation  | dbt 1.8.2                 |
| Containerization     | Docker & Docker Compose   |
| Visualization        | Metabase                  |

---

## Architecture

```text
CSV Files
    │
    ▼
Python Ingestion (Docker)
    │
    ▼
PostgreSQL — bronze schema (raw data)
    │
    ▼
dbt models — silver schema (cleaned & standardized)
    │
    ▼
dbt models — gold schema (fact, dimensions, aggregations)
    │
    ▼
Metabase Dashboard
```

---

## Project Structure

```text
ecommerce-sales-pipeline/
├── data/                            # Raw CSV files (Olist dataset)
├── ingestion/
│   ├── sql/
│   │   └── create_bronze_tables.sql # DDL for bronze schema tables
│   ├── load_to_bronze.py            # Loads CSV files into bronze schema
│   ├── requirements.txt             # Python dependencies
│   └── Dockerfile
├── dbt_project/
│   ├── models/
│   │   ├── silver/                  # Cleaned, standardized models
│   │   │   ├── silver_customers.sql
│   │   │   ├── silver_orders.sql
│   │   │   ├── silver_order_items.sql
│   │   │   ├── silver_products.sql
│   │   │   ├── silver_sellers.sql
│   │   │   ├── silver_payments.sql
│   │   │   ├── silver_order_reviews.sql
│   │   │   ├── silver_geolocation.sql
│   │   │   └── schema.yml
│   │   ├── gold/                    # Fact, dimensions, business aggregations
│   │   │   ├── dim_customer.sql
│   │   │   ├── dim_product.sql
│   │   │   ├── dim_seller.sql
│   │   │   ├── dim_date.sql
│   │   │   ├── fact_sales.sql
│   │   │   ├── sales_summary_daily.sql
│   │   │   ├── product_performance.sql
│   │   │   ├── seller_performance.sql
│   │   │   ├── sales_by_geolocation.sql
│   │   │   ├── review_summary.sql
│   │   │   └── schema.yml
│   │   └── sources.yml
│   ├── macros/
│   │   └── generate_schema_name.sql # Custom schema naming macro
│   ├── dbt_project.yml
│   ├── profiles.yml
│   ├── packages.yml                 # dbt_utils dependency
│   ├── requirements.txt             # dbt dependencies
│   └── Dockerfile
├── docker-compose.yml
├── .env                             # Environment variables (not committed)
├── .gitignore
└── README.md
```

---

## Prerequisites

- Docker Desktop
- Git

No local installation of Python, PostgreSQL, or dbt is required — everything runs inside Docker containers.

---

## Setup

### 1. Clone the repository

```bash
git clone <repo-url>
cd ecommerce-sales-pipeline
```

### 2. Create `.env` file

Create a `.env` file in the project root:

```env
POSTGRES_USER=ecommerce_user
POSTGRES_PASSWORD=ecommerce_password
POSTGRES_DB=ecommerce_db
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

### 3. Add dataset

Download the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle and place all CSV files inside the `data/` folder:

```text
data/
├── olist_orders_dataset.csv
├── olist_order_items_dataset.csv
├── olist_order_payments_dataset.csv
├── olist_customers_dataset.csv
├── olist_sellers_dataset.csv
├── olist_products_dataset.csv
├── olist_order_reviews_dataset.csv
├── olist_geolocation_dataset.csv
└── product_category_name_translation.csv
```

### 4. Start core services

```bash
docker-compose up -d
```

This starts:
- `ecommerce_postgres` — PostgreSQL database (port `5432`)
- `ecommerce_metabase` — Metabase dashboard (port `3000`)
- `ecommerce_dbt` — dbt container (idle, ready for commands)

---

## Running the Pipeline

### Step 1: Create Bronze schema tables

Connect to PostgreSQL using a tool like DBeaver:

| Field    | Value                |
|----------|----------------------|
| Host     | `localhost`          |
| Port     | `5432`               |
| Database | `ecommerce_db`       |
| Username | `ecommerce_user`     |
| Password | `ecommerce_password` |

Run `ingestion/sql/create_bronze_tables.sql` to create all bronze tables.

### Step 2: Load raw data into Bronze layer

```bash
docker-compose run --rm ingestion
```

Reads all CSV files from `data/` and loads them into the `bronze` schema.

### Step 3: Run dbt transformations (Silver + Gold layers)

```bash
docker exec -it ecommerce_dbt bash
dbt deps       # Install dbt packages (first time only)
dbt run        # Build all Silver and Gold models
```

### Step 4: Run data quality tests

```bash
dbt test
```

Validates primary keys, foreign key relationships, accepted values, and uniqueness constraints across all Silver and Gold models.

---

## Data Model

### Bronze Layer (Raw)

| Table | Source File |
|-------|-------------|
| `bronze.orders` | olist_orders_dataset.csv |
| `bronze.order_items` | olist_order_items_dataset.csv |
| `bronze.order_payments` | olist_order_payments_dataset.csv |
| `bronze.customers` | olist_customers_dataset.csv |
| `bronze.sellers` | olist_sellers_dataset.csv |
| `bronze.products` | olist_products_dataset.csv |
| `bronze.order_reviews` | olist_order_reviews_dataset.csv |
| `bronze.geolocation` | olist_geolocation_dataset.csv |
| `bronze.product_category_translation` | product_category_name_translation.csv |

### Silver Layer (Cleaned & Standardized)

| Model | Description |
|-------|-------------|
| `silver_customers` | Cleaned customer data |
| `silver_orders` | Standardized order statuses, deduplicated |
| `silver_order_items` | Line items with calculated `total_item_value` |
| `silver_products` | English category translations, fixed column typos, cast numeric types |
| `silver_sellers` | Standardized city/state casing |
| `silver_payments` | Cleaned payment records |
| `silver_order_reviews` | Deduplicated reviews, validated score range (1-5) |
| `silver_geolocation` | Deduplicated lat/lng averaged per zip code |

### Gold Layer (Business-Ready)

**Dimensions:**

| Model | Description |
|-------|-------------|
| `dim_customer` | Customer dimension (grain: per `customer_id`) |
| `dim_product` | Product dimension with English category names |
| `dim_seller` | Seller dimension with location info |
| `dim_date` | Date spine (2016–2020) with year, month, day, weekday attributes |

**Fact Table:**

| Model | Description |
|-------|-------------|
| `fact_sales` | Grain: one row per order item. Contains revenue, payment, order status, and timestamps |

**Business Aggregations:**

| Model | Description |
|-------|-------------|
| `sales_summary_daily` | Daily revenue, orders, and customers |
| `product_performance` | Revenue, quantity sold, and AOV by product |
| `seller_performance` | Revenue, order count, and product volume by seller |
| `sales_by_geolocation` | Revenue and orders by customer location (lat/lng) |
| `review_summary` | Review score distribution with percentages |

---

## Dashboard (Metabase)

Access Metabase at `http://localhost:3000`.

**Dashboard: E-Commerce Sales Analytics**

### 📊 Executive Overview
Key business metrics and customer satisfaction snapshot for the period January 2017 – August 2018.
- Total Revenue (Trend)
- Total Orders (Trend)
- Total Customers (Trend)
- Average Order Value / AOV (Trend)
- Review Score Distribution (Bar chart)

### 📈 Trends & Geography
Monthly performance trends and geographic distribution of revenue across Brazil.
- Monthly Trends — Revenue & Orders (Dual-axis Line chart)
- Revenue by Location (Pin Map)

### 📦 Product Performance
Top-performing product categories by revenue and volume sold.
- Top Products by Revenue (Horizontal Bar chart)
- Quantity Sold by Category (Horizontal Bar chart)

### 🏪 Seller Performance
Top 10 sellers ranked by total revenue, including order volume and product diversity.
- Seller Ranking (Table)

---

## Data Quality Tests

All models are tested using dbt tests:

| Test Type | Scope |
|---|---|
| `unique` + `not_null` | All primary keys (Silver & Gold) |
| `relationships` | Foreign key integrity across Silver models and Gold fact table |
| `accepted_values` | `order_status` (7 valid values), `review_score` (1-5) |
| `unique_combination_of_columns` | `review_id + order_id` (Silver), `order_id + order_item_id` (Gold) |

---

## Non-Functional Requirements

- Reproducible environment using Docker — no local dependency installation required
- Modular SQL transformations using dbt, organized by Medallion layer
- Data lineage and documentation generated through `dbt docs`
- Version controlled with Git
- Clear separation of concerns: Python handles ingestion only, dbt handles all transformations
- Custom `generate_schema_name` macro ensures models land in the correct schema (`silver.*`, `gold.*`)

---

## Dataset

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — real anonymized commercial data covering orders, products, customers, sellers, payments, reviews, and geolocation from 2016 to 2018.

> **Note:** Dashboard metrics are filtered to January 2017 – August 2018 to exclude incomplete data at the start and end of the dataset.
