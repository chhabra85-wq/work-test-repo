# ApiMetaData Table
## Design
### Overview
---
The purpose of this table is to house any WFS API information needed to successfully call the APIs. The system currently only supports the following APIs:
  - shift
  - calculated-time

### Table Structure

PartitionKey | RowKey | Timestamp | BronzeIndex | Enabled | Method | NextCursor | RecordCountToRequest	| Version
| -------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| name of the api type | name of the api type | last updated | latest incremental ingestion id value | is api enabled | request type | the next api cursor (page link) to use | request query param for amount of records to get (max is 10,000) | api version 
|  |  |  |  |  |  |  |  |  |
| shift | shift | 2023-01-01T20:57:22.2318127Z | 123 | TRUE | GET | nextpagelinktouseis123 | 5000 | v1 