
# Publish_HRDL_Clean_Up Pipeline

## Table of Contents

-   [Overview](#overview)
-   [Prerequisites](#prerequisites)
-   [Architecture Overview](#architecture-overview)
-   [Data Flow](#data-flow)
-   [Data Targets and Impacts](#data-targets-and-impacts)
-   [Monitoring and Alerting](#monitoring-and-alerting)

## Overview

The  `Publish_HRDL_Clean_Up`  pipeline is responsible for cleaning up HR Data Lake file folders. It runs on a scheduled basis and deletes files that are older than a specified threshold in hours.

## Prerequisites

To successfully run the  `Publish_HRDL_Clean_Up`  pipeline, the following prerequisites must be met:

-   Access to HR Data Lake storage account.
-   Proper configuration of storage account connection settings in the pipeline.
-   Correct configuration of the  `ThresholdInHours`  parameter to determine the retention period for files.
-   Proper setup of the  `HRDLCleanUpRecords`  Azure Table Storage to track files to be cleaned up.

## Architecture Overview

The  `Publish_HRDL_Clean_Up`  pipeline is part of a larger ecosystem that includes HR Data Lake, Azure Storage, and other data sources. It interacts with the HR Data Lake to delete files that are no longer needed based on the specified retention period.

## Data Flow

The  `Publish_HRDL_Clean_Up`  pipeline follows a simple data flow process:

1.  The pipeline first fetches the records to be deleted from the  `HRDLCleanUpRecords`  Azure Table Storage. These records contain information about the files to be deleted.
2.  It then iterates over each record and deletes the corresponding files from HR Data Lake. This is done using the "Delete files older than threshold" activity, which identifies the files based on the file path and deletes them.
3.  After deleting the files, the pipeline marks the corresponding record as deleted in the  `HRDLCleanUpRecords`  table using the "Mark Entry as deleted" activity.

## Data Targets and Impacts

The  `Publish_HRDL_Clean_Up`  pipeline primarily targets HR Data Lake and the  `HRDLCleanUpRecords`  table storage. The impacts of this pipeline are as follows:

-   HR Data Lake: The pipeline deletes files from HR Data Lake that are older than the specified threshold. This helps in managing storage space and keeping the data lake clean.
-   `HRDLCleanUpRecords`  Table Storage: The pipeline updates the records in this table to mark them as deleted, ensuring that they are not processed again in the future.

## Monitoring and Alerting

The  `Publish_HRDL_Clean_Up`  pipeline is monitored and alerts are generated in case of failures or issues. The pipeline is part of an overall monitoring system that tracks the execution status and health of the pipeline. Any failures or issues are reported through alerts, allowing for timely investigation and resolution.