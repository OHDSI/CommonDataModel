CREATE TABLE @cdmDatabaseSchema.person  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS gender_concept_id,
	CAST(NULL AS integer) AS year_of_birth,
	CAST(NULL AS integer) AS month_of_birth,
	CAST(NULL AS integer) AS day_of_birth,
	CAST(NULL AS TIMESTAMP) AS birth_datetime,
	CAST(NULL AS integer) AS race_concept_id,
	CAST(NULL AS integer) AS ethnicity_concept_id,
	CAST(NULL AS integer) AS location_id,
	CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS integer) AS care_site_id,
	CAST(NULL AS STRING) AS person_source_value,
	CAST(NULL AS STRING) AS gender_source_value,
	CAST(NULL AS integer) AS gender_source_concept_id,
	CAST(NULL AS STRING) AS race_source_value,
	CAST(NULL AS integer) AS race_source_concept_id,
	CAST(NULL AS STRING) AS ethnicity_source_value,
	CAST(NULL AS integer) AS ethnicity_source_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.person   ZORDER BY person_id;
CREATE TABLE @cdmDatabaseSchema.observation_period  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS observation_period_id,
	CAST(NULL AS integer) AS person_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS observation_period_start_date,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS observation_period_end_date,
	CAST(NULL AS integer) AS period_type_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.observation_period   ZORDER BY person_id;
CREATE TABLE @cdmDatabaseSchema.visit_occurrence  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS visit_occurrence_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS visit_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS visit_start_date,
	CAST(NULL AS TIMESTAMP) AS visit_start_datetime,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS visit_end_date,
	CAST(NULL AS TIMESTAMP) AS visit_end_datetime,
	CAST(NULL AS integer) AS visit_type_concept_id,
	CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS integer) AS care_site_id,
	CAST(NULL AS STRING) AS visit_source_value,
	CAST(NULL AS integer) AS visit_source_concept_id,
	CAST(NULL AS integer) AS admitting_source_concept_id,
	CAST(NULL AS STRING) AS admitting_source_value,
	CAST(NULL AS integer) AS discharge_to_concept_id,
	CAST(NULL AS STRING) AS discharge_to_source_value,
	CAST(NULL AS integer) AS preceding_visit_occurrence_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.visit_occurrence   ZORDER BY person_id;
CREATE TABLE @cdmDatabaseSchema.visit_detail  
USING DELTA
 AS
SELECT
CAST(NULL AS integer) AS visit_detail_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS visit_detail_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS visit_detail_start_date,
	CAST(NULL AS TIMESTAMP) AS visit_detail_start_datetime,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS visit_detail_end_date,
	CAST(NULL AS TIMESTAMP) AS visit_detail_end_datetime,
	CAST(NULL AS integer) AS visit_detail_type_concept_id,
	CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS integer) AS care_site_id,
	CAST(NULL AS STRING) AS visit_detail_source_value,
	CAST(NULL AS integer) AS visit_detail_source_concept_id,
	CAST(NULL AS STRING) AS admitting_source_value,
	CAST(NULL AS integer) AS admitting_source_concept_id,
	CAST(NULL AS STRING) AS discharge_to_source_value,
	CAST(NULL AS integer) AS discharge_to_concept_id,
	CAST(NULL AS integer) AS preceding_visit_detail_id,
	CAST(NULL AS integer) AS visit_detail_parent_id,
	CAST(NULL AS integer) AS visit_occurrence_id  WHERE 1 = 0;
CREATE TABLE @cdmDatabaseSchema.condition_occurrence  
USING DELTA
 AS
