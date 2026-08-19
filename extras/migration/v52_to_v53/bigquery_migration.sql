-- Derived from the OMOP CDM v5.2 and v5.3 BigQuery-compatible schema deltas in this repository.
-- BigQuery SQL references:
--   https://cloud.google.com/bigquery/docs/reference/standard-sql/data-definition-language
--
-- VISIT_DETAIL

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
            admitting_source_value STRING,
            admitting_source_concept_id INT64,
            discharge_to_source_value STRING,
            discharge_to_concept_id INT64,
            preceding_visit_detail_id INT64,
            visit_detail_parent_id INT64,
            visit_occurrence_id INT64 not null );

-- CONDITION_OCCURRENCE
alter table @cdmDatabaseSchema.condition_occurrence alter column condition_start_datetime drop not null;
alter table @cdmDatabaseSchema.condition_occurrence add column visit_detail_id int64;

-- DRUG_EXPOSURE
alter table @cdmDatabaseSchema.drug_exposure alter column drug_exposure_start_datetime drop not null;
alter table @cdmDatabaseSchema.drug_exposure add column visit_detail_id int64;

-- PROCEDURE_OCCURRENCE
alter table @cdmDatabaseSchema.procedure_occurrence rename to procedure_occurrence_v52;
create table @cdmDatabaseSchema.procedure_occurrence as
select
  * except(qualifier_source_value),
  cast(null as int64) as visit_detail_id,
  qualifier_source_value as modifier_source_value
from @cdmDatabaseSchema.procedure_occurrence_v52;

-- DEVICE_EXPOSURE
alter table @cdmDatabaseSchema.device_exposure alter column device_exposure_start_datetime drop not null;
alter table @cdmDatabaseSchema.device_exposure add column visit_detail_id int64;

-- MEASUREMENT
alter table @cdmDatabaseSchema.measurement add column measurement_time string;
alter table @cdmDatabaseSchema.measurement add column visit_detail_id int64;

-- OBSERVATION
alter table @cdmDatabaseSchema.observation add column visit_detail_id int64;

-- DEATH
alter table @cdmDatabaseSchema.death alter column death_type_concept_id drop not null;

-- NOTE
alter table @cdmDatabaseSchema.note add column visit_detail_id int64;

-- PAYER_PLAN_PERIOD
alter table @cdmDatabaseSchema.payer_plan_period add column payer_concept_id int64;
alter table @cdmDatabaseSchema.payer_plan_period add column payer_source_concept_id int64;
alter table @cdmDatabaseSchema.payer_plan_period add column plan_concept_id int64;
alter table @cdmDatabaseSchema.payer_plan_period add column plan_source_concept_id int64;
alter table @cdmDatabaseSchema.payer_plan_period add column sponsor_concept_id int64;
alter table @cdmDatabaseSchema.payer_plan_period add column sponsor_source_value string;
alter table @cdmDatabaseSchema.payer_plan_period add column sponsor_source_concept_id int64;
alter table @cdmDatabaseSchema.payer_plan_period add column stop_reason_concept_id int64;
alter table @cdmDatabaseSchema.payer_plan_period add column stop_reason_source_value string;
alter table @cdmDatabaseSchema.payer_plan_period add column stop_reason_source_concept_id int64;

-- COST
alter table @cdmDatabaseSchema.cost rename to cost_v52;
create table @cdmDatabaseSchema.cost as
select
  * except(reveue_code_source_value),
  reveue_code_source_value as revenue_code_source_value
from @cdmDatabaseSchema.cost_v52;

-- METADATA
create table @cdmDatabaseSchema.metadata (
            metadata_concept_id INT64 not null,
            metadata_type_concept_id INT64 not null,
            name STRING not null,
            value_as_string STRING,
            value_as_concept_id INT64,
            metadata_date DATE,
            metadata_datetime DATETIME );

-- TABLES REMOVED IN v5.3
drop table @cdmDatabaseSchema.cohort_attribute;
drop table @cdmDatabaseSchema.cohort;
