Common-Data-Model
=================

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

