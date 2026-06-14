# E-Commerce Sales Analytics Pipeline

End-to-end ELT pipeline using the Brazilian Olist E-Commerce Dataset, built with Python, PostgreSQL, dbt, Docker, and Metabase, following the Medallion Architecture (Bronze, Silver, Gold).

---

## Overview

This project ingests raw e-commerce CSV data into a PostgreSQL data warehouse, transforms it through Bronze, Silver, and Gold layers using dbt, and visualizes business insights through Metabase dashboards.

It was built as a learning project, with the goal of being adaptable to real e-commerce data (e.g. Shopee store data) in the future.

---

## Tech Stack

| Component           | Technology                |
| ------------------- | ------------------------- |
| Data Source         | CSV Files (Olist Dataset) |
| Data Ingestion      | Python (containerized)    |
| Data Warehouse      | PostgreSQL                |
| Data Transformation | dbt                       |
| Containerization    | Docker & Docker Compose   |
| Visualization       | Metabase                  |

---

## Architecture

```text
CSV Files
    │
    ▼
Python Ingestion (Docker)
    │
    ▼
PostgreSQL - bronze schema (raw data)
    │
    ▼
dbt models - silver schema (cleaned & standardized)
    │
    ▼
dbt models - gold schema (fact, dimensions, aggregations)
    │
    ▼
Metabase Dashboards
```

---

## Project Structure

```text
ecommerce-sales-pipeline/
├── data/                       # Raw CSV files (Olist dataset)
├── ingestion/
│   ├── load_to_bronze.py       # Loads CSV files into bronze schema
│   ├── requirements.txt
│   └── Dockerfile
├── dbt_project/
│   ├── models/
│   │   ├── silver/             # Cleaned, standardized models
│   │   ├── gold/                # Fact, dimensions, business aggregations
│   │   └── sources.yml
│   ├── macros/
│   ├── dbt_project.yml
│   ├── profiles.yml
│   ├── packages.yml
│   ├── requirements.txt
│   └── Dockerfile
├── docker-compose.yml
├── .env                        # Environment variables (not committed)
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

Create a `.env` file in the project root with the following variables:

```env
POSTGRES_USER=ecommerce_user
POSTGRES_PASSWORD=ecommerce_password
POSTGRES_DB=ecommerce_db
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

### 3. Add dataset

Download the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle and place all CSV files inside the `data/` folder.

### 4. Start core services

```bash
docker-compose up -d
```

This starts:

- `postgres` — PostgreSQL database
- `metabase` — Metabase dashboard tool (available at `http://localhost:3000`)
- `dbt` — dbt container (idle, ready for commands)

---

## Running the Pipeline

### Step 1: Create Bronze schema tables

Run the DDL script (`create_bronze_tables.sql`) against the PostgreSQL database using a tool like DBeaver, connecting to:

| Field    | Value                |
| -------- | -------------------- |
| Host     | `localhost`          |
| Port     | `5432`               |
| Database | `ecommerce_db`       |
| Username | `ecommerce_user`     |
| Password | `ecommerce_password` |

### Step 2: Load raw data into Bronze layer

```bash
docker-compose run --rm ingestion
```

This reads all CSV files from `data/` and loads them into the `bronze` schema.

### Step 3: Run dbt transformations (Silver + Gold layers)

```bash
docker exec -it ecommerce_dbt bash
dbt run
```

This builds:

- **Silver layer** — cleaned, standardized views (`silver.*`)
- **Gold layer** — fact table, dimension tables, and business aggregations (`gold.*`)

### Step 4: Run data quality tests

```bash
dbt test
```

This validates primary keys, foreign key relationships, accepted values (e.g. order status, review scores), and uniqueness constraints across Silver and Gold models.

---

## Data Model

### Silver Layer

| Model                  | Description                                     |
| ---------------------- | ----------------------------------------------- |
| `silver_customers`     | Cleaned customer data                           |
| `silver_orders`        | Cleaned order data with standardized statuses   |
| `silver_order_items`   | Order line items with calculated item totals    |
| `silver_products`      | Product data with English category translations |
| `silver_sellers`       | Cleaned seller data                             |
| `silver_payments`      | Cleaned payment records                         |
| `silver_order_reviews` | Deduplicated customer reviews                   |

### Gold Layer

**Dimensions:**

- `dim_customer`
- `dim_product`
- `dim_seller`
- `dim_date`

**Fact table:**

- `fact_sales` — grain: one row per order item, with revenue, payment, and order status info

**Business aggregations:**

- `sales_summary_daily` — daily revenue, orders, and customers
- `product_performance` — revenue, quantity sold, and average order value by product
- `seller_performance` — revenue, order count, and product volume by seller

---

## Dashboards (Metabase)

Access Metabase at `http://localhost:3000`, connect to the `ecommerce_db` PostgreSQL database (host: `postgres`), and build dashboards on top of the Gold layer:

1. **Executive Overview** — total revenue, total orders, total customers, average order value
2. **Product Performance** — top products, revenue by product, quantity sold
3. **Seller Performance** — seller revenue, ranking, orders by seller
4. **Sales Trend** — daily/monthly revenue trend, order growth

---

## Non-Functional Requirements

- Reproducible environment using Docker — no local dependency installation required
- Modular SQL transformations using dbt, organized by Medallion layer
- Data lineage and documentation generated through dbt docs
- Version controlled with Git
- Clear separation of concerns: Python handles ingestion only, dbt handles all business transformations

---

## Dataset

This project uses the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), containing real anonymized order data including orders, order items, products, customers, sellers, payments, reviews, and geolocation.
