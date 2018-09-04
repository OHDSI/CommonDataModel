The CONCEPT_ANCESTOR table is designed to simplify observational analysis by providing the complete hierarchical relationships between Concepts. Only direct parent-child relationships between Concepts are stored in the CONCEPT_RELATIONSHIP table. To determine higher level ancestry connections, all individual direct relationships would have to be navigated at analysis time. The  CONCEPT_ANCESTOR table includes records for all parent-child relationships, as well as grandparent-grandchild relationships and those of any other level of lineage. Using the CONCEPT_ANCESTOR table allows for querying for all descendants of a hierarchical concept. For example, drug ingredients and drug products are all descendants of a drug class ancestor.

This table is entirely derived from the CONCEPT, CONCEPT_RELATIONSHIP and RELATIONSHIP tables.  

Field|Required|Type|Description
:---------------------------|:--------|:------------|:---------------------------------------
|ancestor_concept_id|Yes|integer|A foreign key to the concept in the concept table for the higher-level concept that forms the ancestor in the relationship.|
|descendant_concept_id|Yes|integer|A foreign key to the concept in the concept table for the lower-level concept that forms the descendant in the relationship.|
|min_levels_of_separation|Yes|integer|The minimum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an attribute that is used to simplify hierarchic analysis.|
|max_levels_of_separation|Yes|integer|The maximum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an attribute that is used to simplify hierarchic analysis.|

### Conventions 

  * Each concept is also recorded as an ancestor of itself.
  * Only valid and Standard Concepts participate in the CONCEPT_ANCESTOR table. It is not possible to find ancestors or descendants of deprecated or Source Concepts.
  * Usually, only Concepts of the same Domain are connected through records of the CONCEPT_ANCESTOR table, but there might be exceptions.