SELECT
CAST(NULL AS integer) AS condition_occurrence_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS condition_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS condition_start_date,
	CAST(NULL AS TIMESTAMP) AS condition_start_datetime,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS condition_end_date,
	CAST(NULL AS TIMESTAMP) AS condition_end_datetime,
	CAST(NULL AS integer) AS condition_type_concept_id,
	CAST(NULL AS integer) AS condition_status_concept_id,
	CAST(NULL AS STRING) AS stop_reason,
	CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS integer) AS visit_occurrence_id,
	CAST(NULL AS integer) AS visit_detail_id,
	CAST(NULL AS STRING) AS condition_source_value,
	CAST(NULL AS integer) AS condition_source_concept_id,
	CAST(NULL AS STRING) AS condition_status_source_value  WHERE 1 = 0;
CREATE TABLE @cdmDatabaseSchema.drug_exposure  
USING DELTA
 AS
SELECT
CAST(NULL AS integer) AS drug_exposure_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS drug_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS drug_exposure_start_date,
	CAST(NULL AS TIMESTAMP) AS drug_exposure_start_datetime,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS drug_exposure_end_date,
	CAST(NULL AS TIMESTAMP) AS drug_exposure_end_datetime,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS verbatim_end_date,
	CAST(NULL AS integer) AS drug_type_concept_id,
	CAST(NULL AS STRING) AS stop_reason,
	CAST(NULL AS integer) AS refills,
	CAST(NULL AS DOUBLE) AS quantity,
	CAST(NULL AS integer) AS days_supply,
	CAST(NULL AS STRING) AS sig,
	CAST(NULL AS integer) AS route_concept_id,
	CAST(NULL AS STRING) AS lot_number,
	CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS integer) AS visit_occurrence_id,
	CAST(NULL AS integer) AS visit_detail_id,
	CAST(NULL AS STRING) AS drug_source_value,
	CAST(NULL AS integer) AS drug_source_concept_id,
	CAST(NULL AS STRING) AS route_source_value,
	CAST(NULL AS STRING) AS dose_unit_source_value  WHERE 1 = 0;
CREATE TABLE @cdmDatabaseSchema.procedure_occurrence  
USING DELTA
 AS
SELECT
CAST(NULL AS integer) AS procedure_occurrence_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS procedure_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS procedure_date,
	CAST(NULL AS TIMESTAMP) AS procedure_datetime,
	CAST(NULL AS integer) AS procedure_type_concept_id,
	CAST(NULL AS integer) AS modifier_concept_id,
	CAST(NULL AS integer) AS quantity,
	CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS integer) AS visit_occurrence_id,
	CAST(NULL AS integer) AS visit_detail_id,
	CAST(NULL AS STRING) AS procedure_source_value,
	CAST(NULL AS integer) AS procedure_source_concept_id,
	CAST(NULL AS STRING) AS modifier_source_value  WHERE 1 = 0;
CREATE TABLE @cdmDatabaseSchema.device_exposure  
USING DELTA
 AS
SELECT
CAST(NULL AS integer) AS device_exposure_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS device_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS device_exposure_start_date,
	CAST(NULL AS TIMESTAMP) AS device_exposure_start_datetime,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS device_exposure_end_date,
	CAST(NULL AS TIMESTAMP) AS device_exposure_end_datetime,
	CAST(NULL AS integer) AS device_type_concept_id,
	CAST(NULL AS STRING) AS unique_device_id,
	CAST(NULL AS integer) AS quantity,
	CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS integer) AS visit_occurrence_id,
	CAST(NULL AS integer) AS visit_detail_id,
	CAST(NULL AS STRING) AS device_source_value,
	CAST(NULL AS integer) AS device_source_concept_id  WHERE 1 = 0;
CREATE TABLE @cdmDatabaseSchema.measurement  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS measurement_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS measurement_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS measurement_date,
	CAST(NULL AS TIMESTAMP) AS measurement_datetime,
	CAST(NULL AS STRING) AS measurement_time,
	CAST(NULL AS integer) AS measurement_type_concept_id,
	CAST(NULL AS integer) AS operator_concept_id,
	CAST(NULL AS DOUBLE) AS value_as_number,
	CAST(NULL AS integer) AS value_as_concept_id,
	CAST(NULL AS integer) AS unit_concept_id,
	CAST(NULL AS DOUBLE) AS range_low,
	CAST(NULL AS DOUBLE) AS range_high,
	CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS integer) AS visit_occurrence_id,
	CAST(NULL AS integer) AS visit_detail_id,
	CAST(NULL AS STRING) AS measurement_source_value,
	CAST(NULL AS integer) AS measurement_source_concept_id,
	CAST(NULL AS STRING) AS unit_source_value,
	CAST(NULL AS STRING) AS value_source_value  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.measurement   ZORDER BY person_id;
