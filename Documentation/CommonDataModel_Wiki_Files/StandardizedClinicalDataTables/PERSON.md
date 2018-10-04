The Person Domain contains records that uniquely identify each patient in the source data who is time at-risk to have clinical observations recorded within the source systems. 

Field|Required|Type|Description
:---------------------------|:--------|:------------|:-----------------------------------------------
|person_id|Yes|integer|A unique identifier for each person.|
|gender_concept_id|Yes|integer|A foreign key that refers to an identifier in the CONCEPT table for the unique gender of the person.|
|year_of_birth |Yes|integer|The year of birth of the person. For data sources with date of birth, the year is extracted. For data sources where the year of birth is not available, the approximate year of birth is derived based on any age group categorization available.|
|month_of_birth|No|integer|The month of birth of the person. For data sources that provide the precise date of birth, the month is extracted and stored in this field.|
|day_of_birth|No|integer|The day of the month of birth of the person. For data sources that provide the precise date of birth, the day is extracted and stored in this field.|
|birth_datetime|No|datetime|The date and time of birth of the person.|
|death_datetime|No|datetime|The date and time of death of the person.|
|race_concept_id|Yes|integer|A foreign key that refers to an identifier in the CONCEPT table for the unique race of the person, belonging to the 'Race' vocabulary.|
|ethnicity_concept_id|Yes|integer|A foreign key that refers to the standard concept identifier in the Standardized Vocabularies for the ethnicity of the person, belonging to the 'Ethnicity' vocabulary.|
|location_id|No|integer|A foreign key to the place of residency for the person in the location table, where the detailed address information is stored.|
|provider_id|No|integer|A foreign key to the primary care provider the person is seeing in the provider table.|
|care_site_id|No|integer|A foreign key to the site of primary care in the care_site table, where the details of the care site are stored.|
|person_source_value|No|varchar(50)|An (encrypted) key derived from the person identifier in the source data. This is necessary when a use case requires a link back to the person data at the source dataset.|
|gender_source_value|No|varchar(50)|The source code for the gender of the person as it appears in the source data. The person’s gender is mapped to a standard gender concept in the Standardized Vocabularies; the original value is stored here for reference.|
|gender_source_concept_id|Yes|Integer|A foreign key to the gender concept that refers to the code used in the source.|
|race_source_value|No|varchar(50)|The source code for the race of the person as it appears in the source data. The person race is mapped to a standard race concept in the Standardized Vocabularies and the original value is stored here for reference.|
|race_source_concept_id|Yes|Integer|A foreign key to the race concept that refers to the code used in the source.|
|ethnicity_source_value|No|varchar(50)|The source code for the ethnicity of the person as it appears in the source data. The person ethnicity is mapped to a standard ethnicity concept in the Standardized Vocabularies and the original code is, stored here for reference.|
|ethnicity_source_concept_id|Yes|Integer|A foreign key to the ethnicity concept that refers to the code used in the source.|

### Conventions 

No.|Convention Description
:--------|:------------------------------------   
| 1  | All tables representing patient-related Domains have a foreign-key reference to the person_id field in the PERSON table.|
| 2  | Each person record has associated demographic attributes which are assumed to be constant for the patient throughout the course of their periods of observation. For example, the location or gender is expected to have a unique value per person, even though in life these data may change over time. 
| 3  | The GENDER_CONCEPT_ID should store what is believed to be the biological or sex assigned at birth. If the data set does have gender identification information, this should be stored in the OBSERVATION table (using the gender concepts 8532-Female or 8507-Male in OBSERVATION_CONCEPT_ID)[THEMIS issue #32](https://github.com/OHDSI/Themis/issues/32).|
| 4  | If we do not know the month or day of birth, we do not guess. A person can exist without a month or day of birth. If a person lacks a birth year that person should be dropped([THEMIS issue #30](https://github.com/OHDSI/Themis/issues/30)).|
| 5  | Living patients should not have a value in PERSON.DEATH_DATETIME, nor should they have any records relating to death either in the CONDITION_OCCURRENCE or OBSERVATION tables
| 6  | Only one death date per individual can be used. If a patient has clinical activity (e.g. prescriptions filled, labs performed, etc) more than 60+ days after death you may want to drop the death record as it may have been falsely reported. If multiple records of death exist on multiple days you may select the death that you deem most reliable (e.g. death at discharge) or select the latest death date.
| 7  | If multiple death records occur, the date and the person have to be the same, but the cause can be different. Can be reported by different sources as well.
| 8  | If PERSON.DEATH_DATETIME cannot be precisely determined from the data, the best approximation should be used.
| 9  | The DEATH_DATETIME in the PERSON table should not be used as the way to find all deaths<br><ul><li>`select * from PERSON where death_datetime is not null` should not be the practice</li><li>Rather, deaths should be found through the OBSERVATION table and the PERSON table is only used to determine which death date should be used in analysis </li></ul>
| 10 | Valid Gender, Race and Ethnicity Concepts each belong to their own Domain.
| 11 | Ethnicity in the OMOP CDM follows the OMB Standards for Data on Race and Ethnicity: Only distinctions between Hispanics and Non-Hispanics are made. 
| 12 | Additional information is stored through references to other tables, such as the home address (location_id) or the primary care provider.
| 13 | The Provider refers to the primary care provider (General Practitioner). When the primary provider is unknown for a person then leave the PROVIDER_ID blank ([THEMIS issue #36](https://github.com/OHDSI/Themis/issues/36)).
| 14 | The Care Site refers to where the Provider typically provides the primary care. When care site for the primary provider is unknown then leave the CARE_SITE_ID blank.
| 15 | It is not required that all subjects from the raw data be carried over to the CDM, in fact removing people that are not of high enough quality may help researchers using the CDM. Example scenarios to remove subjects include: a person’s year of birth or age are unreasonable (e.g. born in year 0, 1800, 2999 or just lacking a year of birth), person lacks health benefits in claims database (i.e. thus you do not have a complete picture of their record), or raw data states that the person may not be of high research quality (e.g. CPRD will actually suggest which people not to use within research). Removal of a patient is not required and should be made in consideration of the raw data source. Reasons for removal of persons should be documented in the ETL documentation and METADATA table (insert row in METADATA where metadata.name='count of removed persons' and metada.value_as_string='xyz' where xyz is a number (e.g., 12). <br> An ETL should not delete persons who contribute time however have no health care utilization (e.g. an individual enrolled in insurance but does not visit a doctor or pharmacy). This individual will contribute to analysis however as a healthy / non-care seeking individual ([THEMIS issue #9](https://github.com/OHDSI/Themis/issues/9)).|
