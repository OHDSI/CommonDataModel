Common Data Model v5.1.0
=================

See full CDM specification file on our github [wiki](https://github.com/OHDSI/CommonDataModel/wiki) or in the [CDM V5.1.0 PDF](https://github.com/OHDSI/CommonDataModel/blob/master/Documentation/OMOP_CDM_v5_1_0.pdf)

Release Notes
=============
This version is based on this CDM working group proposal [#60](https://github.com/OHDSI/CommonDataModel/issues/60) and [#59](https://github.com/OHDSI/CommonDataModel/issues/59). The proposed and accepted changes include adding a datetime field to every table that had a date column and adding field DENOMINATOR_VALUE to the DRUG_STRENGTH table. These were the new columns added:

**PERSON**  
* birth_datetime, not required

**SPECIMEN**  
* specimen_datetime, not required

**DEATH**  
* death_datetime, not required

**VISIT_OCCURRENCE**  
* visit_start_datetime, not required
* visit_end_datetime, not required

**PROCEDURE_OCCURRENCE**  
* procedure_datetime, not required

**DRUG_EXPOSURE**  
* drug_exposure_start_datetime, not required
* drug_exposure_end_datetime, not required

**DRUG_STRENGTH**
* DENOMINATOR_VALUE, not required

**DEVICE_EXPOSURE**  
* device_exposure_start_datetime, not required
* device_exposure_end_datetime, not required

**CONDITION_OCCURRENCE**  
* condition_start_datetime, not required
* condition_end_datetime, not required

**MEASUREMENT**  
* measurement_datetime as time, not required

**OBSERVATION**  
* observation_datetime, not required

**NOTE**  
* note_datetime, not required

---------
  
This repo contains the definition of the OMOP Common Data Model. It supports the 4 SQL technologies: Impala, Oracle, Postgres and SQL Server. For each, the DDL, constraints and indexes (if appropriate) are defined. 

Versions are defined using tagging and versioning. Full versions (V6, 7 etc.) are released each year (1-Jan) and are not backwards compatible. Minor versions (V5.1, 5.2 etc.) are released each quarter (1-Apr, 1-Jul and 1-Sep) and are not guaranteed to be backwards compatible though an effort is made to make sure that current queries will not break. Micro versions (V5.1.1, V5.1.2 etc.) are released irregularly and often, and contain small hot fixes or backward compatible changes to the last minor version.
