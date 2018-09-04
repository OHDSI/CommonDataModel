The Person Domain contains records that uniquely identify each patient in the source data who is time at-risk to have clinical observations recorded within the source systems. 

Field|Required|Type|Description
:---------------------------|:--------|:------------|:-----------------------------------------------
|person_id|Yes|integer|A unique identifier for each person.|
|gender_concept_id|Yes|integer|A foreign key that refers to an identifier in the CONCEPT table for the unique gender of the person.|
|year_of_birth |Yes|integer|The year of birth of the person. For data sources with date of birth, the year is extracted. For data sources where the year of birth is not available, the approximate year of birth is derived based on any age group categorization available.|
|month_of_birth|No|integer|The month of birth of the person. For data sources that provide the precise date of birth, the month is extracted and stored in this field.|
|day_of_birth|No|integer|The day of the month of birth of the person. For data sources that provide the precise date of birth, the day is extracted and stored in this field.|
|birth_datetime|No|datetime|The date and time of birth of the person.|
|race_concept_id|Yes|integer|A foreign key that refers to an identifier in the CONCEPT table for the unique race of the person.|
|ethnicity_concept_id|Yes|integer|A foreign key that refers to the standard concept identifier in the Standardized Vocabularies for the ethnicity of the person.|
|location_id|No|integer|A foreign key to the place of residency for the person in the location table, where the detailed address information is stored.|
|provider_id|No|integer|A foreign key to the primary care provider the person is seeing in the provider table.|
|care_site_id|No|integer|A foreign key to the site of primary care in the care_site table, where the details of the care site are stored.|
|person_source_value|No|varchar(50)|An (encrypted) key derived from the person identifier in the source data. This is necessary when a use case requires a link back to the person data at the source dataset.|
|gender_source_value|No|varchar(50)|The source code for the gender of the person as it appears in the source data. The person’s gender is mapped to a standard gender concept in the Standardized Vocabularies; the original value is stored here for reference.|
|gender_source_concept_id|No|Integer|A foreign key to the gender concept that refers to the code used in the source.|
|race_source_value|No|varchar(50)|The source code for the race of the person as it appears in the source data. The person race is mapped to a standard race concept in the Standardized Vocabularies and the original value is stored here for reference.|
|race_source_concept_id|No|Integer|A foreign key to the race concept that refers to the code used in the source.|
|ethnicity_source_value|No|varchar(50)|The source code for the ethnicity of the person as it appears in the source data. The person ethnicity is mapped to a standard ethnicity concept in the Standardized Vocabularies and the original code is, stored here for reference.|
|ethnicity_source_concept_id|No|Integer|A foreign key to the ethnicity concept that refers to the code used in the source.|

### Conventions 

  * All tables representing patient-related Domains have a foreign-key reference to the person_id field in the PERSON table.
  * Each person record has associated demographic attributes which are assumed to be constant for the patient throughout the course of their periods of observation. For example, the location or gender is expected to have a unique value per person, even though in life these data may change over time. 
  * Valid Gender, Race and Ethnicity Concepts each belong to their own Domain.
  * Ethnicity in the OMOP CDM follows the OMB Standards for Data on Race and Ethnicity: Only distinctions between Hispanics and Non-Hispanics are made. 
  * Additional information is stored through references to other tables, such as the home address (location_id) or the primary care provider.
  * The Provider refers to the primary care provider (General Practitioner).
  * The Care Site refers to where the Provider typically provides the primary care.