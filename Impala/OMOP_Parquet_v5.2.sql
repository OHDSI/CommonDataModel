-- Use the search/replace regex in an editor to fix DATE columns:
-- ([^ ]+) VARCHAR\(8\), \-\- DATE
-- TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST($1 AS STRING), 1, 4), SUBSTR(CAST($1 AS STRING), 5, 2), SUBSTR(CAST($1 AS STRING), 7, 2)), 'UTC') AS $1,

CREATE TABLE omop_cdm_parquet.concept
STORED AS PARQUET
AS
SELECT
 concept_id,
 concept_name,
 domain_id,
 vocabulary_id,
 concept_class_id,
 standard_concept,
 concept_code,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(valid_start_date AS STRING), 1, 4), SUBSTR(CAST(valid_start_date AS STRING), 5, 2), SUBSTR(CAST(valid_start_date AS STRING), 7, 2)), 'UTC') AS valid_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(valid_end_date AS STRING), 1, 4), SUBSTR(CAST(valid_end_date AS STRING), 5, 2), SUBSTR(CAST(valid_end_date AS STRING), 7, 2)), 'UTC') AS valid_end_date,
 nullif(invalid_reason, '') AS invalid_reason
FROM omop_cdm.concept;

CREATE TABLE omop_cdm_parquet.vocabulary
STORED AS PARQUET
AS
SELECT * from omop_cdm.vocabulary;

CREATE TABLE omop_cdm_parquet.domain
STORED AS PARQUET
AS
SELECT * from omop_cdm.domain;

CREATE TABLE omop_cdm_parquet.concept_class
STORED AS PARQUET
AS
SELECT * from omop_cdm.concept_class;

CREATE TABLE omop_cdm_parquet.concept_relationship
STORED AS PARQUET
AS
SELECT
 concept_id_1,
 concept_id_2,
 relationship_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(valid_start_date AS STRING), 1, 4), SUBSTR(CAST(valid_start_date AS STRING), 5, 2), SUBSTR(CAST(valid_start_date AS STRING), 7, 2)), 'UTC') AS valid_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(valid_end_date AS STRING), 1, 4), SUBSTR(CAST(valid_end_date AS STRING), 5, 2), SUBSTR(CAST(valid_end_date AS STRING), 7, 2)), 'UTC') AS valid_end_date,
 nullif(invalid_reason, '') AS invalid_reason
FROM omop_cdm.concept_relationship;

CREATE TABLE omop_cdm_parquet.relationship
STORED AS PARQUET
AS
SELECT * from omop_cdm.relationship;

CREATE TABLE omop_cdm_parquet.concept_synonym
STORED AS PARQUET
AS
SELECT * from omop_cdm.concept_synonym;

CREATE TABLE omop_cdm_parquet.concept_ancestor
STORED AS PARQUET
AS
SELECT * from omop_cdm.concept_ancestor;

CREATE TABLE omop_cdm_parquet.source_to_concept_map
STORED AS PARQUET
AS
SELECT
 source_code,
 source_concept_id,
 source_vocabulary_id,
 source_code_description,
 target_concept_id,
 target_vocabulary_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(valid_start_date AS STRING), 1, 4), SUBSTR(CAST(valid_start_date AS STRING), 5, 2), SUBSTR(CAST(valid_start_date AS STRING), 7, 2)), 'UTC') AS valid_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(valid_end_date AS STRING), 1, 4), SUBSTR(CAST(valid_end_date AS STRING), 5, 2), SUBSTR(CAST(valid_end_date AS STRING), 7, 2)), 'UTC') AS valid_end_date,
 nullif(invalid_reason, '') AS invalid_reason
FROM omop_cdm.source_to_concept_map;

CREATE TABLE omop_cdm_parquet.drug_strength
STORED AS PARQUET
AS
SELECT
 drug_concept_id,
 ingredient_concept_id,
 amount_value, -- NUMERIC
 amount_unit_concept_id,
 numerator_value, -- NUMERIC
 numerator_unit_concept_id,
 denominator_value, -- NUMERIC
 denominator_unit_concept_id,
 box_size,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(valid_start_date AS STRING), 1, 4), SUBSTR(CAST(valid_start_date AS STRING), 5, 2), SUBSTR(CAST(valid_start_date AS STRING), 7, 2)), 'UTC') AS valid_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(valid_end_date AS STRING), 1, 4), SUBSTR(CAST(valid_end_date AS STRING), 5, 2), SUBSTR(CAST(valid_end_date AS STRING), 7, 2)), 'UTC') AS valid_end_date,
 nullif(invalid_reason, '') AS invalid_reason
