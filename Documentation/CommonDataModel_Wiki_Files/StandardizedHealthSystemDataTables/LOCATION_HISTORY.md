The LOCATION HISTORY table stores relationships between Persons or Care Sites and geographic locations over time.

Field|Required|Type|Description
:------------------------------|:--------|:------------|:----------------------------------------------
|location_id					|Yes|integer|A foreign key to the location table.|
|relationship_type_concept_id	|Yes|varchar(50)|The type of relationship between location and entity.|
|domain_id						|Yes|varchar(50)|The domain of the entity that is related to the location. Either PERSON, PROVIDER, or CARE_SITE.|
|entity_id						|Yes|integer|The unique identifier for the entity. References either person_id, provider_id, or care_site_id, depending on domain_id.|
|start_date						|Yes|date|The date the relationship started.|
|end_date						|No|date|The date the relationship ended.|

### Conventions

No.|Convention Description
:--------|:------------------------------------
| 1  | The entities (and permissible domains) with related locations are: Persons (PERSON), Providers (PROVIDER), and Care Sites (CARE_SITE). |
| 2  | DOMAIN_ID specifies which table the ENTITY_ID refers to |
| 3  | Locations and entities are static. Relationships between locations and entities are dynamic. |
| 4  | When the domain is PERSON, the permissible values of relationship_type are: 'residence', 'work site', 'school'. |
| 5  | When the domain is CARE_SITE, the value of relationship_type is NULL. |
| 6  | When the domain is PROVIDER, the value of relationship_type is 'office'. |