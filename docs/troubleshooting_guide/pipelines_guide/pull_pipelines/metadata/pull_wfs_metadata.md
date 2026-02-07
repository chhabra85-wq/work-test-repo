# Troubleshooting Guide: Metadata pipeline

This guide will help you diagnose and resolve common failure conditions in Metadata pipeline. Follow the steps below to troubleshoot and fix the problems.
Remember that troubleshooting can sometimes be complex, and these steps might not cover every possible scenario. Use this guide as a starting point and adapt the steps based on your specific situation.

## List of known incidents

## Table of Contents

1. [Troubleshooting Missing Metadata File Alerts](#troubleshooting-missing-metadata-file-alerts)

2. [Troubleshooting Failures Within Metadata Pipelines](#troubleshooting-failures-within-metadata-pipelines)

3. [Troubleshooting Record Count in Metadata File Is Below threshold](#troubleshooting-record-count-in-metadata-file-is-below-threshold)

## Troubleshooting Missing Metadata File Alerts
<details><summary>Expand here for details</summary>

### Symptoms

ICM ticket for this issue is populated with the name like "Synapse Analytics pipeline failure: Pull_Wfs_Metadata_Parent in @{pipeline().DataFactory} failed" from the `Pull_Wfs_Metadata_Child` pipeline run.
The `Pull_Wfs_Metadata_Parent` pipeline might still show as successfully executed. This means other files are processed as expected, but specific metadata files from WFS are absent.

### Possible Causes

The three Metadata pipelines, including `Pull_Wfs_Metadata_Parent`, `Pull_Wfs_Metadata_Child` and `Pull_Wfs_Metadata_Inner_Child`, are designed to expect four files from WFS SFTP location daily: BANK_policy_info_export.csv, PAY_CODE_policy_info_export.csv, TOR_ABSENCE_TYPE_policy_info_export.csv, and bank_balance_export.csv
If engineer receives such ICM ticket, it indicates that there are one or more missing metadata files from WFS SFTP location on that date.

### Impact

- When the four expected files are not present in the SFTP location daily, the newest data in those files therefore will not be updated in our Cartier blob storage, hence result in stale data on HR Datalake.
- Any new paytypes added on WFS since the last publication time will not be available to consumers. Time/time-off records of those paytypes will be pushed to invalid records parquet file and will not get published to TR01 entities.

### Troubleshooting Steps

1. **Step 1:** Follow the instruction inside the ICM ticket. Contact WFS side about the incident and ask them to drop the missing file(s) into the SFTP location.

<!-- Include all relevant troubleshooting steps -->

### Recovering from failure

1. Directly access the WFS SFTP location to verify the presence of the missing metadata files by follow instruction [here](../wfs_sftp_connection/wfs_sftp_connection.md) - you can also view files in SFTP location from "WfsSftp" dataset .
2. Once all the expected files have been confirmed to be in the SFTP location, run a new instance using Debug option of this pipeline - once DRI confirms that this file exist in SFTP location. The Debug option will expect parameter of an array with file names. Pass in the name of the file(s) like this: ["TOR_ABSENCE_TYPE_policy_info_export.csv","bank_balance_export.csv"]. 
- **Note:** If DRI re-run this pipeline without pass in parameter for the expected file(s), this pipeline will try to get four original files, and will trigger Icm tickets for any missing file.
3. After re-running the pipeline, monitor the pipeline's status to ensure it completes successfully.
4. If the re-run get less than four files, a new ICM ticket will get created. In this case just link that new ICM ticket to the existed one and mitigate them.
5. Verify the file output in the Cartier blob storage at "gold" layer. The location of the file should be in "user/trusted-service-user/gold/TR01/<replace with file name>/Full/<date time of pipeline run>/D_<replace with file name>_<date time of pipeline run>.snappy.parquet". If the file is "PAY_CODE_policy_info_export.csv", besides the mentioned "gold" layer location, also verify its output at `PayCodeMetadata` table storage.

### Workarounds (if any)
No workarounds
</details>

## Troubleshooting Failures Within Metadata Pipelines

<details><summary>Expand here for details</summary>

### Symptoms

ICM ticket for this issue is populated with title like "Synapse Analytics pipeline failure: Pull_Wfs_Metadata_Parent in @{pipeline().DataFactory} failed" from the `Pull_Wfs_Metadata_Parent` pipeline.

### Possible Causes

Here are few potential reasons for pipeline's failure:
- The pipeline might not be able to access SFTP location
- Authorization issues
- The pipeline might have encountered unexpected data formats or values that it couldn't process.
- The pipeline relies on WFS services which were unavailable or failed during execution.
- The failure might have come from Publish_HRDL_Entities_Parent pipeline.

### Impact

- When the four expected files are not present in the SFTP location daily, the newest data in those files therefore will not be updated in our Cartier blob storage, hence result in stale data on HR Datalake.
- Any new paytypes added on WFS since the last publication time will not be available to consumers. Time/time-off records of those paytypes will be pushed to invalid records parquet file and will not get published to TR01 entities.

### Troubleshooting Steps

1. **Step 1:** Follow the ICM instructions if there are any.
   - Read the exception message.
   - Get the pipeline name and run ID.

2. **Step 2:** Go to Synapse workspace and find the pipeline that caused the failure.
   - Engineer can find the failed pipeline under Monitor -> Trigger runs,  and then set the Status filter to "Failed"
   - Begin to trouble-shoot and debug the find the source of failure on the error message. It will usually point to the specific pipeline or activity that encountered the issue.
   - After finding the source of failure, which should happen at any activity in the pipeline, take the actions to address it.
   - Engineer can also test and debug a single activity before trying to re-run the pipeline.

<!-- Include all relevant troubleshooting steps -->

### Recovering from failure

- Re-run the metadata pipeline Pull_Wfs_Metadata_Parent.
- Closely monitor the rerun to capture any anomalies or unexpected behaviors.
- Verify the file output in the Cartier blob storage at "gold" layer. The location of the file should be in "user/trusted-service-user/gold/TR01/<replace with file name>/Full/<date time of pipeline run>/D_<replace with file name>_<date time of pipeline run>.snappy.parquet". If the file is "PAY_CODE_policy_info_export.csv", besides the mentioned "gold" layer location, also verify its output at `PayCodeMetadata` table storage.

### Workarounds (if any)
</details>

## Troubleshooting Record Count in Metadata File Is Below threshold

<details><summary>Expand here for details</summary>

### Symptoms
Automated alerts or routine checks indicate that the record count in a metadata file from the WFS SFTP location does not meet the predefined threshold or varies significantly from the previous file count.

### Possible Causes
A discrepancy in the record count can occur due to incomplete file transfer, file corruption, or an issue with the data source at WFS that generates the metadata files.

### Impact

- If the count is significantly lower than expected, this may lead to a lack of critical updates to the HR Datalake, and may result in incomplete data being processed and stored, which could affect downstream consumers.
- Processing a file with a significant discrepancy in record count without confirmation from WFS can introduce errors into the system, hence the process is blocked until verification from WFS is received, which leads to delays and the risk of data becoming stale.

### Troubleshooting Steps

1. Step 1: Verify the current metadata file count by accessing the WFS SFTP location. Instructions for SFTP access can be found [here](../wfs_sftp_connection/wfs_sftp_connection.md). Or you can also check the latest file in Cartier' `wfs-metadata-archive` blob storage.

2. Step 2: Compare the current file count with the previous file count. Previous file counts can also be found in the `wfs-metadata-archive` blob in storage. Or it can also be found in the `HRDLFilePublishDetails` table by navigate to the file name for PartitionKey, and the last record count will be the value of `LastProcessedRecordCount` column.

3. Step 3: If there is a significant discrepancy, contact the WFS team to verify if the provided file count is legitimate.

4. Step 4: Upon confirmation from WFS that the file count is accurate: Update the record count in the Details table to match the new count. Continue with step 6.

5. Step 5: If the file count is confirmed to be incorrect by WFS: Request that WFS send the correct file via the SFTP location. Once the correct file is received, continue with step 6.

6. Step 6: Once all the expected files have been confirmed to have correct record counts, run a new instance using Debug option of this pipeline - after DRI confirms that this file exist in SFTP location. The Debug option will expect parameter of an array with file names. Pass in the name of the file(s) like this: ["TOR_ABSENCE_TYPE_policy_info_export.csv","bank_balance_export.csv"]. 
- **Note:** If DRI re-run this pipeline without pass in parameter for the expected file(s), this pipeline will try to get four original files, and will trigger Icm tickets for any missing file.

### Recovering from failure

1. Check the Cartier blob storage for correct file ingestion.

2. Document the incident and the resolution steps taken for future reference and to improve the troubleshooting process.

### Workarounds (if any)
If a timely resolution from WFS is not feasible and the data is critically needed, consider using the last known good dataset while the issue is being resolved. This should only be a temporary measure until the accurate data can be processed.

</details>
