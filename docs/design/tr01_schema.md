# Time Records (TR01) Data Set

This document provides an overview of the schema definitions for Time Records (TR01) dataset's entities that are published on HR Data Lake.

## Table of Contents

<details><summary><b>Time metadata tables</b></summary>

  - [Table 1: TR01TimeBalancesMeta](#table-1-tr01timebalancesmeta)
  - [Table 2: TR01TimeMeta](#table-2-tr01timemeta)
  - [Table 3: TR01TimeOffMeta](#table-3-tr01timeoffmeta)
</details>

<details><summary><b>Time data tables</b></summary>

  - [Table 1: TR01ShiftRecords](#table-1-tr01shiftrecords)
  - [Table 2: TR01TimeRecords](#table-2-tr01timerecords)
  - [Table 3: TR01TimeOffRecords](#table-3-tr01timeoffrecords)
  - [Table 4: TR01TimeOffRecordsS](#table-4-tr01timeoffrecordsS)
  - [Table 5: TR01TimeOffBalances](#table-5-tr01timeoffbalances)
</details>

## Time metadata tables

### Table 1: TR01TimeBalancesMeta 
**Description:**\
Contains the metadata for accruals/balances, with `bank name` and `description` as configured in Work Force Software. This does not contain any employee data.

**Data Source:** File export from WFS
<details><summary><b>Columns</b></summary>

  - `BankName` [*Accrual type - vacation, HHTO, floating holidays et al*]
  - `ShortDescription` [*Description of accrual (bank) from WFS*]
  - `Units` [*Unit for the bank i.e. hours, days*]

</details>

### Table 2: TR01TimeMeta  
**Description:** Contains the metadata for time (attendance) type/Pay Code as configured in Work Force Software. This does not contain any employee data.

**Data Source:** File export from WFS
<details><summary><b>Columns</b></summary>

  - `PayCodeName` [*Name of time (attendance) type*]
  - `ShortDescription`[*Description of pay code from WFS*]
  - `Unit` [*Unit of the pay code i.e. hours, days*]
</details>

### Table 2: TR01TimeOffMeta
**Description:** Contains the metadata for time off type/Pay Code as configured in Work Force Software. This does not contain any employee data.

**Data Source:** File export from WFS
<details><summary><b>Columns</b></summary>

  - `AbsenceType` [*Name of time-off (absence) type*]
  - `Description`[*Description of absence type*]
  - `DefaultPayCode` [*Pay code for the absence type*]											

</details>


## Time data tables

### Table 1: TR01ShiftRecords
**Description:** Contains the metadata for time off type/Pay Code as configured in Work Force Software. This does not contain any employee data.

**Data Source:** WFS `shift` API
<details><summary><b>Columns</b></summary>

- `ID` [*Unique Identifier of the timeoff record;MSFT generated ID,not from WFS*]
- `PersonnelNumber`[*Personnel number of the employee*]
- `EffectiveDate` [*Effective date for the shift*]
- `ShiftId` [*ID of the shift*]
- `ShiftStartAt` [*Start time of the shift*]
- `ShiftEndAt` [*End time of the shift*]
- `ActivityId` [*ActivityID, if the shift has multiple activities configured on WFS*]
- `ActivityStartAt` [*Start time of the activity*]
- `ActivityEndAt` [*End time of the activity*]
- `Task` [*Task performed in activity*]
- `IsDeleted` [*false if record is active; true if record is deleted*]

</details>



### Table 2: TR01TimeRecords
**Description:**\
Contains all the time entry information for employees. For example, Hours worked, overtime, clock-in clock out.\
This is not a __secure table__, so any consumer subscribing to this table will have the Pay code for the time entry type as well.

**Data Source:** WFS `calculated-time` API

<details><summary><b>Columns</b></summary>

- `ID` [*Unique Identifier of the timeoff record;MSFT generated ID,not from WFS*]
- `PersonnelNumber`[*Personnel number of the employee*]
- `EffectiveDate` [*Date for which the time was recorded *]
- `PayCode` [*Code for the time entry*]
- `StartTime` [*Start time of the time entry*]
- `EndTime` [*End time of the time entry*]
- `Unit` [*Start_dttm, Days, Hours, Amount*]
- `Value` [*# of hours, in case the unit of paycode is hours*]
- `IsDeleted`[*false if record is active; true if record is deleted*]	

</details>


### Table 3: TR01TimeOffRecords
**Description:**\
Contains all time off data, including LOA data for employees. This table is a non- secured table and will not contain the PayCode column.

**Data Source:** WFS `calculated-time` API

<details><summary><b>Columns</b></summary>

- `ID` [*Unique Identifier of the timeoff record;MSFT generated ID,not from WFS*]
- `PersonnelNumber`[*Personnel number of the employee*]
- `EffectiveDate` [*Date of time-off*]
- `StartTime` [*Start time for time-off request, if WFS is capturing start time of time-off for perner's country*]
- `EndTime` [*End time for time-off request, if WFS is capturing end time of time-off for perner's country*]
- `Unit` [*Start_dttm, Days, Hours, Amount*]
- `Value` [*Depending on the unit, the value can be datetime for Start_dttm, .25/.5 or 1 for Days, numerical value for Hours & Amount*]
- `Status` [*Status of request ('Approved' only currently)*]
- `IsDeleted` [*false if record is active; true if record is deleted*]
</details>

### Table 4: TR01TimeOffRecordsS 
**Description:**\
Contains all time off data, including LOA data for employees. This table is __secure__ table and will contain the PayCode column which can identify the type of Leave of Absence an employee is on (like Maternity Leave, Disability Leave etc.).\

**Data Source:** WFS `calculated-time` API

<details><summary><b>Columns</b></summary>

- `ID` [*Unique Identifier of the timeoff record;MSFT generated ID,not from WFS*]
- `PersonnelNumber`[*Personnel number of the employee*]
- `EffectiveDate` [*Date of time-off*]
- `PayCode` [*Code for time-off type*]
- `StartTime` [*Start time for time-off request, if WFS is capturing start time of time-off for perner's country*]
- `EndTime` [*End time for time-off request, if WFS is capturing end time of time-off for perner's country*]
- `Unit` [*Start_dttm, Days, Hours, Amount*]
- `Value` [*Depending on the unit, the value can be datetime for Start_dttm, .25/.5 or 1 for Days, numerical value for Hours & Amount*]
- `Status` [*Status of request ('Approved' only currently)*]
- `IsDeleted` [*false if record is active; true if record is deleted*]

</details>


### Table 5: TR01TimeOffBalances
- **Description:**
Contains the time-off accrual balances (known as banks in WFS terminology) for various time off types for an employee. Vacation, Floating Holiday are examples of `bank name`.

**Data Source:** WFS `calculated-time` API

<details><summary><b>Columns</b></summary>

- `PersonnelNumber`[*Personnel Number of the employee*]
- `BankName` [*Type of bank i.e. vacation, HHTO, floating holidays et al*]
- `Unit` [*Unit of accrual (days/hours)*]
- `Used` [*Value of used time-off (Year-To-Date as per AsOfDate*]
- `Balance` [*Balance accrued (or earned) but not taken (Year-To-Date as per AsOfDate*]
- `AsOfDate` [*Date when accruals/balances are effective from*]

</details>


---

For additional details on this schema or if you have additional thoughts that you would like to share about this, please reach out to <eetpeng@microsoft.com>. 