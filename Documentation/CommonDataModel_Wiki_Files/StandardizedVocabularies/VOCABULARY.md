The VOCABULARY table includes a list of the Vocabularies collected from various sources or created de novo by the OMOP community. This reference table is populated with a single record for each Vocabulary source and includes a descriptive name and other associated attributes for the Vocabulary.

Field|Required|Type|Description
:----------------------|:--------|:-------------|:----------------------------------------
|vocabulary_id|Yes|varchar(20)|A unique identifier for each Vocabulary, such as ICD9CM, SNOMED, Visit.|
|vocabulary_name|Yes|varchar(255)|The name describing the vocabulary, for example "International Classification of Diseases, Ninth Revision, Clinical Modification, Volume 1 and 2 (NCHS)" etc.|
|vocabulary_reference|Yes|varchar(255)|External reference to documentation or available download of the about the vocabulary.|
|vocabulary_version|No|varchar(255)|Version of the Vocabulary as indicated in the source.|
|vocabulary_concept_id|Yes|integer|A foreign key that refers to a standard concept identifier in the CONCEPT table for the Vocabulary the VOCABULARY record belongs to.|

### Conventions

No.|Convention Description
:--------|:------------------------------------
| 1  | There is one record for each Vocabulary. One Vocabulary source or vendor can issue several Vocabularies, each of them creating their own record in the VOCABULARY table. However, the choice of whether a Vocabulary contains Concepts of different Concept Classes, or when these different classes constitute separate Vocabularies cannot precisely be decided based on the definition of what constitutes a Vocabulary. For example, the ICD-9 Volume 1 and 2 codes (ICD9CM, containing predominantly conditions and some procedures and observations) and the ICD-9 Volume 3 codes (ICD9Proc, containing predominantly procedures) are realized as two different Vocabularies. On the other hand, SNOMED-CT codes of the class Condition and those of the class Procedure are part of one and the same Vocabulary. Please refer to the Standardized Vocabularies [specifications](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary) for details of each Vocabulary. |
| 2  | The VOCABULARY_ID field contains an alphanumerical identifier, that can also be used as the abbreviation of the Vocabulary name. |
| 3  | The record with VOCABULARY_ID = 'None' is reserved to contain information regarding the current version of the Entire Standardized Vocabularies. | 
| 4  | The VOCABULARY_NAME field contains the full official name of the Vocabulary, as well as the source or vendor in parenthesis. |
| 5  | Each Vocabulary has an entry in the CONCEPT table, which is recorded in the VOCABULARY_CONCEPT_ID field. This is for purposes of creating a closed Information Model, where all entities in the OMOP CDM are covered by a unique Concept. |
