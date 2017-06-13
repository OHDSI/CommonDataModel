Common-Data-Model
=================

v5.1
See full CDM specification file on our [Wiki](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:cdm:single-page) or in the [CDM V5 PDF](https://github.com/OHDSI/CommonDataModel/blob/master/OMOP%20CDM%20v5.pdf)

Release Notes
=============
This version is bases on this CDM working group  [proposal](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:next_cdm:time). The proposed and accepted changes include adding a datetime field to every table that had a date column. These were the new columns added:

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

=======
This repo contains the definition of the OMOP Common Data Model. It supports the 4 SQL technologies: Impala, Oracle, Postgres and SQL Server. For each, the DDL, constraints and indexes (if appropirate) are defined. 

Versions are defined using tagging and versioning. Full versions (V6, 7 etc.) are released irregularly after a major strategy change or use case coverage. It will be issued during an OHDSI Symposium. Major version (V5.1, 5.2 etc.) are released half yearly (1-Jul and 1-Jan). Those versions are not guaranteed to be backward compatible. Minor versions (V5.1.1, V5.1.2 etc.) are released irregularly and often, and contain small hot fixes or backward compatible changes to the last Major Version.


See full CDM specification file on our [Wiki](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:cdm:single-page).