FROM omop_cdm.drug_strength;

CREATE TABLE omop_cdm_parquet.cohort_definition
STORED AS PARQUET
AS
SELECT
 cohort_definition_id,
 cohort_definition_name,
 cohort_definition_description, -- TEXT
 definition_type_concept_id,
 cohort_definition_syntax, -- TEXT
 subject_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(cohort_initiation_date AS STRING), 1, 4), SUBSTR(CAST(cohort_initiation_date AS STRING), 5, 2), SUBSTR(CAST(cohort_initiation_date AS STRING), 7, 2)), 'UTC') AS cohort_initiation_date
FROM omop_cdm.cohort_definition;

CREATE TABLE omop_cdm_parquet.attribute_definition
STORED AS PARQUET
AS
SELECT * from omop_cdm.attribute_definition;

CREATE TABLE omop_cdm_parquet.cdm_source
STORED AS PARQUET
AS
SELECT
 cdm_source_name,
 cdm_source_abbreviation,
 cdm_holder,
 source_description, -- TEXT
 source_documentation_reference,
 cdm_etl_reference,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(source_release_date AS STRING), 1, 4), SUBSTR(CAST(source_release_date AS STRING), 5, 2), SUBSTR(CAST(source_release_date AS STRING), 7, 2)), 'UTC') AS source_release_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(cdm_release_date AS STRING), 1, 4), SUBSTR(CAST(cdm_release_date AS STRING), 5, 2), SUBSTR(CAST(cdm_release_date AS STRING), 7, 2)), 'UTC') AS cdm_release_date,
 cdm_version,
 vocabulary_version
FROM omop_cdm.cdm_source;

CREATE TABLE omop_cdm_parquet.person
STORED AS PARQUET
AS
SELECT
 person_id,
 gender_concept_id,
 year_of_birth,
 month_of_birth,
 day_of_birth,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', CAST(year_of_birth AS STRING), SUBSTR(CONCAT('0', CAST(month_of_birth AS STRING)), -2), SUBSTR(CONCAT('0', CAST(day_of_birth AS STRING)), -2)), 'UTC') AS birth_datetime,
 race_concept_id,
 ethnicity_concept_id,
 location_id,
 provider_id,
 care_site_id,
 person_source_value,
 gender_source_value,
 gender_source_concept_id,
 race_source_value,
 race_source_concept_id,
 ethnicity_source_value,
 ethnicity_source_concept_id
FROM omop_cdm.person;

CREATE TABLE omop_cdm_parquet.observation_period
STORED AS PARQUET
AS
SELECT
 observation_period_id,
 person_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(observation_period_start_date AS STRING), 1, 4), SUBSTR(CAST(observation_period_start_date AS STRING), 5, 2), SUBSTR(CAST(observation_period_start_date AS STRING), 7, 2)), 'UTC') AS observation_period_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(observation_period_start_date AS STRING), 1, 4), SUBSTR(CAST(observation_period_start_date AS STRING), 5, 2), SUBSTR(CAST(observation_period_start_date AS STRING), 7, 2)), 'UTC') AS observation_period_start_datetime,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(observation_period_end_date AS STRING), 1, 4), SUBSTR(CAST(observation_period_end_date AS STRING), 5, 2), SUBSTR(CAST(observation_period_end_date AS STRING), 7, 2)), 'UTC') AS observation_period_end_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(observation_period_end_date AS STRING), 1, 4), SUBSTR(CAST(observation_period_end_date AS STRING), 5, 2), SUBSTR(CAST(observation_period_end_date AS STRING), 7, 2)), 'UTC') AS observation_period_end_datetime,
 period_type_concept_id
FROM omop_cdm.observation_period;

