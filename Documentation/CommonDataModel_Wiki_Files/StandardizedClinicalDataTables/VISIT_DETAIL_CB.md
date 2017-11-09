The VISIT_DETAIL table contains detail information about a record in the VISIT_OCCURRENCE table. 

Field|Required|Type|Description
:------------------------|:--------|:-----|:-------------------------------------------------
| visit_detail_id| Yes| integer| A unique identifier for each Person's visit-detail at a healthcare provider.|
| person_id | Yes | integer | A foreign key identifier to the Person for whom the visit is recorded. The demographic details of that Person are stored in the PERSON table.|
| visit_detail_concept_id| Yes | integer | A foreign key that refers to a visit Concept identifier in the Standardized Vocabularies. |
| visit_start_date| Yes |	date  | The start date of the visit.|
| visit_start_datetime | Yes | datetime | The date and time of the visit-detail started.|
| visit_end_date| Yes |	date  | The end date of the visit.|
| visit_end_datetime | No | datetime | The date and time of the visit end.|
| visit_type_concept_id | Yes | integer | A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of source data from which the visit record is derived. |
| provider_id | No | integer | A foreign key to the provider in the provider table who was associated with the visit. |
| care_site_id | No | integer |A foreign key to the care site in the care site table where visit occurred |
| admitting_source_concept_id | No | integer | A foreign key to the predefined concept in the Place of Service Vocabulary reflecting the admitting source for a visit. |
| discharge_to_concept_id | No | integer | A foreign key to the predefined concept in the Place of Service Vocabulary reflecting the discharge disposition (destination) for a visit.|
| preceding_visit_detail_id | No | integer | A foreign key to the visit_occurrence table record of the visit immediately preceding this visit. |
| visit_source_value | No | string | The source code for the visit as it appears in the source data. |
| visit_source_concept_id | No | Integer | A foreign key to a Concept that refers to the code used in the source. |
| admitting_source_value | No | string | The source code for the admitting source as it appears in the source data. |
| discharge_to_source_value | No | string | The source code for the discharge disposition as it appears in the source data.|
| visit_detail_parent_id | No | integer | A foreign key to the visit_detail table record to represent the immediate parent visit-detail record. |
| visit_occurrence_id | Yes | integer | A foreign key that refers to the record in the visit_occurrence table |

### Conventions 

  * For every record in VISIT_OCCURRENCE there may be 0 or more records in VISIT_DETAIL.
  * Records in VISIT_DETAIL will be related to each other sequentially or hierarchically AND will be related to the VISIT_OCCURRENCE table
  
**Example:**
An entire inpatient stay is represented as one record in the VISIT_OCCURRENCE table. The one inpatient stay is comprised of movements within the hospital, such as to the ER, ICU or medical floor. Each of the visit details may have different start
and end datetimes and would each end up as one record in the VISIT_DETAIL table with the same VISIT_OCCURRENCE_ID, related to each other sequentially by using the PRECEDING_VISIT_DETAIL_ID.