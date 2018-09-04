The FACT_RELATIONSHIP table contains records about the relationships between facts stored as records in any table of the CDM. Relationships can be defined between facts from the same domain (table), or different domains. Examples of Fact Relationships include: Person relationships (parent-child), care site relationships (hierarchical organizational structure of facilities within a health system), indication relationship (between drug exposures and associated conditions), usage relationships (of devices during the course of an associated procedure), or facts derived from one another (measurements derived from an associated specimen).

Field|Required|Type|Description
:-------------------------|:--------|:------------|:--------------------------------------------------------------
|domain_concept_id_1|Yes|integer|The concept representing the domain of fact one, from which the corresponding table can be inferred.|
|fact_id_1|Yes|integer|The unique identifier in the table corresponding to the domain of fact one.|
|domain_concept_id_2|Yes|integer|The concept representing the domain of fact two, from which the corresponding table can be inferred.|
|fact_id_2|Yes|integer|The unique identifier in the table corresponding to the domain of fact two.|
|relationship_concept_id |Yes|integer|A foreign key to a Standard Concept ID of relationship in the Standardized Vocabularies.|

### Conventions 
  * All relationships are directional, and each relationship is represented twice symmetrically within the FACT_RELATIONSHIP table. For example, two persons if person_id = 1 is the mother of person_id = 2 two records are in the FACT_RELATIONSHIP table (all strings in fact concept_id records in the Concept table:
    * Person, 1, Person, 2, parent of
    * Person, 2, Person, 1, child of
