The source to concept map table is a legacy data structure within the OMOP Common Data Model, recommended for use in ETL processes to maintain local source codes which are not available as Concepts in the Standardized Vocabularies, and to establish mappings for each source code into a Standard Concept as target_concept_ids that can be used to populate the Common Data Model tables. The SOURCE_TO_CONCEPT_MAP table is no longer populated with content within the Standardized Vocabularies published to the OMOP community. 

Field|Required|Type|Description
:-------------------------|:--------|:------------|:----------------------------
|source_code|Yes|varchar(50)|The source code being translated into a Standard Concept.|
|source_concept_id|Yes|integer|A foreign key to the Source Concept that is being translated into a Standard Concept.|
|source_vocabulary_id|Yes|varchar(20)|A foreign key to the VOCABULARY table defining the vocabulary of the source code that is being translated to a Standard Concept.|
|source_code_description|No|varchar(255)|An optional description for the source code. This is included as a convenience to compare the description of the source code to the name of the concept.|
|target_concept_id|Yes|integer|A foreign key to the target Concept to which the source code is being mapped.|
|target_vocabulary_id|Yes|varchar(20)|A foreign key to the VOCABULARY table defining the vocabulary of the target Concept.|
|valid_start_date|Yes|date|The date when the mapping instance was first recorded.|
|valid_end_date|Yes|date|The date when the mapping instance became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.|
|invalid_reason|No|varchar(1)|Reason the mapping instance was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default value.|

### Conventions 

  * This table is no longer used to distribute mapping information between source codes and Standard Concepts for the Standard Vocabularies. Instead, the CONCEPT_RELATIONSHIP table is used for this purpose, using the relationship_id='Maps to'.
  * However, this table can still be used for the translation of local source codes into Standard Concepts.
  * **Note:** This table should not be used to translate source codes to Source Concepts. The source code of a Source Concept is captured in its concept_code field. If the source codes used in a given database do not follow correct formatting the ETL will have to perform this translation. For example, if ICD-9-CM codes are recorded without a dot the ETL will have to perform a lookup function that allows identifying the correct ICD-9-CM Source Concept (with the dot in the concept_code field).
  * The source_concept_id, or the combination of the fields source_code and the source_vocabulary_id uniquely identifies the source information. It is the equivalent to the concept_id_1 field in the CONCEPT_RELATIONSHIP table.
  * If there is no source_concept_id available because the source codes are local and not supported by the Standard Vocabulary, the content of the field is 0 (zero, not null) encoding an undefined concept. However, local Source Concepts are established (concept_id values above 2,000,000,000).
  * The source_code_description contains an optional description of the source code.
  * The target_concept_id contains the Concept the source code is mapped to. It is equivalent to the concept_id_2 in the CONCEPT_RELATIONSHIP table 
  * The target_vocabulary_id field contains the vocabulary_id of the target concept. It is a duplication of the same information in the CONCEPT record of the Target Concept.
  * The fields valid_start_date, valid_end_date and invalid_reason are used to define the life cycle of the mapping information. Invalid mapping records should not be used for mapping information.
