--bigquery CDM DDL Specification for OMOP Common Data Model 5.4
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.person (
			person_id INT64 not null,
			gender_concept_id INT64 not null,
			year_of_birth INT64 not null,
			month_of_birth INT64,
			day_of_birth INT64,
			birth_datetime DATETIME,
			race_concept_id INT64 not null,
			ethnicity_concept_id INT64 not null,
			location_id INT64,
			provider_id INT64,
			care_site_id INT64,
			person_source_value STRING,
			gender_source_value STRING,
			gender_source_concept_id INT64,
			race_source_value STRING,
			race_source_concept_id INT64,
			ethnicity_source_value STRING,
			ethnicity_source_concept_id INT64 );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.observation_period (
			observation_period_id INT64 not null,
			person_id INT64 not null,
			observation_period_start_date date not null,
			observation_period_end_date date not null,
			period_type_concept_id INT64 not null );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.visit_occurrence (
			visit_occurrence_id INT64 not null,
			person_id INT64 not null,
			visit_concept_id INT64 not null,
			visit_start_date date not null,
			visit_start_datetime DATETIME,
			visit_end_date date not null,
			visit_end_datetime DATETIME,
			visit_type_concept_id INT64 not null,
			provider_id INT64,
			care_site_id INT64,
			visit_source_value STRING,
			visit_source_concept_id INT64,
			admitted_from_concept_id INT64,
			admitted_from_source_value STRING,
			discharged_to_concept_id INT64,
			discharged_to_source_value STRING,
			preceding_visit_occurrence_id INT64 );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.visit_detail (
			visit_detail_id INT64 not null,
			person_id INT64 not null,
			visit_detail_concept_id INT64 not null,
			visit_detail_start_date date not null,
			visit_detail_start_datetime DATETIME,
			visit_detail_end_date date not null,
			visit_detail_end_datetime DATETIME,
			visit_detail_type_concept_id INT64 not null,
			provider_id INT64,
			care_site_id INT64,
			visit_detail_source_value STRING,
			visit_detail_source_concept_id INT64,
			admitted_from_concept_id INT64,
			admitted_from_source_value STRING,
			discharged_to_source_value STRING,
			discharged_to_concept_id INT64,
			preceding_visit_detail_id INT64,
			parent_visit_detail_id INT64,
			visit_occurrence_id INT64 not null );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.condition_occurrence (
			condition_occurrence_id INT64 not null,
			person_id INT64 not null,
			condition_concept_id INT64 not null,
			condition_start_date date not null,
			condition_start_datetime DATETIME,
			condition_end_date DATE,
			condition_end_datetime DATETIME,
			condition_type_concept_id INT64 not null,
			condition_status_concept_id INT64,
			stop_reason STRING,
			provider_id INT64,
			visit_occurrence_id INT64,
			visit_detail_id INT64,
			condition_source_value STRING,
			condition_source_concept_id INT64,
			condition_status_source_value STRING );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.drug_exposure (
			drug_exposure_id INT64 not null,
			person_id INT64 not null,
			drug_concept_id INT64 not null,
			drug_exposure_start_date date not null,
			drug_exposure_start_datetime DATETIME,
			drug_exposure_end_date date not null,
			drug_exposure_end_datetime DATETIME,
			verbatim_end_date DATE,
			drug_type_concept_id INT64 not null,
			stop_reason STRING,
			refills INT64,
			quantity FLOAT64,
			days_supply INT64,
			sig STRING,
			route_concept_id INT64,
			lot_number STRING,
			provider_id INT64,
			visit_occurrence_id INT64,
			visit_detail_id INT64,
			drug_source_value STRING,
			drug_source_concept_id INT64,
			route_source_value STRING,
			dose_unit_source_value STRING );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.procedure_occurrence (
			procedure_occurrence_id INT64 not null,
			person_id INT64 not null,
			procedure_concept_id INT64 not null,
			procedure_date date not null,
			procedure_datetime DATETIME,
			procedure_end_date DATE,
			procedure_end_datetime DATETIME,
			procedure_type_concept_id INT64 not null,
			modifier_concept_id INT64,
			quantity INT64,
			provider_id INT64,
			visit_occurrence_id INT64,
			visit_detail_id INT64,
			procedure_source_value STRING,
			procedure_source_concept_id INT64,
			modifier_source_value STRING );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.device_exposure (
			device_exposure_id INT64 not null,
			person_id INT64 not null,
			device_concept_id INT64 not null,
			device_exposure_start_date date not null,
			device_exposure_start_datetime DATETIME,
			device_exposure_end_date DATE,
			device_exposure_end_datetime DATETIME,
			device_type_concept_id INT64 not null,
			unique_device_id STRING,
			production_id STRING,
			quantity INT64,
			provider_id INT64,
			visit_occurrence_id INT64,
			visit_detail_id INT64,
			device_source_value STRING,
			device_source_concept_id INT64,
			unit_concept_id INT64,
			unit_source_value STRING,
			unit_source_concept_id INT64 );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.measurement (
			measurement_id INT64 not null,
			person_id INT64 not null,
			measurement_concept_id INT64 not null,
			measurement_date date not null,
			measurement_datetime DATETIME,
			measurement_time STRING,
			measurement_type_concept_id INT64 not null,
			operator_concept_id INT64,
			value_as_number FLOAT64,
			value_as_concept_id INT64,
			unit_concept_id INT64,
			range_low FLOAT64,
			range_high FLOAT64,
			provider_id INT64,
			visit_occurrence_id INT64,
			visit_detail_id INT64,
			measurement_source_value STRING,
			measurement_source_concept_id INT64,
			unit_source_value STRING,
			unit_source_concept_id INT64,
			value_source_value STRING,
			measurement_event_id INT64,
			meas_event_field_concept_id INT64 );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.observation (
			observation_id INT64 not null,
			person_id INT64 not null,
			observation_concept_id INT64 not null,
			observation_date date not null,
			observation_datetime DATETIME,
			observation_type_concept_id INT64 not null,
			value_as_number FLOAT64,
			value_as_string STRING,
			value_as_concept_id INT64,
			qualifier_concept_id INT64,
			unit_concept_id INT64,
			provider_id INT64,
			visit_occurrence_id INT64,
			visit_detail_id INT64,
			observation_source_value STRING,
			observation_source_concept_id INT64,
			unit_source_value STRING,
			qualifier_source_value STRING,
			value_source_value STRING,
			observation_event_id INT64,
			obs_event_field_concept_id INT64 );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.death (
			person_id INT64 not null,
			death_date date not null,
			death_datetime DATETIME,
			death_type_concept_id INT64,
			cause_concept_id INT64,
			cause_source_value STRING,
			cause_source_concept_id INT64 );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.note (
			note_id INT64 not null,
			person_id INT64 not null,
			note_date date not null,
			note_datetime DATETIME,
			note_type_concept_id INT64 not null,
			note_class_concept_id INT64 not null,
			note_title STRING,
			note_text STRING not null,
			encoding_concept_id INT64 not null,
			language_concept_id INT64 not null,
			provider_id INT64,
			visit_occurrence_id INT64,
			visit_detail_id INT64,
			note_source_value STRING,
			note_event_id INT64,
			note_event_field_concept_id INT64 );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.note_nlp (
			note_nlp_id INT64 not null,
			note_id INT64 not null,
			section_concept_id INT64,
			snippet STRING,
			`offset` STRING,
			lexical_variant STRING not null,
			note_nlp_concept_id INT64,
			note_nlp_source_concept_id INT64,
			nlp_system STRING,
			nlp_date date not null,
			nlp_datetime DATETIME,
			term_exists STRING,
			term_temporal STRING,
			term_modifiers STRING );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.specimen (
			specimen_id INT64 not null,
			person_id INT64 not null,
			specimen_concept_id INT64 not null,
			specimen_type_concept_id INT64 not null,
			specimen_date date not null,
			specimen_datetime DATETIME,
			quantity FLOAT64,
			unit_concept_id INT64,
			anatomic_site_concept_id INT64,
			disease_status_concept_id INT64,
			specimen_source_id STRING,
			specimen_source_value STRING,
			unit_source_value STRING,
			anatomic_site_source_value STRING,
			disease_status_source_value STRING );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.fact_relationship (
			domain_concept_id_1 INT64 not null,
			fact_id_1 INT64 not null,
			domain_concept_id_2 INT64 not null,
			fact_id_2 INT64 not null,
			relationship_concept_id INT64 not null );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.location (
			location_id INT64 not null,
			address_1 STRING,
			address_2 STRING,
			city STRING,
			state STRING,
			zip STRING,
			county STRING,
			location_source_value STRING,
			country_concept_id INT64,
			country_source_value STRING,
			latitude FLOAT64,
			longitude FLOAT64 );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.care_site (
			care_site_id INT64 not null,
			care_site_name STRING,
			place_of_service_concept_id INT64,
			location_id INT64,
			care_site_source_value STRING,
			place_of_service_source_value STRING );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.provider (
			provider_id INT64 not null,
			provider_name STRING,
			npi STRING,
			dea STRING,
			specialty_concept_id INT64,
			care_site_id INT64,
			year_of_birth INT64,
			gender_concept_id INT64,
			provider_source_value STRING,
			specialty_source_value STRING,
			specialty_source_concept_id INT64,
			gender_source_value STRING,
			gender_source_concept_id INT64 );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.payer_plan_period (
			payer_plan_period_id INT64 not null,
			person_id INT64 not null,
			payer_plan_period_start_date date not null,
			payer_plan_period_end_date date not null,
			payer_concept_id INT64,
			payer_source_value STRING,
			payer_source_concept_id INT64,
			plan_concept_id INT64,
			plan_source_value STRING,
			plan_source_concept_id INT64,
			sponsor_concept_id INT64,
			sponsor_source_value STRING,
			sponsor_source_concept_id INT64,
			family_source_value STRING,
			stop_reason_concept_id INT64,
			stop_reason_source_value STRING,
			stop_reason_source_concept_id INT64 );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.cost (
			cost_id INT64 not null,
			cost_event_id INT64 not null,
			cost_domain_id STRING not null,
			cost_type_concept_id INT64 not null,
			currency_concept_id INT64,
			total_charge FLOAT64,
			total_cost FLOAT64,
			total_paid FLOAT64,
			paid_by_payer FLOAT64,
			paid_by_patient FLOAT64,
			paid_patient_copay FLOAT64,
			paid_patient_coinsurance FLOAT64,
			paid_patient_deductible FLOAT64,
			paid_by_primary FLOAT64,
			paid_ingredient_cost FLOAT64,
			paid_dispensing_fee FLOAT64,
			payer_plan_period_id INT64,
			amount_allowed FLOAT64,
			revenue_code_concept_id INT64,
			revenue_code_source_value STRING,
			drg_concept_id INT64,
			drg_source_value STRING );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.drug_era (
			drug_era_id INT64 not null,
			person_id INT64 not null,
			drug_concept_id INT64 not null,
			drug_era_start_date date not null,
			drug_era_end_date date not null,
			drug_exposure_count INT64,
			gap_days INT64 );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.dose_era (
			dose_era_id INT64 not null,
			person_id INT64 not null,
			drug_concept_id INT64 not null,
			unit_concept_id INT64 not null,
			dose_value FLOAT64 not null,
			dose_era_start_date date not null,
			dose_era_end_date date not null );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.condition_era (
			condition_era_id INT64 not null,
			person_id INT64 not null,
			condition_concept_id INT64 not null,
			condition_era_start_date date not null,
			condition_era_end_date date not null,
			condition_occurrence_count INT64 );
