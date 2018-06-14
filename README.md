Common Data Model v5.3.1
=================

See full CDM specification file on our github [wiki](https://github.com/OHDSI/CommonDataModel/wiki) or in the [CDM V5.3.1 PDF](https://github.com/OHDSI/CommonDataModel/blob/master/OMOP_CDM_v5_3_1.pdf)


Release Notes for v5.3.1
=============

### This version address the following issues/pull requests:

* [#183](https://github.com/OHDSI/CommonDataModel/pull/183) Fixes VISIT_DETAIL documentation, 'required' and 'type' columns were switched
* [#169](https://github.com/OHDSI/CommonDataModel/pull/183) Data type changes for BigQuery
* [#171](https://github.com/OHDSI/CommonDataModel/issues/171) Datetime formats in Sql Server changed to Datetime2
* [#173](https://github.com/OHDSI/CommonDataModel/issues/173) Impala reserved words
* [#177](https://github.com/OHDSI/CommonDataModel/pull/177) Postgres readme
* [#140](https://github.com/OHDSI/CommonDataModel/issues/140), [#144](https://github.com/OHDSI/CommonDataModel/issues/140), [#135](https://github.com/OHDSI/CommonDataModel/issues/140) 
  * Typos in readme and documentation
* [#158](https://github.com/OHDSI/CommonDataModel/pull/158) VOCABULARY.VOCABULARY_VERSION no longer a required field
* [#157](https://github.com/OHDSI/CommonDataModel/pull/157) Added MEASUREMENT.MEASUREMENT_TIME back to DDL for backwards compatibility
* [#147](https://github.com/OHDSI/CommonDataModel/issues/147) PAYER_PLAN_PERIOD.STOP_REASON_SOURCE_VALUE varchar instead of integer
* [#120](https://github.com/OHDSI/CommonDataModel/issues/120) PAYER_PLAN_PERIOD documentation
* [#160](https://github.com/OHDSI/CommonDataModel/issues/160) Removed errant semicolon in license header
* **[#145](https://github.com/OHDSI/CommonDataModel/issues/145) VISIT_DETAIL naming convention** 
  * This is the change with the most potential impact as column names were updated
* [#67](https://github.com/OHDSI/CommonDataModel/issues/67) Removed COHORT_DEFINITION_ID foreign key constraint from COHORT table
* [#16](https://github.com/OHDSI/CommonDataModel/issues/16) Added additional foreign key constraints that were missing
* [#12](https://github.com/OHDSI/CommonDataModel/issues/12) .csv file is now delivered with each version
* Additional BigQuery updates for compatibility
* A portion of [#112](https://github.com/OHDSI/CommonDataModel/issues/112) was addressed
  * VISIT_DETAIL and documentation typos

Additional Updates
==================

* There is a [development branch](https://github.com/OHDSI/CommonDataModel/tree/Dev) now available with the DDLs and documentation for tables and/or changes that have been accepted into a future version of the CDM. Please use these with caution as they are subject to change upon formal release
* BigQuery, Netezza, and Parallel Data Warehouse DDLs are now available


---------
  

This repo contains the definition of the OMOP Common Data Model. It supports the SQL technologies: BigQuery, Impala, Netezza, Oracle, Parallel Data Warehouse, Postgres, Redshift, and SQL Server. For each, the DDL, constraints and indexes (if appropriate) are defined. 


Versions are defined using tagging and versioning. Full versions (V6, 7 etc.) are usually released each year (1-Jan) and are not backwards compatible. Minor versions (V5.1, 5.2 etc.) are not guaranteed to be backwards compatible though an effort is made to make sure that current queries will not break. Micro versions (V5.1.1, V5.1.2 etc.) are released irregularly and often, and contain small hot fixes or backward compatible changes to the last minor version.
