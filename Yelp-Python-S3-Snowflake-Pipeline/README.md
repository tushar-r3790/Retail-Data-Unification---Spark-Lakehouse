# Yelp Data Engineering Pipeline — Python, AWS S3 & Snowflake

## Project Overview

This project demonstrates an end-to-end data engineering workflow using the Yelp dataset. Python is used to split a large JSON Lines file into smaller files, AWS S3 serves as the cloud storage layer, and Snowflake is used for data ingestion, transformation, sentiment analysis, and SQL-based analytics.

The repository contains Python code, Snowflake SQL scripts, and analytical queries for exploring Yelp reviews and businesses.

## Architecture

```text
Yelp Academic Dataset
        |
        v
Python — Split large JSON Lines file
        |
        v
AWS S3 — Store split JSON files
        |
        v
Snowflake Storage Integration & External Stage
        |
        v
Raw Tables — Yelp Reviews & Businesses
        |
        v
Enhanced Tables — Structured Data
        |
        v
Sentiment Analysis & SQL Analytics
```

*Note: The S3-to-Snowflake connection and data-loading steps require successful configuration and validation in the target AWS and Snowflake accounts.*

## Technologies Used

- **Python:** File processing and JSON Lines splitting
- **AWS S3:** Cloud object storage
- **Snowflake:** Data ingestion, SQL transformations, and analytics
- **Snowflake Storage Integration:** IAM role-based access to S3 without embedding AWS access keys in SQL scripts
- **Snowflake Python UDF:** Sentiment classification using TextBlob
- **SQL:** Joins, CTEs, aggregations, window functions, and analytical queries
- **GitHub:** Version control and project documentation

## Repository Structure

```text
Yelp-Python-S3-Snowflake-Pipeline/
│
├── .gitignore
├── README.md
├── Yelp Files Split.ipynb
├── Table-yelp_reviews.sql
├── Table-yelp_businesses.sql
├── Function-analyze_sentiment.sql
└── Questions.sql
```

## Project Workflow

### 1. Split the Yelp JSON dataset using Python

The notebook `Yelp Files Split.ipynb` reads `yelp_academic_dataset_review.json` and splits it into smaller JSON Lines files.

The current notebook configuration specifies 20 output files and calculates the number of input lines assigned to each file.

**Input:** `yelp_academic_dataset_review.json`

**Output naming pattern:** `split_file_1.json`, `split_file_2.json`, and so on.

The original dataset must be available locally before running the notebook.

### 2. Store the files in AWS S3

Upload the required JSON files to the configured S3 location:

`s3://sample-practice-projects/yelp_project/`

The bucket and prefix above reflect the current project configuration. Access requires appropriate AWS permissions.

### 3. Configure Snowflake access to S3

The intended setup uses a Snowflake storage integration with an AWS IAM role and an external stage.

The SQL scripts refer to the stage `YELP_S3_STAGE` and integration `YELP_S3_INTEGRATION`. These objects must exist and be configured correctly in your own Snowflake account.

Do not put AWS access keys, secret keys, or other credentials in the repository.

### 4. Load Yelp data into Snowflake

The scripts `Table-yelp_reviews.sql` and `Table-yelp_businesses.sql` define raw tables and use `COPY INTO` to load JSON data from the external stage.

They also create enhanced tables by extracting fields from the JSON data into structured columns.

Examples of fields include:

- Business ID
- User ID
- Review date
- Review text
- Review stars
- Business name
- City and state
- Review count
- Business categories

### 5. Perform sentiment analysis

`Function-analyze_sentiment.sql` defines a Python-based Snowflake user-defined function using TextBlob.

The function classifies review text into three categories:

- **Positive:** Sentiment polarity greater than zero
- **Neutral:** Sentiment polarity equal to zero
- **Negative:** Sentiment polarity less than zero

These labels can be used to explore the sentiment of customer reviews.

### 6. Analyze the data using SQL

`Questions.sql` contains analytical queries covering topics such as:

- Business counts by category
- Users reviewing businesses in the Restaurants category
- Popular business categories based on review counts
- The three most recent reviews for each business
- Monthly review volumes
- Five-star review percentages
- The most-reviewed businesses in each city
- Average ratings for businesses with at least 100 reviews
- Users who have written the most reviews
- Businesses with the highest counts of positive-sentiment reviews

The queries use SQL concepts such as CTEs, joins, aggregation, `LATERAL SPLIT_TO_TABLE`, `ROW_NUMBER()`, and `QUALIFY`.

## Setup and Execution

1. Obtain the Yelp dataset from an authorized source and place the review JSON Lines file in the notebook's working directory.
2. Run `Yelp Files Split.ipynb` to generate the smaller JSON files.
3. Upload the required files to the configured AWS S3 prefix.
4. Configure the AWS IAM role, permissions, Snowflake storage integration, and external stage.
5. Validate that Snowflake can list and read the staged S3 objects.
6. Run the table-creation and data-loading statements in the SQL scripts.
7. Create the sentiment-analysis function and test it on sample review text.
8. Run the analytical queries in `Questions.sql`.

The AWS account, IAM role, Snowflake database, schema, warehouse, and permissions must be configured for the environment where the project is executed. The example resource names are not guaranteed to exist in another account.

## Security and Data Management

- Never commit AWS access keys, secret keys, passwords, or account-specific credentials.
- Use an IAM role and Snowflake storage integration for S3 access.
- Keep large raw Yelp dataset files out of GitHub; document how to obtain the data instead.
- Review `.gitignore` before committing local data, environment files, notebook outputs, or configuration files.
- Apply least-privilege IAM permissions and restrict access to the required S3 bucket and prefix.

## Current Status

The project scripts and notebook are published in this repository. The AWS S3-to-Snowflake integration and end-to-end data load should be considered **in progress until the external stage is validated and the data is successfully loaded**.

## Learning Outcomes

This project provides practical experience with:

- Processing large JSON Lines datasets using Python
- Organizing data files for cloud ingestion
- Configuring IAM role-based access to AWS S3
- Loading semi-structured JSON data into Snowflake
- Transforming JSON fields into structured tables
- Creating Python-based Snowflake UDFs
- Writing SQL for data exploration and business analytics