CREATE TABLE @cdmDatabaseSchema.observation  
USING DELTA
 AS
SELECT
CAST(NULL AS integer) AS observation_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS observation_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS observation_date,
	CAST(NULL AS TIMESTAMP) AS observation_datetime,
	CAST(NULL AS integer) AS observation_type_concept_id,
	CAST(NULL AS DOUBLE) AS value_as_number,
	CAST(NULL AS STRING) AS value_as_string,
	CAST(NULL AS integer) AS value_as_concept_id,
	CAST(NULL AS integer) AS qualifier_concept_id,
	CAST(NULL AS integer) AS unit_concept_id,
	CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS integer) AS visit_occurrence_id,
	CAST(NULL AS integer) AS visit_detail_id,
	CAST(NULL AS STRING) AS observation_source_value,
	CAST(NULL AS integer) AS observation_source_concept_id,
	CAST(NULL AS STRING) AS unit_source_value,
	CAST(NULL AS STRING) AS qualifier_source_value  WHERE 1 = 0;
CREATE TABLE @cdmDatabaseSchema.death  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS person_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS death_date,
	CAST(NULL AS TIMESTAMP) AS death_datetime,
	CAST(NULL AS integer) AS death_type_concept_id,
	CAST(NULL AS integer) AS cause_concept_id,
	CAST(NULL AS STRING) AS cause_source_value,
	CAST(NULL AS integer) AS cause_source_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.death   ZORDER BY person_id;
CREATE TABLE @cdmDatabaseSchema.note  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS note_id,
	CAST(NULL AS integer) AS person_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS note_date,
	CAST(NULL AS TIMESTAMP) AS note_datetime,
	CAST(NULL AS integer) AS note_type_concept_id,
	CAST(NULL AS integer) AS note_class_concept_id,
	CAST(NULL AS STRING) AS note_title,
	CAST(NULL AS STRING) AS note_text,
	CAST(NULL AS integer) AS encoding_concept_id,
	CAST(NULL AS integer) AS language_concept_id,
	CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS integer) AS visit_occurrence_id,
	CAST(NULL AS integer) AS visit_detail_id,
	CAST(NULL AS STRING) AS note_source_value  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.note   ZORDER BY person_id;
CREATE TABLE @cdmDatabaseSchema.note_nlp  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS note_nlp_id,
	CAST(NULL AS integer) AS note_id,
	CAST(NULL AS integer) AS section_concept_id,
	CAST(NULL AS STRING) AS snippet,
	CAST(NULL AS STRING) AS \offset\,
	CAST(NULL AS STRING) AS lexical_variant,
	CAST(NULL AS integer) AS note_nlp_concept_id,
	CAST(NULL AS integer) AS note_nlp_source_concept_id,
	CAST(NULL AS STRING) AS nlp_system,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS nlp_date,
	CAST(NULL AS TIMESTAMP) AS nlp_datetime,
	CAST(NULL AS STRING) AS term_exists,
	CAST(NULL AS STRING) AS term_temporal,
	CAST(NULL AS STRING) AS term_modifiers  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.note_nlp   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.specimen  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS specimen_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS specimen_concept_id,
	CAST(NULL AS integer) AS specimen_type_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS specimen_date,
	CAST(NULL AS TIMESTAMP) AS specimen_datetime,
	CAST(NULL AS DOUBLE) AS quantity,
	CAST(NULL AS integer) AS unit_concept_id,
	CAST(NULL AS integer) AS anatomic_site_concept_id,
	CAST(NULL AS integer) AS disease_status_concept_id,
	CAST(NULL AS STRING) AS specimen_source_id,
	CAST(NULL AS STRING) AS specimen_source_value,
	CAST(NULL AS STRING) AS unit_source_value,
	CAST(NULL AS STRING) AS anatomic_site_source_value,
	CAST(NULL AS STRING) AS disease_status_source_value  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.specimen   ZORDER BY person_id;
