# SURVEY_CONDUCT

The SURVEY_CONDUCT table is used to store an instance of a completed survey or questionnaire. It captures details of the individual questionnaire such as who completed it, when it was completed and to which patient treatment or visit it relates to (if any). Each SURVEY has a SURVEY_CONCEPT_ID, a concept in the CONCEPT table identifying the questionnaire e.g. EQ5D, VR12, SF12. Each questionnaire should exist in the CONCEPT table. Each SURVEY can be optionally related to a specific patient visit in order to link it both to the visit during which it was completed and any subsequent visit where treatment was assigned based on the patient's responses. 

Field                        | Required  | Type        | Description     
:----------------|:-----------------|:------------|:-----------------------------------|
SURVEY_CONDUCT_ID | Yes | integer | Unique identifier for each completed survey.
PERSON_ID | Yes | integer | A foreign key identifier to the Person in the PERSON table about whom the survey was completed.
SURVEY_CONCEPT_ID | Yes | integer | A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the name and identity of the survey.
SURVEY_START_DATE | No | date | Date on which the survey was started.
SURVEY_START_DATETIME | No | datetime | Date and time the survey was started.
SURVEY_END_DATE | Yes | date | Date on which the survey was completed.
SURVEY_END_DATETIME | No | datetime | Date and time the survey was completed.
PROVIDER_ID | No  | integer  | A foreign key to the provider in the provider table who was associated with the survey completion.
ASSISTED_CONCEPT_ID | Yes | integer | A foreign key to the predefined Concept identifier in the Standardized Vocabularies indicating whether the survey was completed with assistance.
RESPONDENT_TYPE_CONCEPT_ID | Yes | integer | A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the respondent type. Example: Research Associate, Patient.
TIMING_CONCEPT_ID | Yes | integer | A foreign key to the predefined Concept identifier in the Standardized Vocabularies that refers to a certain timing. Example: 3 month follow-up, 6 month follow-up.
COLLECTION_METHOD_CONCEPT_ID | Yes | integer | A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the data collection method (e.g. Paper, Telephone, Electronic Questionnaire).
ASSISTED_SOURCE_VALUE | No | varchar(50) | Source value representing whether patient required assistance to complete the survey. Example: “Completed without assistance”, ”Completed with assistance”.
RESPONDENT_TYPE_SOURCE_VALUE | No| varchar(100) | Source code representing role of person who completed the survey.
TIMING_SOURCE_VALUE | No | varchar(100) | Text string representing the timing of the survey. Example: Baseline, 6-month follow-up.
COLLECTION_METHOD_SOURCE_VALUE | No | varchar(100) | The collection method as it appears in the source data.
SURVEY_SOURCE_VALUE | No | varchar(100) | The survey name/title as it appears in the source data.
SURVEY_SOURCE_CONCEPT_ID |Yes| integer | A foreign key to a predefined Concept that refers to the code for the survey name/title used in the source.
SURVEY_SOURCE_IDENTIFIER | No | varchar(100) | Unique identifier for each completed survey in source system.
VALIDATED_SURVEY_CONCEPT_ID | Yes | integer | A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the validation status of the survey.
VALIDATED_SURVEY_SOURCE_VALUE | No | integer | Source value representing the validation status of the survey.
SURVEY_VERSION_NUMBER | No | varchar(20) | Version number of the questionnaire or survey used.
VISIT_OCCURRENCE_ID | No | integer | A foreign key to the VISIT_OCCURRENCE table during which the survey was completed
RESPONSE_VISIT_OCCURRENCE_ID | No | integer  | A foreign key to the visit in the VISIT_OCCURRENCE table during which treatment was carried out that relates to this survey.
                                         
### Conventions 

No.|Convention Description
:--------|:------------------------------------
| 1  | Patient responses to survey questions are stored in the OBSERVATION table. Each record in the OBSERVATION table represents a single question/response pair and is linked to a specific SURVEY/questionnaire using OBSERVATION.DOMAIN_OCCURRENCE_ID and SURVEY.SURVEY_OCCURRENCE_ID. 
| 2  | Each response record is the response to a specific question identified by the OBSERVATION_CONCEPT_ID. This concept ID is a unique question contained in the CONCEPT table.
| 3  | An individual survey question can have multiple responses to a question (e.g. which of these items relate to you, a, b, c ,…?). Each response is stored as a separate record in the OBSERVATION table.<br><ul><li>The name (question) is stored as OBSERVATION_CONCEPT_ID and the value (answer) is stored as OBSERVATION_AS_CONCEPT_ID where the answer is categorical and is defined as a concept in the concept table, OBSERVATION_AS_NUMBER where the answer is numeric, OBSERVATION_AS_STRING where the answer is a free text string or OBSERVATION_AS_DATETIME.
| 4  | The question / answer observation record is linked to the patient questionnaire used for collecting the data using two new fields in the OBSERVATION table; DOMAIN_ID and DOMAIN_OCCURRENCE_ID.<br><ul><li>DOMAIN_ID for any survey related observations contains the text ‘Survey’ and DOMAIN_OCCURRENCE_ID contains the SURVEY_OCCURRENCE_ID of the specific survey.</li><li>This domain construct can be used for other observation groupings.</li></ul>|
| 5  | The OBSERVATION table can also store survey scoring results. Many validated PRO questionnaires have scoring algorithms (many of which proprietary) that return an overall patient score based on the answers provided.<br><ul><li>Survey scores are identified by their OBSERVATION_CONCEPT_ID and are linked back to the scored survey using the same DOMAIN construct described.</li></ul>|
