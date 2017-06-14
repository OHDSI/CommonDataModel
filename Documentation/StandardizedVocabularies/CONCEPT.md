*OMOP Common Data Model v5.1 Specifications*
<br>*Authors: Christian Reich, Patrick Ryan, Rimma Belenkaya, Karthik Natarajan, Clair Blacketer*
<br>***Release date needed***

[Back to Table of Contents](https://github.com/OHDSI/CommonDataModel/blob/master/Documentation/TableofContents.md)
<br>[Back to Standardized Vocabularies](StandardizedVocabularies.md)

---

# 3.1 CONCEPT

## CONCEPT table 
The Standardized Vocabularies contains records, or Concepts, that uniquely identify each fundamental unit of meaning used to express clinical information in all domain tables of the CDM. Concepts are derived from vocabularies, which represent clinical information across a domain (e.g. conditions, drugs, procedures) through the use of codes and associated descriptions. Some Concepts are designated Standard Concepts, meaning these Concepts can be used as normative expressions of a clinical entity within the OMOP Common Data Model and within standardized analytics. Each Standard Concept belongs to one domain, which defines the location where the Concept would be expected to occur within data tables of the CDM.

Concepts can represent broad categories (like “Cardiovascular disease”), detailed clinical elements (”Myocardial infarction of the anterolateral wall”) or modifying characteristics and attributes that define Concepts at various levels of detail (severity of a disease, associated morphology, etc.).

Records in the Standardized Vocabularies tables are derived from national or international vocabularies such as SNOMED-CT, RxNorm, and LOINC, or custom Concepts defined to cover various aspects of observational data analysis. For a detailed description of these vocabularies, their use in the OMOP CDM and their relationships to each other please refer to the [[documentation:vocabulary|Specifications]].

Field|Required|Type|Description
-----|--------|----|-----------
|concept_id|Yes|integer|A unique identifier for each Concept across all domains.|
|concept_name|Yes|varchar(255)|An unambiguous, meaningful and descriptive name for the Concept.|
|domain_id|Yes|varchar(20)|A foreign key to the [[documentation:cdm:domain|DOMAIN]] table the Concept belongs to.|
|vocabulary_id|Yes|varchar(20)|A foreign key to the [[documentation:cdm:vocabulary|VOCABULARY]] table indicating from which source the Concept has been adapted.|
|concept_class_id|Yes|varchar(20)|The attribute or concept class of the Concept. Examples are “Clinical Drug”, “Ingredient”, “Clinical Finding” etc.|
|standard_concept|No|varchar(1)|This flag determines where a Concept is a Standard Concept, i.e. is used in the data, a Classification Concept, or a non-standard Source Concept. The allowables values are 'S' (Standard Concept) and 'C' (Classification Concept), otherwise the content is NULL.|
|concept_code|Yes|varchar(50)|The concept code represents the identifier of the Concept in the source vocabulary, such as SNOMED-CT concept IDs, RxNorm RXCUIs etc. Note that concept codes are not unique across vocabularies.|
|valid_start_date|Yes|date|The date when the Concept was first recorded. The default value is 1-Jan-1970, meaning, the Concept has no (known) date of inception.|
|valid_end_date|Yes|date|The date when the Concept became invalid because it was deleted or superseded (updated) by a new concept. The default value is 31-Dec-2099, meaning, the Concept is valid until it becomes deprecated.|
|invalid_reason|No|varchar(1)|Reason the Concept was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default value.|

### Conventions 
Concepts in the Common Data Model are derived from a number of public or proprietary terminologies such as SNOMED-CT and RxNorm, or custom generated to standardize aspects of observational data. Both types of Concepts are integrated based on the following rules:
  * All Concepts are maintained centrally by the CDM and Vocabularies Working Group. Additional concepts can be added, as needed, upon request.
  * For all Concepts, whether they are custom generated or adopted from published terminologies, a unique numeric identifier concept_id is assigned and used as the key to link all observational data to the corresponding Concept reference data. 
  * The concept_id of a Concept is persistent, i.e. stays the same for the same Concept between releases of the Standardized Vocabularies.
  * A descriptive name for each Concept is stored as the Concept Name as part of the CONCEPT table. Additional names and descriptions for the Concept are stored as Synonyms in the [CONCEPT_SYNONYM](CONCEPT_SYNONYM.md) table.
  * Each Concept is assigned to a Domain. For Standard Concepts, these is always a single Domain. Source Concepts can be composite or coordinated entities, and therefore can belong to more than one Domain. The domain_id field of the record contains the abbreviation of the Domain, or Domain combination. Please refer to the Standardized Vocabularies [[documentation:vocabulary:domains|Specification]] for details of the Domain Assignment.
  * For details of the Vocabularies adopted for use in the OMOP CDM refer to the Standardized Vocabularies specification.
  * Concept Class designation are attributes of Concepts. Each Vocabulary has its own set of permissible Concept Classes, although the same Concept Class can be used by more than one Vocabulary. Depending on the Vocabulary, the Concept Class may categorize Concepts vertically (parallel) or horizontally (hierarchically). See the specification of each vocabulary for details.
  * Concept Class attributes should not be confused with Classification Concepts. These are separate Concepts that have a hierarchical relationship to Standard Concepts or each other, while Concept Classes are unique Vocabulary-specific attributes for each Concept.
  * For Concepts inherited from published terminologies, the source code is retained in the concept_code field and can be used to reference the source vocabulary.
  * Standard Concepts (designated as 'S' in the standard_concept field) may appear in CDM tables in all *_concept_id fields, whereas Classification Concepts ('C') should not appear in the CDM data, but participate in the construction of the [CONCEPT_ANCESTOR](CONCEPT_ANCESTOR.md) table and can be used to identify Descendants that may appear in the data. See [CONCEPT_ANCESTOR](CONCEPT_ANCESTOR.md) table. Non-standard Concepts can only appear in *_source_concept_id fields and are not used in CONCEPT_ANCESTOR table. Please refer to the Standardized Vocabularies [specifications](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:standard_classification_and_source_concepts) for details of the Standard Concept designation.
  * All logical data elements associated with the various CDM tables (usually in the <domain>_type_concept_id field) are called Type Concepts, including defining characteristics, qualifying attributes etc. They are also stored as Concepts in the CONCEPT table. Since they are generated by OMOP, their is no meaningful concept_code.
  * The lifespan of a Concept is recorded through its valid_start_date, valid_end_date and the invalid_reason fields. This allows Concepts to correctly reflect at which point in time were defined. Usually, Concepts get deprecatd if their meaning was deamed ambigous, a duplication of another Conncept, or needed revision for scientific reason. For example, drug ingredients get updated when different salt or isomer variants enter the market. Usually, drugs taken off the market do not cause a deprecation by the terminology vendor. Since observational data are valid with respect to the time they are recorded, it is key for the Standardized Vocabularies to provide even obsolete codes and maintain their relationships to other current Concepts .
  * Concepts without a known instantiated date are assigned valid_start_date of ‘1-Jan-1970’.
  * Concepts that are not invalid are assigned valid_end_date of ‘31-Dec-2099’.
  * Deprecated Concepts (with a valid_end_date before the release date of the Standardized Vocabularies) will have a value of 'D' (deprecated without successor) or 'U' (updated). The updated Concepts have a record in the [CONCEPT_RELATIONSHIP](CONCEPT_RELATIONSHIP.md) table indicating their active replacement Concept.
  * Values for concept_ids generated as part of Standardized Vocabularies will be reserved from 0 to 2,000,000,000. Above this range, concept_ids are available for local use and are guaranteed not to clash with future releases of the Standardized Vocabularies.
