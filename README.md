# Spark Lakehouse Project — Retail Data Unification

A retail data engineering project to unify customer, product, and order data from independent online commerce and offline Point-of-Sale (POS) systems using Apache Spark on Databricks, Amazon S3, Delta Lake, and Medallion Architecture.

The project addresses inconsistent schemas, duplicate customer and product records, data quality issues, and cross-system entity matching to prepare reliable, analytics-ready data.

## Project Objective

A retail company operates two independent systems:

- **Online commerce platform:** Maintains online customer, product, and order data.
- **Offline POS system:** Maintains store customer, product, and order data.

Because these systems operate independently, their data can contain inconsistent attributes, different identifiers, duplicate entities, and incompatible schemas. These issues can lead to unreliable business reporting.

The objective is to build a Lakehouse pipeline that ingests, standardizes, unifies, and models the data for analytics.

## Architecture

The solution follows the Medallion Architecture, with Amazon S3 as the data lake, Databricks Spark as the processing engine, and Delta tables as the storage format.

```text
Online Commerce System        Offline POS System
          |                            |
          +-------------+--------------+
                        |
                        v
                  Amazon S3
                Source Data Files
                        |
                        v
              BRONZE — Raw Ingestion
          Preserve source schemas and data
          Add ingestion and source metadata
                        |
                        v
              SILVER — Clean & Unify
          Standardize schemas and attributes
          Resolve customer and product identity
          Enrich orders and handle rejected data
                        |
                        v
                GOLD — Analytics
            Customer Dimension (SCD Type 1)
            Product Dimension (SCD Type 2)
                  Orders Fact Table
                        |
                        v
             Analytics-Ready Data Model
```

## Technology Stack

| Technology | Purpose |
|---|---|
| Apache Spark | Distributed data processing |
| PySpark | Data transformation and cleansing |
| Databricks | Lakehouse development and execution |
| Amazon S3 | Data lake storage |
| Delta Lake | Storage and table management |
| SQL | Data querying and transformation |
| Medallion Architecture | Layered data processing |
| SCD Type 1 and Type 2 | Dimension data management |

## Source Systems and Data

The pipeline handles six source datasets:

| Source System | Datasets |
|---|---|
| Online | Customers, Products, Orders |
| Offline POS | Customers, Products, Orders |

The source files arrive in date-based folders in Amazon S3. Schemas and column names may differ between the two systems, so standardization is required before unification.

## Bronze Layer — Raw Ingestion

**Objective:** Ingest source data while preserving its original structure.

Requirements:

- Read all six datasets from Amazon S3.
- Preserve the original source schemas.
- Avoid heavy transformations during ingestion.
- Add metadata columns: `ingestion_timestamp`, `source_system`, and `file_date`.
- Store the data in Delta tables, with one Bronze table per source dataset.

Example tables:

- `bronze.online_customers`
- `bronze.offline_customers`
- `bronze.online_orders`
- `bronze.offline_orders`

Equivalent tables are required for online and offline products.

## Silver Layer — Data Cleansing and Unification

**Objective:** Standardize, cleanse, and unify the source datasets.

### 1. Customer Unification

Customer IDs differ between the online and offline systems and cannot be used as a common business key.

The cleaned mobile number is used to identify the same customer across systems.

Transformation rules:

- Remove country codes, spaces, dashes, and other non-numeric characters.
- Extract the last 10 digits of the mobile number into `mobile_clean`.
- Reject records without a valid 10-digit mobile number.
- Trim string fields and remove duplicate internal spaces.
- Standardize customer names to proper case.
- Convert email addresses to lowercase.
- Unify customers using `mobile_clean`.
- When a customer exists in both systems, prefer attributes from the online source.
- Use offline attributes when the customer does not exist online.

**Target table:** `silver.customers_unified`

### 2. Product Unification

The SKU identifier is the common business key for products.

Transformation rules:

- Standardize column names across both systems.
- Trim product names and remove duplicate internal spaces.
- Apply consistent casing to product names.
- Standardize category and brand casing.
- Unify products using `sku_id`.
- Prefer online product attributes when the same SKU exists in both systems.

**Target table:** `silver.products_unified`

Product history is managed in the Gold layer using SCD Type 2.

### 3. Order Enrichment

Orders do not contain a standardized mobile number, so customer identity must be resolved before creating the Gold fact table.

Processing rules:

1. Standardize order column names and add `source_system`.
2. Join online orders to online customers using `customer_id`.
3. Join offline orders to offline customers using `customer_id`.
4. Retrieve the corresponding mobile number.
5. Clean the number and extract the last 10 digits.
6. Match the cleaned number to the unified customer data.
7. Identify orders with missing customer or product matches.
8. Route unmatched orders to rejection or quarantine tables rather than silently dropping them.

**Target tables:**

- `silver.orders_enriched`
- `silver.orders_unmatched`

## Gold Layer — Dimensional Data Model

**Objective:** Create analytics-ready dimensions and a fact table using surrogate keys.

### Customer Dimension — SCD Type 1

The customer dimension uses `mobile_clean` as its business key.

Rules:

- Generate a surrogate key named `customer_sk`.
- Overwrite changed attributes rather than retaining historical versions.
- Maintain the latest customer information.

Expected columns:

`customer_sk`, `mobile_clean`, `name`, `email`, `city`, `state`, `last_updated`

### Product Dimension — SCD Type 2

The product dimension uses `sku_id` as its business key.

Rules:

- Generate a surrogate key named `product_sk`.
- Detect changes by comparing product attributes.
- Preserve historical versions of changed products.
- Maintain `effective_from`, `effective_to`, and `is_current`.
- Ensure each SKU has only one current record.

### Orders Fact Table

The fact table references the customer and product dimensions using surrogate keys.

Expected columns:

`order_sk`, `order_id`, `source_system`, `customer_sk`, `product_sk`, `order_ts`, `quantity`, `amount`, `payment_mode`, `store_num`

Lookup rules:

- Resolve `customer_sk` using `mobile_clean`.
- Resolve `product_sk` using `sku_id` and the appropriate current-record logic.
- Route orders with unresolved customer or product references to rejection tables.
- Populate `store_num` with `ONLINE` for online orders.

## Data Quality and Rejection Handling

The pipeline must account for invalid and unmatched records.

Rejection scenarios include:

- Invalid mobile numbers.
- Orders without a matching customer.
- Orders without a matching product.
- Null business keys.

Rejected records should be retained in appropriate reject or quarantine tables for investigation. Records must not be silently dropped.

## Incremental Processing

The pipeline is designed to support daily incremental data loads.

Requirements:

- Process only newly arrived data.
- Avoid unnecessary full reloads.
- Use Delta Lake `MERGE` operations for applicable Gold tables.
- Apply the relevant SCD Type 1 and SCD Type 2 rules during updates.
- Preserve product history while maintaining the current product record.

## Repository Structure

```text
spark-databricks-data-engineering/
│
├── Notebooks/
│   └── Spark and Databricks project notebooks
│
└── README.md
```

Open the `Notebooks` directory to review the project implementations and execution logic.

## Key Data Engineering Concepts

This project covers the following concepts:

- Spark DataFrame transformations
- Schema standardization and data cleansing
- Cross-system customer and product matching
- Business key resolution
- Surrogate key generation
- Delta Lake tables and incremental processing
- SCD Type 1 and SCD Type 2 dimension management
- Fact table construction
- Data quality validation and rejected-record handling
- Medallion Architecture and dimensional modeling

## Expected Outcome

The intended outcome is a unified retail data model that consolidates online and offline customer, product, and order data into consistent, analytics-ready Gold tables.

The design aims to reduce duplicate entities, improve data quality, preserve product history, and support incremental processing for reliable retail reporting.

