The 'Death' domain contains the clinical event for how and when a Person dies. A Person can have up to one record if the source system contains evidence about the Death, such as:

  * Condition Code in the Header or Detail information of claims
  * Status of enrollment into a health plan
  * Explicit record in EHR data

Field|Required|Type|Description
:-------------------------|:--------|:-----|:----------------------------------------------
| person_id					| Yes	| bigint	| A foreign key identifier to the deceased Person. The demographic details of that Person are stored in the PERSON table.                                                                                          |
| death_date 				| No	| date		| The date the Person was deceased. If the precise date including day or month is not known or not allowed, December is used as the default month, and the last day of the month the default day.        |
| death_datetime 			| Yes	| datetime	| The date and time the Person was deceased. If the precise date including day or month is not known or not allowed, December is used as the default month, the last day of the month the default day, and midnight the default time.|
| death_type_concept_id		| Yes	| integer	| A foreign key referring to the predefined Concept identifier in the Standardized Vocabularies reflecting how the Death was represented in the source data.                                         |
| cause_concept_id			| No	| integer	| A foreign key referring to a Standard Concept identifier in the Standardized Vocabularies belonging to the 'Condition" domain.                                                                                           |
| cause_source_value		| No	| varchar(50)| The source code for the cause of death as it appears in the source data. This code is mapped to a Standard Condition Concept in the Standardized Vocabularies and the original code is stored here for reference.|
| cause_source_concept_id	| No	| integer	| A foreign key to the Concept that refers to the code used in the source. Note, this variable name is abbreviated to ensure it will be allowable across database platforms.                              |

### Conventions 
  * Living patients should not contain any information in the DEATH table.
  * Each Person may have more than one record of death in the source data. If a patient has clinical activity (e.g. prescriptions filled, labs performed, etc) more than 60+ days after death the ETL may want to drop the death record as it may have been falsely reported. If multiple records of death exist on multiple days the ETL may select the death that is deemed most reliable (e.g. death at discharge) or is latest.
  * If the Death Datetime cannot be precisely determined from the data, the best approximation should be used.
  * Valid Concepts for the CAUSE_CONCEPT_ID have domain_id='Condition'.