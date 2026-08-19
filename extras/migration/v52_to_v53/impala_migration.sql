-- Derived from the OMOP CDM v5.2 and v5.3 Impala DDLs in this repository.
-- Impala SQL references:
--   https://docs.cloudera.com/documentation/enterprise/latest/topics/impala_alter_table.html
--
-- VISIT_DETAIL

create table @cdmDatabaseSchema.visit_detail (
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
            visit_detail_source_concept_id integer NULL,
            admitting_source_value VARCHAR(50),
            admitting_source_concept_id integer NULL,
            discharge_to_source_value VARCHAR(50),
            discharge_to_concept_id integer NULL,
            preceding_visit_detail_id integer NULL,
            visit_detail_parent_id integer NULL,
            visit_occurrence_id INT );

-- CONDITION_OCCURRENCE
alter table @cdmDatabaseSchema.condition_occurrence add columns (visit_detail_id int);

-- DRUG_EXPOSURE
alter table @cdmDatabaseSchema.drug_exposure add columns (visit_detail_id int);

-- PROCEDURE_OCCURRENCE
alter table @cdmDatabaseSchema.procedure_occurrence change qualifier_source_value modifier_source_value varchar(50);
alter table @cdmDatabaseSchema.procedure_occurrence add columns (visit_detail_id int);

-- DEVICE_EXPOSURE
alter table @cdmDatabaseSchema.device_exposure change device_source_value device_source_value varchar(50);
alter table @cdmDatabaseSchema.device_exposure add columns (visit_detail_id int);

-- MEASUREMENT
alter table @cdmDatabaseSchema.measurement add columns (measurement_time varchar(10));
alter table @cdmDatabaseSchema.measurement add columns (visit_detail_id int);

-- OBSERVATION
alter table @cdmDatabaseSchema.observation add columns (visit_detail_id int);

-- NOTE
alter table @cdmDatabaseSchema.note add columns (visit_detail_id int);

-- NOTE_NLP
alter table @cdmDatabaseSchema.note_nlp change note_nlp_id note_nlp_id int;
alter table @cdmDatabaseSchema.note_nlp change `offset` `offset` varchar(50);

-- PAYER_PLAN_PERIOD
alter table @cdmDatabaseSchema.payer_plan_period add columns (payer_concept_id int);
alter table @cdmDatabaseSchema.payer_plan_period add columns (payer_source_concept_id int);
alter table @cdmDatabaseSchema.payer_plan_period add columns (plan_concept_id int);
alter table @cdmDatabaseSchema.payer_plan_period add columns (plan_source_concept_id int);
alter table @cdmDatabaseSchema.payer_plan_period add columns (sponsor_concept_id int);
alter table @cdmDatabaseSchema.payer_plan_period add columns (sponsor_source_value varchar(50));
alter table @cdmDatabaseSchema.payer_plan_period add columns (sponsor_source_concept_id int);
alter table @cdmDatabaseSchema.payer_plan_period add columns (stop_reason_concept_id int);
alter table @cdmDatabaseSchema.payer_plan_period add columns (stop_reason_source_value varchar(50));
alter table @cdmDatabaseSchema.payer_plan_period add columns (stop_reason_source_concept_id int);

-- COST
alter table @cdmDatabaseSchema.cost change reveue_code_source_value revenue_code_source_value varchar(50);

-- METADATA
create table @cdmDatabaseSchema.metadata (
            metadata_concept_id INT,
            metadata_type_concept_id INT,
            name VARCHAR(250),
            value_as_string VARCHAR(250),
            value_as_concept_id integer NULL,
            metadata_date TIMESTAMP,
            metadata_datetime TIMESTAMP );

-- TABLES REMOVED IN v5.3
drop table @cdmDatabaseSchema.cohort_attribute;
drop table @cdmDatabaseSchema.cohort;
