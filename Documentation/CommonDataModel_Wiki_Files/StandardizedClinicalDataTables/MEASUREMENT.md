The MEASUREMENT table contains records of Measurement, i.e. structured values (numerical or categorical) obtained through systematic and standardized examination or testing of a Person or Person's sample. The MEASUREMENT table contains both orders and results of such Measurements as laboratory tests, vital signs, quantitative findings from pathology reports, etc. 

Field|Required|Type|Description
:----------------------------------|:--------|:------------|:------------------------------------------------
|measurement_id|Yes|integer|A unique identifier for each Measurement.|
|person_id|Yes|integer|A foreign key identifier to the Person about whom the measurement was recorded. The demographic details of that Person are stored in the PERSON table.|
|measurement_concept_id|Yes|integer|A foreign key to the standard measurement concept identifier in the Standardized Vocabularies.|
|measurement_date|Yes|date|The date of the Measurement.|
|measurement_datetime|No|datetime|The date and time of the Measurement. Some database systems don't have a datatype of time. To accomodate all temporal analyses, datatype datetime can be used (combining measurement_date and measurement_time [forum discussion](http://forums.ohdsi.org/t/date-time-and-datetime-problem-and-the-world-of-hours-and-1day/314))|
|measurement_type_concept_id|Yes|integer|A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the provenance from where the Measurement record was recorded.|
|operator_concept_id|No|integer|A foreign key identifier to the predefined Concept in the Standardized Vocabularies reflecting the mathematical operator that is applied to the value_as_number. Operators are <, <=, =, >=, >.|
|value_as_number|No|float|A Measurement result where the result is expressed as a numeric value.|
|value_as_concept_id|No|integer|A foreign key to a Measurement result represented as a Concept from the Standardized Vocabularies (e.g., positive/negative, present/absent, low/high, etc.).|
|unit_concept_id|No|integer|A foreign key to a Standard Concept ID of Measurement Units in the Standardized Vocabularies.|
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

  * Measurements differ from Observations in that they require a standardized test or some other activity to generate a quantitative or qualitative result. For example, LOINC 1755-8 concept_id 3027035 'Albumin [Mass/time] in 24 hour Urine' is the lab test to measure a certain chemical in a urine sample.
  * Even though each Measurement always have a result, the fields value_as_number and value_as_concept_id are not mandatory. When the result is not known, the Measurement record represents just the fact that the corresponding Measurement was carried out, which in itself is already useful information for some use cases.
  * Valid Measurement Concepts (measurement_concept_id) belong to the 'Measurement' domain, but could overlap with the 'Observation' domain. This is due to the fact that there is a continuum between systematic examination or testing (Measurement) and a simple determination of fact (Observation). When the Measurement Source Value of the code cannot be translated into a standard Measurement Concept ID, a Measurement entry is stored with only the corresponding source_concept_id and measurement_source_value and a measurement_concept_id of 0.
  * Measurements are stored as attribute value pairs, with the attribute as the Measurement Concept and the value representing the result. The value can be a Concept (stored in value_as_concept), or a numerical value (value_as_number) with a Unit (unit_concept_id). 
  * Valid Concepts for the value_as_concept field belong to the 'Meas Value' domain. 
  * For some Measurement Concepts, the result is included in the test. For example, ICD10 concept_id 45595451 "Presence of alcohol in blood, level not specified" indicates a Measurement and the result (present).  In those situations, the CONCEPT_RELATIONSHIP table in addition to the "Maps to" record contains a second record with the relationship_id set to "Maps to value". In this example, the "Maps to" relationship directs to 4041715 "Blood ethanol measurement" as well as a "Maps to value" record to 4181412 "Present".
  * The operator_concept_id is optionally given for relative Measurements where the precise value is not available but its relation to a certain benchmarking value is. For example, this can be used for minimal detection thresholds of a test.
  * The meaning of Concept 4172703 for '=' is identical to omission of a operator_concept_id value. Since the use of this field is rare, it's important when devising analyses to not to forget testing for the content of this field for values different from =.
  * Valid Concepts for the operator_concept_id field belong to the 'Meas Value Operator' domain.
  * The Unit is optional even if a value_as_number is provided.
  * If reference ranges for upper and lower limit of normal as provided (typically by a laboratory) these are stored in the range_high and range_low fields. Ranges have the same unit as the value_as_number.
  * The Visit during which the observation was made is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
  * The Provider making the observation is recorded through a reference to the PROVIDER table. This information is not always available.
