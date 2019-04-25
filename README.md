Common Data Model v6.x [In Development]
=================

This branch is meant to be a repository for those proposals that have been provisionally accepted by the [CommonDataModel Working Group](https://docs.google.com/document/d/144e_fc7dyuinfJfbYW5MsJeSijVSzsNE7GMY6KRX10g/edit?usp=sharing). The main goal is to test proposals with real data prior to their addition to the production version of the OMOP CDM. **PLEASE NOTE** After version 6.0 only Sql Server, PostgreSQL, and Oracle will be fully supported dialects meaning that the ddls, indices, and constraints will be fully tested prior to release. The provided BigQuery, Netezza, Impala, Amazon Redshift, and Parallel Data Warehouse scripts will be translated from Sql Server using the [SqlRender](https://github.com/ohdsi/sqlrender) package. These scripts will not be tested, however, any issues or pull requests related to these dialects will be reviewed in a timely manner. 

Release Notes for v6.x [In Development]
=============

### Since the release of v6.0 this branch includes the following issues/pull requests:

#### CDM
* [#239](https://github.com/OHDSI/CommonDataModel/pull/239) Adds the EPISODE and EPISODE_EVENT tables (24-Apr-2019)
* [#252](https://github.com/OHDSI/CommonDataModel/pull/252)] Adds the field region_concept_id field to the LOCATION table (24-Apr-2019)



Additional Updates
==================

* As of 24-Apr-2019 only the ddl, constraints, and indices have been updated based on the proposals listed above. The .csv file containing all tables and fields, the fully specified pdf, and the wiki files do not reflect these additions. 

---------
  
This repo contains the definition of the OMOP Common Data Model [In Development]. It supports the SQL technologies: Oracle, Postgres, and SQL Server. For each, the DDL, constraints and indexes (if appropriate) are defined. BigQuery, Netezza, Impala, Amazon Redshift, and Parallel Data Warehouse scripts are provided but not tested prior to release.


Versions are defined using tagging and versioning. Full versions (V6, 7 etc.) are usually released at most once a year and are not backwards compatible. Minor versions (V5.1, 5.2 etc.) are not guaranteed to be backwards compatible though an effort is made to make sure that current queries will not break. Micro versions (V5.1.1, V5.1.2 etc.) are released irregularly and often, and contain small hot fixes or backward compatible changes to the last minor version.
