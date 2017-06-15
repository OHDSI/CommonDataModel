*OMOP Common Data Model v5.1 Specifications*
<br>*Authors: Christian Reich, Patrick Ryan, Rimma Belenkaya, Karthik Natarajan, Clair Blacketer*
<br>***Release date needed***

[Back to Table of Contents](https://github.com/OHDSI/CommonDataModel/blob/master/Documentation/TableofContents.md)
<br>[Back to Standardized Vocabularies](StandardizedVocabularies.md)

---

# 3.7 CONCEPT_SYNONYM

The CONCEPT_SYNONYM table is used to store alternate names and descriptions for Concepts. 

Field|Required|Type|Description
:----|:----|:----|:----
|concept_id|Yes|Integer|A foreign key to the Concept in the CONCEPT table.|
|concept_synonym_name|Yes|varchar(1000)|The alternative name for the Concept.|
|language_concept_id|Yes|integer|A foreign key to a Concept representing the language.|

## Conventions 

  * The concept_name field contains a valid Synonym of a concept, including the description in the concept_name itself. I.e. each Concept has at least one Synonym in the CONCEPT_SYNONYM table. As an example, for a SNOMED-CT Concept, if the fully specified name is stored as the concept_name of the CONCEPT table, then the Preferred Term and Synonyms associated with the Concept are stored in the CONCEPT_SYNONYM table. 
  * Only Synonyms that are active and current are stored in the CONCEPT_SYNONYM table. Tracking synonym/description history and mapping of obsolete synonyms to current Concepts/Synonyms is out of scope for the Standard Vocabularies.
  * Currently, only English Synonyms are included.