--HINT DISTRIBUTE ON KEY (person_id)
create table @cdmDatabaseSchema.episode (
			episode_id INT64 not null,
			person_id INT64 not null,
			episode_concept_id INT64 not null,
			episode_start_date date not null,
			episode_start_datetime DATETIME,
			episode_end_date DATE,
			episode_end_datetime DATETIME,
			episode_parent_id INT64,
			episode_number INT64,
			episode_object_concept_id INT64 not null,
			episode_type_concept_id INT64 not null,
			episode_source_value STRING,
			episode_source_concept_id INT64 );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.episode_event (
			episode_id INT64 not null,
			event_id INT64 not null,
			episode_event_field_concept_id INT64 not null );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.metadata (
			metadata_id INT64 not null,
			metadata_concept_id INT64 not null,
			metadata_type_concept_id INT64 not null,
			name STRING not null,
			value_as_string STRING,
			value_as_concept_id INT64,
			value_as_number FLOAT64,
			metadata_date DATE,
			metadata_datetime DATETIME );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.cdm_source (
			cdm_source_name STRING not null,
			cdm_source_abbreviation STRING not null,
			cdm_holder STRING not null,
			source_description STRING,
			source_documentation_reference STRING,
			cdm_etl_reference STRING,
			source_release_date date not null,
			cdm_release_date date not null,
			cdm_version STRING,
			cdm_version_concept_id INT64 not null,
			vocabulary_version STRING not null );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.concept (
			concept_id INT64 not null,
			concept_name STRING not null,
			domain_id STRING not null,
			vocabulary_id STRING not null,
			concept_class_id STRING not null,
			standard_concept STRING,
			concept_code STRING not null,
			valid_start_date date not null,
			valid_end_date date not null,
			invalid_reason STRING );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.vocabulary (
			vocabulary_id STRING not null,
			vocabulary_name STRING not null,
			vocabulary_reference STRING,
			vocabulary_version STRING,
			vocabulary_concept_id INT64 not null );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.domain (
			domain_id STRING not null,
			domain_name STRING not null,
			domain_concept_id INT64 not null );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.concept_class (
			concept_class_id STRING not null,
			concept_class_name STRING not null,
			concept_class_concept_id INT64 not null );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.concept_relationship (
			concept_id_1 INT64 not null,
			concept_id_2 INT64 not null,
			relationship_id STRING not null,
			valid_start_date date not null,
			valid_end_date date not null,
			invalid_reason STRING );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.relationship (
			relationship_id STRING not null,
			relationship_name STRING not null,
			is_hierarchical STRING not null,
			defines_ancestry STRING not null,
			reverse_relationship_id STRING not null,
			relationship_concept_id INT64 not null );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.concept_synonym (
			concept_id INT64 not null,
			concept_synonym_name STRING not null,
			language_concept_id INT64 not null );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.concept_ancestor (
			ancestor_concept_id INT64 not null,
			descendant_concept_id INT64 not null,
			min_levels_of_separation INT64 not null,
			max_levels_of_separation INT64 not null );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.source_to_concept_map (
			source_code STRING not null,
			source_concept_id INT64 not null,
			source_vocabulary_id STRING not null,
			source_code_description STRING,
			target_concept_id INT64 not null,
			target_vocabulary_id STRING not null,
			valid_start_date date not null,
			valid_end_date date not null,
			invalid_reason STRING );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.drug_strength (
			drug_concept_id INT64 not null,
			ingredient_concept_id INT64 not null,
			amount_value FLOAT64,
			amount_unit_concept_id INT64,
			numerator_value FLOAT64,
			numerator_unit_concept_id INT64,
			denominator_value FLOAT64,
			denominator_unit_concept_id INT64,
			box_size INT64,
			valid_start_date date not null,
			valid_end_date date not null,
			invalid_reason STRING );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.cohort (
			cohort_definition_id INT64 not null,
			subject_id INT64 not null,
			cohort_start_date date not null,
			cohort_end_date date not null );
--HINT DISTRIBUTE ON RANDOM
create table @cdmDatabaseSchema.cohort_definition (
			cohort_definition_id INT64 not null,
			cohort_definition_name STRING not null,
			cohort_definition_description STRING,
			definition_type_concept_id INT64 not null,
			cohort_definition_syntax STRING,
			subject_concept_id INT64 not null,
			cohort_initiation_date DATE );