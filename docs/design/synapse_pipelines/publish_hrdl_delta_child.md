
# Publish_HRDL_Delta_Child Pipeline Documentation

## Table of Contents

-   [Overview](#overview)
-   [Prerequisites](#prerequisites)
-   [Architecture Overview](#architecture-overview)
-   [Data Flow](#data-flow)
-   [Data Targets and Impacts](#data-targets-and-impacts)
-   [Monitoring and Alerting](#monitoring-and-alerting)

## Overview

The  `Publish_HRDL_Delta_Child`  pipeline is a component of the ETL (Extract, Transform, Load) engine that fetches data from various APIs and file exports of WorkForce Software (WFS) and publishes it to HR Data Lake. This pipeline is responsible for publishing the delta entities to HR Data Lake after they have been processed and transformed in the previous stages of the ETL process.

## Prerequisites

Before running the  `Publish_HRDL_Delta_Child`  pipeline, the following prerequisites must be met:

-   The  `Get Delta Entities in Queue`  activity in the parent pipeline  `Publish_HRDL_Entities_Parent`  must be successfully executed and provide the delta entities to be published.
-   The necessary permissions and access keys should be set up to access the Azure Table Storage and Azure Blob Storage where the delta entity data is stored.

## Architecture Overview

The  `Publish_HRDL_Delta_Child`  pipeline follows a modular and scalable architecture, designed to publish the delta entities to HR Data Lake. It consists of the following key components:

1.  **Get Delta Entities in Queue**: This activity makes a call to the Azure Table Storage  `HRDLDeltaFileQueue`  to retrieve the delta entity data that needs to be published. It filters the entities based on the  `IsPublished`  flag being false.
    
2.  **Publish each Delta Entity**: This activity iterates through the retrieved delta entities and publishes the entity data to HR Data Lake. It performs the following steps for each delta entity:
    
    -   **Set SourceDataPath**: Sets the  `SourceDataPath`  parameter from the column  `DataPath`  in the delta entity.
    -   **Publish delta Entity**: Publishes the latest data of the delta entity into HR Data Lake. It copies the entity's parquet file from Cartier Storage to HR Data Lake using Azure BlobFS. The data is stored in Parquet format.

## Data Flow

The  `Publish_HRDL_Delta_Child`  pipeline follows the following data flow:

1.  The  `Get Delta Entities in Queue`  activity retrieves the delta entity data from the Azure Table Storage  `HRDLDeltaFileQueue`. It filters the entities based on the  `IsPublished`  flag being false.
    
2.  The retrieved delta entities are then passed to the  `Publish each Delta Entity`  activity, where each delta entity is processed individually.
    
3.  For each delta entity, the  `Set SourceDataPath`  activity sets the  `SourceDataPath`  parameter using the  `DataPath`  column in the delta entity.
    
4.  The  `Publish delta Entity`  activity publishes the latest data of the delta entity to HR Data Lake. It copies the entity's parquet file from Cartier Storage to HR Data Lake using Azure BlobFS. The data is stored in Parquet format.
    
5.  The published delta entities are now available in HR Data Lake for further processing and analysis.
    

## Data Targets and Impacts

The  `Publish_HRDL_Delta_Child`  pipeline has the following data targets and impacts:

**Data Targets (Sinks):**

-   **HR Data Lake**: The final destination of the delta entity data is HR Data Lake. The data is stored in Parquet format in the HR Data Lake storage account.

**Data Formats:**

-   Parquet: The delta entity data is stored in Parquet format, which is a columnar storage file format optimized for big data processing.

**Pipeline Impacts:**

-   HR DataLake Accessibility: Once stored in HR Data Lake, the delta entity data becomes accessible for other pipelines and analytics processes.
-   Alerting and Monitoring: Data failures trigger ICM tickets, affecting monitoring results and incident response.

## Monitoring and Alerting

The  `Publish_HRDL_Delta_Child`  pipeline is monitored and alerts are handled in the following ways:

-   **Monitoring:**  The pipeline execution and activity runs can be monitored in the Synapse Analytics workspace. The status, duration, and output of each activity can be reviewed to ensure successful execution.
    
-   **Alerting:**  Failures or issues in the  `Publish_HRDL_Delta_Child`  pipeline can trigger alerts through the integrated monitoring system. These alerts can be configured to notify the appropriate stakeholders, such as the development team or support personnel, to take appropriate actions.
    

**Note:**  Detailed monitoring and alerting configurations may vary based on the specific implementation and monitoring requirements of the system.

## Conclusion

The  `Publish_HRDL_Delta_Child`  pipeline plays a crucial role in the ETL engine's data flow by publishing the delta entity data to HR Data Lake. It follows a modular and scalable architecture, ensuring that only the required and high-quality data is published. The pipeline's data targets and impacts are carefully managed to ensure the data is accessible and reliable for downstream processes. Monitoring and alerting mechanisms provide visibility into the pipeline's execution and enable timely response to any issues or failures.