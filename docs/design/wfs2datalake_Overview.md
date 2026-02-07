# Workforce Software to HR Data Lake - Overview

## Table of Contents
- [Overview](#Overview)
- [Architecture](#Architecture)
- [Key Components](#Key-Components)
    - [Data sources](#Data-sources)
    - [Medallion architecture](#Medallion-architecture)
        - [Bronze layer](#Data-Ingestion-(Bronze-layer))
        - [Silver layer](#Data-transformation-(Silver-layer))
        - [Gold layer](#Data-publication-(Gold-layer))
    - [Notebooks & pipelines](#Pipelines,notebooks)
- [Data flow](#Data-flow)
    - [Data ingestion, transformation and publication](#Data-ingestion,-transformation-and-publication)    
    - [Metadata extraction from WFS file exports](#Metadata-extraction-from-WFS-file-exports)
    - [Publish data to HR Data Lake](#Publish-data-to-HR-Data-Lake)
- [Follow-ups/Additional references](#Follow-ups/Additional-references)

## Overview
This document provides an in-depth explanation of the design and architecture of the ETL (Extract, Transform, Load) engine that fetches data from multiple APIs and file exports of WorkForce Software (WFS), applies the Medallion architecture for filtering, and publishes the resulting "gold" data to HR Data Lake. The purpose of this engine is to streamline the process of ingesting and processing data from APIs and exported files, ensuring data quality and consistency before it is published to HR Data Lake.

## Architecture
The ETL engine follows a modular and scalable architecture that consists of data pipelines and notebooks deployed on Synapse Analytics. The architecture is designed to accommodate changes in data sources, filtering strategies, and data lake destinations, while maintaining reliability and performance. Data from WFS passes through three layers of filters/transformations/validations to prepare the final data entities that are published to HR Data Lake as TR01 data set.

## Key Components
1. **Data sources:** There are two data sources for this engine.
    1. __WFS APIs__ - Streaming data from WFS, where each stream of data is linked to # of retrieved records and the cursor used to identify the batch of data. Common theme is that each record set is indicated by a data change flag that indicates whether that record has to be merged or deleted from persisted data.\
    *As of today, we are calling WFS's calculated-time and shift end points. One provides absence and attendance records, the other provides shift information.*
    1. __WFS file exports__ - Data from WFS that is not exposed through any API call.\
    *Currently includes configuration items such pay codes (absence, attendance, accrual types) and can extend to other items such as holiday calendar.*

2. **Medallion architecture:** This architecture incorporates a filtering mechanism to ensure that only relevant and high-quality data is processed further. It involves multiple stages of data refinement, applying filters at each stage based on specific criteria.\

    - **Data Ingestion (Bronze layer):** In this layer, data is extracted from WFS APIs; it is flattened but otherwise retained in its raw state of data for ease of traceability. This retention provides data traceability of each record that was published out, to specific WFS API cursor that had that record.  This flattened data forms the 'Bronze' data layer.
    
    - **Data Transformation (Silver layer):** In this layer, (copy of) data extracted in Bronze layer goes validations, is transformed basing on the merge/delete indicators, absence/attendance records, and a 'Silver' copy of the data in the form of delta and full files is prepared.

    - **Data Publication (Gold layer):** In this layer, data from Silver layer goes through schema transformation and validation to match with the proposed schema of TR01 entities. Full and Delta files are created into Cartier's Data Lake storage which are then published to HR Data Lake.
3. __Pipelines, notebooks__: The Medallion architecture is put in place through orchestration of pipelines and notebooks in Synapse Analytics. These orchestrated components perform the data actions that are required for each layer all the way through final publication of entities to HR Data Lake.

## Data flow

### Data ingestion, transformation and publication

Triggers defined on Synapse Analytics trigger a parent pipeline which invokes a child pipeline and tracks the successors' completion state. If any of the successor pipelines fail, the parent pipeline triggers an ICM incident.\
Here is the high-level pipeline flow that takes care of data ingestion (Bronze layer), transformation (Silver layer), and publication (Gold layer).\
- __WFS API-Delta Trigger__ is a trigger that is defined to run every 12 hours and it invokes __Pull_WFS_Data_Parent__ pipeline.

- __Pull_WFS_Data_Parent__ calls __Pull_WFS_Data_Child__ pipeline and tracks its completion. It creates an ICM incident if the child pipeline fails.

- __Pull_WFS_Data_Child__ retrieves the APIs that have to be called and then invokes the notebooks in a sequence to ingest, transform and publish the data recieved from APIs. Here are the high-level steps. 
    - Fetch API metadata (name and method of the API, index, cursor to be used next, max.records to be fetched) from table storage. 
        - Run a chain of three notebooks to fetch the data from each API using the metadata that was fetched in previous step.
            - **Bronze layer** - Call *__ingestion__* notebook to retrieve data of the API from the next cursor value, flattened the data to parquet file. The path of the parquet file is stored in APIDataLocation table.\
            Data at this layer is raw data as received through WFS API.
            - **Silver layer** - Call *__transformation__* notebook that retrieves parquet file from Bronze layer, run required transformations, create delta (changes since last full file) and full files (persistent delta tables). The path of the file is stored into APIDataLocation table.\
            Data at this layer is slightly transformed data that was run through the validation engine for identification of anomalies and truncates unnecessary fields from previous layer.
            - **Gold layer** - Call *__publishing__* notebook that picks up silver layer's delta & full files, set them into consumer-friendly schema, and prepare them for publishing into HR Data Lake.\
            Data at layer is the final version of the TR01 entities that are persisted into Cartier's storage. The latest versions of which are published to HR Data Lake, the sequence of which is explained in below section.        
### Metadata extraction from WFS file exports
In general, configuration items in WFS are not exposed through their APIs. For example, there is no API that provides the list of absence, attendance and accrual types or the list of holidays configured on WFS. WFS is exporting pay codes, bank (accrual) & absence types as CSV files into their SFTP location.\

A series of pipelines fetch those metadata files & publish them __gold__ layer and then to HR Data Lake.

Here is the high-level pipeline flow that explains how this metadata is extracted- 
_WFS Metadata Trigger_ runs once a day and it triggers __Pull_WFS_Metadata_Parent__.
- __Pull_WFS_Metadata_Parent__ pipeline calls and tracks the completion of __Pull_Wfs_Metadata_Child__ pipeline.
    - __Pull_Wfs_Metadata_Child__ gets the available files from WFS SFTP, compares the list of files on SFTP against the required files. It then calls __Pull_WFS_Metadata_Inner_Child__ pipeline for each required file. It creates an ICM if there are no required files on SFTP or if they are less than the expected number.
        - __Pull_WFS_Metadata_Inner_Child__ copies the metadata files into the __*gold*__ layer as the final TR01 metadata entities along a single handshake file. The files are then archived into Cartier's archive container.
    -    Upon successful completion of file processing, it invokes __Publish_HRDL_Entities_Parent__ with *metadata* as the parameter value so that this pipeline can publish the metadata entities to HR Data Lake.

### Publish data to HR Data Lake

The previous section describes how the data from the APIs is fetched and is processed to a *gold* state. This section describes how the entities are published to HR Data Lake.\
Similar to other pipeline orchestrations, a parent pipeline triggers a child pipeline which then publishes the entities out to HR Data Lake. Failure of child pipeline(s) are caught by parent and pushed over to ICM. This process has a separate trigger named __WFS API-Full Trigger__ that invokes the __Publish_WFS_Full_Data_Parent__ pipeline to initiate the final publication to HR Data Lake.

Here is the high-level pipeline flow that publishes the entities to HR Data Lake - 
- __Publish_WFS_Full_Data_Parent__ pipeline (scheduled to run twice a day) calls - 
    - __Publish_HRDL_Entities_Parent__ pipeline with 'Full' as the parameter value. 
    
- __Publish_HRDL_Entities_Parent__ accepts either 'Full', 'Delta', or 'Metadata' as parameters and triggers respective pipelines. 
    - 'Full' triggers __Publish_HRDL_Full_Child__ and passes [Full] as parameter.
    - 'Delta' triggers __Publish_HRDL_Delta_Child__ and passes [Delta] as parameter.
    - 'Metadata' triggers __Publish_HRDL_Full_Child__ and passes [Metadata] as the file type parameter.
- __Publish_HRDL_Full_Child__ accepts either 'Full', 'Delta', or 'Metadata' as parameters and triggers respective pipelines.
    - Look up storage table to pull the list of entities (files) that were published by the *gold layer*, from HRDLFilePublishDetails table storage (*IsPublished is false, RowKey is Full or Metadata*)
    - Publish the __*parquet file*__ and associated __*handshake value*__ (timestamp of publication) for each entity that was looked up, by following these steps - 
        - Create the handshake value & determine the path from which to pick up the file from.
        - Copy the entity's parquet file from Cartier storage to HR Data Lake.
        - Update HRDLFilePublishDetails table storage with latest destination path and update IsPublished to true.
        - Run __Publish_HRDL_Clean_Up__ pipeline to clean up stale (out of retention period as determined by the value of ThredholdInHours parameter of that pipeline) files of that entity from HR Data Lake.
- __Publish_HRDL_Delta_Child__ gets the list of delta entities thata are ready to be published, creates a handshake value and publishes (copies) the delta entity to HR Data Lake.
- __Publish_HRDL_Clean_Up__ identifies the paths of files on HR Data Lake for each entity that are older than the identified thresholdhold hours and deletes those files from HR Data Lake. This is a maintenance activity to ensure optimal use of HR Data Lake's storage capacities.

## Follow-ups/Additional references
- Links to ingestion, transformation and publishing notebook designs.\
- Link to deployed Azure components, explanation.\
- Link to Synapse Analytics user branch setup, explanation of GIT integration, and deployment process\
- Link to TR01 schema.\
- Link to HRDL access provisioning process.\