CREATE TABLE @cdmDatabaseSchema.fact_relationship  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS domain_concept_id_1,
	CAST(NULL AS integer) AS fact_id_1,
	CAST(NULL AS integer) AS domain_concept_id_2,
	CAST(NULL AS integer) AS fact_id_2,
	CAST(NULL AS integer) AS relationship_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.fact_relationship   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.location  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS location_id,
	CAST(NULL AS STRING) AS address_1,
	CAST(NULL AS STRING) AS address_2,
	CAST(NULL AS STRING) AS city,
	CAST(NULL AS STRING) AS state,
	CAST(NULL AS STRING) AS zip,
	CAST(NULL AS STRING) AS county,
	CAST(NULL AS STRING) AS location_source_value  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.location   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.care_site  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS care_site_id,
	CAST(NULL AS STRING) AS care_site_name,
	CAST(NULL AS integer) AS place_of_service_concept_id,
	CAST(NULL AS integer) AS location_id,
	CAST(NULL AS STRING) AS care_site_source_value,
	CAST(NULL AS STRING) AS place_of_service_source_value  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.care_site   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.provider  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS provider_id,
	CAST(NULL AS STRING) AS provider_name,
	CAST(NULL AS STRING) AS npi,
	CAST(NULL AS STRING) AS dea,
	CAST(NULL AS integer) AS specialty_concept_id,
	CAST(NULL AS integer) AS care_site_id,
	CAST(NULL AS integer) AS year_of_birth,
	CAST(NULL AS integer) AS gender_concept_id,
	CAST(NULL AS STRING) AS provider_source_value,
	CAST(NULL AS STRING) AS specialty_source_value,
	CAST(NULL AS integer) AS specialty_source_concept_id,
	CAST(NULL AS STRING) AS gender_source_value,
	CAST(NULL AS integer) AS gender_source_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.provider   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.payer_plan_period  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS payer_plan_period_id,
	CAST(NULL AS integer) AS person_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS payer_plan_period_start_date,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS payer_plan_period_end_date,
	CAST(NULL AS integer) AS payer_concept_id,
	CAST(NULL AS STRING) AS payer_source_value,
	CAST(NULL AS integer) AS payer_source_concept_id,
	CAST(NULL AS integer) AS plan_concept_id,
	CAST(NULL AS STRING) AS plan_source_value,
	CAST(NULL AS integer) AS plan_source_concept_id,
	CAST(NULL AS integer) AS sponsor_concept_id,
	CAST(NULL AS STRING) AS sponsor_source_value,
	CAST(NULL AS integer) AS sponsor_source_concept_id,
	CAST(NULL AS STRING) AS family_source_value,
	CAST(NULL AS integer) AS stop_reason_concept_id,
	CAST(NULL AS STRING) AS stop_reason_source_value,
	CAST(NULL AS integer) AS stop_reason_source_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.payer_plan_period   ZORDER BY person_id;
