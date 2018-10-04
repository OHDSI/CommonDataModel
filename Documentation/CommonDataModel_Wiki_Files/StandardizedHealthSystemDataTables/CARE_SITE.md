The CARE_SITE table contains a list of uniquely identified institutional (physical or organizational) units where healthcare delivery is practiced (offices, wards, hospitals, clinics, etc.).

Field|Required|Type|Description
:--------------------------------|:--------|:------------|:------------------------
|care_site_id|Yes|integer|A unique identifier for each Care Site.|
|care_site_name|No|varchar(255)|The verbatim description or name of the Care Site as in data source|
|place_of_service_concept_id|Yes|integer|A foreign key that refers to a Place of Service Concept ID in the Standardized Vocabularies.|
|location_id|No|integer|A foreign key to the geographic Location in the LOCATION table, where the detailed address information is stored.|
|care_site_source_value|No|varchar(50)|The identifier for the Care Site in the source data, stored here for reference.|
|place_of_service_source_value|No|varchar(50)|The source code for the Place of Service as it appears in the source data, stored here for reference.|

### Conventions

No.|Convention Description
:--------|:------------------------------------
| 1  |  Care site is a unique combination of location_id and place_of_service_source_value. |
| 2  | Every record in the visit_occurrence table may have only one care site. |
| 3  | Care site does not take into account the provider (human) information such a specialty. |
| 4  | Many source data do not make a distinction between individual and institutional providers. The CARE_SITE table contains the institutional providers. |
| 5  | If the source, instead of uniquely identifying individual Care Sites, only provides limited information such as Place of Service, generic or "pooled" Care Site records are listed in the CARE_SITE table. |
| 6  | There are hierarchical and business relationships between Care Sites. For example, wards can belong to clinics or departments, which can in turn belong to hospitals, which in turn can belong to hospital systems, which in turn can belong to HMOs. |
| 7  | The relationships between Care Sites are defined in the FACT_RELATIONSHIP table. |
| 8  | The Care Site Source Value typically contains the name of the Care Site. |
| 9  | The Place of Service Concepts belongs to the Domain 'Place of Service'. |
