The death domain contains the clinical event for how and when a Person dies. A person can have up to one record if the source system contains evidence about the Death, such as:

  * Condition Code in the Header or Detail information of claims
  * Status of enrollment into a health plan
  * Explicit record in EHR data

Field|Required|Type|Description
:-------------------------|:--------|:-----|:----------------------------------------------
|person_id|Yes|integer|A foreign key identifier to the deceased person. The demographic details of that person are stored in the person table.|
|death_date |Yes|date|The date the person was deceased. If the precise date including day or month is not known or not allowed, December is used as the default month, and the last day of the month the default day.|
|death_datetime |No|datetime|The date and time the person was deceased. If the precise date including day or month is not known or not allowed, December is used as the default month, and the last day of the month the default day.|
|death_type_concept_id|Yes|integer|A foreign key referring to the predefined concept identifier in the Standardized Vocabularies reflecting how the death was represented in the source data.|
|cause_concept_id|No|integer|A foreign key referring to a standard concept identifier in the Standardized Vocabularies for conditions.|
|cause_source_value|No|varchar(50)|The source code for the cause of death as it appears in the source data. This code is mapped to a standard concept in the Standardized Vocabularies and the original code is, stored here for reference.|
|cause_source_concept_id|No|integer|A foreign key to the concept that refers to the code used in the source. Note, this variable name is abbreviated to ensure it will be allowable across database platforms.|

### Conventions 
  * Living patients should not contain any information in the DEATH table.
  * Each Person may have more than one record of death in the source data. It is the task of the ETL to pick the most plausible or most accurate records to be aggregated and stored as a single record in the DEATH table.
  * If the Death Date cannot be precisely determined from the data, the best approximation should be used.
  * Valid Concepts for the cause_concept_id have domain_id='Condition'.