-- http://ohdsi.github.io/CommonDataModel/cdm54Changes.html
-- Netezza SQL references: 
--	https://www.ibm.com/docs/en/psfa/7.2.1?topic=reference-alter-table
--	https://www.ibm.com/docs/en/psfa/7.2.1?topic=tables-add-drop-column
--
-- VISIT_OCCURRENCE
-- admitting_source_concept_id -> admitted_from_concept_id
-- admitting_source_value -> admitted_from_source_value
-- discharge_to_concept_id -> discharged_to_concept_id
-- discharge_to_source_value -> discharged_to_source_value

alter table @cdmDatabaseSchema.visit_occurrence rename column admitting_source_concept_id to admitted_from_concept_id;
alter table @cdmDatabaseSchema.visit_occurrence rename column admitting_source_value to admitted_from_source_value;
alter table @cdmDatabaseSchema.visit_occurrence rename column discharge_to_concept_id to discharged_to_concept_id;
alter table @cdmDatabaseSchema.visit_occurrence rename column discharge_to_source_value to discharged_to_source_value;

--
-- VISIT_DETAIL
-- admitting_source_concept_id -> admitted_from_concept_id
-- admitting_source_value -> admitted_from_source_value
-- discharge_to_concept_id -> discharged_to_concept_id
-- discharge_to_source_value -> discharged_to_source_value
-- visit_detail_parent_id -> parent_visit_detail_id

alter table @cdmDatabaseSchema.visit_detail rename column admitting_source_concept_id to admitted_from_concept_id;
alter table @cdmDatabaseSchema.visit_detail rename column admitting_source_value to admitted_from_source_value;
alter table @cdmDatabaseSchema.visit_detail rename column discharge_to_concept_id to discharged_to_concept_id;
alter table @cdmDatabaseSchema.visit_detail rename column discharge_to_source_value to discharged_to_source_value;
alter table @cdmDatabaseSchema.visit_detail rename column visit_detail_parent_id to parent_visit_detail_id;

-- PROCEDURE_OCCURRENCE
-- + Procedure_end_date
-- + Procedure_end_datetime

alter table @cdmDatabaseSchema.procedure_occurrence add column procedure_end_date timestamp null;
alter table @cdmDatabaseSchema.procedure_occurrence add column procedure_end_datetime timestamp null;

-- DEVICE_EXPOSURE
-- Unique_device_id -> Changed to varchar(255)
-- + Production_id
-- + Unit_concept_id
-- + Unit_source_value
-- + Unit_source_concept_id

alter table @cdmDatabaseSchema.device_exposure modify column (unique_device_id varchar(300);
alter table @cdmDatabaseSchema.device_exposure add column production_id integer null;
alter table @cdmDatabaseSchema.device_exposure add column unit_concept_id integer null;
alter table @cdmDatabaseSchema.device_exposure add column unit_source_value varchar(50) null;
alter table @cdmDatabaseSchema.device_exposure add column unit_source_concept_id integer null;

-- MEASUREMENT
-- + Unit_source_concept_id
-- + Measurement_event_id
-- + Meas_event_field_concept_id

alter table @cdmDatabaseSchema.measurement add column unit_source_id integer default null;
alter table @cdmDatabaseSchema.measurement add column measurement_event_id bigint null;
alter table @cdmDatabaseSchema.measurement add column meas_event_field_concept_id integer null;

-- OBSERVATION
-- + Value_source_value
-- + Observation_event_id
-- + Obs_event_field_concept_id

alter table @cdmDatabaseSchema.observation add column value_source_value varchar(50) null;
alter table @cdmDatabaseSchema.observation add column observation_event_id bigint null;
alter table @cdmDatabaseSchema.observation add column obs_event_field_concept_id integer null;

-- NOTE
-- + Note_event_id
-- + Note_event_field_concept_id

alter table @cdmDatabaseSchema.note add column note_event_id bigint null;
alter table @cdmDatabaseSchema.note add column note_event_field_concept_id integer null;

-- LOCATION
-- + Country_concept_id
-- + Country_source_value
-- + Latitude
-- + Longitude

alter table @cdmDatabaseSchema.location add column country_concept_id integer null;
alter table @cdmDatabaseSchema.location add column country_source_value varchar(80) null;
alter table @cdmDatabaseSchema.location add column latitude float null;
alter table @cdmDatabaseSchema.location add column longitude float null;

-- EPISODE
CREATE TABLE @cdmDatabaseSchema.EPISODE  (
            episode_id bigint NOT NULL,
			person_id bigint NOT NULL,
			episode_concept_id integer NOT NULL,
			episode_start_date timestamp NOT NULL,
			episode_start_datetime TIMESTAMP NULL,
			episode_end_date timestamp NULL,
			episode_end_datetime TIMESTAMP NULL,
			episode_parent_id bigint NULL,
			episode_number integer NULL,
			episode_object_concept_id integer NOT NULL,
			episode_type_concept_id integer NOT NULL,
			episode_source_value varchar(50) NULL,
			episode_source_concept_id integer NULL );

-- EPISODE_EVENT
CREATE TABLE @cdmDatabaseSchema.EPISODE_EVENT  (
            episode_id bigint NOT NULL,
			event_id bigint NOT NULL,
			episode_event_field_concept_id integer NOT NULL );
			

-- METADATA
-- + Metadata_id
-- + Value_as_number

alter table @cdmDatabaseSchema.metadata add column metadata_id integer null;
alter table @cdmDatabaseSchema.metadata add column value_as_number float null;

-- CDM_SOURCE
-- Cdm_source_name -> Mandatory field
-- Cdm_source_abbreviation -> Mandatory field
-- Cdm_holder -> Mandatory field
-- Source_release_date -> Mandatory field
-- Cdm_release_date -> Mandatory field
-- + Cdm_version_concept_id

alter table @cdmDatabaseSchema.cdm_source rename to cdm_source_v53;

CREATE TABLE @cdmDatabaseSchema.cdm_source  (
            cdm_source_name varchar(255) NOT NULL,
			cdm_source_abbreviation varchar(25) NOT NULL,
			cdm_holder varchar(255) NOT NULL,
			source_description varchar(1000) NULL,
			source_documentation_reference varchar(255) NULL,
			cdm_etl_reference varchar(255) NULL,
			source_release_date timestamp NOT NULL,
			cdm_release_date timestamp NOT NULL,
			cdm_version varchar(10) NULL,
			cdm_version_concept_id integer NOT NULL,
			vocabulary_version varchar(20) NOT NULL );

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
            vocabulary_id varchar(20) NOT NULL,
			vocabulary_name varchar(255) NOT NULL,
			vocabulary_reference varchar(255) NULL,
			vocabulary_version varchar(255) NULL,
			vocabulary_concept_id integer NOT NULL );

insert into @cdmDatabaseSchema.vocabulary 
select vocabulary_id,vocabulary_name,vocabulary_reference,
       vocabulary_version, vocabulary_concept_id
from @cdmDatabaseSchema.vocabulary_v53;

			
-- ATTRIBUTE_DEFINITION
drop table @cdmDatabaseSchema.attribute_definition;

-- COHORT
CREATE TABLE @cdmDatabaseSchema.cohort  (
            cohort_definition_id integer NOT NULL,
			subject_id integer NOT NULL,
			cohort_start_date timestamp NOT NULL,
			cohort_end_date timestamp NOT NULL );