CREATE TABLE @cdmDatabaseSchema.cost  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS cost_id,
	CAST(NULL AS integer) AS cost_event_id,
	CAST(NULL AS STRING) AS cost_domain_id,
	CAST(NULL AS integer) AS cost_type_concept_id,
	CAST(NULL AS integer) AS currency_concept_id,
	CAST(NULL AS DOUBLE) AS total_charge,
	CAST(NULL AS DOUBLE) AS total_cost,
	CAST(NULL AS DOUBLE) AS total_paid,
	CAST(NULL AS DOUBLE) AS paid_by_payer,
	CAST(NULL AS DOUBLE) AS paid_by_patient,
	CAST(NULL AS DOUBLE) AS paid_patient_copay,
	CAST(NULL AS DOUBLE) AS paid_patient_coinsurance,
	CAST(NULL AS DOUBLE) AS paid_patient_deductible,
	CAST(NULL AS DOUBLE) AS paid_by_primary,
	CAST(NULL AS DOUBLE) AS paid_ingredient_cost,
	CAST(NULL AS DOUBLE) AS paid_dispensing_fee,
	CAST(NULL AS integer) AS payer_plan_period_id,
	CAST(NULL AS DOUBLE) AS amount_allowed,
	CAST(NULL AS integer) AS revenue_code_concept_id,
	CAST(NULL AS STRING) AS revenue_code_source_value,
	CAST(NULL AS integer) AS drg_concept_id,
	CAST(NULL AS STRING) AS drg_source_value  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.cost   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.drug_era  
USING DELTA
 AS
SELECT
CAST(NULL AS integer) AS drug_era_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS drug_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS drug_era_start_date,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS drug_era_end_date,
	CAST(NULL AS integer) AS drug_exposure_count,
	CAST(NULL AS integer) AS gap_days  WHERE 1 = 0;
CREATE TABLE @cdmDatabaseSchema.dose_era  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS dose_era_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS drug_concept_id,
	CAST(NULL AS integer) AS unit_concept_id,
	CAST(NULL AS DOUBLE) AS dose_value,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS dose_era_start_date,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS dose_era_end_date  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.dose_era   ZORDER BY person_id;
CREATE TABLE @cdmDatabaseSchema.condition_era  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS condition_era_id,
	CAST(NULL AS integer) AS person_id,
	CAST(NULL AS integer) AS condition_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS condition_era_start_date,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS condition_era_end_date,
	CAST(NULL AS integer) AS condition_occurrence_count  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.condition_era   ZORDER BY person_id;
CREATE TABLE @cdmDatabaseSchema.metadata  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS metadata_concept_id,
	CAST(NULL AS integer) AS metadata_type_concept_id,
	CAST(NULL AS STRING) AS name,
	CAST(NULL AS STRING) AS value_as_string,
	CAST(NULL AS integer) AS value_as_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS metadata_date,
	CAST(NULL AS TIMESTAMP) AS metadata_datetime  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.metadata   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.cdm_source  
USING DELTA
AS
SELECT
CAST(NULL AS STRING) AS cdm_source_name,
	CAST(NULL AS STRING) AS cdm_source_abbreviation,
	CAST(NULL AS STRING) AS cdm_holder,
	CAST(NULL AS STRING) AS source_description,
	CAST(NULL AS STRING) AS source_documentation_reference,
	CAST(NULL AS STRING) AS cdm_etl_reference,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS source_release_date,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS cdm_release_date,
	CAST(NULL AS STRING) AS cdm_version,
	CAST(NULL AS STRING) AS vocabulary_version  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.cdm_source   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.concept  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS concept_id,
	CAST(NULL AS STRING) AS concept_name,
	CAST(NULL AS STRING) AS domain_id,
	CAST(NULL AS STRING) AS vocabulary_id,
	CAST(NULL AS STRING) AS concept_class_id,
	CAST(NULL AS STRING) AS standard_concept,
	CAST(NULL AS STRING) AS concept_code,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS valid_start_date,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS valid_end_date,
	CAST(NULL AS STRING) AS invalid_reason  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.concept   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.vocabulary  
USING DELTA
AS
SELECT
CAST(NULL AS STRING) AS vocabulary_id,
	CAST(NULL AS STRING) AS vocabulary_name,
	CAST(NULL AS STRING) AS vocabulary_reference,
	CAST(NULL AS STRING) AS vocabulary_version,
	CAST(NULL AS integer) AS vocabulary_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.vocabulary   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.domain  
