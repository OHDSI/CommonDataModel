--sqlite extended CDM DDL Specification for OMOP Common Data Model 5.4
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.person (
			person_id integer NOT NULL,
			gender_concept_id integer NOT NULL,
			year_of_birth integer NOT NULL,
			month_of_birth integer NULL,
			day_of_birth integer NULL,
			birth_datetime datetime NULL,
			race_concept_id integer NOT NULL,
			ethnicity_concept_id integer NOT NULL,
			location_id integer NULL,
			provider_id integer NULL,
			care_site_id integer NULL,
			person_source_value TEXT NULL,
			gender_source_value TEXT NULL,
			gender_source_concept_id integer NULL,
			race_source_value TEXT NULL,
			race_source_concept_id integer NULL,
			ethnicity_source_value TEXT NULL,
			ethnicity_source_concept_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.observation_period (
			observation_period_id integer NOT NULL,
			person_id integer NOT NULL,
			observation_period_start_date date NOT NULL,
			observation_period_end_date date NOT NULL,
			period_type_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.visit_occurrence (
			visit_occurrence_id integer NOT NULL,
			person_id integer NOT NULL,
			visit_concept_id integer NOT NULL,
			visit_start_date date NOT NULL,
			visit_start_datetime datetime NULL,
			visit_end_date date NOT NULL,
			visit_end_datetime datetime NULL,
			visit_type_concept_id Integer NOT NULL,
			provider_id integer NULL,
			care_site_id integer NULL,
			visit_source_value TEXT NULL,
			visit_source_concept_id integer NULL,
			admitted_from_concept_id integer NULL,
			admitted_from_source_value TEXT NULL,
			discharged_to_concept_id integer NULL,
			discharged_to_source_value TEXT NULL,
			preceding_visit_occurrence_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.visit_detail (
			visit_detail_id integer NOT NULL,
			person_id integer NOT NULL,
			visit_detail_concept_id integer NOT NULL,
			visit_detail_start_date date NOT NULL,
			visit_detail_start_datetime datetime NULL,
			visit_detail_end_date date NOT NULL,
			visit_detail_end_datetime datetime NULL,
			visit_detail_type_concept_id integer NOT NULL,
			provider_id integer NULL,
			care_site_id integer NULL,
			visit_detail_source_value TEXT NULL,
			visit_detail_source_concept_id Integer NULL,
			admitted_from_concept_id Integer NULL,
			admitted_from_source_value TEXT NULL,
			discharged_to_source_value TEXT NULL,
			discharged_to_concept_id integer NULL,
			preceding_visit_detail_id integer NULL,
			parent_visit_detail_id integer NULL,
			visit_occurrence_id integer NOT NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.condition_occurrence (
			condition_occurrence_id integer NOT NULL,
			person_id integer NOT NULL,
			condition_concept_id integer NOT NULL,
			condition_start_date date NOT NULL,
			condition_start_datetime datetime NULL,
			condition_end_date date NULL,
			condition_end_datetime datetime NULL,
			condition_type_concept_id integer NOT NULL,
			condition_status_concept_id integer NULL,
			stop_reason TEXT NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			condition_source_value TEXT NULL,
			condition_source_concept_id integer NULL,
			condition_status_source_value TEXT NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.drug_exposure (
			drug_exposure_id integer NOT NULL,
			person_id integer NOT NULL,
			drug_concept_id integer NOT NULL,
			drug_exposure_start_date date NOT NULL,
			drug_exposure_start_datetime datetime NULL,
			drug_exposure_end_date date NOT NULL,
			drug_exposure_end_datetime datetime NULL,
			verbatim_end_date date NULL,
			drug_type_concept_id integer NOT NULL,
			stop_reason TEXT NULL,
			refills integer NULL,
			quantity REAL NULL,
			days_supply integer NULL,
			sig TEXT NULL,
			route_concept_id integer NULL,
			lot_number TEXT NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			drug_source_value TEXT NULL,
			drug_source_concept_id integer NULL,
			route_source_value TEXT NULL,
			dose_unit_source_value TEXT NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.procedure_occurrence (
			procedure_occurrence_id integer NOT NULL,
			person_id integer NOT NULL,
			procedure_concept_id integer NOT NULL,
			procedure_date date NOT NULL,
			procedure_datetime datetime NULL,
			procedure_end_date date NULL,
			procedure_end_datetime datetime NULL,
			procedure_type_concept_id integer NOT NULL,
			modifier_concept_id integer NULL,
			quantity integer NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			procedure_source_value TEXT NULL,
			procedure_source_concept_id integer NULL,
			modifier_source_value TEXT NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.device_exposure (
			device_exposure_id integer NOT NULL,
			person_id integer NOT NULL,
			device_concept_id integer NOT NULL,
			device_exposure_start_date date NOT NULL,
			device_exposure_start_datetime datetime NULL,
			device_exposure_end_date date NULL,
			device_exposure_end_datetime datetime NULL,
			device_type_concept_id integer NOT NULL,
			unique_device_id TEXT NULL,
			production_id TEXT NULL,
			quantity integer NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			device_source_value TEXT NULL,
			device_source_concept_id integer NULL,
			unit_concept_id integer NULL,
			unit_source_value TEXT NULL,
			unit_source_concept_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.measurement (
			measurement_id integer NOT NULL,
			person_id integer NOT NULL,
			measurement_concept_id integer NOT NULL,
			measurement_date date NOT NULL,
			measurement_datetime datetime NULL,
			measurement_time TEXT NULL,
			measurement_type_concept_id integer NOT NULL,
			operator_concept_id integer NULL,
			value_as_number REAL NULL,
			value_as_concept_id integer NULL,
			unit_concept_id integer NULL,
			range_low REAL NULL,
			range_high REAL NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			measurement_source_value TEXT NULL,
			measurement_source_concept_id integer NULL,
			unit_source_value TEXT NULL,
			unit_source_concept_id integer NULL,
			value_source_value TEXT NULL,
			measurement_event_id integer NULL,
			meas_event_field_concept_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.observation (
			observation_id integer NOT NULL,
			person_id integer NOT NULL,
			observation_concept_id integer NOT NULL,
			observation_date date NOT NULL,
			observation_datetime datetime NULL,
			observation_type_concept_id integer NOT NULL,
			value_as_number REAL NULL,
			value_as_string TEXT NULL,
			value_as_concept_id Integer NULL,
			qualifier_concept_id integer NULL,
			unit_concept_id integer NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			observation_source_value TEXT NULL,
			observation_source_concept_id integer NULL,
			unit_source_value TEXT NULL,
			qualifier_source_value TEXT NULL,
			value_source_value TEXT NULL,
			observation_event_id integer NULL,
			obs_event_field_concept_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.death (
			person_id integer NOT NULL,
			death_date date NOT NULL,
			death_datetime datetime NULL,
			death_type_concept_id integer NULL,
			cause_concept_id integer NULL,
			cause_source_value TEXT NULL,
			cause_source_concept_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.note (
			note_id integer NOT NULL,
			person_id integer NOT NULL,
			note_date date NOT NULL,
			note_datetime datetime NULL,
			note_type_concept_id integer NOT NULL,
			note_class_concept_id integer NOT NULL,
			note_title TEXT NULL,
			note_text TEXT NOT NULL,
			encoding_concept_id integer NOT NULL,
			language_concept_id integer NOT NULL,
			provider_id integer NULL,
			visit_occurrence_id integer NULL,
			visit_detail_id integer NULL,
			note_source_value TEXT NULL,
			note_event_id integer NULL,
			note_event_field_concept_id integer NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.note_nlp (
			note_nlp_id integer NOT NULL,
			note_id integer NOT NULL,
			section_concept_id integer NULL,
			snippet TEXT NULL,
			"offset" TEXT NULL,
			lexical_variant TEXT NOT NULL,
			note_nlp_concept_id integer NULL,
			note_nlp_source_concept_id integer NULL,
			nlp_system TEXT NULL,
			nlp_date date NOT NULL,
			nlp_datetime datetime NULL,
			term_exists TEXT NULL,
			term_temporal TEXT NULL,
			term_modifiers TEXT NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.specimen (
			specimen_id integer NOT NULL,
			person_id integer NOT NULL,
			specimen_concept_id integer NOT NULL,
			specimen_type_concept_id integer NOT NULL,
			specimen_date date NOT NULL,
			specimen_datetime datetime NULL,
			quantity REAL NULL,
			unit_concept_id integer NULL,
			anatomic_site_concept_id integer NULL,
			disease_status_concept_id integer NULL,
			specimen_source_id TEXT NULL,
			specimen_source_value TEXT NULL,
			unit_source_value TEXT NULL,
			anatomic_site_source_value TEXT NULL,
			disease_status_source_value TEXT NULL );
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
			address_1 TEXT NULL,
			address_2 TEXT NULL,
			city TEXT NULL,
			state TEXT NULL,
			zip TEXT NULL,
			county TEXT NULL,
			location_source_value TEXT NULL,
			country_concept_id integer NULL,
			country_source_value TEXT NULL,
			latitude REAL NULL,
			longitude REAL NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.care_site (
			care_site_id integer NOT NULL,
			care_site_name TEXT NULL,
			place_of_service_concept_id integer NULL,
			location_id integer NULL,
			care_site_source_value TEXT NULL,
			place_of_service_source_value TEXT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.provider (
			provider_id integer NOT NULL,
			provider_name TEXT NULL,
			npi TEXT NULL,
			dea TEXT NULL,
			specialty_concept_id integer NULL,
			care_site_id integer NULL,
			year_of_birth integer NULL,
			gender_concept_id integer NULL,
			provider_source_value TEXT NULL,
			specialty_source_value TEXT NULL,
			specialty_source_concept_id integer NULL,
			gender_source_value TEXT NULL,
			gender_source_concept_id integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.payer_plan_period (
			payer_plan_period_id integer NOT NULL,
			person_id integer NOT NULL,
			payer_plan_period_start_date date NOT NULL,
			payer_plan_period_end_date date NOT NULL,
			payer_concept_id integer NULL,
			payer_source_value TEXT NULL,
			payer_source_concept_id integer NULL,
			plan_concept_id integer NULL,
			plan_source_value TEXT NULL,
			plan_source_concept_id integer NULL,
			sponsor_concept_id integer NULL,
			sponsor_source_value TEXT NULL,
			sponsor_source_concept_id integer NULL,
			family_source_value TEXT NULL,
			stop_reason_concept_id integer NULL,
			stop_reason_source_value TEXT NULL,
			stop_reason_source_concept_id integer NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.cost (
			cost_id integer NOT NULL,
			cost_event_id integer NOT NULL,
			cost_domain_id TEXT NOT NULL,
			cost_type_concept_id integer NOT NULL,
			currency_concept_id integer NULL,
			total_charge REAL NULL,
			total_cost REAL NULL,
			total_paid REAL NULL,
			paid_by_payer REAL NULL,
			paid_by_patient REAL NULL,
			paid_patient_copay REAL NULL,
			paid_patient_coinsurance REAL NULL,
			paid_patient_deductible REAL NULL,
			paid_by_primary REAL NULL,
			paid_ingredient_cost REAL NULL,
			paid_dispensing_fee REAL NULL,
			payer_plan_period_id integer NULL,
			amount_allowed REAL NULL,
			revenue_code_concept_id integer NULL,
			revenue_code_source_value TEXT NULL,
			drg_concept_id integer NULL,
			drg_source_value TEXT NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.drug_era (
			drug_era_id integer NOT NULL,
			person_id integer NOT NULL,
			drug_concept_id integer NOT NULL,
			drug_era_start_date date NOT NULL,
			drug_era_end_date date NOT NULL,
			drug_exposure_count integer NULL,
			gap_days integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.dose_era (
			dose_era_id integer NOT NULL,
			person_id integer NOT NULL,
			drug_concept_id integer NOT NULL,
			unit_concept_id integer NOT NULL,
			dose_value REAL NOT NULL,
			dose_era_start_date date NOT NULL,
			dose_era_end_date date NOT NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.condition_era (
			condition_era_id integer NOT NULL,
			person_id integer NOT NULL,
			condition_concept_id integer NOT NULL,
			condition_era_start_date date NOT NULL,
			condition_era_end_date date NOT NULL,
			condition_occurrence_count integer NULL );
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE @cdmDatabaseSchema.episode (
			episode_id integer NOT NULL,
			person_id integer NOT NULL,
			episode_concept_id integer NOT NULL,
			episode_start_date date NOT NULL,
			episode_start_datetime datetime NULL,
			episode_end_date date NULL,
			episode_end_datetime datetime NULL,
			episode_parent_id integer NULL,
			episode_number integer NULL,
			episode_object_concept_id integer NOT NULL,
			episode_type_concept_id integer NOT NULL,
			episode_source_value TEXT NULL,
			episode_source_concept_id integer NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.episode_event (
			episode_id integer NOT NULL,
			event_id integer NOT NULL,
			episode_event_field_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.metadata (
			metadata_id integer NOT NULL,
			metadata_concept_id integer NOT NULL,
			metadata_type_concept_id integer NOT NULL,
			name TEXT NOT NULL,
			value_as_string TEXT NULL,
			value_as_concept_id integer NULL,
			value_as_number REAL NULL,
			metadata_date date NULL,
			metadata_datetime datetime NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.cdm_source (
			cdm_source_name TEXT NOT NULL,
			cdm_source_abbreviation TEXT NOT NULL,
			cdm_holder TEXT NOT NULL,
			source_description TEXT NULL,
			source_documentation_reference TEXT NULL,
			cdm_etl_reference TEXT NULL,
			source_release_date date NOT NULL,
			cdm_release_date date NOT NULL,
			cdm_version TEXT NULL,
			cdm_version_concept_id integer NOT NULL,
			vocabulary_version TEXT NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.concept (
			concept_id integer NOT NULL,
			concept_name TEXT NOT NULL,
			domain_id TEXT NOT NULL,
			vocabulary_id TEXT NOT NULL,
			concept_class_id TEXT NOT NULL,
			standard_concept TEXT NULL,
			concept_code TEXT NOT NULL,
			valid_start_date date NOT NULL,
			valid_end_date date NOT NULL,
			invalid_reason TEXT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.vocabulary (
			vocabulary_id TEXT NOT NULL,
			vocabulary_name TEXT NOT NULL,
			vocabulary_reference TEXT NULL,
			vocabulary_version TEXT NULL,
			vocabulary_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.domain (
			domain_id TEXT NOT NULL,
			domain_name TEXT NOT NULL,
			domain_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.concept_class (
			concept_class_id TEXT NOT NULL,
			concept_class_name TEXT NOT NULL,
			concept_class_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.concept_relationship (
			concept_id_1 integer NOT NULL,
			concept_id_2 integer NOT NULL,
			relationship_id TEXT NOT NULL,
			valid_start_date date NOT NULL,
			valid_end_date date NOT NULL,
			invalid_reason TEXT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.relationship (
			relationship_id TEXT NOT NULL,
			relationship_name TEXT NOT NULL,
			is_hierarchical TEXT NOT NULL,
			defines_ancestry TEXT NOT NULL,
			reverse_relationship_id TEXT NOT NULL,
			relationship_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.concept_synonym (
			concept_id integer NOT NULL,
			concept_synonym_name TEXT NOT NULL,
			language_concept_id integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.concept_ancestor (
			ancestor_concept_id integer NOT NULL,
			descendant_concept_id integer NOT NULL,
			min_levels_of_separation integer NOT NULL,
			max_levels_of_separation integer NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.source_to_concept_map (
			source_code TEXT NOT NULL,
			source_concept_id integer NOT NULL,
			source_vocabulary_id TEXT NOT NULL,
			source_code_description TEXT NULL,
			target_concept_id integer NOT NULL,
			target_vocabulary_id TEXT NOT NULL,
			valid_start_date date NOT NULL,
			valid_end_date date NOT NULL,
			invalid_reason TEXT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.drug_strength (
			drug_concept_id integer NOT NULL,
			ingredient_concept_id integer NOT NULL,
			amount_value REAL NULL,
			amount_unit_concept_id integer NULL,
			numerator_value REAL NULL,
			numerator_unit_concept_id integer NULL,
			denominator_value REAL NULL,
			denominator_unit_concept_id integer NULL,
			box_size integer NULL,
			valid_start_date date NOT NULL,
			valid_end_date date NOT NULL,
			invalid_reason TEXT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.cohort (
			cohort_definition_id integer NOT NULL,
			subject_id integer NOT NULL,
			cohort_start_date date NOT NULL,
			cohort_end_date date NOT NULL );
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdmDatabaseSchema.cohort_definition (
			cohort_definition_id integer NOT NULL,
			cohort_definition_name TEXT NOT NULL,
			cohort_definition_description TEXT NULL,
			definition_type_concept_id integer NOT NULL,
			cohort_definition_syntax TEXT NULL,
			subject_concept_id integer NOT NULL,
			cohort_initiation_date date NULL );