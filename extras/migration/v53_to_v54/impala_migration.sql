-- http://ohdsi.github.io/CommonDataModel/cdm54Changes.html
-- Impala SQL references: 
--	https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/impala_alter_table.html
--
-- VISIT_OCCURRENCE
-- admitting_source_concept_id -> admitted_from_concept_id
-- admitting_source_value -> admitted_from_source_value
-- discharge_to_concept_id -> discharged_to_concept_id
-- discharge_to_source_value -> discharged_to_source_value

alter table @cdmDatabaseSchema.visit_occurrence change admitting_source_concept_id admitted_from_concept_id int;
alter table @cdmDatabaseSchema.visit_occurrence change admitting_source_value admitted_from_source_value int;
alter table @cdmDatabaseSchema.visit_occurrence change discharge_to_concept_id discharged_to_concept_id int;
alter table @cdmDatabaseSchema.visit_occurrence change discharge_to_source_value discharged_to_source_value int;

--
-- VISIT_DETAIL
-- admitting_source_concept_id -> admitted_from_concept_id
-- admitting_source_value -> admitted_from_source_value
-- discharge_to_concept_id -> discharged_to_concept_id
-- discharge_to_source_value -> discharged_to_source_value
-- visit_detail_parent_id -> parent_visit_detail_id

alter table @cdmDatabaseSchema.visit_detail change admitting_source_concept_id admitted_from_concept_id int;
alter table @cdmDatabaseSchema.visit_detail change admitting_source_value admitted_from_source_value int;
alter table @cdmDatabaseSchema.visit_detail change discharge_to_concept_id discharged_to_concept_id int;
alter table @cdmDatabaseSchema.visit_detail change discharge_to_source_value discharged_to_source_value int;
alter table @cdmDatabaseSchema.visit_detail change visit_detail_parent_id parent_visit_detail_id int;

-- PROCEDURE_OCCURRENCE
-- + Procedure_end_date
-- + Procedure_end_datetime

alter table @cdmDatabaseSchema.procedure_occurrence add columns (procedure_end_date timestamp);
alter table @cdmDatabaseSchema.procedure_occurrence add columns (procedure_end_datetime timestamp);

-- DEVICE_EXPOSURE
-- Unique_device_id -> Changed to varchar(255)
-- + Production_id
-- + Unit_concept_id
-- + Unit_source_value
-- + Unit_source_concept_id

alter table @cdmDatabaseSchema.device_exposure change unique_device_id unique_device_id varchar(300);
alter table @cdmDatabaseSchema.device_exposure add columns (production_id int);
alter table @cdmDatabaseSchema.device_exposure add columns (unit_concept_id int);
alter table @cdmDatabaseSchema.device_exposure add columns (unit_source_value int);
alter table @cdmDatabaseSchema.device_exposure add columns (unit_source_concept_id int);

-- MEASUREMENT
-- + Unit_source_concept_id
-- + Measurement_event_id
-- + Meas_event_field_concept_id

alter table @cdmDatabaseSchema.measurement add columns (unit_source_concept_id int);
alter table @cdmDatabaseSchema.measurement add columns (measurement_event_id int);
alter table @cdmDatabaseSchema.measurement add columns (meas_event_field_concept_id int);

-- OBSERVATION
-- + Value_source_value
-- + Observation_event_id
-- + Obs_event_field_concept_id

alter table @cdmDatabaseSchema.observation add columns (value_source_value varchar(50));
alter table @cdmDatabaseSchema.observation add columns (observation_event_id int);
alter table @cdmDatabaseSchema.observation add columns (obs_event_field_concept_id int);

-- NOTE
-- + Note_event_id
-- + Note_event_field_concept_id

alter table @cdmDatabaseSchema.note add columns (note_event_id int);
alter table @cdmDatabaseSchema.note add columns (note_event_field_concept_id int);

-- LOCATION
-- + Country_concept_id
-- + Country_source_value
-- + Latitude
-- + Longitude

alter table @cdmDatabaseSchema.location add columns (country_concept_id int);
alter table @cdmDatabaseSchema.location add columns (country_source_value varchar(80));
alter table @cdmDatabaseSchema.location add columns (latitude float);
alter table @cdmDatabaseSchema.location add columns (longitude float);

-- EPISODE
CREATE TABLE @cdmDatabaseSchema.EPISODE  (
            episode_id int,
			person_id int,
			episode_concept_id int,
			episode_start_date timestamp,
			episode_start_datetime TIMESTAMP,
			episode_end_date timestamp,
			episode_end_datetime timestamp,
			episode_parent_id int,
			episode_number int,
			episode_object_concept_id int,
			episode_type_concept_id int,
			episode_source_value varchar(50),
			episode_source_concept_id int );

-- EPISODE_EVENT
CREATE TABLE @cdmDatabaseSchema.EPISODE_EVENT  (
            episode_id int,
			event_id int,
			episode_event_field_concept_id int );
			

-- METADATA
-- + Metadata_id
-- + Value_as_number

alter table @cdmDatabaseSchema.metadata add columns (metadata_id int);
alter table @cdmDatabaseSchema.metadata add columns (value_as_number float);

-- CDM_SOURCE
-- Cdm_source_name -> Mandatory field
-- Cdm_source_abbreviation -> Mandatory field
-- Cdm_holder -> Mandatory field
-- Source_release_date -> Mandatory field
-- Cdm_release_date -> Mandatory field
-- + Cdm_version_concept_id

alter table @cdmDatabaseSchema.cdm_source rename to cdm_source_v53;

CREATE TABLE @cdmDatabaseSchema.cdm_source  (
            cdm_source_name varchar(255),
			cdm_source_abbreviation varchar(25),
			cdm_holder varchar(255),
			source_description varchar(max),
			source_documentation_reference varchar(255),
			cdm_etl_reference varchar(255),
			source_release_date timestamp,
			cdm_release_date timestamp,
			cdm_version varchar(10),
			cdm_version_concept_id int,
			vocabulary_version varchar(20));

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
            vocabulary_id varchar(20),
			vocabulary_name varchar(255),
			vocabulary_reference varchar(255),
			vocabulary_version varchar(255),
			vocabulary_concept_id int );

insert into @cdmDatabaseSchema.vocabulary 
select vocabulary_id,vocabulary_name,vocabulary_reference,
       vocabulary_version, vocabulary_concept_id
from @cdmDatabaseSchema.vocabulary_v53;

			
-- ATTRIBUTE_DEFINITION
drop table @cdmDatabaseSchema.attribute_definition;

-- COHORT
CREATE TABLE @cdmDatabaseSchema.cohort  (
            cohort_definition_id int,
			subject_id int,
			cohort_start_date timestamp,
			cohort_end_date timestamp );