CREATE TABLE omop_cdm_parquet.specimen
STORED AS PARQUET
AS
SELECT
 specimen_id,
 person_id,
 specimen_concept_id,
 specimen_type_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(specimen_date AS STRING), 1, 4), SUBSTR(CAST(specimen_date AS STRING), 5, 2), SUBSTR(CAST(specimen_date AS STRING), 7, 2)), 'UTC') AS specimen_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(specimen_date AS STRING), 1, 4), SUBSTR(CAST(specimen_date AS STRING), 5, 2), SUBSTR(CAST(specimen_date AS STRING), 7, 2)), 'UTC') AS specimen_datetime,
 quantity, -- NUMERIC
 unit_concept_id,
 anatomic_site_concept_id,
 disease_status_concept_id,
 specimen_source_id,
 specimen_source_value,
 unit_source_value,
 anatomic_site_source_value,
 disease_status_source_value
FROM omop_cdm.specimen;

CREATE TABLE omop_cdm_parquet.death
STORED AS PARQUET
AS
SELECT
 person_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(death_date AS STRING), 1, 4), SUBSTR(CAST(death_date AS STRING), 5, 2), SUBSTR(CAST(death_date AS STRING), 7, 2)), 'UTC') AS death_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(death_date AS STRING), 1, 4), SUBSTR(CAST(death_date AS STRING), 5, 2), SUBSTR(CAST(death_date AS STRING), 7, 2)), 'UTC') AS death_datetime,
 death_type_concept_id,
 cause_concept_id,
 cause_source_value,
 cause_source_concept_id
FROM omop_cdm.death;

CREATE TABLE omop_cdm_parquet.visit_occurrence
STORED AS PARQUET
AS
SELECT
 visit_occurrence_id,
 person_id,
 visit_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(visit_start_date AS STRING), 1, 4), SUBSTR(CAST(visit_start_date AS STRING), 5, 2), SUBSTR(CAST(visit_start_date AS STRING), 7, 2)), 'UTC') AS visit_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(visit_start_date AS STRING), 1, 4), SUBSTR(CAST(visit_start_date AS STRING), 5, 2), SUBSTR(CAST(visit_start_date AS STRING), 7, 2)), 'UTC') AS visit_start_datetime,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(visit_end_date AS STRING), 1, 4), SUBSTR(CAST(visit_end_date AS STRING), 5, 2), SUBSTR(CAST(visit_end_date AS STRING), 7, 2)), 'UTC') AS visit_end_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(visit_end_date AS STRING), 1, 4), SUBSTR(CAST(visit_end_date AS STRING), 5, 2), SUBSTR(CAST(visit_end_date AS STRING), 7, 2)), 'UTC') AS visit_end_datetime,
 visit_type_concept_id,
 provider_id,
 care_site_id,
 visit_source_value,
 visit_source_concept_id,
 admitting_source_concept_id,
 admitting_source_value,
 discharge_to_concept_id,
 discharge_to_source_value,
 preceding_visit_occurrence_id
FROM omop_cdm.visit_occurrence;

CREATE TABLE omop_cdm_parquet.procedure_occurrence
STORED AS PARQUET
AS
SELECT
 procedure_occurrence_id,
 person_id,
 procedure_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(procedure_date AS STRING), 1, 4), SUBSTR(CAST(procedure_date AS STRING), 5, 2), SUBSTR(CAST(procedure_date AS STRING), 7, 2)), 'UTC') AS procedure_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(procedure_date AS STRING), 1, 4), SUBSTR(CAST(procedure_date AS STRING), 5, 2), SUBSTR(CAST(procedure_date AS STRING), 7, 2)), 'UTC') AS procedure_datetime,
 procedure_type_concept_id,
 modifier_concept_id,
 quantity,
 provider_id,
 visit_occurrence_id,
 procedure_source_value,
 procedure_source_concept_id,
 qualifier_source_value
FROM omop_cdm.procedure_occurrence;

