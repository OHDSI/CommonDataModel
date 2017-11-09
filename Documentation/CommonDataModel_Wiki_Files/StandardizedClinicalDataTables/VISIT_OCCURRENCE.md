The VISIT_OCCURRENCE table contains the spans of time a Person continuously receives medical services from one or more providers at a Care Site in a given setting within the health care system. Visits are classified into 4 settings: outpatient care, inpatient confinement, emergency room, and long-term care. Persons may transition between these settings over the course of an episode of care (for example, treatment of a disease onset). 

Field|Required|Type|Description
:------------------------|:--------|:-----|:-------------------------------------------------
|visit_occurrence_id|Yes|integer|A unique identifier for each Person's visit or encounter at a healthcare provider.|
|person_id|Yes|integer|A foreign key identifier to the Person for whom the visit is recorded. The demographic details of that Person are stored in the PERSON table.|
|visit_concept_id|Yes|integer|A foreign key that refers to a visit Concept identifier in the Standardized Vocabularies.|
|visit_start_date|Yes|date|The start date of the visit.|
|visit_start_datetime|No|datetime|The date and time of the visit started.|
|visit_end_date|Yes|date|The end date of the visit. If this is a one-day visit the end date should match the start date.|
|visit_end_datetime|No|datetime|The date and time of the visit end.|
|visit_type_concept_id|Yes|Integer|A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of source data from which the visit record is derived.|
|provider_id|No|integer|A foreign key to the provider in the provider table who was associated with the visit.|
|care_site_id|No|integer|A foreign key to the care site in the care site table that was visited.|
|visit_source_value|No|varchar(50)|The source code for the visit as it appears in the source data.|
|visit_source_concept_id|No|integer|A foreign key to a Concept that refers to the code used in the source.|
|admitting_source_concept_id|	|integer	|No	|A foreign key to the predefined concept in the Place of Service Vocabulary reflecting the admitting source for a visit.|
|admitting_source_value	|varchar(50)|	No|	The source code for the admitting source as it appears in the source data.|
|discharge_to_concept_id|	integer	|No	|A foreign key to the predefined concept in the Place of Service Vocabulary reflecting the discharge disposition for a visit.|
|discharge_to_source_value|	varchar(50)|	No|	The source code for the discharge disposition as it appears in the source data.|
|preceding_visit_occurrence_id	|integer|	No	|A foreign key to the VISIT_OCCURRENCE table of the visit immediately preceding this visit|

### Conventions 

  * A Visit Occurrence is recorded for each visit to a healthcare facility. 
  * Valid Visit Concepts belong to the "Visit" domain. 
  * Standard Visit Concepts are defined as Inpatient Visit, Outpatient Visit, Emergency Room Visit, Long Term Care Visit and combined ER and Inpatient Visit. The latter is necessary because it is close to impossible to separate the two in many EHR system, treating them interchangeably. To annotate this correctly, the visit concept "Emergency Room and Inpatient Visit" (concept_id=262) should be used.
  * Handling of death: In the case when a patient died during admission (Visit_Occurrence. discharge_disposition_concept_id = 4216643 'Patient died'), a record in the Death table should be created with death_type_concept_id = 44818516 (EHR discharge status "Expired").
  * Source Concepts from place of service vocabularies are mapped into these standard visit Concepts in the Standardized Vocabularies. 
  * At any one day, there could be more than one visit.
  * One visit may involve multiple providers, in which case the ETL must specify how a single provider id is selected or leave the provider_id field null.
  * One visit may involve multiple Care Sites, in which case the ETL must specify how a single care_site id is selected or leave the care_site_id field null.
  * Visits are recorded in various data sources in different forms with varying levels of standardization. For example:
    * Medical Claims include Inpatient Admissions, Outpatient Services, and Emergency Room visits. 
    * Electronic Health Records may capture Person visits as part of the activities recorded depending whether the EHR system is used at the different Care Sites.
  * In addition to the "Place of Service" vocabulary the following SNOMED concepts for discharge disposition can be used:
    * Patient died: 4216643
	* Absent without leave: 44814693
	* Patient self-discharge against medical advice: 4021968
  * In the case where a patient died during admission (Visit_Occurrence.discharge_disposition_concept_id = 4216643 �Patient died�), a record in the Death table should be created with death_type_concept_id = 44818516 (�EHR discharge status "Expired").
  * PRECEDING_VISIT_ID can be used to link a visit immediately preceding the current visit
  * Some EMR systems combine emergency room followed by inpatient admission into one visit, and it is close to impossible to separate the two. To annotate this visit type, a new visit concept "Emergency Room and Inpatient Visit" was added (CONCEPT_ID 262).