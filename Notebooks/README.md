# Notebooks

This folder contains all Google Colab notebooks for the
Telecom CDR Analytics Platform project.

## Notebook Overview

| Notebook | Description |
|---|---|
| CDR_Analytics_Wipro.ipynb | Data generation of 50,000 realistic Indian telecom CDR records and loading to Snowflake STG_CDR |
| CDR_Advanced_SQL.ipynb | Advanced SQL queries using CTEs, Window Functions, Fraud Detection, Network Analysis |
| CDR_ETL_Pipeline.ipynb | ETL pipeline transforming raw data from STG_CDR to FACT_CDR with dimension key mapping |
| CDR_Spark_Pipeline.ipynb | Apache Spark batch processing and real-time streaming simulation |
| CDR_Snowflake_Optimization.ipynb | Snowflake optimization including Clustering Keys, Time Travel, and Semi-Structured JSON data |
| CDR_Security_RBAC.ipynb | Security implementation including RBAC, Data Masking, Row Access Policy, and Audit Logging |
| CDR_Performance_Tuning.ipynb | Performance tuning using Secure Views and Query Optimization |

## How to Run

1. Open any notebook in Google Colab
2. Run Cell 1 to install dependencies
3. Connection to Snowflake is automatic
4. Run cells sequentially

## Prerequisites

- Snowflake account
- Google Colab account
- Python 3.12+

## Libraries Used

- snowflake-connector-python
- pandas
- pyspark
- faker
- numpy
