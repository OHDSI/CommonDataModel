*OMOP Common Data Model v5.1 Specifications*
<br>*Authors: Christian Reich, Patrick Ryan, Rimma Belenkaya, Karthik Natarajan, Clair Blacketer*
<br>***Release date needed***

[Back to Table of Contents](https://github.com/OHDSI/CommonDataModel/blob/master/Documentation/TableofContents.md)
<br>[Back to Standardized Vocabularies](StandardizedVocabularies.md)

---

# 3.5 CONCEPT_RELATIONSHIP

The CONCEPT_RELATIONSHIP table contains records that define direct relationships between any two Concepts and the nature or type of the relationship. Each type of a relationship is defined in the [RELATIONSHIP](RELATIONSHIP.md) table.

Field|Required|Type|Description
:-----|:-----|:----|:-----
|concept_id_1|Yes|integer|A foreign key to a Concept in the [CONCEPT](CONCEPT.md) table associated with the relationship. Relationships are directional, and this field represents the source concept designation.|
|concept_id_2|Yes|integer|A foreign key to a Concept in the [CONCEPT](CONCEPT.md) table associated with the relationship. Relationships are directional, and this field represents the destination concept designation.|
|relationship_id|Yes|varchar(20)|A unique identifier to the type or nature of the Relationship as defined in the [RELATIONSHIP](RELATIONSHIP.md) table.|
|valid_start_date|Yes|date|The date when the instance of the Concept Relationship is first recorded.|
|valid_end_date|Yes|date|The date when the Concept Relationship became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.|
|invalid_reason|No|varchar(1)|Reason the relationship was invalidated. Possible values are 'D' (deleted), 'U' (replaced with an update) or NULL when valid_end_date has the default value.|

## Conventions 
  * Relationships can generally be classified as hierarchical (parent-child) or non-hierarchical (lateral). 
  * All Relationships are directional, and each Concept Relationship is represented twice symmetrically within the CONCEPT_RELATIONSHIP table. For example, the two SNOMED concepts of ‘Acute myocardial infarction of the anterior wall’ and ‘Acute myocardial infarction’ have two Concept Relationships: 1- ‘Acute myocardial infarction of the anterior wall’ ‘Is a’ ‘Acute myocardial infarction’, and 2- ‘Acute myocardial infarction’ ‘Subsumes’ ‘Acute myocardial infarction of the anterior wall’.
  * There is one record for each Concept Relationship connecting the same Concepts with the same relationship_id.
  * Since all Concept Relationships exist with their mirror image (concept_id_1 and concept_id_2 swapped, and the relationship_id replaced by the reverse_relationship_id from the [RELATIONSHIP](RELATIONSHIP.md) table), it is not necessary to query for the existence of a relationship both in the concept_id_1 and concept_id_2 fields.
  * Concept Relationships define direct relationships between Concepts. Indirect relationships through 3rd Concepts are not captured in this table. However, the [CONCEPT_ANCESTOR](CONCEPT_ANCESTOR.md) table does this for hierachical relationships over several "generations" of direct relationships.
  * In previous versions of the CDM, the relationship_id used to be a numerical identifier. See the [RELATIONSHIP](RELATIONSHIP.md) table.
