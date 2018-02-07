The VOCABULARY table includes a list of the Vocabularies collected from various sources or created de novo by the OMOP community. This reference table is populated with a single record for each Vocabulary source and includes a descriptive name and other associated attributes for the Vocabulary.

Field|Required|Type|Description
:----------------------|:--------|:-------------|:----------------------------------------
|vocabulary_id|Yes|varchar(20)|A unique identifier for each Vocabulary, such as ICD9CM, SNOMED, Visit.|
|vocabulary_name|Yes|varchar(255)|The name describing the vocabulary, for example "International Classification of Diseases, Ninth Revision, Clinical Modification, Volume 1 and 2 (NCHS)" etc.|
|vocabulary_reference|Yes|varchar(255)|External reference to documentation or available download of the about the vocabulary.|
|vocabulary_version|No|varchar(255)|Version of the Vocabulary as indicated in the source.|
|vocabulary_concept_id|Yes|integer|A foreign key that refers to a standard concept identifier in the CONCEPT table for the Vocabulary the VOCABULARY record belongs to.|

### Conventions

  * There is one record for each Vocabulary. One Vocabulary source or vendor can issue several Vocabularies, each of them creating their own record in the VOCABULARY table. However, the choice of whether a Vocabulary contains Concepts of different Concept Classes, or when these different classes constitute separate Vocabularies cannot precisely be decided based on the definition of what constitutes a Vocabulary. For example, the ICD-9 Volume 1 and 2 codes (ICD9CM, containing predominantly conditions and some procedures and observations) and the ICD-9 Volume 3 codes (ICD9Proc, containing predominantly procedures) are realized as two different Vocabularies. On the other hand, SNOMED-CT codes of the class Condition and those of the class Procedure are part of one and the same Vocabulary. Please refer to the Standardized Vocabularies [specifications](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary) for details of each Vocabulary.

  * The vocabulary_id field contains an alphanumerical identifier, that can also be used as the abbreviation of the Vocabulary name.
  * The record with vocabulary_id = 'None' is reserved to contain information regarding the current version of the Entire Standardized Vocabularies.
  * The vocabulary_name field contains the full official name of the Vocabulary, as well as the source or vendor in parenthesis.
  * Each Vocabulary has an entry in the CONCEPT table, which is recorded in the vocabulary_concept_id field. This is for purposes of creating a closed Information Model, where all entities in the OMOP CDM are covered by a unique Concept.
  * In past versions of the VOCABULARY table, the vocabulary_id used to be a numerical value. A conversion table between these old and new IDs is given below:

Previous VOCABULARY_ID|Version 5 VOCABULARY_ID 
----------------------|------------------
|0|None|
|1|[SNOMED](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:snomed)|
|2|[ICD9CM](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:icd9cm)|
|3|ICD9Proc|
|4|[CPT4](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:cpt4)|
|5|HCPCS|
|6|[LOINC](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:loinc)|
|7|NDFRT|
|8|[RxNorm](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:rxnorm)|
|9|[NDC](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:ndc)|
|10|GPI|
|11|[UCUM](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:ucum)|
|12|[Gender](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:gender)|
|13|Race|
|14|Place of Service|
|15|MedDRA|
|16|Multum|
|17|Read|
|18|OXMIS|
|19|Indication|
|20|ETC|
|21|[ATC](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:atc)|
|22|Multilex|
|24|Visit|
|28|VA Product|
|31|SMQ|
|32|VA Class|
|33|Cohort|
|34|[ICD10](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:icd10)|
|35|[ICD10PCS](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:icd10pcs)|
|36|Drug Type|
|37|Condition Type|
|38|Procedure Type|
|39|Observation Type|
|40|DRG|
|41|MDC|
|42|APC|
|43|Revenue Code|
|44|[Ethnicity](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:ethnicity)|
|45|Death Type|
|46|[Mesh](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:mesh)|
|47|NUCC|
|48|Specialty|
|49|[LOINC](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:loinc)|
|50|SPL|
|53|Genseqno|
|54|CCS|
|55|OPCS4|
|56|Gemscript|
|57|HES Specialty|
|58|Note Type|
|59|Domain|
|60|PCORNet|
|61|Obs Period Type|
|62|Visit Type|
|63|Device Type|
|64|Meas Type|
|65|[Currency](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:currency)|
|66|Relationship|
|67|Vocabulary|
|68|Concept Class|
|69|Cohort Type|
|70|[ICD10CM](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:icd10cm)|