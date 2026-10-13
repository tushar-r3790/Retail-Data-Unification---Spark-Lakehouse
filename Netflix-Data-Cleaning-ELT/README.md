# Netflix Data Cleaning and Analysis

## Project Overview

This project explores Netflix movies and TV shows using **Python, Pandas, Jupyter Notebook, and Microsoft SQL Server**. It demonstrates data extraction, data-quality assessment, data preparation, relational data handling, and SQL-based analysis using a Netflix titles dataset.

The objective is to examine the dataset, identify data-quality issues, prepare data for analysis, and answer analytical questions using SQL.

## Technology Stack

- **Python** — data extraction and preparation
- **Pandas** — DataFrame operations and data-quality checks
- **Jupyter Notebook** — interactive development and documentation
- **Microsoft SQL Server** — relational data storage and analysis
- **SQLAlchemy and pyodbc** — Python-to-SQL Server connectivity
- **T-SQL (Microsoft SQL Server)** — data exploration, data preparation, string manipulation, aggregations, joins, and analytical queries.

## Project Workflow

1. **Data Extraction:** Load the Netflix titles CSV file into a Pandas DataFrame.
2. **Data Inspection:** Examine the dataset's dimensions, sample records, and column values.
3. **Data Quality Assessment:** Check missing values and investigate field lengths and non-English text.
4. **Database Integration:** Connect Python to SQL Server and load the dataset into a raw table.
5. **SQL Data Preparation:** Explore duplicate records, split multi-value fields, and investigate missing country information.
6. **Data Analysis:** Use SQL queries to explore genres, countries, directors, release years, and movie durations.

## Data Quality and Preparation

The project explores the following areas:

- Identifying missing values across columns.
- Examining the maximum length of text fields.
- Verifying that non-English characters are preserved in Pandas.
- Investigating duplicate titles and records.
- Splitting comma-separated values, such as director names and genres, into separate records.
- Converting and examining date and duration fields.
- Investigating missing country information using related records.

## SQL Analysis

The SQL script contains analytical queries to explore questions such as:

- How can duplicate Netflix records be identified?
- How are comedy titles distributed across countries?
- Which directors have the highest number of releases in a given year?
- What is the average duration of Netflix movies?
- Which directors are associated with both horror and comedy content?

## Repository Contents

| File | Description |
|---|---|
| `Netflix Data Extract and Analysis.ipynb` | Python and Pandas data inspection, quality checks, and SQL Server integration |
| `Netflix_Data_Cleaning_Analysis.sql` | SQL queries for data preparation and analysis |

## How to Run the Project

### Prerequisites

- Python installed
- Jupyter Notebook
- Pandas, SQLAlchemy, and pyodbc
- Microsoft SQL Server and the appropriate ODBC Driver
- The Netflix titles CSV dataset

### Execution Steps

1. Obtain the Netflix titles CSV dataset and place it in the notebook's working directory.
2. Install the required Python packages if they are not already installed:

   ```bash
   pip install pandas sqlalchemy pyodbc jupyter
   ```

3. Create a SQL Server database named `NetflixDB`, or update the notebook connection string to use your database.
4. Verify the SQL Server instance, authentication method, and ODBC driver settings.
5. Open `Netflix Data Extract and Analysis.ipynb` in Jupyter Notebook.
6. Execute the notebook cells in order.
7. Open `Netflix_Data_Cleaning_Analysis.sql` in SQL Server Management Studio (SSMS) and execute the SQL statements in the appropriate order.

**Note:** The notebook currently uses a local CSV path and Windows Authentication for SQL Server. Update these settings as required for your environment. Review the SQL script's table-creation and data-loading steps before rerunning it against an existing database.

## Learning Outcomes

This project demonstrates practical experience with:

- Python and Pandas for data inspection and preparation.
- Relational database connectivity and data loading.
- SQL joins, aggregations, window functions, and string operations.
- Missing-value investigation and duplicate detection.
- Working with text fields and non-English characters.
- Combining Python-based data handling with SQL-based analysis.

## Author

**Tushar Gajbhiye**

Data Engineering | Python | SQL | Pandas | Apache Spark | Databricks
