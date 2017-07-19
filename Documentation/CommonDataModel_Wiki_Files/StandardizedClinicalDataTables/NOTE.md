The NOTE table captures unstructured information that was recorded by a provider about a patient in free text notes on a given date.

Field|Required|Type|Description
:--------------------|:--------|:------------|:--------------------------------------------------------
|note_id|Yes|integer|A unique identifier for each note.|
|person_id|Yes|integer|A foreign key identifier to the Person about whom the Note was recorded. The demographic details of that Person are stored in the PERSON table.|
|note_date |Yes|date|The date the note was recorded.|
|note_datetime|No|datetime|The date and time the note was recorded.|
|note_type_concept_id|Yes|integer|A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the type, origin or provenance of the Note.|
|note_text|Yes|RBDMS dependent text|The content of the Note.|
|provider_id|No|integer|A foreign key to the Provider in the PROVIDER table who took the Note.|
|note_source_value|No|varchar(50)|The source value associated with the origin of the note|
|visit_occurrence_id|No|integer|Foreign key to the Visit in the VISIT_OCCURRENCE table when the Note was taken.|

### Conventions 
  * The NOTE table contains free text (in ASCII, or preferably in UTF8 format) taken by a healthcare Provider.
  * The Visit during which the note was written is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
  * The Provider making the note is recorded through a reference to the PROVIDER table. This information is not always available.
  * The type of note_text is CLOB or string(MAX) depending on RDBMS
