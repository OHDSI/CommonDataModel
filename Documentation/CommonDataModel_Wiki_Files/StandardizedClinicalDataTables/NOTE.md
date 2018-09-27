The NOTE table captures unstructured information that was recorded by a provider about a patient in free text notes on a given date.

Field|Required|Type|Description
:--------------------|:--------|:------------|:--------------------------------------------------------
|note_id					|Yes|integer|A unique identifier for each note.|
|person_id					|Yes|integer|A foreign key identifier to the Person about whom the Note was recorded. The demographic details of that Person are stored in the PERSON table.|
|note_event_id				|No |integer|A foreign key identifier to the event (e.g. Measurement, Procedure, Visit, Drug Exposure, etc) record during which the note was recorded.|
|note_event_field_concept_id |No|integer|A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the field to which the note_event_id is referring. |
|note_date 					|Yes|date|The date the note was recorded.|
|note_datetime				|No|datetime|The date and time the note was recorded.|
|note_type_concept_id		|Yes|integer|A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the type, origin or provenance of the Note. These belong to the 'Note Type' vocabulary|
|note_class_concept_id		|Yes|	integer|	A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the HL7 LOINC Document Type Vocabulary classification of the note.|
|note_title					|No|	varchar(250)|	The title of the Note as it appears in the source.|
|note_text					|Yes|varchar(MAX)|The content of the Note.|
|encoding_concept_id		|Yes	|integer|	A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the note character encoding type|
|language_concept_id		|Yes	|integer	|A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the language of the note|
|provider_id				|No|integer|A foreign key to the Provider in the PROVIDER table who took the Note.|
|visit_occurrence_id		|No|integer|A foreign key to the Visit in the VISIT_OCCURRENCE table when the Note was taken.|
|visit_detail_id			|No|integer|A foreign key to the Visit in the VISIT_DETAIL table when the Note was taken.|
|note_source_value			|No|varchar(50)|The source value associated with the origin of the Note|

### Conventions 

No.|Convention Description
:--------|:------------------------------------   
| 1  | The NOTE table contains free text (in ASCII, or preferably in UTF8 format) taken by a healthcare Provider.|
| 2  | The Visit during which the note was written is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.|
| 3  | The Provider making the note is recorded through a reference to the PROVIDER table. This information is not always available.|
| 4  | The type of note_text is CLOB or varchar(MAX) depending on RDBMS|
| 5  | NOTE_CLASS_CONCEPT_ID is a foreign key to the CONCEPT table to describe a standardized combination of five LOINC axes (role, domain, setting, type of service, and document kind). See below for description.|
  
### Mapping of clinical documents to Clinical Document Ontology (CDO) and standard terminology

HL7/LOINC CDO is a standard for consistent naming of documents to support a range of use cases: retrieval, organization, display, and exchange. It guides the creation of LOINC codes for clinical notes. CDO annotates each document with 5 dimensions:

* **Kind of Document:** Characterizes the general structure of the document at a macro level (e.g. Anesthesia Consent)
* **Type of Service**: Characterizes the kind of service or activity (e.g. evaluations, consultations, and summaries). The notion of time sequence, e.g., at the beginning (admission) at the end (discharge) is subsumed in this axis. Example: Discharge Teaching.
* **Setting:** Setting is an extension of CMS�s definitions (e.g. Inpatient, Outpatient)
* **Subject Matter Domain (SMD):** Characterizes the subject matter domain of a note (e.g. Anesthesiology)
* **Role:** Characterizes the training or professional level of the author of the document, but does not break down to specialty or subspecialty (e.g. Physician)

Each combination of these 5 dimensions rolls up to a unique LOINC code. 

* According to CDO requirements, only 2 of the 5 dimensions are required to properly annotate a document: Kind of Document and any one of the other 4 dimensions.
* However, not all the permutations of the CDO dimensions will necessarily yield an existing LOINC code.2 HL7/LOINC workforce is committed to establish new LOINC codes for each new encountered combination of CDO dimensions.
* The full document ontology as it exists in the Vocabulary is too extensive to list here, but it is possible to explore through the ATHENA tool starting with the ['LOINC Document Ontology - Type of Service and Kind of Document'](http://athena.ohdsi.org/search-terms/terms/36209248) by walking through the 'Is a'/'Subsumes' relationship hierarchies. 
