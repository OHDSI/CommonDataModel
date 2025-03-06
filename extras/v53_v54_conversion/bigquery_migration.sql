-- http://ohdsi.github.io/CommonDataModel/cdm54Changes.html
-- BigQuery SQL references: 
--	https://cloud.google.com/bigquery/docs/reference/standard-sql/data-definition-language#creating_a_new_table_from_an_existing_table
--	https://cloud.google.com/bigquery/docs/manually-changing-schemas
--	https://cloud.google.com/bigquery/docs/reference/standard-sql/data-definition-language#alter_column_set_data_type_statement
--	https://cloud.google.com/bigquery/docs/managing-tables#renaming-table
--

-- VISIT_OCCURRENCE
-- admitting_source_concept_id -> admitted_from_concept_id
-- admitting_source_value -> admitted_from_source_value
-- discharge_to_concept_id -> discharged_to_concept_id
-- discharge_to_source_value -> discharged_to_source_value

alter table @cdmDatabaseSchema.visit_occurrence rename to visit_occurrence_old;
create table @cdmDatabaseSchema.visit_occurrence
as
select * EXCEPT(admitting_source_concept_id,admitting_source_value,discharge_to_concept_id,discharge_to_source_value),
 admitting_source_concept_id as admitted_from_concept_id,
 admitting_source_value as admitted_from_source_value,
 discharge_to_concept_id as discharged_to_concept_id,
 discharge_to_source_value as discharged_to_source_value
from visit_occurrence_old; 

--
-- VISIT_DETAIL
-- admitting_source_concept_id -> admitted_from_concept_id
-- admitting_source_value -> admitted_from_source_value
-- discharge_to_concept_id -> discharged_to_concept_id
-- discharge_to_source_value -> discharged_to_source_value
-- visit_detail_parent_id -> parent_visit_detail_id

alter table @cdmDatabaseSchema.visit_detail rename to visit_detail_old;
create table @cdmDatabaseSchema.visit_occurrence
as
select * EXCEPT(admitting_source_concept_id,admitting_source_value,discharge_to_concept_id,discharge_to_source_value,visit_detail_parent_id),
 admitting_source_concept_id as admitted_from_concept_id,
 admitting_source_value as admitted_from_source_value,
 discharge_to_concept_id as discharged_to_concept_id,
 discharge_to_source_value as discharged_to_source_value,
 visit_detail_parent_id as parent_visit_detail_id
from visit_detail_old; 

-- PROCEDURE_OCCURRENCE
-- + Procedure_end_date
-- + Procedure_end_datetime

alter table @cdmDatabaseSchema.procedure_occurrence add column procedure_end_date date;
alter table @cdmDatabaseSchema.procedure_occurrence add column procedure_end_datetime datetime;

-- DEVICE_EXPOSURE
-- Unique_device_id -> Changed to varchar(255) (already a STRING on bigquery)
-- + Production_id
-- + Unit_concept_id
-- + Unit_source_value
-- + Unit_source_concept_id

alter table @cdmDatabaseSchema.device_exposure add column production_id int64;
alter table @cdmDatabaseSchema.device_exposure add column unit_concept_id int64;
alter table @cdmDatabaseSchema.device_exposure add column unit_source_value string;
alter table @cdmDatabaseSchema.device_exposure add column unit_source_concept_id int64;

-- MEASUREMENT
-- + Unit_source_concept_id
-- + Measurement_event_id
-- + Meas_event_field_concept_id

alter table @cdmDatabaseSchema.measurement add column unit_source_concept_id int64;
alter table @cdmDatabaseSchema.measurement add column measurement_event_id int64;
alter table @cdmDatabaseSchema.measurement add column meas_event_field_concept_id int64;

-- OBSERVATION
-- + Value_source_value
-- + Observation_event_id
-- + Obs_event_field_concept_id

alter table @cdmDatabaseSchema.observation add column value_source_value string;
alter table @cdmDatabaseSchema.observation add column observation_event_id int64;
alter table @cdmDatabaseSchema.observation add column obs_event_field_concept_id int64;

