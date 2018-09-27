The specimen domain contains the records identifying biological samples from a person.
 
Field|Required|Type|Description
:-----------------------------|:--------|:------------|:------------------------------------------------------
|specimen_id|Yes|integer|A unique identifier for each specimen.|
|person_id|Yes|integer|A foreign key identifier to the Person for whom the Specimen is recorded.|
|specimen_concept_id|Yes|integer|A foreign key referring to a Standard Concept identifier in the Standardized Vocabularies for the Specimen.|
|specimen_type_concept_id|Yes|integer|A foreign key referring to the Concept identifier in the Standardized Vocabularies reflecting the system of record from which the Specimen was represented in the source data.|
|specimen_date|Yes|date|The date the specimen was obtained from the Person.|
|specimen_datetime|No|datetime|The date and time on the date when the Specimen was obtained from the person.|
|quantity|No|float|The amount of specimen collection from the person during the sampling procedure.|
|unit_concept_id|No|integer|A foreign key to a Standard Concept identifier for the Unit associated with the numeric quantity of the Specimen collection.|
|anatomic_site_concept_id|No|integer|A foreign key to a Standard Concept identifier for the anatomic location of specimen collection.|
|disease_status_concept_id|No|integer|A foreign key to a Standard Concept identifier for the Disease Status of specimen collection.|
|specimen_source_id|No|varchar(50)|The Specimen identifier as it appears in the source data.|
|specimen_source_value|No|varchar(50)|The Specimen value as it appears in the source data. This value is mapped to a Standard Concept in the Standardized Vocabularies and the original code is, stored here for reference.|
|unit_source_value|No|varchar(50)|The information about the Unit as detailed in the source.|
|anatomic_site_source_value|No|varchar(50)|The information about the anatomic site as detailed in the source.|
|disease_status_source_value|No|varchar(50)|The information about the disease status as detailed in the source.|

### Conventions 

No.|Convention Description
:--------|:------------------------------------   
| 1  | Anatomic site is coded at the most specific level of granularity possible, such that higher level classifications can be derived using the Standardized Vocabularies.