CREATE TABLE omop_cdm_parquet.drug_exposure
STORED AS PARQUET
AS
SELECT
 drug_exposure_id,
 person_id,
 drug_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(drug_exposure_start_date AS STRING), 1, 4), SUBSTR(CAST(drug_exposure_start_date AS STRING), 5, 2), SUBSTR(CAST(drug_exposure_start_date AS STRING), 7, 2)), 'UTC') AS drug_exposure_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(drug_exposure_start_date AS STRING), 1, 4), SUBSTR(CAST(drug_exposure_start_date AS STRING), 5, 2), SUBSTR(CAST(drug_exposure_start_date AS STRING), 7, 2)), 'UTC') AS drug_exposure_start_datetime,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(drug_exposure_end_date AS STRING), 1, 4), SUBSTR(CAST(drug_exposure_end_date AS STRING), 5, 2), SUBSTR(CAST(drug_exposure_end_date AS STRING), 7, 2)), 'UTC') AS drug_exposure_end_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(drug_exposure_end_date AS STRING), 1, 4), SUBSTR(CAST(drug_exposure_end_date AS STRING), 5, 2), SUBSTR(CAST(drug_exposure_end_date AS STRING), 7, 2)), 'UTC') AS drug_exposure_end_datetime,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(verbatim_end_date AS STRING), 1, 4), SUBSTR(CAST(verbatim_end_date AS STRING), 5, 2), SUBSTR(CAST(verbatim_end_date AS STRING), 7, 2)), 'UTC') AS verbatim_end_date,
 drug_type_concept_id,
 stop_reason,
 refills,
 quantity, -- NUMERIC
 days_supply,
 sig, -- TEXT
 route_concept_id,
 lot_number,
 provider_id,
 visit_occurrence_id,
 drug_source_value,
 drug_source_concept_id,
 route_source_value,
 dose_unit_source_value
FROM omop_cdm.drug_exposure;

CREATE TABLE omop_cdm_parquet.device_exposure
STORED AS PARQUET
AS
SELECT
 device_exposure_id,
 person_id,
 device_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(device_exposure_start_date AS STRING), 1, 4), SUBSTR(CAST(device_exposure_start_date AS STRING), 5, 2), SUBSTR(CAST(device_exposure_start_date AS STRING), 7, 2)), 'UTC') AS device_exposure_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(device_exposure_start_date AS STRING), 1, 4), SUBSTR(CAST(device_exposure_start_date AS STRING), 5, 2), SUBSTR(CAST(device_exposure_start_date AS STRING), 7, 2)), 'UTC') AS device_exposure_start_datetime,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(device_exposure_end_date AS STRING), 1, 4), SUBSTR(CAST(device_exposure_end_date AS STRING), 5, 2), SUBSTR(CAST(device_exposure_end_date AS STRING), 7, 2)), 'UTC') AS device_exposure_end_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(device_exposure_end_date AS STRING), 1, 4), SUBSTR(CAST(device_exposure_end_date AS STRING), 5, 2), SUBSTR(CAST(device_exposure_end_date AS STRING), 7, 2)), 'UTC') AS device_exposure_end_datetime,
 device_type_concept_id,
 unique_device_id,
 quantity,
 provider_id,
 visit_occurrence_id,
 device_source_value,
 device_source_concept_id
FROM omop_cdm.device_exposure;

CREATE TABLE omop_cdm_parquet.condition_occurrence
STORED AS PARQUET
AS
SELECT
 condition_occurrence_id,
 person_id,
 condition_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(condition_start_date AS STRING), 1, 4), SUBSTR(CAST(condition_start_date AS STRING), 5, 2), SUBSTR(CAST(condition_start_date AS STRING), 7, 2)), 'UTC') AS condition_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(condition_start_date AS STRING), 1, 4), SUBSTR(CAST(condition_start_date AS STRING), 5, 2), SUBSTR(CAST(condition_start_date AS STRING), 7, 2)), 'UTC') AS condition_start_datetime,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(condition_end_date AS STRING), 1, 4), SUBSTR(CAST(condition_end_date AS STRING), 5, 2), SUBSTR(CAST(condition_end_date AS STRING), 7, 2)), 'UTC') AS condition_end_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(condition_end_date AS STRING), 1, 4), SUBSTR(CAST(condition_end_date AS STRING), 5, 2), SUBSTR(CAST(condition_end_date AS STRING), 7, 2)), 'UTC') AS condition_end_datetime,
 condition_type_concept_id,
 stop_reason,
 provider_id,
 visit_occurrence_id,
 condition_source_value,
 condition_source_concept_id,
 condition_status_source_value,
 condition_status_concept_id
FROM omop_cdm.condition_occurrence;

