
-- DEATH
CREATE TABLE DEATH  ( person_id integer NOT NULL,
			death_date date NOT NULL,
			death_datetime TIMESTAMP NULL,
			death_type_concept_id integer NULL,
			cause_concept_id integer NULL,
			cause_source_value varchar(50) NULL,
			cause_source_concept_id integer NULL )
DISTKEY(person_id);

-- EPISODE
CREATE TABLE EPISODE  (episode_id bigint NOT NULL,
			 person_id bigint NOT NULL,
			episode_concept_id integer NOT NULL,
			episode_start_date date NOT NULL,
			episode_start_datetime TIMESTAMP NULL,
			episode_end_date date NULL,
			episode_end_datetime TIMESTAMP NULL,
			episode_parent_id bigint NULL,
			episode_number integer NULL,
			episode_object_concept_id integer NOT NULL,
			episode_type_concept_id integer NOT NULL,
			episode_source_value varchar(50) NULL,
			episode_source_concept_id integer NULL )
DISTKEY(person_id);

-- EPISODE_EVENT
CREATE TABLE EPISODE_EVENT  (episode_id bigint NOT NULL,
			event_id bigint NOT NULL,
			episode_event_field_concept_id integer NOT NULL )
DISTSTYLE ALL;

-- PERSON 
alter table person drop column death_datetime;


-- VISIT_OCCURRENCE
alter table visit_occurrence rename column discharge_to_concept_id to discharged_to_concept_id;
alter table visit_occurrence rename column discharge_to_source_value to discharged_to_source_value;


-- VISIT_DETAIL
alter table visit_detail rename column discharge_to_concept_id to discharged_to_concept_id;
alter table visit_detail rename column discharge_to_source_value to discharged_to_source_value;
alter table visit_detail rename column visit_detail_parent_id to parent_visit_detail_id;

-- PROCEDURE_OCCURRENCE
alter table procedure_occurrence add column procedure_end_date date;
alter table procedure_occurrence add column procedure_end_datetime timestamp;


-- DEVICE_EXPOSURE
alter table device_exposure add column production_id varchar(255);
alter table device_exposure add column unit_concept_id integer;
alter table device_exposure add column unit_source_value varchar(50);
alter table device_exposure add column unit_source_concept_id integer;


-- MEASUREMENT
alter table measurement add column unit_source_id integer;
alter table measurement add column measurement_event_id bigint;
alter table measurement add column meas_event_field_concept_id integer;


-- OBSERVATION
alter table observation add column value_source_value varchar(50);
alter table observation drop column value_as_datetime; 

-- LOCATION
alter location add column country_concept_id integer;
alter location add column country_source_value varchar(80);


-- PAYER_PLAN_PERIOD
alter table payer_plan_period drop column contract_person_id; 
alter table payer_plan_period drop column contract_concept_id;
alter table payer_plan_period drop column contract_source_value;
alter table payer_plan_period drop column contract_source_concept_id;

-- COST
alter table cost drop column person_id; 
alter table cost drop column cost_event_field_concept_id;
alter table cost drop column cost_concept_id;
alter table cost drop column cost_source_concept_id;
alter table cost drop column cost_source_value;
alter table cost drop column cost;
alter table cost drop column incurred_date;
alter table cost drop column billed_date;
alter table cost drop column paid_date;
alter table cost drop column revenue_code_source_value;
alter cost add column total_charge float;
alter cost add column total_cost float;
alter cost add column total_paid float;
alter cost add column paid_by_payer float;
alter cost add column paid_by_patient float;
alter cost add column paid_by_primary float;
alter cost add column paid_patient_copay float;
alter cost add column paid_patient_coinsurance float;
alter cost add column paid_patient_deductible float;
alter cost add column paid_ingredient_cost float;
alter cost add column paid_dispensing_fee float;
alter cost add column amount_allowed float;
alter cost add column cost_domain_id varchar(20);
alter cost add column revenue_code_source_value varchar(50);


-- DRUG_ERA
alter table drug_era rename column drug_era_start_datetime to drug_era_start_date;
alter table drug_era rename column drug_era_end_datetime to drug_era_end_date;
alter table drug_era alter column drug_era_start_date date;
alter table drug_era alter column drug_era_end_date date;


-- DOSE_ERA
alter table dose_era rename column dose_era_start_datetime to dose_era_start_date;
alter table dose_era rename column dose_era_end_datetime to dose_era_end_date;
alter table dose_era alter column dose_era_start_date date;
alter table dose_era alter column dose_era_end_date date;

-- CONDITION_ERA
alter table condition_era rename column condition_era_start_datetime to condition_era_start_date;
alter table condition_era rename column condition_era_end_datetime to condition_era_end_date;
alter table condition_era alter column condition_era_start_date date;
alter table condition_era alter column condition_era_end_date date;


-- METADATA
alter table metadata add column metadata_id integer;
alter table metadata add column value_as_number float;


-- CDM_SOURCE
alter table cdm_source add column cdm_version_concept_id integer;
