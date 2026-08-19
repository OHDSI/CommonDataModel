-- Derived from the OMOP CDM v5.2 and v5.3 Redshift DDLs in this repository.
-- Redshift SQL references:
--   https://docs.aws.amazon.com/redshift/latest/dg/r_ALTER_TABLE.html
--
-- VISIT_DETAIL

create table @cdmDatabaseSchema.visit_detail (
    visit_detail_id integer NOT NULL,
    person_id integer NOT NULL,
    visit_detail_concept_id integer NOT NULL,
    visit_detail_start_date date NOT NULL,
    visit_detail_start_datetime TIMESTAMP NULL,
    visit_detail_end_date date NOT NULL,
    visit_detail_end_datetime TIMESTAMP NULL,
    visit_detail_type_concept_id integer NOT NULL,
    provider_id integer NULL,
    care_site_id integer NULL,
    visit_detail_source_value varchar(50) NULL,
    visit_detail_source_concept_id integer NULL,
    admitting_source_value varchar(50) NULL,
    admitting_source_concept_id integer NULL,
    discharge_to_source_value varchar(50) NULL,
    discharge_to_concept_id integer NULL,
    preceding_visit_detail_id integer NULL,
    visit_detail_parent_id integer NULL,
    visit_occurrence_id integer NOT NULL
);

-- CONDITION_OCCURRENCE
alter table @cdmDatabaseSchema.condition_occurrence alter column condition_start_datetime drop not null;
alter table @cdmDatabaseSchema.condition_occurrence add column visit_detail_id integer default null;

-- DRUG_EXPOSURE
alter table @cdmDatabaseSchema.drug_exposure alter column drug_exposure_start_datetime drop not null;
alter table @cdmDatabaseSchema.drug_exposure add column visit_detail_id integer default null;

-- PROCEDURE_OCCURRENCE
alter table @cdmDatabaseSchema.procedure_occurrence alter column procedure_datetime drop not null;
alter table @cdmDatabaseSchema.procedure_occurrence rename column qualifier_source_value to modifier_source_value;
alter table @cdmDatabaseSchema.procedure_occurrence add column visit_detail_id integer default null;

-- DEVICE_EXPOSURE
alter table @cdmDatabaseSchema.device_exposure alter column device_exposure_start_datetime drop not null;
alter table @cdmDatabaseSchema.device_exposure alter column device_source_value type varchar(50);
alter table @cdmDatabaseSchema.device_exposure add column visit_detail_id integer default null;

-- MEASUREMENT
alter table @cdmDatabaseSchema.measurement add column measurement_time varchar(10) default null;
alter table @cdmDatabaseSchema.measurement add column visit_detail_id integer default null;

-- OBSERVATION
alter table @cdmDatabaseSchema.observation add column visit_detail_id integer default null;

-- DEATH
alter table @cdmDatabaseSchema.death alter column death_type_concept_id drop not null;

-- NOTE
alter table @cdmDatabaseSchema.note add column visit_detail_id integer default null;

-- NOTE_NLP
alter table @cdmDatabaseSchema.note_nlp alter column note_nlp_id type integer;
alter table @cdmDatabaseSchema.note_nlp alter column "offset" type varchar(50);

-- PAYER_PLAN_PERIOD
alter table @cdmDatabaseSchema.payer_plan_period add column payer_concept_id integer default null;
alter table @cdmDatabaseSchema.payer_plan_period add column payer_source_concept_id integer default null;
alter table @cdmDatabaseSchema.payer_plan_period add column plan_concept_id integer default null;
alter table @cdmDatabaseSchema.payer_plan_period add column plan_source_concept_id integer default null;
alter table @cdmDatabaseSchema.payer_plan_period add column sponsor_concept_id integer default null;
alter table @cdmDatabaseSchema.payer_plan_period add column sponsor_source_value varchar(50) default null;
alter table @cdmDatabaseSchema.payer_plan_period add column sponsor_source_concept_id integer default null;
alter table @cdmDatabaseSchema.payer_plan_period add column stop_reason_concept_id integer default null;
alter table @cdmDatabaseSchema.payer_plan_period add column stop_reason_source_value varchar(50) default null;
alter table @cdmDatabaseSchema.payer_plan_period add column stop_reason_source_concept_id integer default null;

-- COST
alter table @cdmDatabaseSchema.cost rename column reveue_code_source_value to revenue_code_source_value;

-- METADATA
create table @cdmDatabaseSchema.metadata (
    metadata_concept_id integer NOT NULL,
    metadata_type_concept_id integer NOT NULL,
    name varchar(250) NOT NULL,
    value_as_string varchar(250) NULL,
    value_as_concept_id integer NULL,
    metadata_date date NULL,
    metadata_datetime TIMESTAMP NULL
);

-- VOCABULARY
update @cdmDatabaseSchema.vocabulary
set vocabulary_reference = ''
where vocabulary_reference is null;

alter table @cdmDatabaseSchema.vocabulary alter column vocabulary_reference set not null;

-- TABLES REMOVED IN v5.3
drop table @cdmDatabaseSchema.cohort_attribute;
drop table @cdmDatabaseSchema.cohort;
