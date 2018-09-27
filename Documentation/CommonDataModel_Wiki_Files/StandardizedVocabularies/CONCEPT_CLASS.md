The CONCEPT_CLASS table is a reference table, which includes a list of the classifications used to differentiate Concepts within a given Vocabulary. This reference table is populated with a single record for each Concept Class:

Field|Required|Type|Description
:------------------------|:--------|:----------|:---------------------------------------
|concept_class_id|Yes|varchar(20)|A unique key for each class.|
|concept_class_name|Yes|varchar(255)|The name describing the Concept Class, e.g. "Clinical Finding", "Ingredient", etc.|
|concept_class_concept_id|Yes|integer|A foreign key that refers to an identifier in the [CONCEPT](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT) table for the unique Concept Class the record belongs to.|

### Conventions 

No.|Convention Description
:--------|:------------------------------------
| 1  | There is one record for each Concept Class. Concept Classes are used to create additional structure to the Concepts within each Vocabulary. Some Concept Classes are unique to a Vocabulary (for example 'Clinical Finding' in SNOMED), but others can be used across different Vocabularies. The separation of Concepts through Concept Classes can be semantically horizontal (each Class subsumes Concepts of the same hierarchical level, akin to sub-Vocabularies within a Vocabulary) or vertical (each Class subsumes Concepts of a certain kind, going across hierarchical levels). For example, Concept Classes in SNOMED are vertical: The classes "Procedure" and "Clinical Finding" define very granular to very generic Concepts. On the other hand, 'Clinical Drug' and 'Ingredient' Concept Classes define horizontal layers or strata in the RxNorm vocabulary, which all belong to the same concept of a Drug. |
| 2  | The CONCEPT_CLASS_ID field contains an alphanumerical identifier, that can also be used as the abbreviation of the Concept Class. |
| 3  | The CONCEPT_CLASS_NAME field contains the unabbreviated names of the Concept Class. | 
| 4  | Each Concept Class also has an entry in the Concept table, which is recorded in the concept_class_concept_id field. This is for purposes of creating a closed Information Model, where all entities in the OMOP CDM are covered by unique Concepts. |