CREATE TABLE omop_cdm_parquet.measurement
STORED AS PARQUET
AS
SELECT
 measurement_id,
 person_id,
 measurement_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(measurement_date AS STRING), 1, 4), SUBSTR(CAST(measurement_date AS STRING), 5, 2), SUBSTR(CAST(measurement_date AS STRING), 7, 2)), 'UTC') AS measurement_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(measurement_date AS STRING), 1, 4), SUBSTR(CAST(measurement_date AS STRING), 5, 2), SUBSTR(CAST(measurement_date AS STRING), 7, 2)), 'UTC') AS measurement_datetime,
 measurement_type_concept_id,
 operator_concept_id,
 value_as_number, -- NUMERIC
 value_as_concept_id,
 unit_concept_id,
 range_low, -- NUMERIC
 range_high, -- NUMERIC
 provider_id,
 visit_occurrence_id,
 measurement_source_value,
 measurement_source_concept_id,
 unit_source_value,
 value_source_value
FROM omop_cdm.measurement;

CREATE TABLE omop_cdm_parquet.note
STORED AS PARQUET
AS
SELECT
 note_id,
 person_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(note_date AS STRING), 1, 4), SUBSTR(CAST(note_date AS STRING), 5, 2), SUBSTR(CAST(note_date AS STRING), 7, 2)), 'UTC') AS note_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(note_date AS STRING), 1, 4), SUBSTR(CAST(note_date AS STRING), 5, 2), SUBSTR(CAST(note_date AS STRING), 7, 2)), 'UTC') AS note_datetime,
 note_type_concept_id,
 note_text, -- TEXT
 provider_id,
 visit_occurrence_id,
 note_source_value
FROM omop_cdm.note;

CREATE TABLE omop_cdm_parquet.observation
STORED AS PARQUET
AS
SELECT
 observation_id,
 person_id,
 observation_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(observation_date AS STRING), 1, 4), SUBSTR(CAST(observation_date AS STRING), 5, 2), SUBSTR(CAST(observation_date AS STRING), 7, 2)), 'UTC') AS observation_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(observation_date AS STRING), 1, 4), SUBSTR(CAST(observation_date AS STRING), 5, 2), SUBSTR(CAST(observation_date AS STRING), 7, 2)), 'UTC') AS observation_datetime,
 observation_type_concept_id,
 value_as_number, -- NUMERIC
 value_as_string,
 value_as_concept_id,
 qualifier_concept_id,
 unit_concept_id,
 provider_id,
 visit_occurrence_id,
 observation_source_value,
 observation_source_concept_id ,
 unit_source_value,
 qualifier_source_value
FROM omop_cdm.observation;

CREATE TABLE omop_cdm_parquet.fact_relationship
STORED AS PARQUET
AS
SELECT * from omop_cdm.fact_relationship;

CREATE TABLE omop_cdm_parquet.`location`
STORED AS PARQUET
AS
SELECT * from omop_cdm.`location`;

CREATE TABLE omop_cdm_parquet.care_site
STORED AS PARQUET
AS
SELECT * from omop_cdm.care_site;

CREATE TABLE omop_cdm_parquet.provider
STORED AS PARQUET
AS
SELECT * from omop_cdm.provider;

CREATE TABLE omop_cdm_parquet.payer_plan_period
STORED AS PARQUET
AS
SELECT
 payer_plan_period_id,
 person_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(payer_plan_period_start_date AS STRING), 1, 4), SUBSTR(CAST(payer_plan_period_start_date AS STRING), 5, 2), SUBSTR(CAST(payer_plan_period_start_date AS STRING), 7, 2)), 'UTC') AS payer_plan_period_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(payer_plan_period_end_date AS STRING), 1, 4), SUBSTR(CAST(payer_plan_period_end_date AS STRING), 5, 2), SUBSTR(CAST(payer_plan_period_end_date AS STRING), 7, 2)), 'UTC') AS payer_plan_period_end_date,
 payer_source_value,
 plan_source_value,
 family_source_value
FROM omop_cdm.payer_plan_period;


/* The individual cost tables are being phased out and will disappear soon

CREATE TABLE omop_cdm_parquet.visit_cost
STORED AS PARQUET
AS
SELECT * from omop_cdm.visit_cost;

CREATE TABLE omop_cdm_parquet.procedure_cost
STORED AS PARQUET
AS
SELECT * from omop_cdm.procedure_cost;

CREATE TABLE omop_cdm_parquet.drug_cost
STORED AS PARQUET
AS
SELECT * from omop_cdm.drug_cost;

CREATE TABLE omop_cdm_parquet.device_cost
STORED AS PARQUET
AS
SELECT * from omop_cdm.device_cost;
*/

