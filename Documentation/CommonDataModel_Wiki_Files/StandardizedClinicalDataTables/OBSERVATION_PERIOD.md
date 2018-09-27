The OBSERVATION_PERIOD table contains records which uniquely define the spans of time for which a Person is at-risk to have clinical events recorded within the source systems, even if no events in fact are recorded (healthy patient with no healthcare interactions).

Field|Required|Type|Description
:------------------------------|:--------|:------------|:----------------------------------------------
|observation_period_id|Yes|integer|A unique identifier for each observation period.|
|person_id|Yes|integer|A foreign key identifier to the person for whom the observation period is defined. The demographic details of that person are stored in the person table.|
|observation_period_start_date|Yes|date|The start date of the observation period for which data are available from the data source.|
|observation_period_end_date|Yes|date|The end date of the observation period for which data are available from the data source.|
|period_type_concept_id|Yes|Integer|A foreign key identifier to the predefined concept in the Standardized Vocabularies reflecting the source of the observation period information, belonging to the 'Obs Period Type' vocabulary|

### Conventions 

No.|Convention Description
:--------|:------------------------------------   
| 1  | Each Person has to have at least one observation period.|
| 2  | One Person may have one or more disjoint observation periods, during which times analyses may assume that clinical events would be captured if observed|
| 3  | Each Person can have more than one valid OBSERVATION_PERIOD record, but no two observation periods can overlap in time for a given person.|
| 4  | As a general assumption, during an Observation Period any clinical event that happens to the patient is expected to be recorded. Conversely, the absence of data indicates that no clinical events occurred to the patient.
| 5  | Both the _START_DATE and the _END_DATE of the clinical event has to be between observation_period_start_date and observation_period_end_date. |
| 6  | Events CAN fall outside of an observation period though they should fall in a valid payer plan period, such as Medicare Part D, which can overlap an observation period. However, time outside of an observation period cannot be used to identify people. To ensure quality, events outside of an observation period should not be used for analysis. |
| 7  | For claims data, observation periods are inferred from the enrollment periods to a health benefit plan.|
| 8  | For EHR data, the observation period cannot be determined explicitly, because patients usually do not announce their departure from a certain healthcare provider. The ETL will have to apply some heuristic to make a reasonable guess on what the observation_period should be. Refer to the ETL documentation for details. |
