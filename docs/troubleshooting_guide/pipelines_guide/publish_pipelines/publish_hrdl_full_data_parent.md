# Troubleshooting Guide: Publish_WFS_Full_Data_Parent Pipeline

This guide will help you diagnose and resolve common failure conditions in the `Publish_WFS_Full_Data_Parent` pipeline and its nested pipelines. 
Follow the steps below to troubleshoot and fix the problems. `Publish_WFS_Full_Data_Parent` is scheduled to run every 12 hours, with JobType parameter value of "Full".
**Please use this guide as a starting point and adapt the steps based on your specific situation, and update the guide if needed.**

## Table of Contents

- [Issue: Failures from the nested pipeline Publish_HRDL_Entities_Parent](#issue-failures-from-the-nested-pipeline-publish_hrdl_entities_parent)

## Issue: Failures from the nested pipelines

<details><summary>Expand here for details</summary>

### Symptoms

- `Publish_WFS_Full_Data_Parent` failed due to a failure from the `Publish_HRDL_Entities_Parent` pipeline or its nested pipelines.
- An ICM ticket was created for the failure with title "Title: "Synapse Analytics pipeline failure: @{Pipeline} in @{DataFactory} identified a failure".

### Possible Causes

- `Publish_WFS_Full_Data_Parent` pipeline executes `Publish_HRDL_Entities_Parent`, and this pipeline executes other nested pipelines. Any failure from the nested pipelines will cause the `Publish_WFS_Full_Data_Parent` pipeline to fail.

### Troubleshooting Steps

#### 1. Refer to Publish_HRDL_Entities_Parent
- Since the JobType parameter's value for Publish_WFS_Full_Data_Parent is "Full", the child pipeline is `Publish_HRDL_Entities_Parent`. Follow the [Publish_HRDL_Entities_Parent pipeline TSG](publish_hrdl_full_child.md).
- Resolve the child pipeline or nested pipeline's issue.

### Recovering from failure
- If needed, re-run the `Publish_WFS_Full_Data_Parent` parent pipeline and ensure that the pipeline is run successfully.

### Workarounds (if any)

</details>
