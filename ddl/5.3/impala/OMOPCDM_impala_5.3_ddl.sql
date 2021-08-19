--impala CDM DDL Specification for OMOP Common Data Model 5.3

--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.PERSON (
			person_id INT,
			gender_concept_id INT,
			year_of_birth INT,
			month_of_birth integer NULL,
			day_of_birth integer NULL,
			birth_datetime TIMESTAMP,
			race_concept_id INT,
			ethnicity_concept_id INT,
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
CREATE TABLE @cdmDatabaseSchema.OBSERVATION_PERIOD (
			observation_period_id INT,
			person_id INT,
			observation_period_start_date TIMESTAMP,
			observation_period_end_date TIMESTAMP,
			period_type_concept_id INT );

--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.VISIT_OCCURRENCE (
			visit_occurrence_id INT,
			person_id INT,
			visit_concept_id INT,
			visit_start_date TIMESTAMP,
			visit_start_datetime TIMESTAMP,
			visit_end_date TIMESTAMP,
			visit_end_datetime TIMESTAMP,
			visit_type_concept_id INT,
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
CREATE TABLE @cdmDatabaseSchema.VISIT_DETAIL (
			visit_detail_id INT,
			person_id INT,
			visit_detail_concept_id INT,
			visit_detail_start_date TIMESTAMP,
			visit_detail_start_datetime TIMESTAMP,
			visit_detail_end_date TIMESTAMP,
			visit_detail_end_datetime TIMESTAMP,
			visit_detail_type_concept_id INT,
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
			visit_occurrence_id INT );

--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.CONDITION_OCCURRENCE (
			condition_occurrence_id INT,
			person_id INT,
			condition_concept_id INT,
			condition_start_date TIMESTAMP,
			condition_start_datetime TIMESTAMP,
			condition_end_date TIMESTAMP,
			condition_end_datetime TIMESTAMP,
			condition_type_concept_id INT,
			condition_status_concept_id integer NULL,
			stop_reason VARCHAR(20),
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			condition_source_value VARCHAR(50),
			condition_source_concept_id integer NULL,
			condition_status_source_value VARCHAR(50) );

--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.DRUG_EXPOSURE (
			drug_exposure_id INT,
			person_id INT,
			drug_concept_id INT,
			drug_exposure_start_date TIMESTAMP,
			drug_exposure_start_datetime TIMESTAMP,
			drug_exposure_end_date TIMESTAMP,
			drug_exposure_end_datetime TIMESTAMP,
			verbatim_end_date TIMESTAMP,
			drug_type_concept_id INT,
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
CREATE TABLE @cdmDatabaseSchema.PROCEDURE_OCCURRENCE (
			procedure_occurrence_id INT,
			person_id INT,
			procedure_concept_id INT,
			procedure_date TIMESTAMP,
			procedure_datetime TIMESTAMP,
			procedure_type_concept_id INT,
			modifier_concept_id integer NULL,
			quantity integer NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			procedure_source_value VARCHAR(50),
			procedure_source_concept_id integer NULL,
			modifier_source_value VARCHAR(50) );

--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.DEVICE_EXPOSURE (
			device_exposure_id INT,
			person_id INT,
			device_concept_id INT,
			device_exposure_start_date TIMESTAMP,
			device_exposure_start_datetime TIMESTAMP,
			device_exposure_end_date TIMESTAMP,
			device_exposure_end_datetime TIMESTAMP,
			device_type_concept_id INT,
			unique_device_id VARCHAR(50),
			quantity integer NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			device_source_value VARCHAR(50),
			device_source_concept_id integer NULL );

--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.MEASUREMENT (
			measurement_id INT,
			person_id INT,
			measurement_concept_id INT,
			measurement_date TIMESTAMP,
			measurement_datetime TIMESTAMP,
			measurement_time VARCHAR(10),
			measurement_type_concept_id INT,
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
CREATE TABLE @cdmDatabaseSchema.OBSERVATION (
			observation_id INT,
			person_id INT,
			observation_concept_id INT,
			observation_date TIMESTAMP,
			observation_datetime TIMESTAMP,
			observation_type_concept_id INT,
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
CREATE TABLE @cdmDatabaseSchema.DEATH (
			person_id INT,
			death_date TIMESTAMP,
			death_datetime TIMESTAMP,
			death_type_concept_id integer NULL,
			cause_concept_id integer NULL,
			cause_source_value VARCHAR(50),
			cause_source_concept_id integer NULL );

--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.NOTE (
			note_id INT,
			person_id INT,
			note_date TIMESTAMP,
			note_datetime TIMESTAMP,
			note_type_concept_id INT,
			note_class_concept_id INT,
			note_title VARCHAR(250),
			note_text VARCHAR(MAX),
			encoding_concept_id INT,
			language_concept_id INT,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			note_source_value VARCHAR(50) );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.NOTE_NLP (
			note_nlp_id INT,
			note_id INT,
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
CREATE TABLE @cdmDatabaseSchema.SPECIMEN (
			specimen_id INT,
			person_id INT,
			specimen_concept_id INT,
			specimen_type_concept_id INT,
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
CREATE TABLE @cdmDatabaseSchema.FACT_RELATIONSHIP (
			domain_concept_id_1 INT,
			fact_id_1 INT,
			domain_concept_id_2 INT,
			fact_id_2 INT,
			relationship_concept_id INT );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.`location` (
			location_id INT,
			address_1 VARCHAR(50),
			address_2 VARCHAR(50),
			city VARCHAR(50),
			state VARCHAR(2),
			zip VARCHAR(9),
			county VARCHAR(20),
			location_source_value VARCHAR(50) );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.CARE_SITE (
			care_site_id INT,
			care_site_name VARCHAR(255),
			place_of_service_concept_id integer NULL,
			location_id integer NULL,
			care_site_source_value VARCHAR(50),
			place_of_service_source_value VARCHAR(50) );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.PROVIDER (
			provider_id INT,
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
CREATE TABLE @cdmDatabaseSchema.PAYER_PLAN_PERIOD (
			payer_plan_period_id INT,
			person_id INT,
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
CREATE TABLE @cdmDatabaseSchema.COST (
			cost_id INT,
			cost_event_id INT,
			cost_domain_id VARCHAR(20),
			cost_type_concept_id INT,
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
CREATE TABLE @cdmDatabaseSchema.DRUG_ERA (
			drug_era_id INT,
			person_id INT,
			drug_concept_id INT,
			drug_era_start_date TIMESTAMP,
			drug_era_end_date TIMESTAMP,
			drug_exposure_count integer NULL,
			gap_days integer NULL );

--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.DOSE_ERA (
			dose_era_id INT,
			person_id INT,
			drug_concept_id INT,
			unit_concept_id INT,
			dose_value FLOAT,
			dose_era_start_date TIMESTAMP,
			dose_era_end_date TIMESTAMP );

--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.CONDITION_ERA (
			condition_era_id INT,
			person_id INT,
			condition_concept_id INT,
			condition_era_start_date TIMESTAMP,
			condition_era_end_date TIMESTAMP,
			condition_occurrence_count integer NULL );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.METADATA (
			metadata_concept_id INT,
			metadata_type_concept_id INT,
			name VARCHAR(250),
			value_as_string VARCHAR(250),
			value_as_concept_id integer NULL,
			metadata_date TIMESTAMP,
			metadata_datetime TIMESTAMP );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.CDM_SOURCE (
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
CREATE TABLE @cdmDatabaseSchema.CONCEPT (
			concept_id INT,
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
CREATE TABLE @cdmDatabaseSchema.VOCABULARY (
			vocabulary_id VARCHAR(20),
			vocabulary_name VARCHAR(255),
			vocabulary_reference VARCHAR(255),
			vocabulary_version VARCHAR(255),
			vocabulary_concept_id INT );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.DOMAIN (
			domain_id VARCHAR(20),
			domain_name VARCHAR(255),
			domain_concept_id INT );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.CONCEPT_CLASS (
			concept_class_id VARCHAR(20),
			concept_class_name VARCHAR(255),
			concept_class_concept_id INT );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.CONCEPT_RELATIONSHIP (
			concept_id_1 INT,
			concept_id_2 INT,
			relationship_id VARCHAR(20),
			valid_start_date TIMESTAMP,
			valid_end_date TIMESTAMP,
			invalid_reason VARCHAR(1) );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.RELATIONSHIP (
			relationship_id VARCHAR(20),
			relationship_name VARCHAR(255),
			is_hierarchical VARCHAR(1),
			defines_ancestry VARCHAR(1),
			reverse_relationship_id VARCHAR(20),
			relationship_concept_id INT );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.CONCEPT_SYNONYM (
			concept_id INT,
			concept_synonym_name VARCHAR(1000),
			language_concept_id INT );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.CONCEPT_ANCESTOR (
			ancestor_concept_id INT,
			descendant_concept_id INT,
			min_levels_of_separation INT,
			max_levels_of_separation INT );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.SOURCE_TO_CONCEPT_MAP (
			source_code VARCHAR(50),
			source_concept_id INT,
			source_vocabulary_id VARCHAR(20),
			source_code_description VARCHAR(255),
			target_concept_id INT,
			target_vocabulary_id VARCHAR(20),
			valid_start_date TIMESTAMP,
			valid_end_date TIMESTAMP,
			invalid_reason VARCHAR(1) );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.DRUG_STRENGTH (
			drug_concept_id INT,
			ingredient_concept_id INT,
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
CREATE TABLE @cdmDatabaseSchema.COHORT_DEFINITION (
			cohort_definition_id INT,
			cohort_definition_name VARCHAR(255),
			cohort_definition_description VARCHAR(MAX),
			definition_type_concept_id INT,
			cohort_definition_syntax VARCHAR(MAX),
			subject_concept_id INT,
			cohort_initiation_date TIMESTAMP );

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.ATTRIBUTE_DEFINITION (
			attribute_definition_id INT,
			attribute_name VARCHAR(255),
			attribute_description VARCHAR(MAX),
			attribute_type_concept_id INT,
			attribute_syntax VARCHAR(MAX) );