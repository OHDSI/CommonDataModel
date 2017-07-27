Common Data Model v5.2
=================

See full CDM specification file on our github [wiki](https://github.com/OHDSI/CommonDataModel/wiki) or in the [CDM V5.2 PDF](https://github.com/OHDSI/CommonDataModel/blob/master/OMOP_CDM_v5_2.pdf)


Release Notes for v5.2.0
=============
This version is based on the CDM working group proposals:
* [#71](https://github.com/OHDSI/CommonDataModel/issues/71) Adds the field VERBATIM_END_DATE to DRUG_EXPOSURE and makes DRUG_EXPOSURE_END_DATE a required field
* [#73](https://github.com/OHDSI/CommonDataModel/issues/73) Removes EFFECTIVE_DRUG_DOSE and DOSE_UNIT_CONCEPT_ID from DRUG_EXPOSURE
* [#75](https://github.com/OHDSI/CommonDataModel/issues/75) Adds the field BOX_SIZE to DRUG_STRENGTH
* [#83](https://github.com/OHDSI/CommonDataModel/issues/83) Adds the following fields to VISIT_OCCURRENCE:
  * ADMITTING_SOURCE_CONCEPT_ID
  * ADMITTING_SOURCE_VALUE
  * DISCHARGE_TO_CONCEPT_ID
  * DISCHARGE_TO_SOURCE_VALUE
  * PRECEDING_VISIT_OCCURRENCE_ID
* [#84](https://github.com/OHDSI/CommonDataModel/issues/84) Adds the following fields to CONDITION_OCCURRENCE:
  * CONDITION_STATUS_CONCEPT_ID
  * CONDITION_STATUS_SOURCE_VALUE
* [#69](https://github.com/OHDSI/CommonDataModel/issues/69) Adds the following fields to COST:
  * DRG_CONCEPT_ID
  * DRG_SOURCE_VALUE
* [#85](https://github.com/OHDSI/CommonDataModel/issues/85) Adds the NOTE_NLP table and the following fields to NOTE:
  * NOTE_CLASS_CONCEPT_ID
  * NOTE_TITLE
  * ENCODING_CONCEPT_ID
  * LANGUAGE_CONCEPT_ID
  
Additional Updates
==================

* Files to generate the '_ERA' tables are now availalbe in the [CodeExcerpts](https://github.com/OHDSI/CommonDataModel/tree/master/CodeExcerpts) folder
* Redshift DDLs are now available

This version is **backwards compatibile with v5.0.1**. 


---------
  

This repo contains the definition of the OMOP Common Data Model. It supports the 5 SQL technologies: Impala, Oracle, Postgres, Redshift, and SQL Server. For each, the DDL, constraints and indexes (if appropriate) are defined. 


Versions are defined using tagging and versioning. Full versions (V6, 7 etc.) are released each year (1-Jan) and are not backwards compatible. Minor versions (V5.1, 5.2 etc.) are released each quarter (1-Apr, 1-Jul and 1-Sep) and are not guaranteed to be backwards compatible though an effort is made to make sure that current queries will not break. Micro versions (V5.1.1, V5.1.2 etc.) are released irregularly and often, and contain small hot fixes or backward compatible changes to the last minor version.
