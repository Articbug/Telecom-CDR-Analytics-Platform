-- ============================================================
--   TELECOM CDR ANALYTICS PLATFORM
--   Snowflake SQL Scripts
--   Author: Chandan Sahoo
--   Date: February 2026
-- ============================================================


-- ============================================================
--   SECTION 1: DATABASE SETUP
-- ============================================================

-- Create Database
CREATE DATABASE IF NOT EXISTS TELECOM_DWH;

-- Create Schemas
CREATE SCHEMA IF NOT EXISTS TELECOM_DWH.STAGING;
CREATE SCHEMA IF NOT EXISTS TELECOM_DWH.DWH;
CREATE SCHEMA IF NOT EXISTS TELECOM_DWH.ANALYTICS;
CREATE SCHEMA IF NOT EXISTS TELECOM_DWH.STREAMING;

-- Create Warehouses
CREATE WAREHOUSE IF NOT EXISTS INGEST_WH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

CREATE WAREHOUSE IF NOT EXISTS TRANSFORM_WH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

CREATE WAREHOUSE IF NOT EXISTS REPORTING_WH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;


-- ============================================================
--   SECTION 2: DIMENSION TABLES
-- ============================================================

-- DIM_DATE
CREATE TABLE IF NOT EXISTS TELECOM_DWH.DWH.DIM_DATE (
    DATE_KEY        NUMBER PRIMARY KEY,
    FULL_DATE       DATE NOT NULL,
    DAY_OF_WEEK     NUMBER,
    DAY_NAME        VARCHAR(10),
    DAY_OF_MONTH    NUMBER,
    MONTH_NUM       NUMBER,
    MONTH_NAME      VARCHAR(10),
    QUARTER         NUMBER,
    YEAR_NUM        NUMBER,
    IS_WEEKEND      BOOLEAN,
    IS_HOLIDAY      BOOLEAN
);

-- DIM_SUBSCRIBER (SCD Type 2)
CREATE TABLE IF NOT EXISTS TELECOM_DWH.DWH.DIM_SUBSCRIBER (
    SUBSCRIBER_KEY  NUMBER AUTOINCREMENT PRIMARY KEY,
    MSISDN          VARCHAR(15) NOT NULL,
    FIRST_NAME      VARCHAR(50),
    LAST_NAME       VARCHAR(50),
    PLAN_TYPE       VARCHAR(20),
    PLAN_NAME       VARCHAR(50),
    SEGMENT         VARCHAR(20),
    CITY            VARCHAR(50),
    STATE           VARCHAR(50),
    ACTIVATION_DATE DATE,
    EFFECTIVE_DATE  DATE NOT NULL,
    EXPIRY_DATE     DATE DEFAULT '9999-12-31'::DATE,
    IS_CURRENT      BOOLEAN DEFAULT TRUE
);

-- DIM_CELL_TOWER
CREATE TABLE IF NOT EXISTS TELECOM_DWH.DWH.DIM_CELL_TOWER (
    CELL_KEY        NUMBER AUTOINCREMENT PRIMARY KEY,
    CELL_ID         VARCHAR(20) NOT NULL,
    CELL_NAME       VARCHAR(100),
    TOWER_TYPE      VARCHAR(20),
    LATITUDE        NUMBER(10,6),
    LONGITUDE       NUMBER(10,6),
    ZONE_KEY        NUMBER
);

-- DIM_CALL_TYPE
CREATE TABLE IF NOT EXISTS TELECOM_DWH.DWH.DIM_CALL_TYPE (
    CALL_TYPE_KEY   NUMBER AUTOINCREMENT PRIMARY KEY,
    CALL_TYPE_CODE  VARCHAR(10) NOT NULL,
    CALL_TYPE_NAME  VARCHAR(50),
    DESCRIPTION     VARCHAR(200)
);

-- DIM_ZONE
CREATE TABLE IF NOT EXISTS TELECOM_DWH.DWH.DIM_ZONE (
    ZONE_KEY        NUMBER AUTOINCREMENT PRIMARY KEY,
    ZONE_CODE       VARCHAR(10),
    ZONE_NAME       VARCHAR(50),
    REGION          VARCHAR(50)
);


