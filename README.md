Common Data Model v5.3
=================

See full CDM specification file on our github [wiki](https://github.com/OHDSI/CommonDataModel/wiki) or in the [CDM V5.3 PDF](https://github.com/OHDSI/CommonDataModel/blob/master/OMOP_CDM_v5_3.pdf)


Release Notes for v5.3
=============
This version is based on the pull requests and CDM proposals:
* [#64](https://github.com/OHDSI/CommonDataModel/pull/64) This removes the datetime fields from OBSERVATION_PERIOD
* [#70](https://github.com/OHDSI/CommonDataModel/issues/70) Adds the VISIT_DETAIL table
* [#79](https://github.com/OHDSI/CommonDataModel/issues/79) Adds the METADATA table
* [#92](https://github.com/OHDSI/CommonDataModel/issues/92) Fixes qualifier typo in PROCEDURE_OCCURRENCE
* [#120](https://github.com/OHDSI/CommonDataModel/issues/120) Adds the following fields to PAYER_PLAN_PERIOD:
	* PAYER_CONCEPT_ID
	* PAYER_SOURCE_CONCEPT_ID
	* PLAN_CONCEPT_ID
	* PLAN_SOURCE_CONCEPT_ID
	* SPONSOR_CONCEPT_ID
	* SPONSOR_SOURCE_CONCEPT_ID
	* STOP_REASON_CONCEPT_ID
	* STOP_REASON_SOURCE_VALUE
	* STOP_REASON_SOURCE_CONCEPT_ID

Additional Updates
==================

* There is a [development branch](https://github.com/OHDSI/CommonDataModel/tree/Dev) now available with the DDLs and documentation for tables and/or changes that have been accepted into a future version of the CDM. Please use these with caution as they are subject to change upon formal release
* BigQuery, Netezza, and Parallel Data Warehouse DDLs are now available


---------
  

This repo contains the definition of the OMOP Common Data Model. It supports the SQL technologies: BigQuery, Impala, Netezza, Oracle, Parallel Data Warehouse, Postgres, Redshift, and SQL Server. For each, the DDL, constraints and indexes (if appropriate) are defined. 


Versions are defined using tagging and versioning. Full versions (V6, 7 etc.) are usually released each year (1-Jan) and are not backwards compatible. Minor versions (V5.1, 5.2 etc.) are not guaranteed to be backwards compatible though an effort is made to make sure that current queries will not break. Micro versions (V5.1.1, V5.1.2 etc.) are released irregularly and often, and contain small hot fixes or backward compatible changes to the last minor version.
