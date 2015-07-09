Conversion from CDM v4 to CDM v5
==============================================================

The scripts in this directory will aid you in moving your data from the Common Data Model (CDM) version 4 to version 5.

Usage & Assumptions
==============================================================

We have created a directory per RDBMS that contains the conversion script for that database platform. All of the script assume the following:

1. Your source CDM V4 database is on the same sever as your target CDM v5 database.
2. You have read rights to the CDM V4 database and database owner privileges on the target V5 database as this script will create an "ETL_WARNINGS" table in the process.

** **NOTE** ** If you are running the Oracle script via Sql Developer or similar, you may need to alter the script to include the appropriate "/" symbols to mark the end of the anonymous code blocks. 

Quality Assurance
===================

We have included 2 scripts in the root of this directory that were used while doing quality assurance on the conversion scripts:

* Conversion-QA - Sql Server.sql
* Conversion-QA-Part-2 - Sql Server.sql
 
As noted in the file names, these scripts were written specifically for Sql Server but should be a fairly easy port to your RDBMS target. The goals of these scripts were to measure the following:

* **Conversion-QA - Sql Server.sql**: provides row counts from each table in the V4 and V5 databases. It also includes a column called "Migration Target" which notes if that table was a target of the migration. The full list will help you to see if there were any tables in V4 that were either missed or are not targeted as part of the migration. Of particular note: **Cohort** and **Source\_To\_Concept\_Map** are not targeted for this migration.

* **Conversion-QA-Part-2 - Sql Server.sql**: provides 2 summary tables to help verify the output from the first script. The first summary table provides row counts for specific V4 tables and how the rows in the tables map to the V5 domains. This summary is useful to understand why the row counts for these tables will vary between the V4 and V5. The second summary table provides a row count sum by domain which should then match the V5 row counts for the corresponding V5 tables. The tables that are summarized in this script are: condition\_occurrence, drug\_exposure, observation, procedure\_occurrence. 

Contributions
==============================================================

Each script found in the RDBMS directory was generated from the template SQL file: *OMOP CDMv4 to CDMv5 - templateSQL.sql* found in the root of this directory. If you would like to contribute to this script, we'd suggest you modify this script and use **[SqlRender](https://github.com/OHDSI/SqlRender "SqlRender")** to re-generate the specific RDBMS scripts.
