# Architecture Diagram

## Files
| File | Description |
|---|---|
| architecture_diagram.png | Architecture diagram image |
| CDR_Architecture_Diagram.drawio | Editable Draw.io source file |

## Architecture Overview

Data flows through 4 main layers:

1. **Data Source** - Python generates 50,000 CDR records
2. **Staging Layer** - Raw data loaded to Snowflake STG_CDR
3. **ETL Pipeline** - Transform and load to DWH FACT_CDR
4. **DWH Layer** - Star schema with 5 dimension tables

Supporting components:
- Apache Spark for batch and streaming
- Snowflake Optimization (Clustering, Time Travel, JSON)
- Security (RBAC, Masking, Governance)
- Performance Tuning (Secure Views)
- Tableau Dashboard (7 charts)
