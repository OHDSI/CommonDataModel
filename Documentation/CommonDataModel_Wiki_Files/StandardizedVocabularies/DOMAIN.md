The DOMAIN table includes a list of OMOP-defined Domains the Concepts of the Standardized Vocabularies can belong to. A Domain defines the set of allowable Concepts for the standardized fields in the CDM tables. For example, the "Condition" Domain contains Concepts that describe a condition of a patient, and these Concepts can only be stored in the condition_concept_id field of the [CONDITION_OCCURRENCE](https://github.com/OHDSI/CommonDataModel/wiki/CONDITION_OCCURRENCE) and [CONDITION_ERA](https://github.com/OHDSI/CommonDataModel/wiki/CONDITION_ERA) tables. This reference table is populated with a single record for each Domain and includes a descriptive name for the Domain.

Field|Required|Type|Description
:------------------|:--------|:------------|:----------------------------------
|domain_id|Yes|varchar(20)|A unique key for each domain.|
|domain_name|Yes|varchar(255)|The name describing the Domain, e.g. "Condition", "Procedure", "Measurement" etc.|
|domain_concept_id|Yes|integer|A foreign key that refers to an identifier in the [CONCEPT](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT) table for the unique Domain Concept the Domain record belongs to.|

### Conventions

No.|Convention Description
:--------|:------------------------------------
| 1  | There is one record for each Domain. The domains are defined by the tables and fields in the OMOP CDM that can contain Concepts describing all the various aspects of the healthcare experience of a patient. |
| 2  | The DOMAIN_ID field contains an alphanumerical identifier, that can also be used as the abbreviation of the Domain. |
| 3  | The DOMAIN_NAME field contains the unabbreviated names of the Domain. |
| 4  | Each Domain also has an entry in the Concept table, which is recorded in the DOMAIN_CONCEPT_ID field. This is for purposes of creating a closed Information Model, where all entities in the OMOP CDM are covered by unique Concepts.
| 5  | Versions prior to v5.0.0 of the OMOP CDM did not support the notion of a Domain. |
