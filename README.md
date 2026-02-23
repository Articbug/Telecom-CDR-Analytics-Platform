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
│   ├── CDR_Analytics_Wipro.ipynb         # Data Generation + Load
│   ├── CDR_Advanced_SQL.ipynb            # 5 Advanced SQL Queries
│   ├── CDR_ETL_Pipeline.ipynb            # ETL STG → FACT_CDR
│   ├── CDR_Spark_Pipeline.ipynb          # Spark Batch + Streaming
│   ├── CDR_Snowflake_Optimization.ipynb  # Clustering + Time Travel + JSON
│   ├── CDR_Security_RBAC.ipynb           # RBAC + Masking + Governance
│   └── CDR_Performance_Tuning.ipynb      # Secure Views + Optimization
│
├── sql/
│   └── snowflake_queries.sql             # Complete SQL (8 sections)
│
├── dashboard/
│   └── dashboard.png                     # Tableau Dashboard screenshot
│
├── architecture/
│   ├── architecture_diagram.png          # Architecture diagram
│   └── CDR_Architecture_Diagram.drawio   # Editable Draw.io file
│
└── presentation/
    └── Telecom_CDR_Analytics_Wipro.pptx  # Final PPT (10 slides)
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

## ✅ Features Implemented

### 1. Data Warehouse Design
- Star Schema with FACT_CDR + 5 Dimension Tables
- STAGING, DWH, ANALYTICS, STREAMING schemas
- 3 Snowflake Warehouses (INGEST, TRANSFORM, REPORTING)

### 2. Data Generation
- 50,000 realistic Indian telecom CDR records
- 500 unique subscribers with Indian phone numbers
- 5 cell towers (Bhubaneswar, Cuttack, Puri, Mumbai, Delhi)
- Realistic traffic patterns with peak hours
- Jan 1 — Dec 31, 2024

### 3. Advanced SQL Queries
- Monthly Revenue Trend (CTE + LAG Window Function)
- Customer Ranking (RANK + NTILE — PLATINUM/GOLD/SILVER/BRONZE)
- Fraud Detection (Rolling 7-Day Average)
- Network Performance Analysis (RANK with PARTITION BY)
- Cell Tower Performance (Revenue + Drop Rate Ranking)

### 4. ETL Pipeline
- Extract: 50,000 records from STG_CDR
- Transform: Dimension key mapping (4 lookup tables)
- Load: Batch insert 5,000 records at a time
- Validate: 0 records dropped, 100% data integrity

### 5. Apache Spark
- Batch Processing: Revenue, fraud, network aggregations
- Streaming Simulation: 500ms micro-batches, 10 iterations
- PySpark 4.0 DataFrame API

### 6. Snowflake Optimization
- Clustering Keys on FACT_CDR (DATE_KEY) and STG_CDR (CALL_TYPE)
- Time Travel: 7-day retention, delete and recover demo
- Semi-Structured JSON: CDR_JSON VARIANT table

### 7. Security & Governance
- RBAC: CDR_ADMIN / CDR_ANALYST / CDR_VIEWER roles
- Data Masking: Phone numbers and charge amounts
- Row Access Policy: Network type based filtering
- Data Classification Tags: CONFIDENTIAL / RESTRICTED
- Audit Logging: 6 events tracked

### 8. Performance Tuning
- VW_MONTHLY_REVENUE (Secure View)
- VW_CUSTOMER_SUMMARY (Secure View)
- VW_NETWORK_PERFORMANCE (Secure View)

### 9. Tableau Dashboard
- Monthly Revenue Trend (Line Chart)
- Call Type Revenue (Bar Chart)
- Network Performance (Bar Chart)
- Fraud Analysis (Stacked Bar)
- Cell Tower Performance (Bar Chart)
- Network Distribution (Pie Chart)
- Monthly Calls (Stacked Bar)

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
| Average Drop Rate | 14-15% |
| ETL Data Loss | 0% |

---

## 🗄️ Data Model

### FACT_CDR (50,000 rows)
| Column | Type | Description |
|---|---|---|
| CALL_ID | VARCHAR | Unique call identifier |
| DATE_KEY | NUMBER | FK to DIM_DATE |
| CALLER_KEY | NUMBER | FK to DIM_SUBSCRIBER |
| CALLEE_KEY | NUMBER | FK to DIM_SUBSCRIBER |
| CELL_KEY | NUMBER | FK to DIM_CELL_TOWER |
| CALL_TYPE_KEY | NUMBER | FK to DIM_CALL_TYPE |
| DURATION_SECS | NUMBER | Call duration |
| CHARGE_AMOUNT | NUMBER | Billing amount |
| IS_FRAUD | BOOLEAN | Fraud flag |
| IS_ROAMING | BOOLEAN | Roaming flag |

### Dimension Tables
| Table | Rows | Description |
|---|---|---|
| DIM_DATE | 366 | Full year 2024 |
| DIM_SUBSCRIBER | 500 | All unique callers |
| DIM_CELL_TOWER | 5 | Network towers |
| DIM_CALL_TYPE | 4 | VOICE/SMS/DATA/VIDEO |
| DIM_ZONE | 5 | Geographic zones |

---

## 🚀 How to Run

1. Open any notebook in **Google Colab**
2. Run **Cell 1** to install dependencies
3. Snowflake connection is automatic
4. Run cells sequentially

### Prerequisites
- Snowflake account
- Google account (for Colab)
- Python 3.12+

---

## 👤 Author

**Chandan Sahoo**
Data Engineering Assessment — Wipro
February 2026

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.
