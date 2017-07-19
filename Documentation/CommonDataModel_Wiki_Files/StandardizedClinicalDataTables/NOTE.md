The NOTE table captures unstructured information that was recorded by a provider about a patient in free text notes on a given date.

Field|Required|Type|Description
:--------------------|:--------|:------------|:--------------------------------------------------------
|note_id|Yes|integer|A unique identifier for each note.|
|person_id|Yes|integer|A foreign key identifier to the Person about whom the Note was recorded. The demographic details of that Person are stored in the PERSON table.|
|note_date |Yes|date|The date the note was recorded.|
|note_datetime|No|datetime|The date and time the note was recorded.|
|note_type_concept_id|Yes|integer|A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the type, origin or provenance of the Note.|
|note_class_concept_id|	Yes|	integer|	A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the HL7 LOINC Document Type Vocabulary classification of the note.|
|note_title	|No|	varchar(250)|	The title of the Note as it appears in the source.|
|note_text|Yes|RBDMS dependent text|The content of the Note.|
|encoding_concept_id	|Yes	|integer|	A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the note character encoding type|
|language_concept_id	|Yes	|integer	|A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the language of the note|
|provider_id|No|integer|A foreign key to the Provider in the PROVIDER table who took the Note.|
|note_source_value|No|varchar(50)|The source value associated with the origin of the note|
|visit_occurrence_id|No|integer|Foreign key to the Visit in the VISIT_OCCURRENCE table when the Note was taken.|

### Conventions 
  * The NOTE table contains free text (in ASCII, or preferably in UTF8 format) taken by a healthcare Provider.
  * The Visit during which the note was written is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
  * The Provider making the note is recorded through a reference to the PROVIDER table. This information is not always available.
  * The type of note_text is CLOB or varchar(MAX) depending on RDBMS
  * note_class_concept_id is a foreign key to the CONCEPT table to describe a standardized combination of five LOINC axes (role, domain, setting, type of service, and document kind). See below for description.
  
## Mapping of clinical documents to Clinical Document Ontology (CDO) and standard terminology

HL7/LOINC CDO is a standard for consistent naming of documents to support a range of use cases: retrieval, organization, display, and exchange. It guides the creation of LOINC codes for clinical notes. CDO annotates each document with 5 dimensions:
* **Kind of Document:** Characterizes the generalc structure of the document at a macro level (e.g. Anesthesia Consent)
* **Type of Service:** Characterizes the kind of service or activity (e.g. evaluations, consultations, and summaries). The notion of time sequence, e.g., at the beginning (admission) at the end (discharge) is subsumed in this axis. Example: Discharge Teaching.
* **Setting:** Setting is an extension of CMS’s definitions (e.g. Inpatient, Outpatient)
* **Subject Matter Domain (SMD):** Characterizes the subject matter domain of a note (e.g. Anesthesiology)
* **Role:** Characterizes the training or professional level of the author of the document, but does not break down to specialty or subspecialty (e.g. Physician)

Each combination of these 5 dimensions should roll up to a unique LOINC code. For example, Dentistry Hygienist Outpatient Progress note (LOINC code 34127-1) has the following dimensions:
* According to CDO requirements, only 2 of the 5 dimensions are required to properly annotate a document: Kind of Document and any one of the other 4 dimensions.
* However, not all the permutations of the CDO dimensions will necessarily yield an existing LOINC code.2 HL7/LOINC workforce is committed to establish new LOINC codes for each new encountered combination of CDO dimensions. 3
 
Automation of mapping of clinical notes to a standard terminology based on the note title is possible when it is driven by ontology (aka CDO). Mapping to individual LOINC codes which may or may not exist for a particular note type cannot be fully automated. To support mapping of clinical notes to CDO in OMOP CDM, we propose the following approach:

#### 1.  Add all LOINC concepts representing 5 CDO dimensions to the Concept table. For example:

