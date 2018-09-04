The OBSERVATION table captures clinical facts about a Person obtained in the context of examination, questioning or a procedure. Any data that cannot be represented by any other domains, such as social and lifestyle facts, medical history, family history, etc. are recorded here.

Field|Required|Type|Description
:----------------------------------|:--------|:------------|:------------------------------------
|observation_id						|Yes|integer|A unique identifier for each observation.|
|person_id							|Yes|integer|A foreign key identifier to the Person about whom the observation was recorded. The demographic details of that Person are stored in the PERSON table.|
|observation_concept_id				|Yes|integer|A foreign key to the standard observation concept identifier in the Standardized Vocabularies.|
|observation_date|Yes|date|The date of the observation.|
|observation_datetime|No|datetime|The date and time of the observation.|
|observation_type_concept_id|Yes|integer|A foreign key to the predefined concept identifier in the Standardized Vocabularies reflecting the type of the observation.|
|value_as_number|No|float|The observation result stored as a number. This is applicable to observations where the result is expressed as a numeric value.|
|value_as_string|No|varchar(60)|The observation result stored as a string. This is applicable to observations where the result is expressed as verbatim text.|
|value_as_concept_id|No|Integer|A foreign key to an observation result stored as a Concept ID. This is applicable to observations where the result can be expressed as a Standard Concept from the Standardized Vocabularies (e.g., positive/negative, present/absent, low/high, etc.).|
|qualifier_concept_id|No|integer|A foreign key to a Standard Concept ID for a qualifier (e.g., severity of drug-drug interaction alert)|
|unit_concept_id|No|integer|A foreign key to a Standard Concept ID of measurement units in the Standardized Vocabularies.|
|provider_id|No|integer|A foreign key to the provider in the PROVIDER table who was responsible for making the observation.|
|visit_occurrence_id|No|integer|A foreign key to the visit in the VISIT_OCCURRENCE table during which the observation was recorded.|
|visit_detail_id|No|integer|A foreign key to the visit in the VISIT_DETAIL table during which the observation was recorded.|
|observation_source_value|No|varchar(50)|The observation code as it appears in the source data. This code is mapped to a Standard Concept in the Standardized Vocabularies and the original code is, stored here for reference.|
|observation_source_concept_id|No|integer|A foreign key to a Concept that refers to the code used in the source.|
|unit_source_value|No|varchar(50)|The source code for the unit as it appears in the source data. This code is mapped to a standard unit concept in the Standardized Vocabularies and the original code is, stored here for reference.|
|qualifier_source_value|No|varchar(50)|The source value associated with a qualifier to characterize the observation|

### Conventions 

  * Observations differ from Measurements in that they do not require a standardized test or some other activity to generate clinical fact. Typical observations are medical history, family history, the stated need for certain treatment, social circumstances, lifestyle choices, healthcare utilization patterns, etc. If the generation clinical facts requires a standardized testing such as lab testing or imaging and leads to a standardized result, the data item is recorded in the MEASUREMENT table. If the clinical fact observed determines a sign, symptom, diagnosis of a disease or other medical condition, it is recorded in the CONDITION_OCCURRENCE table.
  * Valid Observation Concepts are not enforced to be from any domain. They still should be Standard Concepts, and they typically belong to the "Observation" or sometimes "Measurement" domain.
  * Observation can be stored as attribute value pairs, with the attribute as the Observation Concept and the value representing the clinical fact. This fact can be a Concept (stored in value_as_concept), a numerical value (value_as_number) or a verbatim string (value_as_string). Even though Observations do not have an explicit result, the clinical fact can be stated separately from the type of Observation in the value_as_ fields.
  * It is recommended for observations that are suggestive statements of positive assertion should have a value of "Yes" (concept_id=4188539), recorded, even though the null value is the equivalent. 
  * Valid Concepts of the value_as_concept field are not enforced, but typically belong to the "Meas Value" domain.
  * For numerical facts a Unit can be provided in the unit_concept_id.
  * For facts represented as Concepts no domain membership is enforced.
  * Note that the value of value_as_concept_id may be provided through mapping from a source Concept which contains the content of the Observation. In those situations, the CONCEPT_RELATIONSHIP table in addition to the "Maps to" record contains a second record with the relationship_id set to "Maps to value". For example, ICD9CM V17.5 concept_id 44828510 "Family history of asthma" has a "Maps to" relationship to 4167217 "Family history of clinical finding" as well as a "Maps to value" record to 317009 "Asthma".
  * The qualifier_concept_id field contains all attributes specifying the clinical fact further, such as as degrees, severities, drug-drug interaction alerts etc.
  * The Visit during which the observation was made is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
  * The Provider making the observation is recorded through a reference to the PROVIDER table. This information is not always available.
