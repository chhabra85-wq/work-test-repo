# Troubleshooting Guide: Synapse Pull_WFS_Data_Child Pipeline

This guide will help you diagnose and resolve common failure conditions in Pull_WFS_Data pipelines including `Pull_WFS_Data_Parent` and `Pull_WFS_Data_Child`. Follow the steps below to troubleshoot and fix the problems.
Remember that troubleshooting can sometimes be complex, and these steps might not cover every possible scenario. Use this guide as a starting point and adapt the steps based on your specific situation.

## List of known incidents

## Table of Contents

- [Issue 1: FetchAPIMetadata Failure](#issue-1-fetchapimetadata-failure)
- [Issue 2: Execute Ingestion Notebook Failure](#issue-2-execute-ingestion-notebook-failure)
- [Issue 3: Execute Transformation Notebook Failure](#issue-3-execute-transformation-notebook-failure)
- [Issue 4: Execute Publishing Notebook Failure](#issue-4-execute-publishing-notebook-failure)
- [Issue 5: Publish HRDL Entities Parent Downstream Pipeline Failure](#issue-5-publish-hrdl-entities-parent-downstream-pipeline-failure)


## Issue 1: FetchAPIMetadata Failure
<details><summary>Expand here for details</summary>

### Symptoms 
- Data not being fetched from the Azure Storage Table `ApiMetaData`.
- Failure alerts from ICM function or monitor logs related to the `ApiMetaData` Table data retrieval.

### Possible Causes 
- `ApiMetaData` Table might be inaccessible or facing authentication issues, possibly due to expired or incorrect credentials.
- Misconfiguration in the pipeline's connection settings to `ApiMetaData` Table.
- The `ApiMetaData` Table contains no data.

### Troubleshooting Steps 

1. **Check for Data in `ApiMetaData` Azure Storage Table**
   - Navigate to the Pull_WFS_Data_Child pipeline in the Synapse workspace.
   - Click on the "Preview data" button to view the available datain `ApiMetaData` table. 
   - Unless there was a human action of purging this table, the pipelines or notebooks will not delete the records in this table. In the event of accidental deletion of the table by someone, it warrants a sev-3 bridge. 
   - Way to recover the data: The baseline table is deployed as a part of infrastructure deployment scripts which can be used as a reference to create the two rows required in this table.  The last processed BronzeIndex and NextCursor values have to be fetched from telemetry and updated in those two rows.
   - Consider manually enter the data in the`ApiMetaData` Table directly in corresponding environment's storage account.
   - Example of the `ApiMetaData` Table in Azure Storage Account:
   ![ApiMetaData](../../../design/images/table_storages/ApiMetadata.png)
   - <TODO: Add guide on how to fetch the latest values in this table>

2. **Test the Connection from CartierTableStorage**
   - Find the `CartierTableStorage` linked service from the Lookup FetchAPIMetadata's connection settings, or under Manage > Linked services.
   - Click on the "Test connection" button.
   - If the connection test fails, this indicates a potential authentication or configuration problem.
   - Find the Azure Key Vault resource in Azure Portal from `CartierKeyVault` linked servie. Double-check the authentication credentials set for the `ApiMetaData` Table connection. Ensure they are up-to-date and have the necessary permissions.
   - Review the configuration settings to ensure they match the `ApiMetaData` Table's current setup.
   - If it was an authentication issue, update the credentials in the `CartierTableStorage` linked service connection settings and re-run the pipeline. Test the connections for all other linked services to make sure that they are all up to date.
   - If it was a configuration issue, correct the settings and try fetching the data again.

### Recovering from failure 
- <**TODO:** This is a place holder for pre re-run step. Before re-running the pipeline, ensure to review and complete any prerequisite steps or checks necessary. Update this section with specific actions if needed.>
- Re-run the `Pull_WFS_Data_Parent` parent pipeline and ensure that the pipeline is run successfully.

### Workarounds (if any)

</details>

## Issue 2: Execute Ingestion Notebook Failure

<details><summary>Expand here for details</summary>

### Symptoms 

- The `Pull_WFS_Data_Child` pipeline run fails, with the root cause pointing to the `ingest_runners_data_to_storage` notebook execution.

### Possible Causes 

- There could be code errors or exceptions thrown within the notebook.
- Data dependencies or sources that the notebook relies on might be unavailable or changed.
- Library dependencies in the notebook might be missing or at incorrect versions.

### Troubleshooting Steps 

1. **Diagnose the Ingestion notebook**
- Locate the `ingest_runners_data_to_storage` Ingestion notebook in the Synapse workspace.
- Refer to this [Ingestion TSG](../notebooks_guide/ingest_runners_data_to_storage.md) to resolve notebook's failure.
- Address any identified issues within the notebook.

### Recovering from failure 
- <**TODO:** This is a place holder for pre re-run step. Before re-running the pipeline, ensure to review and complete any prerequisite steps or checks necessary. Update this section with specific actions if needed.>
 - After ensuring the notebook is working correctly, re-run the `Pull_WFS_Data_Parent` parent pipeline and ensure that the pipeline is run successfully.
### Workarounds (if any)

</details>

## Issue 3: Execute Transformation Notebook Failure

<details><summary>Expand here for details</summary>

### Symptoms 

- The `Pull_WFS_Data_Child` pipeline run fails, with the root cause pointing to the `transformation_runner` notebook execution.

### Possible Causes 

- There could be code errors or exceptions thrown within the notebook.
- Data dependencies or sources that the notebook relies on might be unavailable or changed.
- Library dependencies in the notebook might be missing or at incorrect versions.

### Troubleshooting Steps 

1. **Diagnose the Ingestion notebook**
- Locate the `transformation_runner` Transformation notebook in the Synapse workspace.
- Refer to this [Transformation TSG](../notebooks_guide/transformation_runner.md) to resolve notebook's failure.
- Address any identified issues within the notebook.

### Recovering from failure 
- <**TODO:** This is a place holder for pre re-run step. Before re-running the pipeline, ensure to review and complete any prerequisite steps or checks necessary. Update this section with specific actions if needed.>
 - After ensuring the notebook is working correctly, re-run the `Pull_WFS_Data_Parent` parent pipeline and ensure that the pipeline is run successfully.
### Workarounds (if any)

</details>

## Issue 4: Execute Publishing Notebook Failure

<details><summary>Expand here for details</summary>

### Symptoms

- The `Pull_WFS_Data_Child` pipeline run fails, with the root cause pointing to the `publishing_runner` notebook execution.

### Possible Causes

- There could be code errors or exceptions thrown within the notebook.
- Data dependencies or sources that the notebook relies on might be unavailable or changed.
- Library dependencies in the notebook might be missing or at incorrect versions.
### Troubleshooting Steps

1. **Diagnose the Ingestion notebook**
- Locate the `publishing_runner` Publish notebook in the Synapse workspace.
- Refer to this [Publishing TSG](../notebooks_guide/publishing_runner.md) to resolve notebook's failure.
- Address any identified issues within the notebook.

### Recovering from failure
- <**TODO:** This is a place holder for pre re-run step. Before re-running the pipeline, ensure to review and complete any prerequisite steps or checks necessary. Update this section with specific actions if needed.>
 - After ensuring the notebook is working correctly, re-run the `Pull_WFS_Data_Parent` parent pipeline and ensure that the pipeline is run successfully.
### Workarounds (if any)

## Issue 5: Publish HRDL Entities Parent Downstream Pipeline Failure

### Symptoms (Issue 5)
- Failure alerts from ICM function or monitor logs reference an issue in the `Publish_HRDL_Entities_Parent` pipeline. This `Publish_HRDL_Entities_Parent` pipeline is called within this execution path only if 'delta' publishing is enabled by setting publishDeltaToHRDL to 'true' in parent pipeline.

### Possible Causes (Issue 5)
- The `Pull_WFS_Data_Child` pipeline triggers the `Publish_HRDL_Entities_Parent` pipeline at the end if delta publishing is opted for. If there is a failure in this pipeline, it can cause the `Pull_WFS_Data_Child` pipeline to fail as well.

### Troubleshooting Steps (Issue 5)

1. **Step 1: Review the `Publish_HRDL_Entities_Parent` Pipeline**
   - Navigate to the Synapse workspace and locate the `Publish_HRDL_Entities_Parent` pipeline.
   - Access the logs or activity runs to identify any error messages or points of failure.
   - Review the [Publish_HRDL_Entities_Parent TSG](../publish_hrdl_pipelines_guide/publish_hrdl_entities_parent.md) to resolve any issues within the pipeline.
   - After addressing the issues, re-run the `Pull_WFS_Data_Child` pipeline to ensure it runs successfully.
### Recovering from failure (Issue 5)
- Address and correct any identified errors or issues within the `Publish_HRDL_Entities_Parent` pipeline.
- <**TODO:** This is a place holder for pre re-run step. Before re-running the pipeline, ensure to review and complete any prerequisite steps or checks necessary. Update this section with specific actions if needed.>
- After resolving the problems, re-running the `Publish_HRDL_Entities_Parent` pipeline with JobType parameter set to "Delta" to ensure this pipeline executes successfully.

### Workarounds (if any)

</details>
