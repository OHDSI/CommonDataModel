The OBSERVATION_PERIOD table contains records which uniquely define the spans of time for which a Person is at-risk to have clinical events recorded within the source systems, even if no events in fact are recorded (healthy patient with no healthcare interactions).

Field|Required|Type|Description
:------------------------------|:--------|:------------|:----------------------------------------------
|observation_period_id|Yes|integer|A unique identifier for each observation period.|
|person_id|Yes|integer|A foreign key identifier to the person for whom the observation period is defined. The demographic details of that person are stored in the person table.|
|observation_period_start_date|Yes|date|The start date of the observation period for which data are available from the data source.|
|observation_period_end_date|Yes|date|The end date of the observation period for which data are available from the data source.|
|period_type_concept_id|Yes|Integer|A foreign key identifier to the predefined concept in the Standardized Vocabularies reflecting the source of the observation period information|

### Conventions 

  * One Person may have one or more disjoint observation periods, during which times analyses may assume that clinical events would be captured if observed, and outside of which no clinical events may be recorded.
  * Each Person can have more than one valid OBSERVATION_PERIOD record, but no two observation periods can overlap in time for a given person.
  * As a general assumption, during an Observation Period any clinical event that happens to the patient is expected to be recorded. Conversely, the absence of data indicates that no clinical events occurred to the patient.
  * No clinical data are valid outside an active Observation Period. Clinical data that refer to a time outside (diagnoses of previous conditions such as "Old MI" or medical history) of an active Observation Period are recorded as Observations. The date of the Observation is the first day of the first Observation Period of a patient.
  * For claims data, observation periods are inferred from the enrollment periods to a health benefit plan.
  * For EHR data, the observation period cannot be determined explicitly, because patients usually do not announce their departure from a certain healthcare provider. The ETL will have to apply some heuristic to make a reasonable guess on what the observation_period should be. Refer to the ETL documentation for details.
