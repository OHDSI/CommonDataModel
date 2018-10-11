The VISIT_DETAIL table is an optional table used to represents details of each record in the parent visit_occurrence table. For every record in visit_occurrence table there may be 0 or more records in the visit_detail table with a 1:n relationship where n may be 0. The visit_detail table is structurally very similar to visit_occurrence table and belongs to the similar domain as the visit. 


Field|Required|Type|Description
:------------------------|:--------|:-----|:-------------------------------------------------
|visit_detail_id			|Yes|integer|A unique identifier for each Person's visit or encounter at a healthcare provider.|
|person_id					|Yes|integer|A foreign key identifier to the Person for whom the visit is recorded. The demographic details of that Person are stored in the PERSON table.|
|visit_detail_concept_id			|Yes|integer|A foreign key that refers to a visit Concept identifier in the Standardized Vocabularies belonging to the 'Visit' Vocabulary. |
|visit_detail_start_date			|No|date|The start date of the visit.|
|visit_detail_start_datetime		|Yes|datetime|The date and time of the visit started.|
|visit_detail_end_date				|No|date|The end date of the visit. If this is a one-day visit the end date should match the start date.|
|visit_detail_end_datetime			|Yes|datetime|The date and time of the visit end.|
|visit_detail_type_concept_id		|Yes|Integer|A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of source data from which the visit record is derived belonging to the 'Visit Type' vocabulary. |
|provider_id				|No|integer|A foreign key to the provider in the provider table who was associated with the visit.|
|care_site_id				|No|integer|A foreign key to the care site in the care site table that was visited.|
|visit_detail_source_value			|No|string(50)|The source code for the visit as it appears in the source data.|
|visit_detail_source_concept_id	|Yes|Integer|A foreign key to a Concept that refers to the code used in the source.|
|admitted_from_source_value		|	No|Varchar(50)|	The source code for the admitting source as it appears in the source data.|
|admitted_from_concept_id	|Yes	|Integer	|A foreign key to the predefined concept in the 'Place of Service' Vocabulary reflecting the admitting source for a visit.|
|discharge_to_source_value	|	No|	Varchar(50)|	The source code for the discharge disposition as it appears in the source data.|
|discharge_to_concept_id	|Yes	|	Integer	|A foreign key to the predefined concept in the 'Place of Service' Vocabulary reflecting the discharge disposition for a visit.|
|preceding_visit_detail_id	|No	|Integer|	A foreign key to the VISIT_DETAIL table of the visit immediately preceding this visit|
|visit_detail_parent_id		|	No	|Integer|A foreign key to the VISIT_DETAIL table record to represent the immediate parent visit-detail record.|
|visit_occurrence_id		|	Yes	|Integer|A foreign key that refers to the record in the VISIT_OCCURRENCE table. This is a required field, because for every visit_detail is a child of visit_occurrence and cannot exist without a corresponding parent record in visit_occurrence.|

### Conventions 

All conventions used in VISIT_OCCURRENCE apply to VISIT_DETAIL, with some notable exceptions as detailed below

No.|Convention Description
:--------|:------------------------------------   
| 1  | A Visit Detail is an optional detail record for each Visit Occurrence to a healthcare facility. For every record in VISIT_DETAIL there has to be a parent VISIT_OCCURRENCE record. |
| 2  | One record in VISIT_DETAIL can only have one VISIT_OCCURRENCE parent. |
| 3  | A single VISIT_OCCURRENCE record may have many child VISIT_DETAIL records. |
| 4  | Valid Visit Concepts belong to the 'Visit' domain. Standard Visit Concepts are yet to be defined, but will represent a detail of the Standard Visit Concept in VISIT_OCCURRENCE. |
| 5  | Handling of death: In the case when a patient died during admission (VISIT_DETAIL.DISCHARGE_TO_CONCEPT_ID = 4216643 'Patient died'), a record in the Observation table should be created with OBSERVATION_TYPE_CONCEPT_ID = 44818516 (EHR discharge status 'Expired').|
| 6  | Source Concepts from place of service vocabularies are mapped into these Standard Visit Concepts in the Standardized Vocabularies. |
| 7  | On any one day, there could be more than one visit. VISIT_OCCURRENCE allows for more than one visit within a single day. VISIT_DETAIL is to be used to only capture details within the visit.
| 8  | One visit may involve multiple Providers, in which case, in VISIT_OCCURRENCE, the ETL must specify how a single PROVIDER_ID is selected or leave the PROVIDER_ID field null. VISIT_DETAIL allows for the ETL to specify multiple child records per VISIT_OCCURRENCE - and each of these child records may represent different PROVIDER_IDs.|
| 9  | One visit may involve multiple Care Sites, in which case, in VISIT_OCCURRENCE, the ETL must specify how a single CARE_SITE_ID is selected or leave the CARE_SITE_ID field null. VISIT_DETAIL allows for the ETL to specify multiple child records per visit occurrence - and each of these child records may represent different CARE_SITEs.|
| 10 | Just like in VISIT_OCCURRENCE, records in VISIT_DETAIL may be sequentially related to each. These sequential relations are represented using PRECEDING_VISIT_DETAIL_ID.|
| 11 | Unlike VISIT_OCCURRENCE, VISIT_DETAIL may have nested visits with hierarchical relationships to each other. These relationships are represented using VISIT_DETAIL_PARENT_ID. |
| 12 | In US claims data Header/summary data that summarizes the entire claim and Line/detail that details a claim, detail is thus a child of the summary, and for every record in summary there is one or more records in detail. i.e. there will be at least one foreign key link from VISIT_DETAIL to VISIT_OCCURRENCE.
 
 For example: an entire inpatient stay maybe one record in the VISIT_OCCURRENCE table. This may have one or more detail records such as ER, ICU, medical floor, rehabilitation floor etc. Each of these visit details may have different start/end date-times, different concept_ids and fact_ids. These would become separate records in VISIT_DETAIL with a FK link to VISIT_OCCURRENCE. 
 
 Each record within VISIT_DETAIL may be related to each other, sequentially –> ER leading to ICU leading to medical floor, leading to rehabilitation, or in hierarchical parent-child visit –> a visit for dialysis while in ICU.

Note the domain is Visit, and it is shared between VISIT_OCCURRENCE and VISIT_DETAIL in OMOP CDM. The key deviation from VISIT_OCCURRENCE is
- self-referencing key: a new foreign key visit_detail_parent_id allows self referencing for nested visits.
- VISIT_DETAIL points to its parent record in the VISIT_OCCURRENCE table (visit_occurrence_id)
