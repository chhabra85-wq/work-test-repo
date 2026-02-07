# Troubleshooting Guide: Pubish_HRDL_Clean_Up Pipeline

This guide will help you diagnose and resolve common failure conditions in the `Pubish_HRDL_Clean_Up` pipeline. 
Follow the steps below to troubleshoot and fix the problems.
Remember that troubleshooting can sometimes be complex, and these steps might not cover every possible scenario. Use this guide as a starting point and adapt the steps based on your specific situation.

**Please use this guide as a starting point and adapt the steps based on your specific situation, and update the guide if needed.**

## Table of Contents

- [Issue: Failure at Get Full Entities for Publishing activity](#failure-at-get-entities-for-publishing-activity)
- [Issue: Failure at Delete Each folder older than threshold activity](#failure-at-delete-each-folder-older-than-threashold-activity)
- [Issue: Failure at Mark Entry as deleted activity](#failure-at-mark-entry-as-deleted-activity)
- [Issue: Failure at Execute HRDL_Clean_Up activity](#failure-at-execute-hrdl-clean-up-activity)

---
## Issue: Failure at Get Full Entities for Publishing activity

### Symptoms

-   Failure happens at the  `Get Full Entities for Publishing`  activity.

### Possible Causes

-   Authentication issues such as incorrect or expired access keys.
-   Connection problems to the  `HRDLFilePublishDetails`  Azure Storage table.
-   Missing entities within the  `HRDLFilePublishDetails`  Azure Storage table.
-   The  `FileType`  parameter does not exist or is misconfigured.

### Troubleshooting Steps

#### For Cause 1: Authentication Issues

1.  Validate that the provided connection string or access keys are current and correct.
2.  Ensure the Synapse pipeline's managed identity has the necessary permissions to read from the Azure Storage table.

#### For Cause 2: Connection Problems

1.  Verify network connectivity to Cartier Azure Storage.
2.  Confirm that the storage account URL and table name are correct.

#### For Cause 3: Missing Entities

1.  Preview data from the  `Lookup`  activity to verify that the required entities are present.
2.  Access the Azure Storage table directly and verify if the required entities are present.
3.  Check if any filters applied during the lookup are excluding required entities.

#### For Cause 4: Non-existent FileType Parameter

1.  Review the pipeline's configuration to ensure that the  `FileType`  parameter is correctly set.
2.  Validate that the value provided for the  `FileType`  parameter exists and is expected in the context of the  `Lookup`  activity.

### Recovering from failure

-   Correct the issue and re-run the pipeline.

### Workarounds (if any)

-   Consider using tools like Azure Storage Explorer to manually fetch data while the main issue is being resolved.
---
## Issue: Failure at Delete Each folder older than threshold activity

### Symptoms

-   Failure happens at the  `Delete Each folder older than threshold`  activity.

### Possible Causes

-   The pipeline is unable to delete the folders older than the threshold.
-   The folders may not exist or there could be permission issues.

### Troubleshooting Steps

#### 1. Read the error message from the activity

-   Fix the issue based on the error message.
-   If the error is related to permission issues, ensure that the pipeline has the necessary permissions to delete the folders.

### Recovering from failure

-   Correct the folder path or resolve permission issues and re-run the pipeline.

### Workarounds (if any)
---
## Issue: Failure at Mark Entry as deleted activity

### Symptoms

-   Failure happens at the  `Mark Entry as deleted`  activity.

### Possible Causes

-   The pipeline is unable to update the  `HRDLCleanUpRecords`  table.
-   There could be permission issues or network connectivity problems.

### Troubleshooting Steps

#### 1. Read the error message from the activity

-   Fix the issue based on the error message.
-   If the error is related to permission issues, ensure that the pipeline has the necessary permissions to update the table.

### Recovering from failure

-   Correct the issue with the table or resolve permission issues and re-run the pipeline.

### Workarounds (if any)
---
## Issue: Failure at Execute HRDL_Clean_Up activity

### Symptoms

-   Failure happens at the  `Execute HRDL_Clean_Up`  activity.

### Possible Causes

-   The  `HRDL_Clean_Up`  pipeline failed to execute.
-   There could be issues with the dependent activities or the pipeline configuration.

### Troubleshooting Steps

#### 1. Read the error message from the activity

-   Fix the issue based on the error message.
-   Check the dependent activities and ensure they are successful.

### Recovering from failure

-   Correct the issue with the  `HRDL_Clean_Up`  pipeline or resolve any dependency issues and re-run the pipeline.

### Workarounds (if any)