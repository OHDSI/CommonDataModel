The MEASUREMENT table contains records of Measurement, i.e. structured values (numerical or categorical) obtained through systematic and standardized examination or testing of a Person or Person's sample. The MEASUREMENT table contains both orders and results of such Measurements as laboratory tests, vital signs, quantitative findings from pathology reports, etc. 

Field|Required|Type|Description
:----------------------------------|:--------|:------------|:------------------------------------------------
|measurement_id|Yes|integer|A unique identifier for each Measurement.|
|person_id|Yes|integer|A foreign key identifier to the Person about whom the measurement was recorded. The demographic details of that Person are stored in the PERSON table.|
|measurement_concept_id|Yes|integer|A foreign key to the standard measurement concept identifier in the Standardized Vocabularies. These belong to the 'Measurement' domain, but could overlap with the 'Observation' domain (see #3 below).|
|measurement_date|Yes|date|The date of the Measurement.|
|measurement_datetime|No|datetime|The date and time of the Measurement. Some database systems don't have a datatype of time. To accommodate all temporal analyses, datatype datetime can be used (combining measurement_date and measurement_time [forum discussion](http://forums.ohdsi.org/t/date-time-and-datetime-problem-and-the-world-of-hours-and-1day/314))|
|measurement_time |No|varchar(10)|The time of the Measurement. This is present for backwards compatibility and will be deprecated in an upcoming version|
|measurement_type_concept_id|Yes|integer|A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the provenance from where the Measurement record was recorded. These belong to the 'Meas Type' vocabulary|
|operator_concept_id|No|integer|A foreign key identifier to the predefined Concept in the Standardized Vocabularies reflecting the mathematical operator that is applied to the value_as_number. Operators are <, <=, =, >=, > and these concepts belong to the 'Meas Value Operator' domain.|
|value_as_number|No|float|A Measurement result where the result is expressed as a numeric value.|
|value_as_concept_id|No|integer|A foreign key to a Measurement result represented as a Concept from the Standardized Vocabularies (e.g., positive/negative, present/absent, low/high, etc.). These belong to the 'Meas Value' domain|
|unit_concept_id|No|integer|A foreign key to a Standard Concept ID of Measurement Units in the Standardized Vocabularies that belong to the 'Unit' domain.|
|range_low|No|float|The lower limit of the normal range of the Measurement result. The lower range is assumed to be of the same unit of measure as the Measurement value.|
|range_high|No|float|The upper limit of the normal range of the Measurement. The upper range is assumed to be of the same unit of measure as the Measurement value.|
|provider_id|No|integer|A foreign key to the provider in the PROVIDER table who was responsible for initiating or obtaining the measurement.|
|visit_occurrence_id|No|integer|A foreign key to the Visit in the VISIT_OCCURRENCE table during which the Measurement was recorded.|
|visit_detail_id|No|integer|A foreign key to the Visit Detail in the VISIT_DETAIL table during which the Measurement was recorded. |
|measurement_source_value|No|varchar(50)|The Measurement name as it appears in the source data. This code is mapped to a Standard Concept in the Standardized Vocabularies and the original code is stored here for reference.|
|measurement_source_concept_id|No|integer|A foreign key to a Concept in the Standard Vocabularies that refers to the code used in the source.|
|unit_source_value|No|varchar(50)|The source code for the unit as it appears in the source data. This code is mapped to a standard unit concept in the Standardized Vocabularies and the original code is stored here for reference.|
|value_source_value|No|varchar(50)|The source value associated with the content of the value_as_number or value_as_concept_id as stored in the source data.|

### Conventions 

No.|Convention Description
:--------|:------------------------------------   
| 1  | Measurements differ from Observations in that they require a standardized test or some other activity to generate a quantitative or qualitative result. For example, LOINC 1755-8 concept_id 3027035 'Albumin [Mass/time] in 24 hour Urine' is the lab test to measure a certain chemical in a urine sample.|
| 2  | Even though each Measurement always have a result, the fields VALUE_AS_NUMBER and VALUE_AS_CONCEPT_ID are not mandatory. When the result is not known, the Measurement record represents just the fact that the corresponding Measurement was carried out, which in itself is already useful information for some use cases.|
| 3  | Valid Measurement Concepts (MEASUREMENT_CONCEPT_ID) belong to the 'Measurement' domain, but could overlap with the 'Observation' domain. This is due to the fact that there is a continuum between systematic examination or testing (Measurement) and a simple determination of fact (Observation). When the Measurement Source Value of the code cannot be translated into a standard Measurement Concept ID, a Measurement entry is stored with only the corresponding SOURCE_CONCEPT_ID and MEASUREMENT_SOURCE_VALUE and a MEASUREMENT_CONCEPT_ID of 0.|
| 4  | Measurements are stored as attribute value pairs, with the attribute as the Measurement Concept and the value representing the result. The value can be a Concept (stored in VALUE_AS_CONCEPT), or a numerical value (VALUE_AS_NUMBER) with a Unit (UNIT_CONCEPT_ID). |
| 5  | Valid Concepts for the VALUE_AS_CONCEPT field belong to the 'Meas Value' domain. |
| 6  | For some Measurement Concepts, the result is included in the test. For example, ICD10 concept_id 45595451 'Presence of alcohol in blood, level not specified' indicates a Measurement and the result (present).  In those situations, the CONCEPT_RELATIONSHIP table in addition to the 'Maps to' record contains a second record with the relationship_id set to 'Maps to value'. In this example, the 'Maps to' relationship directs to 4041715 'Blood ethanol measurement' as well as a 'Maps to value' record to 4181412 'Present'.|
| 7  | The OPERATOR_CONCEPT_ID is optionally given for relative Measurements where the precise value is not available but its relation to a certain benchmarking value is. For example, this can be used for minimal detection thresholds of a test.|
| 8  | The meaning of Concept 4172703 for '=' is identical to omission of a OPERATOR_CONCEPT_ID value. Since the use of this field is rare, it's important when devising analyses to not to forget testing for the content of this field for values different from =.|
| 9  | Valid Concepts for the OPERATOR_CONCEPT_ID field belong to the 'Meas Value Operator' domain.|
| 10 | The Unit is optional even if a VALUE_AS_NUMBER is provided.|
| 11 | If reference ranges for upper and lower limit of normal as provided (typically by a laboratory) these are stored in the RANGE_HIGH and RANGE_LOW fields. Ranges have the same unit as the VALUE_AS_NUMBER.|
| 12 | The Visit during which the observation was made is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.|
| 13 | The Provider making the observation is recorded through a reference to the PROVIDER table. This information is not always available.|
| 14 | If there is a negative value coming from the source, set the VALUE_AS_NUMBER to NULL, with the exception of the following Measurements (listed as LOINC codes):<br><ul><li>1925-7 Base excess in Arterial blood by calculation</li><li>1927-3 Base excess in Venous blood by calculation</li><li>8632-2 QRS-Axis</li><li>11555-0 Base excess in Blood by calculation</li><li>1926-5 Base excess in Capillary blood by calculation</li><li>28638-5 Base excess in Arterial cord blood by calculation</li><li>28639-3 Base excess in Venous cord blood by calculation</li></ul>| 
