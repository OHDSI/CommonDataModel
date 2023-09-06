--hive CDM DDL Specification for OMOP Common Data Model 5.3
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.person (
			person_id integer NOT NULL,
			gender_concept_id integer NOT NULL,
			year_of_birth integer NOT NULL,
			month_of_birth integer NULL,
			day_of_birth integer NULL,
			birth_datetime TIMESTAMP,
			race_concept_id integer NOT NULL,
			ethnicity_concept_id integer NOT NULL,
			location_id integer NULL,
			provider_id integer NULL,
			care_site_id integer NULL,
			person_source_value VARCHAR(50),
			gender_source_value VARCHAR(50),
			gender_source_concept_id integer NULL,
			race_source_value VARCHAR(50),
			race_source_concept_id integer NULL,
			ethnicity_source_value VARCHAR(50),
			ethnicity_source_concept_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.observation_period (
			observation_period_id integer NOT NULL,
			person_id integer NOT NULL,
			observation_period_start_date TIMESTAMP,
			observation_period_end_date TIMESTAMP,
			period_type_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.visit_occurrence (
			visit_occurrence_id integer NOT NULL,
			person_id integer NOT NULL,
			visit_concept_id integer NOT NULL,
			visit_start_date TIMESTAMP,
			visit_start_datetime TIMESTAMP,
			visit_end_date TIMESTAMP,
			visit_end_datetime TIMESTAMP,
			visit_type_concept_id Integer NOT NULL,
			provider_id integer NULL,
			care_site_id integer NULL,
			visit_source_value VARCHAR(50),
			visit_source_concept_id integer NULL,
			admitting_source_concept_id integer NULL,
			admitting_source_value VARCHAR(50),
			discharge_to_concept_id integer NULL,
			discharge_to_source_value VARCHAR(50),
			preceding_visit_occurrence_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.visit_detail (
			visit_detail_id integer NOT NULL,
			person_id integer NOT NULL,
			visit_detail_concept_id integer NOT NULL,
			visit_detail_start_date TIMESTAMP,
			visit_detail_start_datetime TIMESTAMP,
			visit_detail_end_date TIMESTAMP,
			visit_detail_end_datetime TIMESTAMP,
			visit_detail_type_concept_id integer NOT NULL,
			provider_id integer NULL,
			care_site_id integer NULL,
			visit_detail_source_value VARCHAR(50),
			visit_detail_source_concept_id Integer NULL,
			admitting_source_value VARCHAR(50),
			admitting_source_concept_id Integer NULL,
			discharge_to_source_value VARCHAR(50),
			discharge_to_concept_id integer NULL,
			preceding_visit_detail_id integer NULL,
			visit_detail_parent_id integer NULL,
			visit_occurrence_id integer NOT NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.condition_occurrence (
			condition_occurrence_id integer NOT NULL,
			person_id integer NOT NULL,
			condition_concept_id integer NOT NULL,
			condition_start_date TIMESTAMP,
			condition_start_datetime TIMESTAMP,
			condition_end_date TIMESTAMP,
			condition_end_datetime TIMESTAMP,
			condition_type_concept_id integer NOT NULL,
			condition_status_concept_id integer NULL,
			stop_reason VARCHAR(20),
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			condition_source_value VARCHAR(50),
			condition_source_concept_id integer NULL,
			condition_status_source_value VARCHAR(50) );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.drug_exposure (
			drug_exposure_id integer NOT NULL,
			person_id integer NOT NULL,
			drug_concept_id integer NOT NULL,
			drug_exposure_start_date TIMESTAMP,
			drug_exposure_start_datetime TIMESTAMP,
			drug_exposure_end_date TIMESTAMP,
			drug_exposure_end_datetime TIMESTAMP,
			verbatim_end_date TIMESTAMP,
			drug_type_concept_id integer NOT NULL,
			stop_reason VARCHAR(20),
			refills integer NULL,
			quantity FLOAT,
			days_supply integer NULL,
			sig VARCHAR(MAX),
			route_concept_id integer NULL,
			lot_number VARCHAR(50),
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			drug_source_value VARCHAR(50),
			drug_source_concept_id integer NULL,
			route_source_value VARCHAR(50),
			dose_unit_source_value VARCHAR(50) );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.procedure_occurrence (
			procedure_occurrence_id integer NOT NULL,
			person_id integer NOT NULL,
			procedure_concept_id integer NOT NULL,
			procedure_date TIMESTAMP,
			procedure_datetime TIMESTAMP,
			procedure_type_concept_id integer NOT NULL,
			modifier_concept_id integer NULL,
			quantity integer NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			procedure_source_value VARCHAR(50),
			procedure_source_concept_id integer NULL,
			modifier_source_value VARCHAR(50) );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.device_exposure (
			device_exposure_id integer NOT NULL,
			person_id integer NOT NULL,
			device_concept_id integer NOT NULL,
			device_exposure_start_date TIMESTAMP,
			device_exposure_start_datetime TIMESTAMP,
			device_exposure_end_date TIMESTAMP,
			device_exposure_end_datetime TIMESTAMP,
			device_type_concept_id integer NOT NULL,
			unique_device_id VARCHAR(50),
			quantity integer NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			device_source_value VARCHAR(50),
			device_source_concept_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.measurement (
			measurement_id integer NOT NULL,
			person_id integer NOT NULL,
			measurement_concept_id integer NOT NULL,
			measurement_date TIMESTAMP,
			measurement_datetime TIMESTAMP,
			measurement_time VARCHAR(10),
			measurement_type_concept_id integer NOT NULL,
			operator_concept_id integer NULL,
			value_as_number FLOAT,
			value_as_concept_id integer NULL,
			unit_concept_id integer NULL,
			range_low FLOAT,
			range_high FLOAT,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			measurement_source_value VARCHAR(50),
			measurement_source_concept_id integer NULL,
			unit_source_value VARCHAR(50),
			value_source_value VARCHAR(50) );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.observation (
			observation_id integer NOT NULL,
			person_id integer NOT NULL,
			observation_concept_id integer NOT NULL,
			observation_date TIMESTAMP,
			observation_datetime TIMESTAMP,
			observation_type_concept_id integer NOT NULL,
			value_as_number FLOAT,
			value_as_string VARCHAR(60),
			value_as_concept_id Integer NULL,
			qualifier_concept_id integer NULL,
			unit_concept_id integer NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			observation_source_value VARCHAR(50),
			observation_source_concept_id integer NULL,
			unit_source_value VARCHAR(50),
			qualifier_source_value VARCHAR(50) );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.death (
			person_id integer NOT NULL,
			death_date TIMESTAMP,
			death_datetime TIMESTAMP,
			death_type_concept_id integer NULL,
			cause_concept_id integer NULL,
			cause_source_value VARCHAR(50),
			cause_source_concept_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.note (
			note_id integer NOT NULL,
			person_id integer NOT NULL,
			note_date TIMESTAMP,
			note_datetime TIMESTAMP,
			note_type_concept_id integer NOT NULL,
			note_class_concept_id integer NOT NULL,
			note_title VARCHAR(250),
			note_text VARCHAR(MAX),
			encoding_concept_id integer NOT NULL,
			language_concept_id integer NOT NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			note_source_value VARCHAR(50) );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.note_nlp (
			note_nlp_id integer NOT NULL,
			note_id integer NOT NULL,
			section_concept_id integer NULL,
			snippet VARCHAR(250),
			"offset" VARCHAR(50),
			lexical_variant VARCHAR(250),
			note_nlp_concept_id integer NULL,
			note_nlp_source_concept_id integer NULL,
			nlp_system VARCHAR(250),
			nlp_date TIMESTAMP,
			nlp_datetime TIMESTAMP,
			term_exists VARCHAR(1),
			term_temporal VARCHAR(50),
			term_modifiers VARCHAR(2000) );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.specimen (
			specimen_id integer NOT NULL,
			person_id integer NOT NULL,
			specimen_concept_id integer NOT NULL,
			specimen_type_concept_id integer NOT NULL,
			specimen_date TIMESTAMP,
			specimen_datetime TIMESTAMP,
			quantity FLOAT,
			unit_concept_id integer NULL,
			anatomic_site_concept_id integer NULL,
			disease_status_concept_id integer NULL,
			specimen_source_id VARCHAR(50),
			specimen_source_value VARCHAR(50),
			unit_source_value VARCHAR(50),
			anatomic_site_source_value VARCHAR(50),
			disease_status_source_value VARCHAR(50) );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.fact_relationship (
			domain_concept_id_1 integer NOT NULL,
			fact_id_1 integer NOT NULL,
			domain_concept_id_2 integer NOT NULL,
			fact_id_2 integer NOT NULL,
			relationship_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.location (
			location_id integer NOT NULL,
			address_1 VARCHAR(50),
			address_2 VARCHAR(50),
			city VARCHAR(50),
			state VARCHAR(2),
			zip VARCHAR(9),
			county VARCHAR(20),
			location_source_value VARCHAR(50) );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.care_site (
			care_site_id integer NOT NULL,
			care_site_name VARCHAR(255),
			place_of_service_concept_id integer NULL,
			location_id integer NULL,
			care_site_source_value VARCHAR(50),
			place_of_service_source_value VARCHAR(50) );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.provider (
			provider_id integer NOT NULL,
			provider_name VARCHAR(255),
			npi VARCHAR(20),
			dea VARCHAR(20),
			specialty_concept_id integer NULL,
			care_site_id integer NULL,
			year_of_birth integer NULL,
			gender_concept_id integer NULL,
			provider_source_value VARCHAR(50),
			specialty_source_value VARCHAR(50),
			specialty_source_concept_id integer NULL,
			gender_source_value VARCHAR(50),
			gender_source_concept_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.payer_plan_period (
			payer_plan_period_id integer NOT NULL,
			person_id integer NOT NULL,
			payer_plan_period_start_date TIMESTAMP,
			payer_plan_period_end_date TIMESTAMP,
			payer_concept_id integer NULL,
			payer_source_value VARCHAR(50),
			payer_source_concept_id integer NULL,
			plan_concept_id integer NULL,
			plan_source_value VARCHAR(50),
			plan_source_concept_id integer NULL,
			sponsor_concept_id integer NULL,
			sponsor_source_value VARCHAR(50),
			sponsor_source_concept_id integer NULL,
			family_source_value VARCHAR(50),
			stop_reason_concept_id integer NULL,
			stop_reason_source_value VARCHAR(50),
			stop_reason_source_concept_id integer NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.cost (
			cost_id integer NOT NULL,
			cost_event_id integer NOT NULL,
			cost_domain_id VARCHAR(20),
			cost_type_concept_id integer NOT NULL,
			currency_concept_id integer NULL,
			total_charge FLOAT,
			total_cost FLOAT,
			total_paid FLOAT,
			paid_by_payer FLOAT,
			paid_by_patient FLOAT,
			paid_patient_copay FLOAT,
			paid_patient_coinsurance FLOAT,
			paid_patient_deductible FLOAT,
			paid_by_primary FLOAT,
			paid_ingredient_cost FLOAT,
			paid_dispensing_fee FLOAT,
			payer_plan_period_id integer NULL,
			amount_allowed FLOAT,
			revenue_code_concept_id integer NULL,
			revenue_code_source_value VARCHAR(50),
			drg_concept_id integer NULL,
			drg_source_value VARCHAR(3) );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.drug_era (
			drug_era_id integer NOT NULL,
			person_id integer NOT NULL,
			drug_concept_id integer NOT NULL,
			drug_era_start_date TIMESTAMP,
			drug_era_end_date TIMESTAMP,
			drug_exposure_count integer NULL,
			gap_days integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.dose_era (
			dose_era_id integer NOT NULL,
			person_id integer NOT NULL,
			drug_concept_id integer NOT NULL,
			unit_concept_id integer NOT NULL,
			dose_value FLOAT,
			dose_era_start_date TIMESTAMP,
			dose_era_end_date TIMESTAMP );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.condition_era (
			condition_era_id integer NOT NULL,
			person_id integer NOT NULL,
			condition_concept_id integer NOT NULL,
			condition_era_start_date TIMESTAMP,
			condition_era_end_date TIMESTAMP,
			condition_occurrence_count integer NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.metadata (
			metadata_concept_id integer NOT NULL,
			metadata_type_concept_id integer NOT NULL,
			name VARCHAR(250),
			value_as_string VARCHAR(250),
			value_as_concept_id integer NULL,
			metadata_date TIMESTAMP,
			metadata_datetime TIMESTAMP );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.cdm_source (
			cdm_source_name VARCHAR(255),
			cdm_source_abbreviation VARCHAR(25),
			cdm_holder VARCHAR(255),
			source_description VARCHAR(MAX),
			source_documentation_reference VARCHAR(255),
			cdm_etl_reference VARCHAR(255),
			source_release_date TIMESTAMP,
			cdm_release_date TIMESTAMP,
			cdm_version VARCHAR(10),
			vocabulary_version VARCHAR(20) );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.concept (
			concept_id integer NOT NULL,
			concept_name VARCHAR(255),
			domain_id VARCHAR(20),
			vocabulary_id VARCHAR(20),
			concept_class_id VARCHAR(20),
			standard_concept VARCHAR(1),
			concept_code VARCHAR(50),
			valid_start_date TIMESTAMP,
			valid_end_date TIMESTAMP,
			invalid_reason VARCHAR(1) );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.vocabulary (
			vocabulary_id VARCHAR(20),
			vocabulary_name VARCHAR(255),
			vocabulary_reference VARCHAR(255),
			vocabulary_version VARCHAR(255),
			vocabulary_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.domain (
			domain_id VARCHAR(20),
			domain_name VARCHAR(255),
			domain_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.concept_class (
			concept_class_id VARCHAR(20),
			concept_class_name VARCHAR(255),
			concept_class_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.concept_relationship (
			concept_id_1 integer NOT NULL,
			concept_id_2 integer NOT NULL,
			relationship_id VARCHAR(20),
			valid_start_date TIMESTAMP,
			valid_end_date TIMESTAMP,
			invalid_reason VARCHAR(1) );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.relationship (
			relationship_id VARCHAR(20),
			relationship_name VARCHAR(255),
			is_hierarchical VARCHAR(1),
			defines_ancestry VARCHAR(1),
			reverse_relationship_id VARCHAR(20),
			relationship_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.concept_synonym (
			concept_id integer NOT NULL,
			concept_synonym_name VARCHAR(1000),
			language_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.concept_ancestor (
			ancestor_concept_id integer NOT NULL,
			descendant_concept_id integer NOT NULL,
			min_levels_of_separation integer NOT NULL,
			max_levels_of_separation integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.source_to_concept_map (
			source_code VARCHAR(50),
			source_concept_id integer NOT NULL,
			source_vocabulary_id VARCHAR(20),
			source_code_description VARCHAR(255),
			target_concept_id integer NOT NULL,
			target_vocabulary_id VARCHAR(20),
			valid_start_date TIMESTAMP,
			valid_end_date TIMESTAMP,
			invalid_reason VARCHAR(1) );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.drug_strength (
			drug_concept_id integer NOT NULL,
			ingredient_concept_id integer NOT NULL,
			amount_value FLOAT,
			amount_unit_concept_id integer NULL,
			numerator_value FLOAT,
			numerator_unit_concept_id integer NULL,
			denominator_value FLOAT,
			denominator_unit_concept_id integer NULL,
			box_size integer NULL,
			valid_start_date TIMESTAMP,
			valid_end_date TIMESTAMP,
			invalid_reason VARCHAR(1) );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.cohort_definition (
			cohort_definition_id integer NOT NULL,
			cohort_definition_name VARCHAR(255),
			cohort_definition_description VARCHAR(MAX),
			definition_type_concept_id integer NOT NULL,
			cohort_definition_syntax VARCHAR(MAX),
			subject_concept_id integer NOT NULL,
			cohort_initiation_date TIMESTAMP );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.attribute_definition (
			attribute_definition_id integer NOT NULL,
			attribute_name VARCHAR(255),
			attribute_description VARCHAR(MAX),
			attribute_type_concept_id integer NOT NULL,
			attribute_syntax VARCHAR(MAX) );