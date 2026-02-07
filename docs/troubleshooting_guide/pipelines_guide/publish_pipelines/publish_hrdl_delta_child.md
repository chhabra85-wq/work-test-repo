# Troubleshooting Guide: Publish_HRDL_Delta_Child Pipeline

This guide will help you diagnose and resolve common failure conditions in the `Publish_WFS_Full_Data_Parent` pipeline and its nested pipelines. 
Follow the steps below to troubleshoot and fix the problems. `Publish_WFS_Full_Data_Parent` is scheduled to run every 12 hours, with JobType parameter value of "Full".
**Please use this guide as a starting point and adapt the steps based on your specific situation, and update the guide if needed.**

## Table of Contents

- [Issue: Failures at "Get Delta Entities in Queue" activity](#issue-failures-at-get-delta-entities-in-queue-activity)
- [Issue: Failures at any "Set Variable" activity](#issue-failures-at-any-set-variable-activity)

## Issue: Failures at Get Delta Entities in Queue activity
<details><summary>Expand here for details</summary>

### Symptoms

- Error messages or failures occuring from the LookUp activity "Get Delta Entities in Queue".

### Possible Causes

1. Authentication issues such as incorrect or expired access keys.
2. Connection problems to the `HRDLDeltaFileQueue` Azure Storage table.
3. Missing entities within the `HRDLDeltaFileQueue` Azure Storage table.

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

### Recovering from failure
- If needed, re-run the `Publish_HRDL_Delta_Child` pipeline and ensure that the pipeline is run successfully.

### Workarounds (if any)
- Consider using tools like Azure Storage Explorer to manually fetch data while the main issue is being resolved.

</details>

## Issue: Failures at any "Set Variable" activity
<details><summary>Expand here for details</summary>

### Symptoms

- Error messages or failures occuring from any of the Set Variable activity.

### Possible Causes

1. Missing entities within the `HRDLDeltaFileQueue` Azure Storage table.

### Troubleshooting Steps

#### For Cause 1: Authentication Issues

1. Preview data from the LookUp activity to verify that the required entities are present.
2. Access the Azure Storage table directly and verify if the required entities are present.
3. Check if any filters applied during the lookup are excluding required entities.

### Recovering from failure
- If needed, re-run the `Publish_HRDL_Delta_Child` pipeline and ensure that the pipeline is run successfully.

### Workarounds (if any)

</details>

