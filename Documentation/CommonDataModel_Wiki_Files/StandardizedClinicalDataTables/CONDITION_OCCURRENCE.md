Conditions are records of a Person suggesting the presence of a disease or medical condition stated as a diagnosis, a sign or a symptom, which is either observed by a Provider or reported by the patient. Conditions are recorded in different sources and levels of standardization, for example:

  * Medical claims data include diagnoses coded in ICD-9-CM that are submitted as part of a reimbursement claim for health services and 
  * EHRs may capture Person Conditions in the form of diagnosis codes or symptoms.

Field|Required|Type|Description
:--------------------------------|:--------|:------------|:------------------------------------------------------------
| condition_occurrence_id        | Yes       | integer      | A unique identifier for each Condition Occurrence event.                                                                                                                                                         |
| person_id                      | Yes       | integer      | A foreign key identifier to the Person who is experiencing the condition. The demographic details of that Person are stored in the PERSON table.                                                                 |
| condition_concept_id           | Yes       | integer      | A foreign key that refers to a Standard Condition Concept identifier in the Standardized Vocabularies.                                                                                                           |
| condition_start_date           | Yes       | date         | The date when the instance of the Condition is recorded.                                                                                                                                                         |
| condition_start_datetime       | No        | datetime     | The date and time when the instance of the Condition is recorded.                                                                                                                                                |
| condition_end_date             | No        | date         | The date when the instance of the Condition is considered to have ended.                                                                                                                                         |
| condition_end_datetime         | No        | date         | The date when the instance of the Condition is considered to have ended.                                                                                                                                         |
| condition_type_concept_id      | Yes       | integer      | A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the source data from which the condition was recorded, the level of standardization, and the type of occurrence.  |
| stop_reason                    | No        | varchar(20)  | The reason that the condition was no longer present, as indicated in the source data.                                                                                                                            |
| provider_id                    | No        | integer      | A foreign key to the Provider in the PROVIDER table who was responsible for capturing (diagnosing) the Condition.                                                                                                |
| visit_occurrence_id            | No        | integer      | A foreign key to the visit in the VISIT table during which the Condition was determined (diagnosed).                                                                                                             |
| condition_source_value         | No        | varchar(50)  | The source code for the condition as it appears in the source data. This code is mapped to a standard condition concept in the Standardized Vocabularies and the original code is stored here for reference.     |
| condition_source_concept_id    | No        | integer      | A foreign key to a Condition Concept that refers to the code used in the source.                                                                                                                                 |
| condition_status_source_value  | No        | varchar(50)  | The source code for the condition status as it appears in the source data.    |
| condition_status_concept_id    | No        | integer      | A foreign key to the predefined concept in the standard vocabulary reflecting the condition status |                                                                                                                               |

### Conventions 

  * Valid Condition Concepts belong to the "Condition" domain. 
  * Condition records are typically inferred from diagnostic codes recorded in the source data. Such code system, like ICD-9-CM, ICD-10-CM, Read etc., provide a comprehensive coverage of conditions. However, if the diagnostic code in the source does not define a condition, but rather an observation or a procedure, then such information is not stored in the CONDITION_OCCURRENCE table, but in the respective tables instead.
  * Source Condition identifiers are mapped to Standard Concepts for Conditions in the Standardized Vocabularies. When the source code cannot be translated into a Standard Concept, a CONDITION_OCCURRENCE entry is stored with only the corresponding source_concept_id and source_value, while the condition_concept_id is set to 0. 
  * Family history and past diagnoses ("history of") are not recorded in the CONDITION_OCCURRENCE table. Instead, they are listed in the OBSERVATION table.
  * Codes written in the process of establishing the diagnosis, such as "question of" of and "rule out", are not represented here.  Instead, they are listed in the OBSERVATION table, if they are used for analyses.
  * A Condition Occurrence Type is assigned based on the data source and type of condition attribute, for example:
    * ICD-9-CM Primary Diagnosis from inpatient and outpatient Claims
    * ICD-9-CM Secondary Diagnoses from inpatient and outpatient Claims
    * Diagnoses or problems recorded in an EHR.
  * The Stop Reason indicates why a Condition is no longer valid with respect to the purpose within the source data. Typical values include "Discharged", "Resolved", etc.  Note that a Stop Reason does not necessarily imply that the condition is no longer occurring.
  * Condition source codes are typically ICD-9-CM, Read or ICD-10 diagnosis codes from medical claims or discharge status/visit diagnosis codes from EHRs.
  * Presently, there is no designated vocabulary, domain, or class that represents condition status. The following concepts from SNOMED are recommended:
    * Admitting diagnosis: 4203942
    * Final diagnosis: 4230359 � should also be used for �Discharge diagnosis�
    * Preliminary diagnosis: 4033240