
## Table of Contents

1.  [Overview](#overview)
2.  [Prerequisites](#prerequisites)
3.  [Architecture Overview](#architecture-overview)
4.  [Data Flow](#data-flow)
5.  [Data Targets and Impacts](#data-targets-and-impacts)
6.  [Monitoring and Alerting](#monitoring-and-alerting)

## Overview

The  `Publish_HRDL_Full_Child`  pipeline is responsible for publishing full entity data to the HR Data Lake (HRDL). It is a child pipeline that is called by the parent pipeline  `Publish_HRDL_Entities_Parent`. The pipeline iterates through the full entities that are ready to be published and copies the latest data files to HRDL, along with generating a handshake file. It also updates the  `HRDLFilePublishDetails`  table storage to track the published entities.

## Prerequisites

Before running the  `Publish_HRDL_Full_Child`  pipeline, ensure that the following prerequisites are met:

-   The required full entity data is available for publishing.
-   The  `HRDLFilePublishDetails`  table storage is set up and accessible.
-   The  `CartierDatalakeParquet`  dataset is properly configured for reading the data files.
-   The  `HRDLParquet`  dataset is properly configured for writing the data files to HRDL.
-   The necessary permissions and credentials are set up for accessing the required external systems.

## Architecture Overview

The  `Publish_HRDL_Full_Child`  pipeline follows a simple architecture. It leverages Azure Synapse to orchestrate the data movement and transformation tasks. It interacts with the following external systems and components:

-   `HRDLFilePublishDetails`  Table Storage: This storage is used to track the published entities and store the latest source data path and handshake path for each entity.
-   `CartierDatalakeParquet`  Dataset: This dataset represents the source data in Azure Blob Storage (Cartier Blob Storage). It is used to read the latest data files for each entity.
-   `HRDLParquet`  Dataset: This dataset represents the target data in HR Data Lake. It is used to write the data files for each entity.
-   Handshake File: For each entity, a handshake file is generated and published along with the data file. The handshake file represents the timestamp of the publication.

## Data Flow

The  `Publish_HRDL_Full_Child`  pipeline follows a sequential data flow process. The main steps involved in the data flow are as follows:

1.  Get Full Entities for Publishing: This step retrieves the list of full entity data that is ready to be published. It queries the  `HRDLFilePublishDetails`  table storage to filter the entities based on the  `IsPublished`  flag and the  `RowKey`  value.
2.  Publish each Full Entity: This step iterates through the list of full entities and performs the following tasks for each entity:
    -   Set SourceDataPath: This task sets the source data path parameter by extracting the latest source data path from the entity details.
    -   Publish Full Entity: This task copies the latest data file from the source path to HRDL using the  `CartierDatalakeParquet`  and  `HRDLParquet`  datasets. It also generates a handshake file representing the timestamp of the publication.
    -   Update HRDLFilePublishDetails: This task updates the  `HRDLFilePublishDetails`  table storage with the latest destination path and sets the  `IsPublished`  flag to true for the entity.
3.  Execute HRDL_Clean_Up: This step triggers the  `HRDL_Clean_Up`  pipeline to clean up stale files in HRDL based on the defined retention period.

## Data Targets and Impacts

The  `Publish_HRDL_Full_Child`  pipeline has the following data targets:

-   HR Data Lake: The published full entity data is stored in HRDL in the specified folder structure. The data files are in Parquet format and are organized based on the entity and timestamp.
-   HRDLFilePublishDetails Table Storage: This table storage is updated with the latest destination path and publication status for each entity.
-   Handshake Files: The handshake files are published alongside the data files in HRDL. They represent the timestamp of the publication.

The impacts of the pipeline include:

-   HR Data Lake Accessibility: The published full entity data becomes accessible for other pipelines and processes in the HR Data Lake.
-   Data Traceability: The  `HRDLFilePublishDetails`  table storage provides traceability for the published entities and their respective paths.
-   Monitoring and Alerting: Data failures in the pipeline trigger ICM tickets and affect monitoring results and incident response.

## Monitoring and Alerting

The  `Publish_HRDL_Full_Child`  pipeline is monitored and alerts are handled in the following ways:

-   Monitoring: The pipeline execution and status can be monitored through Azure Synapse's monitoring interface. It provides visibility into the pipeline's execution, activity status, and data flow.
-   Alerting: Data failures in the pipeline trigger ICM tickets, which are used for incident management and resolution. The pipeline failure alerts are sent to the appropriate teams for investigation and remediation.

**Note:**  This documentation provides a high-level overview of the  `Publish_HRDL_Full_Child`  pipeline. For more detailed information, including pipeline designs and configurations, please refer to the Synapse Analytics workspace and related documentation.