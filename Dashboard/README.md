# Dashboard

This folder contains the Tableau dashboard for the
Telecom CDR Analytics Platform project.

## Dashboard Overview

**Tool:** Tableau Public
**Data Source:** Snowflake (exported as CSV)
**Records:** 50,000 CDR records (2024)

## Charts Included

| Chart | Description |
|---|---|
| Monthly Revenue | Line chart showing revenue trend Jan-Dec 2024 |
| Call Type Revenue | Bar chart comparing revenue by VOICE/SMS/DATA/VIDEO |
| Network Performance | Bar chart showing dropped calls by network type |
| Fraud Analysis | Stacked bar chart showing fraud calls by month |
| Cell Tower Performance | Bar chart comparing revenue by cell tower |
| Network Distribution | Pie chart showing call distribution by network |
| Monthly Calls | Stacked bar chart showing calls by month and type |

## Key Insights

- Total Revenue: Rs 59,405 for year 2024
- VOICE calls generate 70% of total revenue
- 4G network handles 55% of all traffic
- Fraud rate maintained at 0.5% across all months
- All 5 cell towers performing consistently

## Files

| File | Description |
|---|---|
| dashboard.png | Screenshot of complete dashboard |
| cdr_data.csv | Exported data used for dashboard |

## How to View

1. Open Tableau Public
2. Upload cdr_data.csv
3. Recreate charts as per screenshots
