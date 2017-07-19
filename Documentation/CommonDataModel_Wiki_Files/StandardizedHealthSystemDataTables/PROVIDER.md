The PROVIDER table contains a list of uniquely identified healthcare providers. These are individuals providing hands-on healthcare to patients, such as physicians, nurses, midwives, physical therapists etc.

Field|Required|Type|Description
:-------------------------|:--------|:------------|:-------------------------------------
|provider_id|Yes|integer|A unique identifier for each Provider.|
|provider_name|No|varchar(50)|A description of the Provider.|
|npi|No|varchar(20)|The National Provider Identifier (NPI) of the provider.|
|dea|No|varchar(20)|The Drug Enforcement Administration (DEA) number of the provider.|
|specialty_concept_id|No|integer|A foreign key to a Standard Specialty Concept ID in the Standardized Vocabularies.|
|care_site_id|No|integer|A foreign key to the main Care Site where the provider is practicing.|
|year_of_birth|No|integer|The year of birth of the Provider.|
|gender_concept_id|No|integer|The gender of the Provider.|
|provider_source_value|No|varchar(50)|The identifier used for the Provider in the source data, stored here for reference.|
|specialty_source_value|No|varchar(50)|The source code for the Provider specialty as it appears in the source data, stored here for reference.|
|specialty_source_concept_id|No|integer|A foreign key to a Concept that refers to the code used in the source.|
|gender_source_value|No|varchar(50)|The gender code for the Provider as it appears in the source data, stored here for reference.|
|gender_source_concept_id|No|integer|A foreign key to a Concept that refers to the code used in the source.|

### Conventions 
  * Many sources do not make a distinction between individual and institutional providers. The PROVIDER table contains the individual providers.
  * If the source, instead of uniquely identifying individual providers, only provides limited information such as specialty, generic or "pooled" Provider records are listed in the PROVIDER table.
  * A single Provider cannot be listed twice (be duplicated) in the table. If a Provider has more than one Specialty, the main or most often exerted specialty should be recorded.
  * Valid Specialty Concepts belong to the 'Specialty' domain.
  * The care_site_id represent a fixed relationship between a Provider and her main Care Site. Providers are also linked to Care Sites through Condition, Procedure and Visit records.