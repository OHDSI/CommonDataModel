---
title: "Readme"
output: 
    html_document:
        toc: TRUE
        toc_float: TRUE
---

# How to Update the CDM 

**NOTE** This information is for the maintainers of the CDM as it is best for all information to be in one place. If you want to suggest an update or addition to the OMOP CDM please visit the [CommonDataModel repo](https://github.com/OHDSI/CommonDataModel/issues). The instructions contained herein are meant to describe the process by which new versions of the CDM are produced, should it need to be replicated in the future. These steps are also enumerated in `extras/codeToRun.R`.

Typically, new CDM versions and updates are decided by the CDM working group (details to join meetings on [homepage](https://ohdsi.github.io/CommonDataModel/)). These changes are tracked as issues in the [github repo](https://github.com/OHDSI/CommonDataModel/issues). Once the working group decides which changes make up a version, all the corresponding issues should be tagged with a version number e.g. v6.1. 

## Step 0

All the issues and additions that are incorporated into the new CDM version will be handled in the [CommonDataModel repository](https://github.com/OHDSI/CommonDataModel). Changes should be made in the representative csv files and it is the job of the CdmDdlBase repo to take those files and convert them to DDLs and documentation. This README will walk through how to update and create all the relevant DDLs, constraints, indices, and documentation for the CDM utilizing both the CommonDataModel repo and the CdmDdlBase repo.

## Step 1

Create a branch in the CommonDataModel repository for the new version of the CDM you are creating.

### Step 1.1 
Rename the csv files from the current released version to the new version. For example, if the new version you are creating is v6.0 and the most recent released version is v5.3.1, rename the csv files named "OMOP_CDMv5.3.1_Field_Level.csv" and "OMOP_CDMv5.3.1_Table_Level.csv" to "OMOP_CDMv6.0_Field_Level.csv" and "OMOP_CDMv6.0_Table_Level.csv". These files serve multiple functions; they serve as the basis for the CDM DDL, CDM documentation, and Data Quality Dashboard (DQD). You can read more about the DQD [here](https://ohdsi.github.io/DataQualityDashboard/index.html). 

### Step 1.2
The csv files can now be updated with the changes and additions for the new CDM version. If a new table should be added, add a line to the *Table_Level.csv* with the table name and description and list it as part of the CDM schema. The remaining columns are quality checks that can be run. Details [here](https://ohdsi.github.io/DataQualityDashboard/index.html) on what those are. After adding any tables, make any changes or additions to CDM fields in the *Field_Level.csv*. The columns are meant to mimic how a DDL is structured, which is how it will eventually be generated. A yes in the field *isRequired* indicates a NOT NULL constraint and the datatype field should be filled in exactly how it would look in the DDL. Any additions or changes should also be reflected in the userGuidance and etlConventions fields, which are the basis for the documentation. **DO NOT MAKE ANY CHANGES IN THE DDL ITSELF**. The structure is set up in such a way that the csv files are the ground truth. If changes are made in the DDL instead of the csv files then the DDL will be out of sync with the documentation and the DQD. 

## Step 2
Push the csv files up to the branch for the new CDM version and then switch to the CdmDdlBase repository. Get the zip url for the CDM branch (on the github page for the branch, click on the green download button and then right click on download zip to get the url) in progress and use the file `packageMaintenance.R` and the instructions therein to copy the csv files over to the inst/csv folder of the CdmDdlBase package. For each CDM version represented in CdmDdlBase there should be two csv files. For example, CDM v5.3.1 has csv files "OMOP_CDMv5.3.1_Field_Level" and "OMOP_CDMv5.3.1_Table_Level" in the inst/csv folder. 

## Step 3
Once all changes are made the csvs, open `extras/codeToRun.R` and run the `createDdlFromFile` function, setting the parameters `cdmTableCsvLoc` and `cdmFieldCsvLoc` to the locations of the csv files created in step 3. For example, the `cdmTableCsvLoc` for cdm v5.3.1 is "inst/csv/OMOP_CDMv5.3.1_Table_Level.csv". This will create a sql file in *inst/sql/sql_server* with the ddl for the current cdm version. Once the DDL is created, run the `createPkFromFile` and `createFkFromFile` functions to create the primary key and foreign key scripts.

## Step 4 
Use the`writeDDL` function to tranlate the sql script created in the step above into oracle, postgres, and sql server dialects.


**NOTE** This documentation is a work in progress and will continue to be updated. 
