The RELATIONSHIP table provides a reference list of all types of relationships that can be used to associate any two concepts in the CONCEPT_RELATIONSHP table. 

Field|Required|Type|Description
:-----------------------|:--------|:------------|:-----------------------------------------
|relationship_id|Yes|varchar(20)| The type of relationship captured by the relationship record.|
|relationship_name|Yes|varchar(255)| The text that describes the relationship type.|
|is_hierarchical|Yes|varchar(1)|Defines whether a relationship defines concepts into classes or hierarchies. Values are 1 for hierarchical relationship or 0 if not.|
|defines_ancestry|Yes|varchar(1)|Defines whether a hierarchical relationship contributes to the concept_ancestor table. These are subsets of the hierarchical relationships. Valid values are 1 or 0.|
|reverse_relationship_id|Yes|varchar(20)|The identifier for the relationship used to define the reverse relationship between two concepts.|
|relationship_concept_id|Yes|integer|A foreign key that refers to an identifier in the CONCEPT table for the unique relationship concept.|

### Conventions

No.|Convention Description
:--------|:------------------------------------
| 1  | There is one record for each Relationship. |
| 2  | Relationships are classified as hierarchical (parent-child) or non-hierarchical (lateral)|
| 3  | They are used to determine which concept relationship records should be included in the computation of the CONCEPT_ANCESTOR table. |
| 4  | The RELATIONSHIP_ID field contains an alphanumerical identifier, that can also be used as the abbreviation of the Relationship. |
| 5  | The RELATIONSHIP_NAME field contains the unabbreviated names of the Relationship. | 
| 6  | Relationships all exist symmetrically, i.e. in both direction. The RELATIONSHIP_ID of the opposite Relationship is provided in the REVERSE_RELATIONSHIP_ID field. |
| 7  | Each Relationship also has an equivalent entry in the Concept table, which is recorded in the RELATIONSHIP_CONCEPT_ID field. This is for purposes of creating a closed Information Model, where all entities in the OMOP CDM are covered by unique Concepts. |
| 8  | Hierarchical Relationships are used to build a hierarchical tree out of the Concepts, which is recorded in the CONCEPT_ANCESTOR table. For example, 'has_ingredient' is a Relationship between Concept of the Concept Class 'Clinical Drug' and those of 'Ingredient', and all Ingredients can be classified as the 'parental' hierarchical Concepts for the drug products they are part of. All 'Is a' Relationships are hierarchical. |
| 9  | Relationships, also hierarchical, can be between Concepts within the same Vocabulary or those adopted from different Vocabulary sources. |
 