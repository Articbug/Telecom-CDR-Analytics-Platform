# 📡 Telecom CDR Analytics Platform

> End-to-end Data Engineering project simulating a real-world telecom Call Detail Records (CDR) analytics system built for Wipro Assessment — February 2026

---

## 🎯 Project Overview

This project demonstrates a complete data engineering pipeline for a telecom company processing **50,000+ CDR records** with advanced analytics, real-time streaming, and enterprise-grade security.

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Python 3.12 | Data Generation, ETL Pipeline |
| Apache PySpark 4.0 | Batch + Streaming Processing |
| Snowflake | Cloud Data Warehouse |
| Tableau Public | Interactive Dashboard |
| Google Colab | Development Environment |
| Draw.io | Architecture Diagram |

---

## 📁 Project Structure

```
telecom-cdr-analytics-platform/
│
├── notebooks/
│   ├── 1_CDR_Analytics_Wipro.ipynb         # Data Generation + Load to Snowflake
│   ├── 2_CDR_Advanced_SQL.ipynb            # 5 Advanced SQL Queries
│   ├── 3_CDR_ETL_Pipeline.ipynb            # ETL STG_CDR → FACT_CDR
│   ├── 4_CDR_Spark_Pipeline.ipynb          # Spark Batch + Streaming
│   ├── 5_CDR_Snowflake_Optimization.ipynb  # Clustering + Time Travel + JSON
│   ├── 6_CDR_Security_RBAC.ipynb           # RBAC + Masking + Governance
│   ├── 7_CDR_Performance_Tuning.ipynb      # Secure Views + Query Optimization
│   └── README.md
│
├── sql/
│   ├── snowflake_queries.sql               # Complete SQL Scripts (8 sections)
│   └── README.md
│
├── dashboard/
│   ├── 1_Monthly_Revenue_Visualization.png
│   ├── 2_Call_Type_Revenue_Visualization.png
│   ├── 3_Network_Performance_Visualization.png
│   ├── 4_Fraud_Analysis_Visualization.png
│   ├── 5_Cell_Tower_Performance_Visualization.png
│   ├── 6_Network_Distribution_Visualization.png
│   ├── 7_Monthly_Calls_Visualization.png
│   ├── CDR_Analytics_Dashboard.png         # Complete dashboard screenshot
│   ├── Telecom_CDR_Analytics_Dashboard.twbx # Tableau workbook file
│   ├── cdr_data.csv                        # Exported Snowflake data
│   └── README.md
│
├── architecture/
│   ├── CDR_Architecture Diagram.drawio     # Editable Draw.io source file
│   ├── CDR_Architecture Diagram.drawio.png # Architecture diagram image
│   └── README.md
│
├── CDR_Presentation.pptx                   # Final PPT Presentation (10 slides)
├── LICENSE                                 # MIT License
└── README.md
```

---

## 🏗️ Architecture

```
Python Generator → STG_CDR → ETL Pipeline → FACT_CDR → Analytics Views → Tableau
                                   ↓
                            Apache Spark
                       (Batch + Streaming)
```

---

## 📓 Notebooks

| # | Notebook | Description |
|---|---|---|
| 1 | 1_CDR_Analytics_Wipro.ipynb | Generates 50,000 realistic Indian telecom CDR records and loads to Snowflake STG_CDR |
| 2 | 2_CDR_Advanced_SQL.ipynb | 5 advanced SQL queries using CTEs, Window Functions, Fraud Detection, Network Analysis |
| 3 | 3_CDR_ETL_Pipeline.ipynb | ETL pipeline transforming raw STG_CDR data into FACT_CDR with dimension key mapping |
| 4 | 4_CDR_Spark_Pipeline.ipynb | Apache Spark batch processing and real-time streaming simulation |
| 5 | 5_CDR_Snowflake_Optimization.ipynb | Clustering Keys, Time Travel (7 days), Semi-Structured JSON |
| 6 | 6_CDR_Security_RBAC.ipynb | RBAC roles, Data Masking, Row Access Policy, Audit Logging |
| 7 | 7_CDR_Performance_Tuning.ipynb | Secure Views and query optimization |

---

## 📊 Dashboard

Built with **Tableau Public** using exported Snowflake data.

