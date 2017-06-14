*OMOP Common Data Model v5.1 Specifications*
<br>*Authors: Christian Reich, Patrick Ryan, Rimma Belenkaya, Karthik Natarajan, Clair Blacketer*
<br>***Release date needed***

[Back to Table of Contents](https://github.com/OHDSI/CommonDataModel/blob/master/Documentation/TableofContents.md)
<br>[Back to Standardized Vocabularies](StandardizedVocabularies.md)

---

# 3.3 DOMAIN

The DOMAIN table includes a list of OMOP-defined Domains the Concepts of the Standardized Vocabularies can belong to. A Domain defines the set of allowable Concepts for the standardized fields in the CDM tables. For example, the "Condition" Domain contains Concepts that describe a condition of a patient, and these Concepts can only be stored in the condition_concept_id field of the [CONDITION_OCCURRENCE]() and [CONDITION_ERA]() tables. This reference table is populated with a single record for each Domain and includes a descriptive name for the Domain.

Field|Required|Type|Description
:----|:----|:----|:-----
|domain_id|Yes|varchar(20)|A unique key for each domain.|
|domain_name|Yes|varchar(255)|The name describing the Domain, e.g. "Condition", "Procedure", "Measurement" etc.|
|domain_concept_id|Yes|integer|A foreign key that refers to an identifier in the [CONCEPT](CONCEPT.md) table for the unique Domain Concept the Domain record belongs to.|

## Conventions

  * There is one record for each Domain. The domains are defined by the tables and fields in the OMOP CDM that can contain Concepts describing all the various aspects of the healthcare experience of a patient. 
  * The domain_id field contains an alphanumerical identifier, that can also be used as the abbreviation of the Domain.
  * The domain_name field contains the unabbreviated names of the Domain.
  * Each Domain also has an entry in the Concept table, which is recorded in the domain_concept_id field. This is for purposes of creating a closed Information Model, where all entities in the OMOP CDM are covered by unique Concept.
  * Versions prior to v5.0.0 of the OMOP CDM did not support the notion of a Domain.