-- ============================================================
--   SECTION 3: FACT TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS TELECOM_DWH.DWH.FACT_CDR (
    CDR_KEY         NUMBER AUTOINCREMENT PRIMARY KEY,
    CALL_ID         VARCHAR(50) NOT NULL,
    DATE_KEY        NUMBER,
    CALLER_KEY      NUMBER,
    CALLEE_KEY      NUMBER,
    CELL_KEY        NUMBER,
    CALL_TYPE_KEY   NUMBER,
    DURATION_SECS   NUMBER DEFAULT 0,
    CHARGE_AMOUNT   NUMBER(12,4) DEFAULT 0,
    DATA_VOLUME_MB  NUMBER(12,3) DEFAULT 0,
    IS_ROAMING      BOOLEAN DEFAULT FALSE,
    IS_FRAUD        BOOLEAN DEFAULT FALSE,
    TERMINATION_CD  VARCHAR(10),
    NETWORK_TYPE    VARCHAR(5),
    LOAD_TIMESTAMP  TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Staging Table
CREATE TABLE IF NOT EXISTS TELECOM_DWH.STAGING.STG_CDR (
    CALL_ID         VARCHAR(50),
    CALLING_NUMBER  VARCHAR(15),
    CALLED_NUMBER   VARCHAR(15),
    CALL_START_TIME TIMESTAMP_NTZ,
    CALL_END_TIME   TIMESTAMP_NTZ,
    DURATION_SECONDS NUMBER,
    CALL_TYPE       VARCHAR(10),
    CELL_ID         VARCHAR(20),
    TERMINATION_CD  VARCHAR(10),
    IS_ROAMING      BOOLEAN,
    CHARGE_AMOUNT   NUMBER(12,4),
    DATA_VOLUME_MB  NUMBER(12,3),
    NETWORK_TYPE    VARCHAR(5),
    IS_FRAUD        BOOLEAN
);


-- ============================================================
--   SECTION 4: SEED DATA
-- ============================================================

-- DIM_CALL_TYPE
INSERT INTO TELECOM_DWH.DWH.DIM_CALL_TYPE (CALL_TYPE_CODE, CALL_TYPE_NAME, DESCRIPTION) VALUES
('VOICE', 'Voice Call',     'Regular voice call between subscribers'),
('SMS',   'SMS Message',    'Short message service'),
('DATA',  'Data Session',   'Mobile internet/data usage'),
('VIDEO', 'Video Call',     'Video call service');

-- DIM_ZONE
INSERT INTO TELECOM_DWH.DWH.DIM_ZONE (ZONE_CODE, ZONE_NAME, REGION) VALUES
('NORTH', 'North India', 'North'),
('SOUTH', 'South India', 'South'),
('EAST',  'East India',  'East'),
('WEST',  'West India',  'West'),
('CENTRAL','Central India','Central');

-- DIM_CELL_TOWER
INSERT INTO TELECOM_DWH.DWH.DIM_CELL_TOWER (CELL_ID, CELL_NAME, TOWER_TYPE, LATITUDE, LONGITUDE, ZONE_KEY) VALUES
('CELL_00001', 'Bhubaneswar Tower 1', 'MACRO',  20.2961, 85.8245, 3),
('CELL_00002', 'Cuttack Tower 1',     'MACRO',  20.4625, 85.8830, 3),
('CELL_00003', 'Puri Tower 1',        'MICRO',  19.8135, 85.8312, 3),
('CELL_00004', 'Mumbai Tower 1',      'MACRO',  19.0760, 72.8777, 4),
('CELL_00005', 'Delhi Tower 1',       'MACRO',  28.6139, 77.2090, 1);

-- DIM_DATE (2024 full year)
INSERT INTO TELECOM_DWH.DWH.DIM_DATE
SELECT
    TO_NUMBER(TO_CHAR(DATEADD(DAY, SEQ4(), '2024-01-01'), 'YYYYMMDD')) AS DATE_KEY,
    DATEADD(DAY, SEQ4(), '2024-01-01')                                  AS FULL_DATE,
    DAYOFWEEK(DATEADD(DAY, SEQ4(), '2024-01-01'))                       AS DAY_OF_WEEK,
    DAYNAME(DATEADD(DAY, SEQ4(), '2024-01-01'))                         AS DAY_NAME,
    DAY(DATEADD(DAY, SEQ4(), '2024-01-01'))                             AS DAY_OF_MONTH,
    MONTH(DATEADD(DAY, SEQ4(), '2024-01-01'))                           AS MONTH_NUM,
    MONTHNAME(DATEADD(DAY, SEQ4(), '2024-01-01'))                       AS MONTH_NAME,
    QUARTER(DATEADD(DAY, SEQ4(), '2024-01-01'))                         AS QUARTER,
    YEAR(DATEADD(DAY, SEQ4(), '2024-01-01'))                            AS YEAR_NUM,
    CASE WHEN DAYNAME(DATEADD(DAY, SEQ4(), '2024-01-01'))
         IN ('Sat','Sun') THEN TRUE ELSE FALSE END                       AS IS_WEEKEND,
    FALSE                                                                AS IS_HOLIDAY
FROM TABLE(GENERATOR(ROWCOUNT => 366));


-- ============================================================
--   SECTION 5: ADVANCED SQL QUERIES
-- ============================================================

-- Query 1: Monthly Revenue Trend (CTE + Window Functions)
WITH monthly_revenue AS (
    SELECT
        YEAR(CALL_START_TIME)           AS year_num,
        MONTH(CALL_START_TIME)          AS month_num,
        MONTHNAME(CALL_START_TIME)      AS month_name,
        COUNT(*)                        AS total_calls,
        ROUND(SUM(CHARGE_AMOUNT), 2)    AS total_revenue,
        COUNT(DISTINCT CALLING_NUMBER)  AS unique_customers
    FROM TELECOM_DWH.STAGING.STG_CDR
    GROUP BY YEAR(CALL_START_TIME), MONTH(CALL_START_TIME), MONTHNAME(CALL_START_TIME)
),
revenue_with_growth AS (
    SELECT *,
        LAG(total_revenue) OVER (ORDER BY year_num, month_num) AS prev_revenue,
        ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY year_num, month_num))
            / NULLIF(LAG(total_revenue) OVER (ORDER BY year_num, month_num), 0) * 100, 2) AS mom_growth_pct,
        ROUND(total_revenue / SUM(total_revenue) OVER () * 100, 2) AS revenue_share_pct
    FROM monthly_revenue
)
SELECT month_name, total_calls, unique_customers,
       total_revenue, prev_revenue, mom_growth_pct, revenue_share_pct