USING DELTA
AS
SELECT
CAST(NULL AS STRING) AS domain_id,
	CAST(NULL AS STRING) AS domain_name,
	CAST(NULL AS integer) AS domain_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.domain   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.concept_class  
USING DELTA
AS
SELECT
CAST(NULL AS STRING) AS concept_class_id,
	CAST(NULL AS STRING) AS concept_class_name,
	CAST(NULL AS integer) AS concept_class_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.concept_class   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.concept_relationship  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS concept_id_1,
	CAST(NULL AS integer) AS concept_id_2,
	CAST(NULL AS STRING) AS relationship_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS valid_start_date,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS valid_end_date,
	CAST(NULL AS STRING) AS invalid_reason  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.concept_relationship   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.relationship  
USING DELTA
AS
SELECT
CAST(NULL AS STRING) AS relationship_id,
	CAST(NULL AS STRING) AS relationship_name,
	CAST(NULL AS STRING) AS is_hierarchical,
	CAST(NULL AS STRING) AS defines_ancestry,
	CAST(NULL AS STRING) AS reverse_relationship_id,
	CAST(NULL AS integer) AS relationship_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.relationship   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.concept_synonym  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS concept_id,
	CAST(NULL AS STRING) AS concept_synonym_name,
	CAST(NULL AS integer) AS language_concept_id  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.concept_synonym   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.concept_ancestor  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS ancestor_concept_id,
	CAST(NULL AS integer) AS descendant_concept_id,
	CAST(NULL AS integer) AS min_levels_of_separation,
	CAST(NULL AS integer) AS max_levels_of_separation  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.concept_ancestor   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.source_to_concept_map  
USING DELTA
AS
SELECT
CAST(NULL AS STRING) AS source_code,
	CAST(NULL AS integer) AS source_concept_id,
	CAST(NULL AS STRING) AS source_vocabulary_id,
	CAST(NULL AS STRING) AS source_code_description,
	CAST(NULL AS integer) AS target_concept_id,
	CAST(NULL AS STRING) AS target_vocabulary_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS valid_start_date,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS valid_end_date,
	CAST(NULL AS STRING) AS invalid_reason  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.source_to_concept_map   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.drug_strength  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS drug_concept_id,
	CAST(NULL AS integer) AS ingredient_concept_id,
	CAST(NULL AS DOUBLE) AS amount_value,
	CAST(NULL AS integer) AS amount_unit_concept_id,
	CAST(NULL AS DOUBLE) AS numerator_value,
	CAST(NULL AS integer) AS numerator_unit_concept_id,
	CAST(NULL AS DOUBLE) AS denominator_value,
	CAST(NULL AS integer) AS denominator_unit_concept_id,
	CAST(NULL AS integer) AS box_size,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS valid_start_date,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS valid_end_date,
	CAST(NULL AS STRING) AS invalid_reason  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.drug_strength   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.cohort_definition  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS cohort_definition_id,
	CAST(NULL AS STRING) AS cohort_definition_name,
	CAST(NULL AS STRING) AS cohort_definition_description,
	CAST(NULL AS integer) AS definition_type_concept_id,
	CAST(NULL AS STRING) AS cohort_definition_syntax,
	CAST(NULL AS integer) AS subject_concept_id,
	IF(try_cast(NULL  AS DATE) IS NULL, to_date(cast(NULL  AS STRING), 'yyyyMMdd'), try_cast(NULL  AS DATE)) AS cohort_initiation_date  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.cohort_definition   ZORDER BY RANDOM;
CREATE TABLE @cdmDatabaseSchema.attribute_definition  
USING DELTA
AS
SELECT
CAST(NULL AS integer) AS attribute_definition_id,
	CAST(NULL AS STRING) AS attribute_name,
	CAST(NULL AS STRING) AS attribute_description,
	CAST(NULL AS integer) AS attribute_type_concept_id,
	CAST(NULL AS STRING) AS attribute_syntax  WHERE 1 = 0;
OPTIMIZE @cdmDatabaseSchema.attribute_definition   ZORDER BY RANDOM;