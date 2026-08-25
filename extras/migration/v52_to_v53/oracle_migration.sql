-- Derived from the OMOP CDM v5.2 and v5.3 Oracle DDLs in this repository.
-- Oracle SQL references:
--   https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/ALTER-TABLE.html
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
    visit_detail_source_value varchar2(50) NULL,
    visit_detail_source_concept_id integer NULL,
    admitting_source_value varchar2(50) NULL,
    admitting_source_concept_id integer NULL,
    discharge_to_source_value varchar2(50) NULL,
    discharge_to_concept_id integer NULL,
    preceding_visit_detail_id integer NULL,
    visit_detail_parent_id integer NULL,
    visit_occurrence_id integer NOT NULL
);

-- CONDITION_OCCURRENCE
alter table @cdmDatabaseSchema.condition_occurrence modify (condition_start_datetime timestamp null);
alter table @cdmDatabaseSchema.condition_occurrence add (visit_detail_id number default null);

-- DRUG_EXPOSURE
alter table @cdmDatabaseSchema.drug_exposure modify (drug_exposure_start_datetime timestamp null);
alter table @cdmDatabaseSchema.drug_exposure add (visit_detail_id number default null);

-- PROCEDURE_OCCURRENCE
alter table @cdmDatabaseSchema.procedure_occurrence modify (procedure_datetime timestamp null);
alter table @cdmDatabaseSchema.procedure_occurrence rename column qualifier_source_value to modifier_source_value;
alter table @cdmDatabaseSchema.procedure_occurrence add (visit_detail_id number default null);

-- DEVICE_EXPOSURE
alter table @cdmDatabaseSchema.device_exposure modify (device_exposure_start_datetime timestamp null);
alter table @cdmDatabaseSchema.device_exposure modify (device_source_value varchar2(50));
alter table @cdmDatabaseSchema.device_exposure add (visit_detail_id number default null);

-- MEASUREMENT
alter table @cdmDatabaseSchema.measurement add (measurement_time varchar2(10) default null);
alter table @cdmDatabaseSchema.measurement add (visit_detail_id number default null);

-- OBSERVATION
alter table @cdmDatabaseSchema.observation add (visit_detail_id number default null);

-- DEATH
alter table @cdmDatabaseSchema.death modify (death_type_concept_id number null);

-- NOTE
alter table @cdmDatabaseSchema.note add (visit_detail_id number default null);

-- NOTE_NLP
alter table @cdmDatabaseSchema.note_nlp modify (note_nlp_id number);
alter table @cdmDatabaseSchema.note_nlp modify ("offset" varchar2(50));

-- PAYER_PLAN_PERIOD
alter table @cdmDatabaseSchema.payer_plan_period add (payer_concept_id number default null);
alter table @cdmDatabaseSchema.payer_plan_period add (payer_source_concept_id number default null);
alter table @cdmDatabaseSchema.payer_plan_period add (plan_concept_id number default null);
alter table @cdmDatabaseSchema.payer_plan_period add (plan_source_concept_id number default null);
alter table @cdmDatabaseSchema.payer_plan_period add (sponsor_concept_id number default null);
alter table @cdmDatabaseSchema.payer_plan_period add (sponsor_source_value varchar2(50) default null);
alter table @cdmDatabaseSchema.payer_plan_period add (sponsor_source_concept_id number default null);
alter table @cdmDatabaseSchema.payer_plan_period add (stop_reason_concept_id number default null);
alter table @cdmDatabaseSchema.payer_plan_period add (stop_reason_source_value varchar2(50) default null);
alter table @cdmDatabaseSchema.payer_plan_period add (stop_reason_source_concept_id number default null);

-- COST
alter table @cdmDatabaseSchema.cost rename column reveue_code_source_value to revenue_code_source_value;

-- METADATA
create table @cdmDatabaseSchema.metadata (
    metadata_concept_id integer NOT NULL,
    metadata_type_concept_id integer NOT NULL,
    name varchar2(250) NOT NULL,
    value_as_string varchar2(250) NULL,
    value_as_concept_id integer NULL,
    metadata_date date NULL,
    metadata_datetime TIMESTAMP NULL
);

-- VOCABULARY
update @cdmDatabaseSchema.vocabulary
set vocabulary_reference = ''
where vocabulary_reference is null;

alter table @cdmDatabaseSchema.vocabulary modify (vocabulary_reference varchar2(255) not null);

-- TABLES REMOVED IN v5.3
drop table @cdmDatabaseSchema.cohort_attribute;
drop table @cdmDatabaseSchema.cohort;