-- NOTE
-- + Note_event_id
-- + Note_event_field_concept_id

alter table @cdmDatabaseSchema.note add column note_event_id int64;
alter table @cdmDatabaseSchema.note add column note_event_field_concept_id int64;

-- LOCATION
-- + Country_concept_id
-- + Country_source_value
-- + Latitude
-- + Longitude

alter table @cdmDatabaseSchema.location add column country_concept_id int64;
alter table @cdmDatabaseSchema.location add column country_source_value string;
alter table @cdmDatabaseSchema.location add column latitude float64;
alter table @cdmDatabaseSchema.location add column longitude float64;

-- EPISODE
create table @cdmDatabaseSchema.episode (
			episode_id INT64 not null,
			person_id INT64 not null,
			episode_concept_id INT64 not null,
			episode_start_date date not null,
			episode_start_datetime datetime null,
			episode_end_date date null,
			episode_end_datetime datetime null,
			episode_parent_id INT64,
			episode_number INT64,
			episode_object_concept_id INT64 not null,
			episode_type_concept_id INT64 not null,
			episode_source_value STRING,
			episode_source_concept_id INT64 );

-- EPISODE_EVENT
CREATE TABLE @cdmDatabaseSchema.EPISODE_EVENT  (
            episode_id int64 NOT NULL,
			event_id int64 NOT NULL,
			episode_event_field_concept_id int64 NOT NULL );
			

-- METADATA
-- + Metadata_id
-- + Value_as_number

alter table @cdmDatabaseSchema.metadata add column metadata_id int64;
alter table @cdmDatabaseSchema.metadata add column value_as_number float64;

-- CDM_SOURCE
-- Cdm_source_name -> Mandatory field
-- Cdm_source_abbreviation -> Mandatory field
-- Cdm_holder -> Mandatory field
-- Source_release_date -> Mandatory field
-- Cdm_release_date -> Mandatory field
-- + Cdm_version_concept_id

alter table @cdmDatabaseSchema.cdm_source rename to cdm_source_v53;

CREATE TABLE @cdmDatabaseSchema.cdm_source  (
            cdm_source_name string NOT NULL,
			cdm_source_abbreviation string NOT NULL,
			cdm_holder string NOT NULL,
			source_description string NULL,
			source_documentation_reference string NULL,
			cdm_etl_reference string NULL,
			source_release_date datetime NOT NULL,
			cdm_release_date datetime NOT NULL,
			cdm_version string NULL,
			cdm_version_concept_id int64 NOT NULL,
			vocabulary_version string NOT NULL );

insert into @cdmDatabaseSchema.cdm_source 
select cdm_source_name,cdm_source_abbreviation,cdm_holder,
            source_description,source_documentation_reference,cdm_etl_reference,
			source_release_date,cdm_release_date,'5.4',
            756265,vocabulary_version
from @cdmDatabaseSchema.cdm_source_v53;


-- VOCABULARY
-- Vocabulary_reference -> Non-mandatory field
-- Vocabulary_version -> Non-mandatory field
alter table @cdmDatabaseSchema.vocabulary rename to vocabulary_v53;

CREATE TABLE @cdmDatabaseSchema.vocabulary  (
            vocabulary_id string NOT NULL,
			vocabulary_name string NOT NULL,
			vocabulary_reference string NULL,
			vocabulary_version string NULL,
			vocabulary_concept_id int64 NOT NULL );

insert into @cdmDatabaseSchema.vocabulary 
select vocabulary_id,vocabulary_name,vocabulary_reference,
       vocabulary_version, vocabulary_concept_id
from @cdmDatabaseSchema.vocabulary_v53;

			
-- ATTRIBUTE_DEFINITION
drop table @cdmDatabaseSchema.attribute_definition;

-- COHORT
CREATE TABLE @cdmDatabaseSchema.cohort  (
            cohort_definition_id int64 NOT NULL,
			subject_id int64 NOT NULL,
			cohort_start_date datetime NOT NULL,
			cohort_end_date datetime NOT NULL );


