# Troubleshooting Guide: Publish_HRDL_Entities_Parent Pipeline

This guide will help you diagnose and resolve common failure conditions in the `Publish_HRDL_Entities_Parent` pipeline and its nested pipelines. 
Follow the steps below to troubleshoot and fix the problems.
**Please use this guide as a starting point and adapt the steps based on your specific situation, and update the guide if needed.**

## Table of Contents

- [Issue: Switch Parameter Value Error](#issue-switch-parameter-value-error)
- [Issue: Failures from the nested pipelines](#issue-failures-from-the-nested-pipelines)

## Issue: Switch Parameter Value Error
<details><summary>Expand here for details</summary>

### Symptoms

- Pipeline fails with a 500 error code.
- An error message stating: "<JobType parameter> is not a valid type. Pipeline only supports "Delta" or "Full" or "Metadata" file types."

### Possible Causes

- The JobType parameter's value provided to the switch in the `Publish_HRDL_Entities_Parent` pipeline is not recognized.
- The expected values of JobType parameter are "Full", "Delta", and "Metadata".

### Troubleshooting Steps

1. **Step 1: Verify Parameter's Value**
- Check the JobType parameter's value provided to the switch in the `Publish_HRDL_Entities_Parent` pipeline. Ensure that it matches one of the recognized values.
- If the value is correct, the failure might come from the referenced pipeline that `Publish_HRDL_Entities_Parent` pipeline called. For each JobType:
- **Full**: check the [Publish_HRDL_Full_Child pipeline](publish_hrdl_full_child.md) .
- **Delta**: check the [Publish_HRDL_Delta_Child pipeline](publish_hrdl_delta_child.md) .
- **Metadata**: check the [Publish_HRDL_Full_Child pipeline](publish_hrdl_full_child.md) .


### Recovering from failure

- Correct the parameter value provided to the switch in the `Publish_HRDL_Entities_Parent` pipeline.
- If there was a misconfiguration, rectify the switch's setup or recognized values list.

### Workarounds (if any)

</details>

## Issue: Failures from the nested pipelines

<details><summary>Expand here for details</summary>

### Symptoms

- Pipelines `Publish_HRDL_Entities_Parent` failed with error failure come from child pipelines.

### Possible Causes

- `Publish_HRDL_Entities_Parent` pipeline executes `Publish_HRDL_Full_Child` or `Publish_HRDL_Delta_Child` depends on JobType parameter's value. Any failure from the child pipeline will cause the `Publish_HRDL_Entities_Parent` pipeline to fail.

### Troubleshooting Steps

#### 1. Verify Parameter's Value:
- **Full**: check the [Publish_HRDL_Full_Child pipeline](publish_hrdl_full_child.md) .
- **Delta**: check the [Publish_HRDL_Delta_Child pipeline](publish_hrdl_delta_child.md) .
- **Metadata**: check the [Publish_HRDL_Full_Child pipeline](publish_hrdl_full_child.md) .

#### 2. Examine the Switch Configuration:
- Open the `Publish_HRDL_Entities_Parent` pipeline and inspect the switch's configuration.

#### 3. Review Logs and Error Messages:
- Go into the detailed logs of the `Publish_HRDL_Entities_Parent` pipeline run.
- Look for any additional clues or context around the error.

#### 4. Check for Recent Changes:
- Review any recent changes or deployments that might have affected the pipeline, especially changes to the set of recognized values or the switch's configuration.

### Recovering from failure

- Correct the parameter value provided to the switch in the `Publish_HRDL_Entities_Parent` pipeline.
- If there was a misconfiguration, rectify the switch's setup or recognized values list.

### Workarounds (if any)
</details>