FROM revenue_with_growth
ORDER BY year_num, month_num;


-- Query 2: Customer Ranking (RANK + NTILE)
WITH customer_revenue AS (
    SELECT CALLING_NUMBER, COUNT(*) AS total_calls,
           ROUND(SUM(CHARGE_AMOUNT), 2) AS total_revenue,
           COUNT(DISTINCT CALL_TYPE) AS services_used
    FROM TELECOM_DWH.STAGING.STG_CDR
    GROUP BY CALLING_NUMBER
)
SELECT CALLING_NUMBER, total_calls, total_revenue, services_used,
       RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
       CASE NTILE(4) OVER (ORDER BY total_revenue DESC)
           WHEN 1 THEN 'PLATINUM' WHEN 2 THEN 'GOLD'
           WHEN 3 THEN 'SILVER'   ELSE 'BRONZE' END AS tier
FROM customer_revenue
ORDER BY revenue_rank
LIMIT 20;


-- Query 3: Fraud Detection (Rolling 7-Day Average)
WITH daily_stats AS (
    SELECT DATE(CALL_START_TIME) AS call_date,
           COUNT(*) AS daily_calls,
           SUM(CASE WHEN IS_FRAUD = TRUE THEN 1 ELSE 0 END) AS fraud_calls,
           ROUND(SUM(CHARGE_AMOUNT), 2) AS daily_revenue
    FROM TELECOM_DWH.STAGING.STG_CDR
    GROUP BY DATE(CALL_START_TIME)
)
SELECT call_date, daily_calls, fraud_calls, daily_revenue,
       ROUND(AVG(daily_calls) OVER (
           ORDER BY call_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 1) AS rolling_7day_calls,
       ROUND(AVG(fraud_calls) OVER (
           ORDER BY call_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS rolling_7day_fraud
FROM daily_stats
ORDER BY call_date;


-- Query 4: Network Performance Analysis
SELECT NETWORK_TYPE, CALL_TYPE, COUNT(*) AS total_calls,
       ROUND(AVG(DURATION_SECONDS), 1) AS avg_duration,
       ROUND(SUM(CHARGE_AMOUNT), 2) AS total_revenue,
       ROUND(SUM(CASE WHEN TERMINATION_CD = 'DROPPED' THEN 1 ELSE 0 END)
             * 100.0 / COUNT(*), 2) AS drop_rate_pct,
       RANK() OVER (PARTITION BY CALL_TYPE ORDER BY
           SUM(CASE WHEN TERMINATION_CD = 'DROPPED' THEN 1 ELSE 0 END)
           * 100.0 / COUNT(*) ASC) AS reliability_rank
FROM TELECOM_DWH.STAGING.STG_CDR
GROUP BY NETWORK_TYPE, CALL_TYPE
ORDER BY CALL_TYPE, reliability_rank;


-- Query 5: Cell Tower Performance
SELECT CELL_ID, COUNT(*) AS total_calls,
       ROUND(AVG(DURATION_SECONDS), 1) AS avg_duration,
       ROUND(SUM(CHARGE_AMOUNT), 2) AS total_revenue,
       SUM(CASE WHEN TERMINATION_CD = 'DROPPED' THEN 1 ELSE 0 END) AS dropped_calls,
       ROUND(SUM(CASE WHEN TERMINATION_CD = 'DROPPED' THEN 1 ELSE 0 END)
             * 100.0 / COUNT(*), 2) AS drop_rate_pct,
       SUM(CASE WHEN IS_FRAUD = TRUE THEN 1 ELSE 0 END) AS fraud_calls,
       RANK() OVER (ORDER BY SUM(CHARGE_AMOUNT) DESC) AS revenue_rank
FROM TELECOM_DWH.STAGING.STG_CDR
GROUP BY CELL_ID
ORDER BY revenue_rank;


-- ============================================================
--   SECTION 6: SNOWFLAKE OPTIMIZATION
-- ============================================================

-- Clustering Keys
ALTER TABLE TELECOM_DWH.DWH.FACT_CDR CLUSTER BY (DATE_KEY);
ALTER TABLE TELECOM_DWH.STAGING.STG_CDR CLUSTER BY (CALL_TYPE);

-- Verify Clustering
SELECT SYSTEM$CLUSTERING_INFORMATION('TELECOM_DWH.DWH.FACT_CDR');

-- Time Travel
ALTER TABLE TELECOM_DWH.DWH.FACT_CDR SET DATA_RETENTION_TIME_IN_DAYS = 7;
ALTER TABLE TELECOM_DWH.STAGING.STG_CDR SET DATA_RETENTION_TIME_IN_DAYS = 7;

-- Semi-Structured JSON
CREATE OR REPLACE TABLE TELECOM_DWH.STAGING.CDR_JSON (
    CALL_ID      VARCHAR(50),
    CALL_DATE    DATE,
    CDR_METADATA VARIANT
);

-- Query JSON Data
SELECT
    CALL_ID,
    CALL_DATE,
    CDR_METADATA:call_type::VARCHAR  AS call_type,
    CDR_METADATA:network::VARCHAR    AS network,
    CDR_METADATA:duration::INT       AS duration,
    CDR_METADATA:charge::FLOAT       AS charge,
    CDR_METADATA:is_roaming::BOOLEAN AS is_roaming,
    CDR_METADATA:is_fraud::BOOLEAN   AS is_fraud
FROM TELECOM_DWH.STAGING.CDR_JSON
LIMIT 10;


-- ============================================================
--   SECTION 7: SECURITY - RBAC + DATA MASKING
-- ============================================================

-- Create Roles
CREATE ROLE IF NOT EXISTS CDR_ADMIN;
CREATE ROLE IF NOT EXISTS CDR_ANALYST;
CREATE ROLE IF NOT EXISTS CDR_VIEWER;

-- Grant Privileges
GRANT ALL PRIVILEGES ON DATABASE TELECOM_DWH TO ROLE CDR_ADMIN;
GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE TELECOM_DWH TO ROLE CDR_ADMIN;
GRANT ALL PRIVILEGES ON ALL TABLES IN DATABASE TELECOM_DWH TO ROLE CDR_ADMIN;

GRANT USAGE ON DATABASE TELECOM_DWH TO ROLE CDR_ANALYST;
GRANT USAGE ON SCHEMA TELECOM_DWH.STAGING TO ROLE CDR_ANALYST;
GRANT USAGE ON SCHEMA TELECOM_DWH.DWH TO ROLE CDR_ANALYST;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA TELECOM_DWH.STAGING TO ROLE CDR_ANALYST;
GRANT SELECT ON ALL TABLES IN SCHEMA TELECOM_DWH.DWH TO ROLE CDR_ANALYST;

GRANT USAGE ON DATABASE TELECOM_DWH TO ROLE CDR_VIEWER;
GRANT USAGE ON SCHEMA TELECOM_DWH.DWH TO ROLE CDR_VIEWER;
GRANT SELECT ON ALL TABLES IN SCHEMA TELECOM_DWH.DWH TO ROLE CDR_VIEWER;

-- Data Masking Policies
CREATE OR REPLACE MASKING POLICY TELECOM_DWH.DWH.MASK_PHONE_NUMBER
AS (VAL VARCHAR) RETURNS VARCHAR ->
CASE
    WHEN CURRENT_ROLE() IN ('CDR_ADMIN', 'ACCOUNTADMIN') THEN VAL
    ELSE CONCAT(LEFT(VAL, 4), '********', RIGHT(VAL, 2))
END;

CREATE OR REPLACE MASKING POLICY TELECOM_DWH.DWH.MASK_CHARGE_AMOUNT
AS (VAL NUMBER) RETURNS NUMBER ->
CASE
    WHEN CURRENT_ROLE() IN ('CDR_ADMIN', 'ACCOUNTADMIN') THEN VAL
    ELSE NULL
END;

-- Row Access Policy
CREATE OR REPLACE ROW ACCESS POLICY TELECOM_DWH.DWH.CDR_ROW_ACCESS
AS (network_type VARCHAR) RETURNS BOOLEAN ->
CASE
    WHEN CURRENT_ROLE() = 'CDR_ADMIN'   THEN TRUE
    WHEN CURRENT_ROLE() = 'CDR_ANALYST' THEN network_type IN ('4G', '5G')
    WHEN CURRENT_ROLE() = 'CDR_VIEWER'  THEN network_type = '4G'
    ELSE FALSE
END;

-- Data Classification Tags
CREATE TAG IF NOT EXISTS TELECOM_DWH.DWH.DATA_SENSITIVITY
ALLOWED_VALUES 'PUBLIC', 'INTERNAL', 'CONFIDENTIAL', 'RESTRICTED';


-- ============================================================
--   SECTION 8: PERFORMANCE TUNING - SECURE VIEWS
-- ============================================================

-- Monthly Revenue View
CREATE OR REPLACE SECURE VIEW TELECOM_DWH.ANALYTICS.VW_MONTHLY_REVENUE
AS
SELECT
    d.YEAR_NUM, d.MONTH_NUM, d.MONTH_NAME,
    ct.CALL_TYPE_CODE,
    COUNT(*)                        AS total_calls,
    ROUND(SUM(f.CHARGE_AMOUNT), 2)  AS total_revenue,
    ROUND(AVG(f.DURATION_SECS), 1)  AS avg_duration,
    COUNT(DISTINCT f.CALLER_KEY)    AS unique_callers
FROM TELECOM_DWH.DWH.FACT_CDR f
JOIN TELECOM_DWH.DWH.DIM_DATE      d  ON f.DATE_KEY      = d.DATE_KEY
JOIN TELECOM_DWH.DWH.DIM_CALL_TYPE ct ON f.CALL_TYPE_KEY = ct.CALL_TYPE_KEY
GROUP BY d.YEAR_NUM, d.MONTH_NUM, d.MONTH_NAME, ct.CALL_TYPE_CODE;

-- Customer Summary View
CREATE OR REPLACE SECURE VIEW TELECOM_DWH.ANALYTICS.VW_CUSTOMER_SUMMARY
AS
SELECT
    f.CALLER_KEY,
    COUNT(*)                        AS total_calls,
    ROUND(SUM(f.CHARGE_AMOUNT), 2)  AS total_revenue,
    ROUND(AVG(f.DURATION_SECS), 1)  AS avg_duration,
    COUNT(DISTINCT f.CALL_TYPE_KEY) AS services_used,
    SUM(CASE WHEN f.IS_FRAUD   = TRUE THEN 1 ELSE 0 END) AS fraud_count,
    SUM(CASE WHEN f.IS_ROAMING = TRUE THEN 1 ELSE 0 END) AS roaming_count
FROM TELECOM_DWH.DWH.FACT_CDR f
GROUP BY f.CALLER_KEY;

-- Network Performance View
CREATE OR REPLACE SECURE VIEW TELECOM_DWH.ANALYTICS.VW_NETWORK_PERFORMANCE
AS
SELECT
    f.NETWORK_TYPE,
    ct.CALL_TYPE_CODE,
    COUNT(*)                        AS total_calls,
    ROUND(AVG(f.DURATION_SECS), 1)  AS avg_duration,
    ROUND(SUM(f.CHARGE_AMOUNT), 2)  AS total_revenue,
    SUM(CASE WHEN f.TERMINATION_CD = 'DROPPED' THEN 1 ELSE 0 END) AS dropped_calls,
    ROUND(SUM(CASE WHEN f.TERMINATION_CD = 'DROPPED' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2) AS drop_rate_pct
FROM TELECOM_DWH.DWH.FACT_CDR f
JOIN TELECOM_DWH.DWH.DIM_CALL_TYPE ct ON f.CALL_TYPE_KEY = ct.CALL_TYPE_KEY
GROUP BY f.NETWORK_TYPE, ct.CALL_TYPE_CODE;
