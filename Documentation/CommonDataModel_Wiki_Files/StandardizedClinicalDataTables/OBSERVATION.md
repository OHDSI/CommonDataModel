The OBSERVATION table captures clinical facts about a Person obtained in the context of examination, questioning or a procedure. Any data that cannot be represented by any other domains, such as social and lifestyle facts, medical history, family history, etc. are recorded here.

Field|Required|Type|Description
:----------------------------------|:--------|:------------|:------------------------------------
|observation_id						|Yes|integer|A unique identifier for each observation.|
|person_id							|Yes|integer|A foreign key identifier to the Person about whom the observation was recorded. The demographic details of that Person are stored in the PERSON table.|
|observation_concept_id				|Yes|integer|A foreign key to the standard observation concept identifier in the Standardized Vocabularies.|
|observation_date|No|date|The date of the observation.|
|observation_datetime|Yes|datetime|The date and time of the observation.|
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
|observation_source_concept_id|Yes|integer|A foreign key to a Concept that refers to the code used in the source.|
|unit_source_value|No|varchar(50)|The source code for the unit as it appears in the source data. This code is mapped to a standard unit concept in the Standardized Vocabularies and the original code is, stored here for reference.|
|qualifier_source_value|No|varchar(50)|The source value associated with a qualifier to characterize the observation|
|observation_event_id| No | integer| A foreign key to an event table (e.g., PROCEDURE_OCCURRENCE_ID). |
|obs_event_field_concept_id| Yes | integer| A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies referring to the field represented in the OBSERVATION_EVENT_ID. |
|value_as_datetime| No | integer| The observation result stored as a datetime value. This is applicable to observations where the result is expressed as a point in time.|

### Conventions 

No.|Convention Description
:--------|:------------------------------------   
| 1  | Observations differ from Measurements in that they do not require a standardized test or some other activity to generate clinical fact. Typical observations are medical history, family history, the stated need for certain treatment, social circumstances, lifestyle choices, healthcare utilization patterns, etc. If the generation clinical facts requires a standardized testing such as lab testing or imaging and leads to a standardized result, the data item is recorded in the MEASUREMENT table. If the clinical fact observed determines a sign, symptom, diagnosis of a disease or other medical condition, it is recorded in the CONDITION_OCCURRENCE table. |
| 2  | Valid Observation Concepts are not enforced to be from any domain. They still should be Standard Concepts, and they typically belong to the 'Observation' or sometimes 'Measurement' domain. |
| 3  | Observations can be stored as attribute value pairs, with the attribute as the Observation Concept and the value representing the clinical fact. This fact can be a Concept (stored in VALUE_AS_CONCEPT), a numerical value (VALUE_AS_NUMBER), a verbatim string (VALUE_AS_STRING), or a datetime (VALUE_AS_DATETIME). Even though Observations do not have an explicit result, the clinical fact can be stated separately from the type of Observation in the VALUE_AS_* fields.
| 4  | It is recommended for Observations that are suggestive statements of positive assertion should have a value of 'Yes' (concept_id=4188539), recorded, even though the null value is the equivalent. |
| 5  | Valid Concepts of the VALUE_AS_CONCEPT field are not enforced, but typically belong to the 'Meas Value' domain.|
| 6  | For numerical facts a Unit can be provided in the UNIT_CONCEPT_ID.|
| 7  | For facts represented as Concepts no domain membership is enforced.|
| 8  | Note that the value of VALUE_AS_CONCEPT_ID may be provided through mapping from a source Concept which contains the content of the Observation. In those situations, the CONCEPT_RELATIONSHIP table in addition to the 'Maps to' record contains a second record with the relationship_id set to 'Maps to value'. For example, ICD9CM V17.5 concept_id 44828510 'Family history of asthma' has a 'Maps to' relationship to 4167217 'Family history of clinical finding' as well as a 'Maps to value' record to 317009 'Asthma'. |
| 9  | The QUALIFIER_CONCEPT_ID field contains all attributes specifying the clinical fact further, such as as degrees, severities, drug-drug interaction alerts etc. |
| 10 | The Visit during which the Observation was made is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.|
| 11 | The Visit Detail during which the Observation was made is recorded through a reference to the VISIT_DETAIL table. This information is not always available.|
| 12 | The Provider making the observation is recorded through a reference to the PROVIDER table. This information is not always available. |
| 13 | When storing patient responses to survey questions, each record in the OBSERVATION table represents a single question/response pair and is linked to a specific survey/questionnaire using OBSERVATION.OBSERVATION_EVENT_ID and SURVEY_CONDUCT.SURVEY_CONDUCT_ID. |
| 14 | Each survey response record is the response to a specific question identified by the OBSERVATION_CONCEPT_ID. This concept ID is a unique question contained in the CONCEPT table. |
| 15 | An individual survey question can have multiple responses to a question (e.g. which of these items relate to you, a,b,c,...?). Each response is stored as a separate record in the OBSERVATION table.|
| 16 | The question / answer OBSERVATION record is linked to the patient questionnaire used for collecting the data using two new fields in the OBSERVATION table; OBS_EVENT_FIELD_CONCEPT_ID and OBSERVATION_EVENT_ID.<br><ul><li>OBS_EVENT_FIELD_CONCEPT_ID for any survey related observations contains the concept that refers to the field SURVEY_CONDUCT_ID and OBSERVATION_EVENT_ID contains the actual SURVEY_CONDUCT_ID of the specific survey</li><li>This construct can be used for other observation groupings</li></ul> |
| 17 | The OBSERVATION table can also store survey scoring results. Many validated PRO questionnaires have scoring algorithms (many of which proprietary) that return an overall patient score based on the answers provided.<br><ul><li>Survey scores are identified by their OBSERVATION_CONCEPT_ID and are linked back to the scored survey using the same EVENT_FIELD construct described above. In the name/value pair model, the name (question) is stored as OBSERVATION_CONCEPT_ID and the value (answer) is stored as OBSERVATION_AS_CONCEPT_ID where the answer is categorical and is defined as a concept in the concept table, OBSERVATION_AS_NUMBER where the answer is numeric, OBSERVATION_AS_STRING where the answer is a free text string or OBSERVATION_AS_DATETIME.</li></ul>|
