# Data Engineering Portfolio — Spark, Databricks & SQL

Hands-on data engineering projects covering Apache Spark, PySpark, Databricks, Delta Lake, Python, SQL, ETL pipelines, and dimensional data modeling.

This repository showcases practical projects focused on data ingestion, transformation, cleansing, integration, and analytics-ready data preparation.

## Projects

### 1. Retail Lakehouse Data Engineering Pipeline

**Online & Offline Retail Data Unification**

**Technologies:** Databricks, Apache Spark, PySpark, Delta Lake, Amazon S3, SQL

A hands-on Lakehouse project that brings together customer, product, and order data from two independent retail systems: an online commerce platform and an offline point-of-sale (POS) system.

The project uses Medallion Architecture to organize data processing into three layers:

- **Bronze — Ingestion:** Ingest source datasets, retain source information, and add ingestion metadata.
- **Silver — Cleansing and Unification:** Standardize schemas, clean attributes, deduplicate records, and unify online and offline customer and product data.
- **Gold — Analytics-Ready Modeling:** Build dimensional tables using SCD Type 1 and SCD Type 2 concepts, surrogate keys, and an orders fact table.

**Key concepts**
- Medallion Architecture and Lakehouse design
- PySpark DataFrame transformations
- Schema standardization and data cleansing
- Deduplication and cross-system entity matching
- Business keys and surrogate keys
- Slowly Changing Dimensions (SCD Type 1 and Type 2)
- Fact and dimension tables
- Data quality and rejected-record handling

**Project notebooks**
- [Bronze Layer](Notebooks/bronze%20layer.ipynb)
- [Silver Layer](Notebooks/silver%20layer.ipynb)
- [Gold Layer](Notebooks/gold%20layer.ipynb)

### 2. Kaggle to Pandas to SQL Server

**Technologies:** Python, Pandas, SQL Server, SQLAlchemy, PyODBC, SQL

An ETL project demonstrating dataset handling with Python and Pandas, loading data into SQL Server, and analyzing order data using SQL.

**Project files**
- [Kaggle to Pandas to SQL Server notebook](Python-SQL-Server-Kaggle/Kaggle_to_Pandas_to_SQLServer.ipynb)
- [Order Analysis SQL](Python-SQL-Server-Kaggle/df_orders_analysis.sql)

### 3. Netflix Data Cleaning and Analysis

**Technologies:** Python, Pandas, SQL Server, SQL

A data preparation and analysis project using the Netflix titles dataset. It covers dataset extraction, data handling, relational database storage, and SQL-based analysis.

**Project files**
- [Netflix Data Extraction and Analysis notebook](Netflix-Data-Cleaning-ELT/Netflix%20Data%20Extract%20and%20Analysis.ipynb)
- [Netflix Raw Data SQL](Netflix-Data-Cleaning-ELT/Netflix_Raw_Data.sql)
- [Netflix Data Cleaning and Analysis SQL](Netflix-Data-Cleaning-ELT/Netflix_Data_Cleaning_Analysis.sql)
- [Netflix Project README](Netflix-Data-Cleaning-ELT/README.md)

## Technology Stack

| Category | Technologies and Concepts |
|---|---|
| Big Data | Apache Spark, PySpark, Spark DataFrames |
| Lakehouse | Databricks, Delta Lake, Medallion Architecture |
| Cloud Storage | Amazon S3 |
| Programming | Python, SQL |
| Data Processing | ETL, data cleansing, schema standardization, deduplication |
| Data Modeling | Dimensional modeling, fact tables, dimension tables, surrogate keys |
| Historical Tracking | SCD Type 1, SCD Type 2 |
| Databases | Microsoft SQL Server |
| Version Control | Git, GitHub |

## About

This repository is a practical learning portfolio focused on data engineering concepts and implementation. Each project demonstrates selected techniques in data ingestion, transformation, data quality, database loading, and analytical data modeling.

Implementation details and limitations are documented in the respective project files.