CREATE TABLE omop_cdm_parquet.cost
STORED AS PARQUET
AS
SELECT * from omop_cdm.cost;

CREATE TABLE omop_cdm_parquet.cohort
STORED AS PARQUET
AS
SELECT
 cohort_definition_id,
 subject_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(cohort_start_date AS STRING), 1, 4), SUBSTR(CAST(cohort_start_date AS STRING), 5, 2), SUBSTR(CAST(cohort_start_date AS STRING), 7, 2)), 'UTC') AS cohort_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(cohort_end_date AS STRING), 1, 4), SUBSTR(CAST(cohort_end_date AS STRING), 5, 2), SUBSTR(CAST(cohort_end_date AS STRING), 7, 2)), 'UTC') AS cohort_end_date
FROM omop_cdm.cohort;

CREATE TABLE omop_cdm_parquet.cohort_attribute
STORED AS PARQUET
AS
SELECT
 cohort_definition_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(cohort_start_date AS STRING), 1, 4), SUBSTR(CAST(cohort_start_date AS STRING), 5, 2), SUBSTR(CAST(cohort_start_date AS STRING), 7, 2)), 'UTC') AS cohort_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(cohort_end_date AS STRING), 1, 4), SUBSTR(CAST(cohort_end_date AS STRING), 5, 2), SUBSTR(CAST(cohort_end_date AS STRING), 7, 2)), 'UTC') AS cohort_end_date,
 subject_id,
 attribute_definition_id,
 value_as_number, -- NUMERIC
 value_as_concept_id
FROM omop_cdm.cohort_attribute;

CREATE TABLE omop_cdm_parquet.drug_era
STORED AS PARQUET
AS
SELECT
 drug_era_id,
 person_id,
 drug_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(drug_era_start_date AS STRING), 1, 4), SUBSTR(CAST(drug_era_start_date AS STRING), 5, 2), SUBSTR(CAST(drug_era_start_date AS STRING), 7, 2)), 'UTC') AS drug_era_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(drug_era_end_date AS STRING), 1, 4), SUBSTR(CAST(drug_era_end_date AS STRING), 5, 2), SUBSTR(CAST(drug_era_end_date AS STRING), 7, 2)), 'UTC') AS drug_era_end_date,
 drug_exposure_count,
 gap_days
FROM omop_cdm.drug_era;

CREATE TABLE omop_cdm_parquet.dose_era
STORED AS PARQUET
AS
SELECT
 dose_era_id,
 person_id,
 drug_concept_id,
 unit_concept_id,
 dose_value, -- NUMERIC
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(dose_era_start_date AS STRING), 1, 4), SUBSTR(CAST(dose_era_start_date AS STRING), 5, 2), SUBSTR(CAST(dose_era_start_date AS STRING), 7, 2)), 'UTC') AS dose_era_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(dose_era_end_date AS STRING), 1, 4), SUBSTR(CAST(dose_era_end_date AS STRING), 5, 2), SUBSTR(CAST(dose_era_end_date AS STRING), 7, 2)), 'UTC') AS dose_era_end_date
FROM omop_cdm.dose_era;

CREATE TABLE omop_cdm_parquet.condition_era
STORED AS PARQUET
AS
SELECT
 condition_era_id,
 person_id,
 condition_concept_id,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(condition_era_start_date AS STRING), 1, 4), SUBSTR(CAST(condition_era_start_date AS STRING), 5, 2), SUBSTR(CAST(condition_era_start_date AS STRING), 7, 2)), 'UTC') AS condition_era_start_date,
 TO_UTC_TIMESTAMP(CONCAT_WS('-', SUBSTR(CAST(condition_era_end_date AS STRING), 1, 4), SUBSTR(CAST(condition_era_end_date AS STRING), 5, 2), SUBSTR(CAST(condition_era_end_date AS STRING), 7, 2)), 'UTC') AS condition_era_end_date,
 condition_occurrence_count
FROM omop_cdm.condition_era;