Field | Record 1 | Record 2
:-- | :-- | :--
concept_id | 55443322132 | 55443322175
concept_name | Administrative note | Against medical advice note
concept_code | LP173418-7 | LP173388-2
vocabulary_id | LOINC | LOINC

#### 2. Represent CDO hierarchy in the Concept_Relationship table using the “Subsumes” – “Is a” relationship pair. For example:

Field | Record 1 | Record 2
:-- | :-- | :--
concept_id_1 | 55443322132 | 55443322175
concept_id_2 | 55443322175 | 55443322132
relationship_id | Subsumes | Is a

#### 3. Add LOINC document codes to the Concept table (e.g. Dentistry Hygienist Outpatient Progress note, LOINC code 34127-1). For example:

Field | Record 1 | Record 2
:-- | :-- | :--
concept_id | 193240 | 193241
concept_name | Dentistry Hygienist Outpatient Progress note | Consult note
concept_code | 34127-1 | 11488-4
vocabulary_id | LOINC | LOINC

#### 4.  Represent dimensions of each document concept in Concept_Relationship table by its relationships to the respective concepts from CDO. 
* Use the “Member Of” – “Has Member”  (new) relationship pair. 
* Using example from the Dentistry Hygienist Outpatient Progress note (LOINC code 34127-1):

concept_id_1 | concept_id_1 | relationship_id
:-- | :-- | :--
193240 | 55443322132 | Member Of
55443322132 | 193240 | Has Member
193240 | 55443322175 | Member Of
55443322175 | 193240 | Has Member
193240 | 55443322166 | Member Of
55443322166 | 193240 | Has Member
193240 | 55443322107 | Member Of
55443322107 | 193240 | Has Member
193240 | 55443322146 | Member Of
55443322146 | 193240 | Has Member

Where concept codes represent the following concepts:

Content | Description
:-- | :--
193240 | Corresponds to LOINC 34127-1, Dentistry Hygienist Outpatient Progress note
55443322132 | Corresponds to LOINC LP173418-7, Kind of Document = Note
55443322175 | Corresponds to LOINC LP173213-2, Type of Service = Progress
55443322166 | Corresponds to LOINC LP173051-6, Setting = Outpatient
55443322107 | Corresponds to LOINC LP172934-4, Subject Matter Domain  = Dentistry
55443322146 | Corresponds to LOINC LP173071-4, Role = Hygienist

Most of the codes will not have all 5 dimensions. Therefore, they may be represented by 2-5 relationship pairs.

#### 5. If LOINC does not have a code corresponding to a permutation of the 5 CDO encountered in the source, this code will be generated as OMOP vocabulary code. 
* Its relationships to the CDO dimensions will be represented exactly as those of existing LOINC concepts (as described above). If/when a proper LOINC code for this permutation is released, the old code should be deprecated.  Transition between the old and new codes should be represented by “Concept replaces” – “Concept replaced by” pairs.

#### 6.  Mapping from the source data will be performed to the 2-5 CDO dimensions.

Query below finds LOINC code for Dentistry Hygienist Outpatient Progress note (see example above) that has all 5 dimensions:

`SELECT 
FROM Concept_Relationship
WHERE relationship_id = ‘Has Member’ AND
(concept_id_1 = 55443322132
OR concept_id_1 = 55443322175
OR concept_id_1 = 55443322166
OR concept_id_1 = 55443322107
OR concept_id_1 = 55443322146)
GROUP BY concept_ID_2
`
If less than 5 dimensions are available, HAVING COUNT(n) clause should be added to get a unique record at the intersection of these dimensions. n is the number of dimensions available:

`SELECT
FROM Concept_Relationship
WHERE relationship_id = ‘Has Member’ AND
(concept_id_1 = 55443322132
OR concept_id_1 = 55443322175
OR concept_id_1 = 55443322146)
GROUP BY concept_ID_2
HAVING COUNT(*) = 3
`