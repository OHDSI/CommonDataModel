The CONCEPT_CLASS table is a reference table, which includes a list of the classifications used to differentiate Concepts within a given Vocabulary. This reference table is populated with a single record for each Concept Class:

Field|Required|Type|Description
:------------------------|:--------|:----------|:---------------------------------------
|concept_class_id|Yes|varchar(20)|A unique key for each class.|
|concept_class_name|Yes|varchar(255)|The name describing the Concept Class, e.g. "Clinical Finding", "Ingredient", etc.|
|concept_class_concept_id|Yes|integer|A foreign key that refers to an identifier in the [CONCEPT](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT) table for the unique Concept Class the record belongs to.|

### Conventions 

  * There is one record for each Concept Class. Concept Classes are used to create additional structure to the Concepts within each Vocabulary. Some Concept Classes are unique to a Vocabulary (for example "Clinical Finding" in SNOMED), but others can be used across different Vocabularies. The separation of Concepts through Concept Classes can be semantically horizontal (each Class subsumes Concepts of the same hierarchical level, akin to sub-Vocabularies within a Vocabulary) or vertical (each Class subsumes Concepts of a certain kind, going across hierarchical levels). For example, Concept Classes in SNOMED are vertical: The classes "Procedure" and "Clinical Finding" define very granular to very generic Concepts. On the other hand, "Clinical Drug" and "Ingredient" Concept Classes define horizontal layers or strata in the RxNorm vocabulary, which all belong to the same concept of a Drug.
  * The concept_class_id field contains an alphanumerical identifier, that can also be used as the abbreviation of the Concept Class.
  * The concept_class_name field contains the unabbreviated names of the Concept Class.
  * Each Concept Class also has an entry in the Concept table, which is recorded in the concept_class_concept_id field. This is for purposes of creating a closed Information Model, where all entities in the OMOP CDM are covered by unique Concepts.
  * Past versions of the OMOP CDM did not have a separate reference table for all Concept Classes. Also, the content of the old concept_class and the new concept_class_id fields are not always identical. A conversion table can be found here:

Previous CONCEPT_CLASS|Version 5 CONCEPT_CLASS_ID
:------------------------------|:----------------------------------------------
|Administrative concept|Admin Concept|
|Admitting Source|Admitting Source|
|Anatomical Therapeutic Chemical Classification|ATC|
|Anatomical Therapeutic Chemical Classification|ATC|
|APC|Procedure|
|Attribute|Attribute|
|Biobank Flag|Biobank Flag|
|Biological function|Biological Function|
|Body structure|Body Structure|
|Brand Name|Brand Name|
|Branded Drug|Branded Drug|
|Branded Drug Component|Branded Drug Comp|
|Branded Drug Form|Branded Drug Form|
|Branded Pack|Branded Pack|
|CCS_DIAGNOSIS|Condition|
|CCS_PROCEDURES|Procedure|
|Chart Availability|Chart Availability|
|Chemical Structure|Chemical Structure|
|Clinical Drug|Clinical Drug|
|Clinical Drug Component|Clinical Drug Comp|
|Clinical Drug Form|Clinical Drug Form|
|Clinical finding|Clinical Finding|
|Clinical Pack|Clinical Pack|
|Concept Relationship|Concept Relationship|
|Condition Occurrence Type|Condition Occur Type|
|Context-dependent category|Context-dependent|
|CPT-4|Procedure|
|Currency|Currency|
|Death Type|Death Type|
|Device Type|Device Type|
|Discharge Disposition|Discharge Dispo|
|Discharge Status|Discharge Status|
|Domain|Domain|
|Dose Form|Dose Form|
|DRG|Diagnostic Category|
|Drug Exposure Type|Drug Exposure Type|
|Drug Interaction|Drug Interaction|
|Encounter Type|Encounter Type|
|Enhanced Therapeutic Classification|ETC|
|Enrollment Basis|Enrollment Basis|
|Environment or geographical location|Location|
|Ethnicity|Ethnicity|
|Event|Event|
|Gender|Gender|
|HCPCS|Procedure|
|Health Care Provider Specialty|Provider Specialty|
|HES specialty|Provider Specialty|
|High Level Group Term|HLGT|
|High Level Term|HLT|
|Hispanic|Hispanic|
|ICD-9-Procedure|Procedure|
|Indication or Contra-indication|Ind / CI|
|Ingredient|Ingredient|
|LOINC Code|Measurement|
|LOINC Multidimensional Classification|Meas Class|
|Lowest Level Term|LLT|
|MDC|Diagnostic Category|
|Measurement Type|Meas Type|
|Mechanism of Action|Mechanism of Action|
|Model component|Model Comp|
|Morphologic abnormality|Morph Abnormality|
|MS-DRG|Diagnostic Category|
|Namespace concept|Namespace Concept|
|Note Type|Note Type|
|Observable entity|Observable Entity|
|Observation Period Type|Obs Period Type|
|Observation Type|Observation Type|
|OMOP DOI cohort|Drug Cohort|
|OMOP HOI cohort|Condition Cohort|
|OPCS-4|Procedure|
|Organism|Organism|
|Patient Status|Patient Status|
|Pharmaceutical / biologic product|Pharma/Biol Product|
|Pharmaceutical Preparations|Pharma Preparation|
|Pharmacokinetics|PK|
|Pharmacologic Class|Pharmacologic Class|
|Physical force|Physical Force|
|Physical object|Physical Object|
|Physiologic Effect|Physiologic Effect|
|Place of Service|Place of Service|
|Preferred Term|PT|
|Procedure|Procedure|
|Procedure Occurrence Type|Procedure Occur Type|
|Qualifier value|Qualifier Value|
|Race|Race|
|Record artifact|Record Artifact|
|Revenue Code|Revenue Code|
|Sex|Gender|
|Social context|Social Context|
|Special concept|Special Concept|
|Specimen|Specimen|
|Staging and scales|Staging / Scales|
|Standardized MedDRA Query|SMQ|
|Substance|Substance|
|System Organ Class|SOC|
|Therapeutic Class|Therapeutic Class|
|UCUM|Unit|
|UCUM Canonical|Canonical Unit|
|UCUM Custom|Unit|
|UCUM Standard|Unit|
|Undefined|Undefined|
|UNKNOWN|Undefined|
|VA Class|Drug Class|
|VA Drug Interaction|Drug Interaction|
|VA Product|Drug Product|
|Visit|Visit|
|Visit Type|Visit Type|
