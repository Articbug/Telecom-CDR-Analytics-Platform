# SQL Scripts

This folder contains all Snowflake SQL scripts for the
Telecom CDR Analytics Platform project.

## Files

| File | Description |
|---|---|
| snowflake_queries.sql | Complete Snowflake SQL script |

## Script Sections

| Section | Content |
|---|---|
| Section 1 | Database Setup (Database, Schemas, Warehouses) |
| Section 2 | Dimension Tables (DIM_DATE, DIM_SUBSCRIBER, DIM_CELL_TOWER, DIM_CALL_TYPE, DIM_ZONE) |
| Section 3 | Fact Table (FACT_CDR, STG_CDR) |
| Section 4 | Seed Data (Call Types, Zones, Cell Towers, Date Dimension) |
| Section 5 | Advanced SQL Queries (CTE, Window Functions, Fraud Detection) |
| Section 6 | Snowflake Optimization (Clustering Keys, Time Travel, Semi-Structured JSON) |
| Section 7 | Security (RBAC Roles, Data Masking, Row Access Policy, Tags) |
| Section 8 | Performance Tuning (Secure Views) |

## How to Run

1. Open Snowflake SQL Worksheet
2. Copy and paste each section one by one
3. Run in order from Section 1 to Section 8

## Database Structure
```
TELECOM_DWH/
├── STAGING/    Raw CDR data (STG_CDR, CDR_JSON)
├── DWH/        Star schema (FACT_CDR + 5 dimensions)
├── ANALYTICS/  Secure views for reporting
└── STREAMING/  Real-time streaming data
```

## Key Statistics

- 50,000 CDR records loaded
- 366 date dimension records (full year 2024)
- 500 subscriber records
- 5 cell tower records
- 4 call type records
- 5 zone records
