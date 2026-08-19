-- Derived from the OMOP CDM v5.2 and v5.3 SQL Server DDLs in this repository.
-- SQL Server SQL references:
--   https://learn.microsoft.com/sql/t-sql/statements/alter-table-transact-sql
--
-- VISIT_DETAIL

create table @cdmDatabaseSchema.visit_detail (
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
            visit_detail_source_value varchar(50) NULL,
            visit_detail_source_concept_id integer NULL,
            admitting_source_value varchar(50) NULL,
            admitting_source_concept_id integer NULL,
            discharge_to_source_value varchar(50) NULL,
            discharge_to_concept_id integer NULL,
            preceding_visit_detail_id integer NULL,
            visit_detail_parent_id integer NULL,
            visit_occurrence_id integer NOT NULL );

-- CONDITION_OCCURRENCE
alter table @cdmDatabaseSchema.condition_occurrence alter column condition_start_datetime datetime null;
alter table @cdmDatabaseSchema.condition_occurrence add visit_detail_id int null;

-- DRUG_EXPOSURE
alter table @cdmDatabaseSchema.drug_exposure alter column drug_exposure_start_datetime datetime null;
alter table @cdmDatabaseSchema.drug_exposure add visit_detail_id int null;

-- PROCEDURE_OCCURRENCE
alter table @cdmDatabaseSchema.procedure_occurrence alter column procedure_datetime datetime null;
EXEC sp_rename '@cdmDatabaseSchema.procedure_occurrence.qualifier_source_value', 'modifier_source_value', 'COLUMN';
alter table @cdmDatabaseSchema.procedure_occurrence add visit_detail_id int null;

-- DEVICE_EXPOSURE
alter table @cdmDatabaseSchema.device_exposure alter column device_exposure_start_datetime datetime null;
alter table @cdmDatabaseSchema.device_exposure alter column device_source_value varchar(50) null;
alter table @cdmDatabaseSchema.device_exposure add visit_detail_id int null;

-- MEASUREMENT
alter table @cdmDatabaseSchema.measurement add measurement_time varchar(10) null;
alter table @cdmDatabaseSchema.measurement add visit_detail_id int null;

-- OBSERVATION
alter table @cdmDatabaseSchema.observation add visit_detail_id int null;

-- DEATH
alter table @cdmDatabaseSchema.death alter column death_type_concept_id int null;

-- NOTE
alter table @cdmDatabaseSchema.note add visit_detail_id int null;

-- NOTE_NLP
alter table @cdmDatabaseSchema.note_nlp alter column note_nlp_id int not null;
alter table @cdmDatabaseSchema.note_nlp alter column "offset" varchar(50) null;

-- PAYER_PLAN_PERIOD
alter table @cdmDatabaseSchema.payer_plan_period add payer_concept_id int null;
alter table @cdmDatabaseSchema.payer_plan_period add payer_source_concept_id int null;
alter table @cdmDatabaseSchema.payer_plan_period add plan_concept_id int null;
alter table @cdmDatabaseSchema.payer_plan_period add plan_source_concept_id int null;
alter table @cdmDatabaseSchema.payer_plan_period add sponsor_concept_id int null;
alter table @cdmDatabaseSchema.payer_plan_period add sponsor_source_value varchar(50) null;
alter table @cdmDatabaseSchema.payer_plan_period add sponsor_source_concept_id int null;
alter table @cdmDatabaseSchema.payer_plan_period add stop_reason_concept_id int null;
alter table @cdmDatabaseSchema.payer_plan_period add stop_reason_source_value varchar(50) null;
alter table @cdmDatabaseSchema.payer_plan_period add stop_reason_source_concept_id int null;

-- COST
EXEC sp_rename '@cdmDatabaseSchema.cost.reveue_code_source_value', 'revenue_code_source_value', 'COLUMN';

-- METADATA
create table @cdmDatabaseSchema.metadata (
            metadata_concept_id integer NOT NULL,
            metadata_type_concept_id integer NOT NULL,
            name varchar(250) NOT NULL,
            value_as_string varchar(250) NULL,
            value_as_concept_id integer NULL,
            metadata_date date NULL,
            metadata_datetime datetime NULL );

-- VOCABULARY
update @cdmDatabaseSchema.vocabulary
set vocabulary_reference = ''
where vocabulary_reference is null;

alter table @cdmDatabaseSchema.vocabulary alter column vocabulary_reference varchar(255) not null;

-- TABLES REMOVED IN v5.3
drop table @cdmDatabaseSchema.cohort_attribute;
drop table @cdmDatabaseSchema.cohort;
