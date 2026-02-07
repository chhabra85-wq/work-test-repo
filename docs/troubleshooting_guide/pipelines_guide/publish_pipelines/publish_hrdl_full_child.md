# Troubleshooting Guide: Publish_HRDL_Full_Child Pipeline

This guide will help you diagnose and resolve common failure conditions in the `Publish_HRDL_Full_Child` pipeline and its nested pipelines. 
Follow the steps below to troubleshoot and fix the problems. `Publish_HRDL_Full_Child` is scheduled to run every 12 hours, with JobType parameter value of "Full".
**Please use this guide as a starting point and adapt the steps based on your specific situation, and update the guide if needed.**

## Table of Contents

- [Issue: Failures at "Get Full Entities for Publishing" activity](#issue-failures-at-get-full-entities-for-publishing-activity)
- [Issue: Failure in "Publish full Entity" Activity](#issue-failure-in-publish-full-entity-activity)
- [Issue: Failure in "Publish full Handshake" Activity](#issue-failure-in-publish-full-handshake-activity)
- [Issue: Failure in "Update HRDLFilePublishDetails" Activity](#issue-failure-in-update-hrdlfilepublishdetails-activity)
- [Issue: Failure in "Execute HRDL_Clean_Up" Activity](#issue-failure-in-execute-hrdl_clean_up-activity)

## Issue: Failures at "Get Full Entities for Publishing" activity
<details><summary>Expand here for details</summary>

### Symptoms

- Error messages or failures occuring from the LookUp activity "Get Full Entities for Publishing".

### Possible Causes

1. Authentication issues such as incorrect or expired access keys.
2. Connection problems to the `HRDLFilePublishDetails` Azure Storage table.
3. Missing entities within the `HRDLFilePublishDetails` Azure Storage table.
4. The `FileType` parameter does not exist or is misconfigured.

### Troubleshooting Steps

#### For Cause 1: Authentication Issues

1. Validate that the provided connection string or access keys are current and correct.
2. Ensure the Synapse pipeline's managed identity has the necessary permissions to read from the Azure Storage table.

#### For Cause 2: Connection Problems

1. Verify network connectivity to Cartier Azure Storage. 
2. Confirm that the storage account URL and table name are correct.

#### For Cause 3: Missing Entities

1. Preview data from the LookUp activity to verify that the required entities are present.
2. Access the Azure Storage table directly and verify if the required entities are present.
3. Check if any filters applied during the lookup are excluding required entities.

#### For Cause 4: Non-existent FileType Parameter

1. Review the pipeline's configuration to ensure that the `FileType` parameter is correctly set.
2. Validate that the value provided for the `FileType` parameter exists and is expected in the context of the LookUp activity.

### Recovering from failure
- If needed, re-run the `Publish_WFS_Full_Data_Parent` parent pipeline and ensure that the pipeline is run successfully.

### Workarounds (if any)
- Consider using tools like Azure Storage Explorer to manually fetch data while the main issue is being resolved.

</details>

## Issue: Failure in "Publish full Entity" Activity
<details><summary>Expand here for details</summary>

### Symptoms

- Error messages or failures coming from the "Publish Full Entity" activity.

### Possible Causes

1. Connection or permission issues with the source or sink (HRDL) Azure Blob storage.
2. Incorrect path or filename in `CartierDatalakeParquet` or `HRDLParquet` datasets due to misconfigured variables or expressions.
3. Data type conversion issues when transferring data.
4. Problems with the Parquet format settings for either the source or sink (HRDL).

### Troubleshooting Steps
Review the error message carefully to find out the root cause and follow these steps:
#### For Cause 1: Connection or Permission Issues
1. Verify that the Synapse pipeline has access to both the source and sink storage accounts.
2. Ensure that the connection information, like access keys or connection strings, are correctly set.
3. Check for potential issues in the Azure Blob storage (e.g., outages, permission changes).

#### For Cause 2: Path or Filename Misconfigurations

1. Evaluate the variables used for generating paths and filenames, like `SourceLatestSourceDataPath` and `PublishDataPath`.
2. Ensure that the expressions provided for generating paths, like `@variables('SourceLatestSourceDataPath')`, are returning the expected results.

#### For Cause 3: Data Type Conversion Issues

1. Review the data convertion to ensure that the data types are compatible with the HRDL data model.

#### For Cause 4: Parquet Format Issues

1. Check the configuration of both `ParquetSource` and `ParquetSink` settings. Ensure that the respective read and write settings are compatible with your Parquet data and its structure.

### Recovering from Failure

- After identifying and resolving the root cause, re-run the `Publish_WFS_Full_Data_Parent` pipeline. Ensure that dependent activities run successfully before "Publish full Entity" starts.

### Workarounds

- Consider manually verifying data structures, paths, and storage accounts. Directly access Azure Blob storage using tools like Azure Storage Explorer to further diagnose storage-related issues.

</details>

## Issue: Failure in "Publish full Handshake" Activity
<details><summary>Expand here for details</summary>

### Symptoms

- Error messages or failures stemming from the "Publish full Handshake" activity.

### Possible Causes

1. Dependency failures: The activity depends on the successful completion of the `Publish full Entity` activity.
2. Incorrect path or filename in `CartierDatalakeParquet` dataset or `HRDLParquet` outputs due to misconfigured variables or expressions, particularly related to handshakes.
3. Data type conversion issues during the copying process.
4. Problems with the Parquet format settings for either the source or sink.
5. Connection or permission issues with the source or sink Azure Blob storage.

### Troubleshooting Steps

#### For Cause 1: Dependency Failures

1. Check the status of the `Publish full Entity` activity. Resolve any issues with that activity first, as it's a prerequisite for "Publish full Handshake".

#### For Cause 2: Path or Filename Misconfigurations

1. Validate the variable used for handshake paths, `SourceLatestHandshakePath` and `PublishHandShakePath`.
2. Ensure the expressions provided for paths, such as `@variables('SourceLatestHandshakePath')`, are generating the expected results.

#### For Cause 3: Data Type Conversion Issues

1. Examine the `translator` configuration. Verify that the type conversion settings, like `allowDataTruncation`, are suited for the data you're working with.

#### For Cause 4: Parquet Format Issues

1. Inspect the settings for both `ParquetSource` and `ParquetSink`. Confirm that the read and write settings align with the structure of your Parquet data.

#### For Cause 5: Connection or Permission Issues

1. Double-check that the Synapse pipeline has the necessary permissions to access both the source and sink storage accounts.
2. Validate that connection details, such as access keys or connection strings, are correctly provided.
3. Look for possible disruptions in the Azure Blob storage (e.g., outages, permission modifications).

### Recovering from Failure

- After determining and addressing the root cause, re-run the pipeline. Make sure that the prerequisite `Publish full Entity` activity executes successfully before starting "Publish full Handshake".

### Workarounds

- Manually verify data structures, paths, and storage accounts. Access Azure Blob storage directly using tools like Azure Storage Explorer for a deeper diagnosis of storage-linked issues.

</details>

## Issue: Failure in "Update HRDLFilePublishDetails" Activity
<details><summary>Expand here for details</summary>

### Symptoms

- Errors or failures coming from the "Update HRDLFilePublishDetails" activity.

### Possible Causes

1. Table storage issues (e.g., quota exceeded, service outages).
2. Misconfigured or unreachable Azure Table Storage URL.
3. Authentication failures due to Managed Service Identity (MSI) issues.
4. Incorrect request body structure or variables.

### Troubleshooting Steps
#### For Cause 1: Table Storage Issues

1. Check Azure's status page or the Azure portal for any ongoing service issues related to Azure Table Storage.
2. Confirm that the table, `HRDLFilePublishDetails`, exists and is accessible.

#### For Cause 2: Misconfigured or Unreachable URL

1. Validate the URL structure, especially the `PartitionKey` and `RowKey` values from the variables and parameters.
2. Test the URL manually using a tool like Postman or via a browser to ensure it's accessible.

#### For Cause 3: MSI Authentication Failures

1. Confirm the Managed Service Identity (MSI) is correctly set up and has the required permissions to update the Azure Table Storage.
2. Check the specified authentication resource `https://storage.azure.com/` to ensure it's correct for Azure Table Storage operations.

#### For Cause 4: Incorrect Request Body or Variables

1. Inspect the request body structure and ensure it aligns with the requirements for updating the Azure Table.
2. Validate the variables used in the body like `PublishDataPath` and `PublishHandShakePath`.


### Recovering from Failure

- After determining and rectifying the root cause, re-run the pipeline, ensuring that the prerequisite `Publish full Handshake` activity executes successfully before starting "Update HRDLFilePublishDetails".

### Workarounds

- Manually update the table using Azure Storage Explorer or other tools if there's an urgent need to reflect changes and the activity is still failing.
- Use tools like Postman to simulate the PATCH request and identify any issues with the request structure or headers.

</details>

## Issue: Failure in "Execute HRDL_Clean_Up" Activity
<details><summary>Expand here for details</summary>

### Symptoms

- Errors or failures originating from the "Execute HRDL_Clean_Up" activity.

### Possible Causes

1. Dependency failures: This activity is dependent on the successful completion of the "Update HRDLFilePublishDetails" activity.
2. Issues in the triggered pipeline ("Pubish_HRDL_Clean_Up").
3. Incorrect parameters passed to the triggered pipeline.

### Troubleshooting Steps

#### For Cause 1: Dependency Failures

1. Check the status of the "Update HRDLFilePublishDetails" activity. If there are issues with this activity, they need to be addressed first as it's a prerequisite for "Execute HRDL_Clean_Up".

#### For Cause 2: Issues in the Triggered Pipeline

1. If the "Execute HRDL_Clean_Up" activity failed due to issues in the "Pubish_HRDL_Clean_Up" pipeline, refer to the [TSG for the "Pubish_HRDL_Clean_Up" pipeline](publish_hrdl_clean_up.md) for detailed troubleshooting steps.
2. Ensure that the "Pubish_HRDL_Clean_Up" pipeline is active and not in a disabled state.

#### For Cause 3: Incorrect Parameters

1. Validate the parameters being passed to the "Pubish_HRDL_Clean_Up" pipeline, especially `HRDLFolderPath`, `ExecutionTime`, and `ThresholdInHours`.
2. Check for any syntax errors or unexpected values in the expressions used for the parameters.

### Recovering from Failure

- Once the root cause has been identified and fixed, re-run the pipeline, ensuring the "Update HRDLFilePublishDetails" activity runs successfully before starting "Execute HRDL_Clean_Up".

### Workarounds

- If needed, manually trigger the "Pubish_HRDL_Clean_Up" pipeline from the Synapse Studio with the appropriate parameters.

</details>
