# ApiDataLocation Table
## Design
### Overview
---
The purpose of this table is to house the latest location paths of all parquets created throughout the entire system. This includes Ingestion, Transformation & Publishing layers. The system currently only supports the following APIs:
  - shift
  - calculated-time

### Table Structure

PartitionKey | RowKey | Timestamp | Path | GoldIndex | IsProcessed 
| -------- | ------- | ------- | ------- | ------- | ------- 
| name of the api type | layer specific file type | last updated | file location | latest incremental id value for publishing parquets (only for transformation file types) | flag to determine if file needs to be transformed (only for ingestion file types)
| | | | | |
| shift | Bronze_Full_Default | 2023-01-01T20:57:22.2318127Z | bronze/2023-01-01T20:57:22.2318127Z | N/A | true
| shift | Silver_Delta_Default | 2023-01-01T20:57:22.2318127Z | silver/2023-01-01T20:57:22.2318127Z | 3001 | N/A
| shift | Gold_Full_Default | 2023-01-01T20:57:22.2318127Z | gold/2023-01-01T20:57:22.2318127Z | N/A | N/A