| # | Visualization | Description |
|---|---|---|
| 1 | 1_Monthly_Revenue_Visualization.png | Line chart — revenue trend Jan–Dec 2024 |
| 2 | 2_Call_Type_Revenue_Visualization.png | Bar chart — VOICE/SMS/DATA/VIDEO revenue |
| 3 | 3_Network_Performance_Visualization.png | Dropped calls by 2G/3G/4G/5G network |
| 4 | 4_Fraud_Analysis_Visualization.png | Stacked bar — fraud calls by month |
| 5 | 5_Cell_Tower_Performance_Visualization.png | Revenue across 5 cell towers |
| 6 | 6_Network_Distribution_Visualization.png | Pie chart — call distribution by network |
| 7 | 7_Monthly_Calls_Visualization.png | Stacked bar — calls by month and call type |
| - | CDR_Analytics_Dashboard.png | Complete combined dashboard screenshot |

---

## 🗄️ SQL Scripts

`sql/snowflake_queries.sql` contains 8 sections:

| Section | Content |
|---|---|
| 1 | Database Setup (Schemas, Warehouses) |
| 2 | Dimension Tables |
| 3 | Fact Table (FACT_CDR, STG_CDR) |
| 4 | Seed Data |
| 5 | Advanced SQL Queries (CTE, Window Functions) |
| 6 | Snowflake Optimization (Clustering, Time Travel, JSON) |
| 7 | Security (RBAC, Masking, Row Access Policy) |
| 8 | Performance Tuning (Secure Views) |

---

## ✅ Features Implemented

### Data Warehouse Design
- Star Schema — FACT_CDR + 5 Dimension Tables
- STAGING, DWH, ANALYTICS, STREAMING schemas
- 3 Snowflake Warehouses (INGEST_WH, TRANSFORM_WH, REPORTING_WH)

### Data Generation
- 50,000 realistic Indian telecom CDR records
- 500 unique subscribers with Indian phone numbers (91XX prefix)
- 5 cell towers — Bhubaneswar, Cuttack, Puri, Mumbai, Delhi
- Realistic peak hour traffic patterns
- Full year 2024 (Jan 1 — Dec 31)

### Advanced SQL Queries
- Monthly Revenue Trend — CTE + LAG() Window Function
- Customer Ranking — RANK() + NTILE() tiers (PLATINUM/GOLD/SILVER/BRONZE)
- Fraud Detection — Rolling 7-Day Average
- Network Performance — RANK() with PARTITION BY
- Cell Tower Performance — Revenue + Drop Rate Ranking

### ETL Pipeline
- Extract: 50,000 records from STG_CDR
- Transform: Dimension key mapping across 4 lookup tables
- Load: Batch insert (5,000 records per batch)
- Validate: 0 records dropped — 100% data integrity

### Apache Spark
- Batch Processing: Revenue, fraud, network aggregations
- Streaming Simulation: 500ms micro-batches, 10 iterations
- PySpark 4.0 DataFrame API

### Snowflake Optimization
- Clustering Keys — FACT_CDR (DATE_KEY), STG_CDR (CALL_TYPE)
- Time Travel — 7-day retention, delete and recover demo (138 records)
- Semi-Structured JSON — CDR_JSON VARIANT table with PARSE_JSON()

### Security & Governance
- RBAC — CDR_ADMIN / CDR_ANALYST / CDR_VIEWER roles
- Data Masking — Phone numbers (91XX********XX) and charge amounts
- Row Access Policy — Network type based row filtering
- Data Classification Tags — CONFIDENTIAL / RESTRICTED
- Audit Logging — 6 events tracked in AUDIT_LOG table

### Performance Tuning
- VW_MONTHLY_REVENUE (Secure View)
- VW_CUSTOMER_SUMMARY (Secure View)
- VW_NETWORK_PERFORMANCE (Secure View)

---

## 📊 Key Statistics

| Metric | Value |
|---|---|
| Total CDR Records | 50,000 |
| Unique Subscribers | 500 |
| Date Range | Jan 1 — Dec 31, 2024 |
| Total Revenue | ₹59,405.55 |
| Fraud Rate | 0.5% (250 records) |
| Roaming Rate | 2% |
| Average Drop Rate | 14–15% |
| ETL Data Loss | 0% |
| ETL Runtime | 52 seconds |

---

## 🚀 How to Run

1. Open any notebook in **Google Colab**
2. Run **Cell 1** to install dependencies
3. Snowflake connection is pre-configured
4. Run cells sequentially from top to bottom

### Prerequisites
- Google account (for Colab)
- Snowflake account
- Python 3.12+

---

## 👤 Author

**Chandan Sahoo**
Data Engineering Assessment — Wipro
February 2026

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.
