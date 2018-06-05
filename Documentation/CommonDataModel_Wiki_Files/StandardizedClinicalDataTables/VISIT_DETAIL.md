The VISIT_DETAIL table is an optional table used to represents details of each record in the parent visit_occurrence table. For every record in visit_occurrence table there may be 0 or more records in the visit_detail table with a 1:n relationship where n may be 0. The visit_detail table is structurally very similar to visit_occurrence table and belongs to the similar domain as the visit. 


Field|Required|Type|Description
:------------------------|:--------|:-----|:-------------------------------------------------
|visit_detail_id			|Yes|integer|A unique identifier for each Person's visit or encounter at a healthcare provider.|
|person_id					|Yes|integer|A foreign key identifier to the Person for whom the visit is recorded. The demographic details of that Person are stored in the PERSON table.|
|visit_concept_id			|Yes|integer|A foreign key that refers to a visit Concept identifier in the Standardized Vocabularies.|
|visit_start_date			|Yes|date|The start date of the visit.|
|visit_start_datetime		|No|datetime|The date and time of the visit started.|
|visit_end_date				|Yes|date|The end date of the visit. If this is a one-day visit the end date should match the start date.|
|visit_end_datetime			|No|datetime|The date and time of the visit end.|
|visit_type_concept_id		|Yes|Integer|A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of source data from which the visit record is derived.|
|provider_id				|No|integer|A foreign key to the provider in the provider table who was associated with the visit.|
|care_site_id				|No|integer|A foreign key to the care site in the care site table that was visited.|
|visit_source_value			|No|string(50)|The source code for the visit as it appears in the source data.|
|visit_source_concept_id	|No|Integer|A foreign key to a Concept that refers to the code used in the source.|
|admitting_source_value		|Varchar(50)|	No|	The source code for the admitting source as it appears in the source data.|
|admitting_source_concept_id	|No	|Integer	|A foreign key to the predefined concept in the Place of Service Vocabulary reflecting the admitting source for a visit.|
|discharge_to_source_value	|	No|	Varchar(50)|	The source code for the discharge disposition as it appears in the source data.|
|discharge_to_concept_id	|No	|	Integer	|A foreign key to the predefined concept in the Place of Service Vocabulary reflecting the discharge disposition for a visit.|
|preceding_visit_detail_id	|	No	|Integer|A foreign key to the VISIT_DETAIL table of the visit immediately preceding this visit|
|visit_detail_parent_id		|No	|Integer|	A foreign key to the VISIT_DETAIL table record to represent the immediate parent visit-detail record.|
|visit_occurrence_id		|Yes	|Integer|	A foreign key that refers to the record in the VISIT_OCCURRENCE table. This is a required field, because for every visit_detail is a child of visit_occurrence and cannot exist without a corresponding parent record in visit_occurrence.|

### Conventions 

  * All conventions used in VISIT_OCCURRENCE apply to VISIT_DETAIL, some notable exceptions:
  * A Visit Detail is an optional detail record for each Visit Occurrence to a healthcare facility. For every record in VISIT_DETAIL there has to be a parent VISIT_OCCURRENCE record.
  * One record in VISIT_DETAIL can only have one VISIT_OCCURRENCE parent.
  * A single VISIT_OCCURRENCE record may have many child VISIT_DETAIL records.
  * Valid Visit Concepts belong to the "Visit" domain. Standard Visit Concepts are yet to be defined, but will represent a detail of the Standard Visit Concept in VISIT_OCCURRENCE.
  * Handling of death: In the case when a patient died during admission (VISIT_OCCURRENCE.DISCHARGE_DISPOSITION_CONCEPT_ID = 4216643 'Patient died'), a record in the Death table should be created with DEATH_TYPE_CONCEPT_ID = 44818516 (EHR discharge status "Expired").
  * Source Concepts from place of service vocabularies are mapped into these Standard Visit Concepts in the Standardized Vocabularies. 
  * At any one day, there could be more than one visit. VISIT_OCCURRENCE allows for more than one visit within a single day. VISIT_DETAIL is to be used to only capture details within the visit.
  * One visit may involve multiple providers, in which case, in VISIT_OCCURRENCE, the ETL must specify how a single provider id is selected or leave the provider_id field null. VISIT_DETAIL allows for ETL to speicify multiple child records per visit occurrence - and each of these child records may represent different provider_ids.
  * One visit may involve multiple Care Sites, in which case, in VISIT_OCCURRENCE, the ETL must specify how a single care_site id is selected or leave the care_site_id field null. VISIT_DETAIL allows for ETL to speicify multiple child records per visit occurrence - and each of these child records may represent different care_sites.
  * Just like in VISIT_OCCURRENCE, records in VISIT_DETAIL may be sequentially related to each. These sequential relations are represented using preceding_visit_detail_id
  * Unlike VISIT_OCCURRENCE, VISIT_DETAIL may have nested visits with hierarchial relationships to each other. 
  * Representation of US claim data: US claims data generally has two-levels. Header/summary data that summarizes the entire claim; Line/detail that details a claim. Detail is thus a child of the summary, and for every record in summary there is one or more records in detail. i.e. there will be atleast one FK link from VISIT_DETAIL to VISIT_OCCURRENCE.
 
 Example: an entire inpatient stay maybe one record in the VISIT_OCCURRENCE table. This may have one or more detail records such as ER, ICU, medical floor, rehabilitation floor etc. Each of these visit details may have different start/end date-times, different concept_ids and fact_ids. These would become separate records in VISIT_DETAIL with a FK link to VISIT_OCCURRENCE. 
 
 Each record within VISIT_DETAIL may be related to each other, sequentially –> ER leading to ICU leading to medical floor, leading to rehabilitation, or in hierarchical parent-child visit –> a visit for dialysis while in ICU.

Note the CONCEPT_ID for visits is 8, and is shared between VISIT_OCCURRENCE and VISIT_DETAIL in OMOP CDM. The key deviation from VISIT_OCCURRENCE is
- self-referencing key: a new foreign key visit_detail_parent_id allows self referencing for nested visits.
- VISIT_DETAIL points to its parent record in the VISIT_OCCURRENCE table (visit_occurrence_id)
