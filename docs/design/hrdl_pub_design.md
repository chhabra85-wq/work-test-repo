# HRDL Publishing
## Design
### Overview
---
The purpose of the HRDL Publishing Synapse Pipeline is to transfer HR data from WorkForce Software (**WFS**) into the HR DataLake (**HRDL**) store in a unified schema for dependencies to consume. The Synapse pipeline ingests data via WFS' APIs & SFTPs, transforms/validates the data & publishes the data into the HRDL store.

### Architecture
---
Azure Synapse Analytics is used for all facets of the ETL processes. The orchestration of the ETL is handled by Synapse ADF Pipelines. Activities triggered by the ADF Pipelines include / not limited to: PySpark Notebook executions, Copy Jobs & LookUps.

The Synapse Pipelines can be broken down into 2 categories given the data sources: **API & SFTP**.

#### WFS API Walkthrough
---
WFS supports a series of APIs, [WFS Swagger](https://docs.integration.wfs.cloud/), which provide data for different types of HR Entities. 

The system leverages PySpark Notebooks to call these APIs, validate / transform & finally produce a dataset for dependencies to consume. The publishing of the final output is handled by pipeline Copy activities into the HRDL store.

![synapse_pipeline_orch_api](images\synapse_pipeline_orch_api.png)

Details of each phase of the WFS API ETL process:
- [Synapse Pipeline Orchestrator for APIs](wfs_api\api_pipeline_orchestrator.md)
- [Bronze / Ingestion PySpark Notebook](wfs_api\api_ingestion_notebook.md)
- [Silver / Transformation PySpark Notebook](wfs_api\api_transformation_notebook.md)
- [Gold / Publishing PySpark Notebook](wfs_api\api_publishing_notebook.md)
  
#### WFS SFTP Walkthrough
---
WFS supports SFTP for HR Entities not present in the WFS APIs / requiring specialized formatting.

The system leverages Synapse pipeline Copy activities to copy files via SFTP into the HRDL store.

![Synapse Pipeline Orchestrator for SFTP](images\synapse_pipeline_orch_sftp.png)

Details of the SFTP into HRDL store:
- [Synapse Pipeline Orchestrator for SFTP](wfs_metadata\metadata_orchestrator.md)

### Related Technologies
---

- [WFS APIs](https://docs.integration.wfs.cloud/)
- [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is)
- [Azure Synapse Pipelines](https://learn.microsoft.com/en-us/azure/synapse-analytics/get-started-pipelines)
- [Azure Storage Tables](https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-overview)
- [Azure Application Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview?tabs=net)
- [PySpark](https://spark.apache.org/docs/latest/api/python/)