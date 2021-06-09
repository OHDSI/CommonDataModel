--postgresql CDM DDL Specification for OMOP Common Data Model v6_0 

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.PERSON (
 
			person_id bigint NOT NULL, 
			gender_concept_id integer NOT NULL, 
			year_of_birth integer NOT NULL, 
			month_of_birth integer NULL, 
			day_of_birth integer NULL, 
			birth_datetime TIMESTAMP NULL, 
			death_datetime TIMESTAMP NULL, 
			race_concept_id integer NOT NULL, 
			ethnicity_concept_id integer NOT NULL, 
			location_id bigint NULL, 
			provider_id bigint NULL, 
			care_site_id bigint NULL, 
			person_source_value varchar(50) NULL, 
			gender_source_value varchar(50) NULL, 
			gender_source_concept_id integer NOT NULL, 
			race_source_value varchar(50) NULL, 
			race_source_concept_id integer NOT NULL, 
			ethnicity_source_value varchar(50) NULL, 
			ethnicity_source_concept_id integer NOT NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.OBSERVATION_PERIOD (
 
			observation_period_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			observation_period_start_date date NOT NULL, 
			observation_period_end_date date NOT NULL, 
			period_type_concept_id Integer NOT NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.VISIT_OCCURRENCE (
 
			visit_occurrence_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			visit_concept_id integer NOT NULL, 
			visit_start_date date NULL, 
			visit_start_datetime TIMESTAMP NOT NULL, 
			visit_end_date date NULL, 
			visit_end_datetime TIMESTAMP NOT NULL, 
			visit_type_concept_id Integer NOT NULL, 
			provider_id bigint NULL, 
			care_site_id bigint NULL, 
			visit_source_value varchar(50) NULL, 
			visit_source_concept_id integer NOT NULL, 
			admitted_from_concept_id integer NOT NULL, 
			admitted_from_source_value varchar(50) NULL, 
			discharge_to_concept_id integer NOT NULL, 
			discharge_to_source_value varchar(50) NULL, 
			preceding_visit_occurrence_id bigint NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.VISIT_DETAIL (
 
			visit_detail_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			visit_detail_concept_id integer NOT NULL, 
			visit_detail_start_date date NOT NULL, 
			visit_detail_start_datetime TIMESTAMP NULL, 
			visit_detail_end_date date NOT NULL, 
			visit_detail_end_datetime TIMESTAMP NULL, 
			visit_detail_type_concept_id Integer NOT NULL, 
			provider_id bigint NULL, 
			care_site_id bigint NULL, 
			visit_detail_source_value varchar(50) NULL, 
			visit_detail_source_concept_id integer NOT NULL, 
			admitting_source_value varchar(50) NULL, 
			admitting_source_concept_id integer NOT NULL, 
			discharge_to_source_value varchar(50) NULL, 
			discharge_to_concept_id integer NOT NULL, 
			preceding_visit_detail_id bigint NULL, 
			visit_detail_parent_id bigint NULL, 
			visit_occurrence_id bigint NOT NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.CONDITION_OCCURRENCE (
 
			condition_occurrence_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			condition_concept_id integer NOT NULL, 
			condition_start_date date NOT NULL, 
			condition_start_datetime TIMESTAMP NULL, 
			condition_end_date date NULL, 
			condition_end_datetime TIMESTAMP NULL, 
			condition_type_concept_id integer NOT NULL, 
			condition_status_concept_id integer NOT NULL, 
			stop_reason varchar(20) NULL, 
			provider_id bigint NULL, 
			visit_occurrence_id bigint NULL, 
			visit_detail_id bigint NULL, 
			condition_source_value varchar(50) NULL, 
			condition_source_concept_id integer NOT NULL, 
			condition_status_source_value varchar(50) NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.DRUG_EXPOSURE (
 
			drug_exposure_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			drug_concept_id integer NOT NULL, 
			drug_exposure_start_date date NOT NULL, 
			drug_exposure_start_datetime TIMESTAMP NULL, 
			drug_exposure_end_date date NOT NULL, 
			drug_exposure_end_datetime TIMESTAMP NULL, 
			verbatim_end_date date NULL, 
			drug_type_concept_id integer NOT NULL, 
			stop_reason varchar(20) NULL, 
			refills integer NULL, 
			quantity NUMERIC NULL, 
			days_supply integer NULL, 
			sig TEXT NULL, 
			route_concept_id integer NULL, 
			lot_number varchar(50) NULL, 
			provider_id bigint NULL, 
			visit_occurrence_id bigint NULL, 
			visit_detail_id bigint NULL, 
			drug_source_value varchar(50) NULL, 
			drug_source_concept_id integer NOT NULL, 
			route_source_value varchar(50) NULL, 
			dose_unit_source_value varchar(50) NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.PROCEDURE_OCCURRENCE (
 
			procedure_occurrence_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			procedure_concept_id integer NOT NULL, 
			procedure_date date NULL, 
			procedure_datetime TIMESTAMP NOT NULL, 
			procedure_type_concept_id integer NOT NULL, 
			modifier_concept_id integer NOT NULL, 
			quantity integer NULL, 
			provider_id bigint NULL, 
			visit_occurrence_id bigint NULL, 
			visit_detail_id bigint NULL, 
			procedure_source_value varchar(50) NULL, 
			procedure_source_concept_id integer NOT NULL, 
			modifier_source_value varchar(50) NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.DEVICE_EXPOSURE (
 
			device_exposure_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			device_concept_id integer NOT NULL, 
			device_exposure_start_date date NOT NULL, 
			device_exposure_start_datetime TIMESTAMP NULL, 
			device_exposure_end_date date NULL, 
			device_exposure_end_datetime TIMESTAMP NULL, 
			device_type_concept_id integer NOT NULL, 
			unique_device_id varchar(50) NULL, 
			quantity integer NULL, 
			provider_id bigint NULL, 
			visit_occurrence_id bigint NULL, 
			visit_detail_id bigint NULL, 
			device_source_value varchar(50) NULL, 
			device_source_concept_id integer NOT NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.MEASUREMENT (
 
			measurement_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			measurement_concept_id integer NOT NULL, 
			measurement_date date NOT NULL, 
			measurement_datetime TIMESTAMP NULL, 
			measurement_time varchar(10) NULL, 
			measurement_type_concept_id integer NOT NULL, 
			operator_concept_id integer NULL, 
			value_as_number NUMERIC NULL, 
			value_as_concept_id integer NULL, 
			unit_concept_id integer NULL, 
			range_low NUMERIC NULL, 
			range_high NUMERIC NULL, 
			provider_id bigint NULL, 
			visit_occurrence_id bigint NULL, 
			visit_detail_id bigint NULL, 
			measurement_source_value varchar(50) NULL, 
			measurement_source_concept_id integer NOT NULL, 
			unit_source_value varchar(50) NULL, 
			value_source_value varchar(50) NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.OBSERVATION (
 
			observation_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			observation_concept_id integer NOT NULL, 
			observation_date date NULL, 
			observation_datetime TIMESTAMP NOT NULL, 
			observation_type_concept_id integer NOT NULL, 
			value_as_number NUMERIC NULL, 
			value_as_string varchar(60) NULL, 
			value_as_concept_id Integer NULL, 
			qualifier_concept_id integer NULL, 
			unit_concept_id integer NULL, 
			provider_id bigint NULL, 
			visit_occurrence_id bigint NULL, 
			visit_detail_id bigint NULL, 
			observation_source_value varchar(50) NULL, 
			observation_source_concept_id integer NOT NULL, 
			unit_source_value varchar(50) NULL, 
			qualifier_source_value varchar(50) NULL, 
			observation_event_id bigint NULL, 
			obs_event_field_concept_id integer NULL, 
			value_as_datetime TIMESTAMP NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.NOTE (
 
			note_id integer NOT NULL, 
			person_id bigint NOT NULL, 
			note_date date NOT NULL, 
			note_datetime TIMESTAMP NULL, 
			note_type_concept_id integer NOT NULL, 
			note_class_concept_id integer NOT NULL, 
			note_title varchar(250) NULL, 
			note_text TEXT NOT NULL, 
			encoding_concept_id integer NOT NULL, 
			language_concept_id integer NOT NULL, 
			provider_id bigint NULL, 
			visit_occurrence_id bigint NULL, 
			visit_detail_id bigint NULL, 
			note_source_value varchar(50) NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.NOTE_NLP (
 
			note_nlp_id bigint NOT NULL, 
			note_id integer NOT NULL, 
			section_concept_id integer NULL, 
			snippet varchar(250) NULL, 
			"offset" varchar(50) NULL, 
			lexical_variant varchar(250) NOT NULL, 
			note_nlp_concept_id integer NULL, 
			note_nlp_source_concept_id integer NULL, 
			nlp_system varchar(250) NULL, 
			nlp_date date NOT NULL, 
			nlp_datetime TIMESTAMP NULL, 
			term_exists varchar(1) NULL, 
			term_temporal varchar(50) NULL, 
			term_modifiers varchar(2000) NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.SPECIMEN (
 
			specimen_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			specimen_concept_id integer NOT NULL, 
			specimen_type_concept_id integer NOT NULL, 
			specimen_date date NOT NULL, 
			specimen_datetime TIMESTAMP NULL, 
			quantity NUMERIC NULL, 
			unit_concept_id integer NULL, 
			anatomic_site_concept_id integer NULL, 
			disease_status_concept_id integer NULL, 
			specimen_source_id varchar(50) NULL, 
			specimen_source_value varchar(50) NULL, 
			unit_source_value varchar(50) NULL, 
			anatomic_site_source_value varchar(50) NULL, 
			disease_status_source_value varchar(50) NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.FACT_RELATIONSHIP (
 
			domain_concept_id_1 integer NOT NULL, 
			fact_id_1 bigint NOT NULL, 
			domain_concept_id_2 integer NOT NULL, 
			fact_id_2 bigint NOT NULL, 
			relationship_concept_id integer NOT NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.SURVEY_CONDUCT (
 
			survey_conduct_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			survey_concept_id integer NOT NULL, 
			survey_start_date date NULL, 
			survey_start_datetime TIMESTAMP NULL, 
			survey_end_date date NULL, 
			survey_end_datetime TIMESTAMP NOT NULL, 
			provider_id bigint NULL, 
			assisted_concept_id integer NOT NULL, 
			respondent_type_concept_id integer NOT NULL, 
			timing_concept_id integer NOT NULL, 
			collection_method_concept_id integer NOT NULL, 
			assisted_source_value varchar(50) NULL, 
			respondent_type_source_value varchar(100) NULL, 
			timing_source_value varchar(100) NULL, 
			collection_method_source_value varchar(100) NULL, 
			survey_source_value varchar(100) NULL, 
			survey_source_concept_id integer NOT NULL, 
			survey_source_identifier varchar(100) NULL, 
			validated_survey_concept_id integer NOT NULL, 
			validated_survey_source_value integer NULL, 
			survey_version_number varchar(20) NULL, 
			visit_occurrence_id bigint NULL, 
			response_visit_occurrence_id bigint NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.LOCATION (
 
			location_id bigint NOT NULL, 
			address_1 varchar(50) NULL, 
			address_2 varchar(50) NULL, 
			city varchar(50) NULL, 
			state varchar(2) NULL, 
			zip varchar(9) NULL, 
			county varchar(20) NULL, 
			location_source_value varchar(50) NULL, 
			latitude NUMERIC NULL, 
			longitude NUMERIC NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.LOCATION_HISTORY (
 
			location_id bigint NOT NULL, 
			relationship_type_concept_id integer NOT NULL, 
			domain_id varchar(50) NOT NULL, 
			entity_id bigint NOT NULL, 
			start_date date NOT NULL, 
			end_date date NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.CARE_SITE (
 
			care_site_id bigint NOT NULL, 
			care_site_name varchar(255) NULL, 
			place_of_service_concept_id integer NOT NULL, 
			location_id bigint NULL, 
			care_site_source_value varchar(50) NULL, 
			place_of_service_source_value varchar(50) NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.PROVIDER (
 
			provider_id bigint NOT NULL, 
			provider_name varchar(255) NULL, 
			npi varchar(20) NULL, 
			dea varchar(20) NULL, 
			specialty_concept_id integer NOT NULL, 
			care_site_id bigint NULL, 
			year_of_birth integer NULL, 
			gender_concept_id integer NOT NULL, 
			provider_source_value varchar(50) NULL, 
			specialty_source_value varchar(50) NULL, 
			specialty_source_concept_id integer NOT NULL, 
			gender_source_value varchar(50) NULL, 
			gender_source_concept_id integer NOT NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.PAYER_PLAN_PERIOD (
 
			payer_plan_period_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			contract_person_id bigint NULL, 
			payer_plan_period_start_date date NOT NULL, 
			payer_plan_period_end_date date NOT NULL, 
			payer_concept_id integer NOT NULL, 
			payer_source_value varchar(50) NULL, 
			payer_source_concept_id integer NOT NULL, 
			plan_concept_id integer NOT NULL, 
			plan_source_value varchar(50) NULL, 
			plan_source_concept_id integer NOT NULL, 
			contract_concept_id integer NOT NULL, 
			contract_source_value varchar(50) NOT NULL, 
			contract_source_concept_id integer NOT NULL, 
			sponsor_concept_id integer NOT NULL, 
			sponsor_source_value varchar(50) NULL, 
			sponsor_source_concept_id integer NULL, 
			family_source_value varchar(50) NULL, 
			stop_reason_concept_id integer NULL, 
			stop_reason_source_value varchar(50) NULL, 
			stop_reason_source_concept_id integer NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.COST (
 
			cost_id INTEGER NOT NULL, 
			cost_event_id bigint NOT NULL, 
			cost_domain_id VARCHAR(20) NOT NULL, 
			cost_type_concept_id integer NOT NULL, 
			currency_concept_id integer NULL, 
			total_charge NUMERIC NULL, 
			total_cost NUMERIC NULL, 
			total_paid NUMERIC NULL, 
			paid_by_payer NUMERIC NULL, 
			paid_by_patient NUMERIC NULL, 
			paid_patient_copay NUMERIC NULL, 
			paid_patient_coinsurance NUMERIC NULL, 
			paid_patient_deductible NUMERIC NULL, 
			paid_by_primary NUMERIC NULL, 
			paid_ingredient_cost NUMERIC NULL, 
			paid_dispensing_fee NUMERIC NULL, 
			payer_plan_period_id bigint NULL, 
			amount_allowed NUMERIC NULL, 
			revenue_code_concept_id integer NULL, 
			revenue_code_source_value VARCHAR(50) NULL, 
			drg_concept_id integer NULL, 
			drg_source_value VARCHAR(3) NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.DRUG_ERA (
 
			drug_era_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			drug_concept_id integer NOT NULL, 
			drug_era_start_date TIMESTAMP NOT NULL, 
			drug_era_end_date TIMESTAMP NOT NULL, 
			drug_exposure_count integer NULL, 
			gap_days integer NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.DOSE_ERA (
 
			dose_era_id bigint NOT NULL, 
			person_id bigint NOT NULL, 
			drug_concept_id integer NOT NULL, 
			unit_concept_id integer NOT NULL, 
			dose_value NUMERIC NOT NULL, 
			dose_era_start_date TIMESTAMP NOT NULL, 
			dose_era_end_date TIMESTAMP NOT NULL );  

--HINT DISTRIBUTE ON KEY (person_id)
 CREATE TABLE ohdsi.CONDITION_ERA (
 
			condition_era_id integer NOT NULL, 
			person_id bigint NOT NULL, 
			condition_concept_id integer NOT NULL, 
			condition_era_start_date TIMESTAMP NOT NULL, 
			condition_era_end_date TIMESTAMP NOT NULL, 
			condition_occurrence_count integer NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.METADATA (
 
			metadata_concept_id integer NOT NULL, 
			metadata_type_concept_id integer NOT NULL, 
			name varchar(250) NOT NULL, 
			value_as_string varchar(250) NULL, 
			value_as_concept_id integer NULL, 
			metadata_date date NULL, 
			metadata_datetime TIMESTAMP NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.CDM_SOURCE (
 
			cdm_source_name varchar(255) NOT NULL, 
			cdm_source_abbreviation varchar(25) NULL, 
			cdm_holder varchar(255) NULL, 
			source_description TEXT NULL, 
			source_documentation_reference varchar(255) NULL, 
			cdm_etl_reference varchar(255) NULL, 
			source_release_date date NULL, 
			cdm_release_date date NULL, 
			cdm_version varchar(10) NULL, 
			vocabulary_version varchar(20) NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.CONCEPT (
 
			concept_id integer NOT NULL, 
			concept_name varchar(255) NOT NULL, 
			domain_id varchar(20) NOT NULL, 
			vocabulary_id varchar(20) NOT NULL, 
			concept_class_id varchar(20) NOT NULL, 
			standard_concept varchar(1) NULL, 
			concept_code varchar(50) NOT NULL, 
			valid_start_date date NOT NULL, 
			valid_end_date date NOT NULL, 
			invalid_reason varchar(1) NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.VOCABULARY (
 
			vocabulary_id varchar(20) NOT NULL, 
			vocabulary_name varchar(255) NOT NULL, 
			vocabulary_reference varchar(255) NOT NULL, 
			vocabulary_version varchar(255) NULL, 
			vocabulary_concept_id integer NOT NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.DOMAIN (
 
			domain_id varchar(20) NOT NULL, 
			domain_name varchar(255) NOT NULL, 
			domain_concept_id integer NOT NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.CONCEPT_CLASS (
 
			concept_class_id varchar(20) NOT NULL, 
			concept_class_name varchar(255) NOT NULL, 
			concept_class_concept_id integer NOT NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.CONCEPT_RELATIONSHIP (
 
			concept_id_1 integer NOT NULL, 
			concept_id_2 integer NOT NULL, 
			relationship_id varchar(20) NOT NULL, 
			valid_start_date date NOT NULL, 
			valid_end_date date NOT NULL, 
			invalid_reason varchar(1) NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.RELATIONSHIP (
 
			relationship_id varchar(20) NOT NULL, 
			relationship_name varchar(255) NOT NULL, 
			is_hierarchical varchar(1) NOT NULL, 
			defines_ancestry varchar(1) NOT NULL, 
			reverse_relationship_id varchar(20) NOT NULL, 
			relationship_concept_id integer NOT NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.CONCEPT_SYNONYM (
 
			concept_id integer NOT NULL, 
			concept_synonym_name varchar(1000) NOT NULL, 
			language_concept_id integer NOT NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.CONCEPT_ANCESTOR (
 
			ancestor_concept_id integer NOT NULL, 
			descendant_concept_id integer NOT NULL, 
			min_levels_of_separation integer NOT NULL, 
			max_levels_of_separation integer NOT NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.SOURCE_TO_CONCEPT_MAP (
 
			source_code varchar(50) NOT NULL, 
			source_concept_id integer NOT NULL, 
			source_vocabulary_id varchar(20) NOT NULL, 
			source_code_description varchar(255) NULL, 
			target_concept_id integer NOT NULL, 
			target_vocabulary_id varchar(20) NOT NULL, 
			valid_start_date date NOT NULL, 
			valid_end_date date NOT NULL, 
			invalid_reason varchar(1) NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.DRUG_STRENGTH (
 
			drug_concept_id integer NOT NULL, 
			ingredient_concept_id integer NOT NULL, 
			amount_value NUMERIC NULL, 
			amount_unit_concept_id integer NULL, 
			numerator_value NUMERIC NULL, 
			numerator_unit_concept_id integer NULL, 
			denominator_value NUMERIC NULL, 
			denominator_unit_concept_id integer NULL, 
			box_size integer NULL, 
			valid_start_date date NOT NULL, 
			valid_end_date date NOT NULL, 
			invalid_reason varchar(1) NULL );  

--HINT DISTRIBUTE ON RANDOM
 CREATE TABLE ohdsi.COHORT_DEFINITION (
 
			cohort_definition_id integer NOT NULL, 
			cohort_definition_name varchar(255) NOT NULL, 
			cohort_definition_description TEXT NULL, 
			definition_type_concept_id integer NOT NULL, 
			cohort_definition_syntax TEXT NULL, 
			subject_concept_id integer NOT NULL, 
			cohort_initiation_date date NULL ); 