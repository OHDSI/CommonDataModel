-- http://ohdsi.github.io/CommonDataModel/cdm54Changes.html
-- Oracle SQL references: 
--	https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/ALTER-TABLE.html#GUID-552E7373-BF93-477D-9DA3-B2C9386F2877
--	https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Data-Types.html#GUID-0DC7FFAA-F03F-4448-8487-F2592496A510
--	https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/RENAME.html#GUID-573347CE-3EB8-42E5-B4D5-EF71CA06FAFC
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

alter table @cdmDatabaseSchema.procedure_occurrence add (procedure_end_date date default null);
alter table @cdmDatabaseSchema.procedure_occurrence add (procedure_end_datetime timestamp default null);

-- DEVICE_EXPOSURE
-- Unique_device_id -> Changed to varchar(255)
-- + Production_id
-- + Unit_concept_id
-- + Unit_source_value
-- + Unit_source_concept_id

alter table @cdmDatabaseSchema.device_exposure modify (unique_device_id varchar2(300));
alter table @cdmDatabaseSchema.device_exposure add (production_id number default null);
alter table @cdmDatabaseSchema.device_exposure add (unit_concept_id number default null);
alter table @cdmDatabaseSchema.device_exposure add (unit_source_value varchar2(50) default null);
alter table @cdmDatabaseSchema.device_exposure add (unit_source_concept_id number default null);

-- MEASUREMENT
-- + Unit_source_concept_id
-- + Measurement_event_id
-- + Meas_event_field_concept_id

alter table @cdmDatabaseSchema.measurement add (unit_source_id number default null);
alter table @cdmDatabaseSchema.measurement add (measurement_event_id number default null);
alter table @cdmDatabaseSchema.measurement add (meas_event_field_concept_id number default null);

-- OBSERVATION
-- + Value_source_value
-- + Observation_event_id
-- + Obs_event_field_concept_id

alter table @cdmDatabaseSchema.observation add (value_source_value varchar2(50) default null);
alter table @cdmDatabaseSchema.observation add (observation_event_id number default null);
alter table @cdmDatabaseSchema.observation add (obs_event_field_concept_id number default null);

-- NOTE
-- + Note_event_id
-- + Note_event_field_concept_id

alter table @cdmDatabaseSchema.note add (note_event_id number default null);
alter table @cdmDatabaseSchema.note add (note_event_field_concept_id number default null);

-- LOCATION
-- + Country_concept_id
-- + Country_source_value
-- + Latitude
-- + Longitude

alter table @cdmDatabaseSchema.location add (country_concept_id number default null);
alter table @cdmDatabaseSchema.location add (country_source_value varchar2(80) default null);
alter table @cdmDatabaseSchema.location add (latitude float default null);
alter table @cdmDatabaseSchema.location add (longitude float default null);

-- EPISODE
CREATE TABLE @cdmDatabaseSchema.EPISODE  (
            episode_id number NOT NULL,
			person_id number NOT NULL,
			episode_concept_id number NOT NULL,
			episode_start_date date NOT NULL,
			episode_start_datetime TIMESTAMP NULL,
			episode_end_date date NULL,
			episode_end_datetime TIMESTAMP NULL,
			episode_parent_id number NULL,
			episode_number number NULL,
			episode_object_concept_id number NOT NULL,
			episode_type_concept_id number NOT NULL,
			episode_source_value varchar2(50) NULL,
			episode_source_concept_id number NULL );

-- EPISODE_EVENT
CREATE TABLE @cdmDatabaseSchema.EPISODE_EVENT  (
            episode_id number NOT NULL,
			event_id number NOT NULL,
			episode_event_field_concept_id number NOT NULL );
			

-- METADATA
-- + Metadata_id
-- + Value_as_number

alter table @cdmDatabaseSchema.metadata add (metadata_id number default null);
alter table @cdmDatabaseSchema.metadata add (value_as_number float default null);

-- CDM_SOURCE
-- Cdm_source_name -> Mandatory field
-- Cdm_source_abbreviation -> Mandatory field
-- Cdm_holder -> Mandatory field
-- Source_release_date -> Mandatory field
-- Cdm_release_date -> Mandatory field
-- + Cdm_version_concept_id

rename @cdmDatabaseSchema.cdm_source to cdm_source_v53;

CREATE TABLE @cdmDatabaseSchema.cdm_source  (
            cdm_source_name varchar2(255) NOT NULL,
			cdm_source_abbreviation varchar2(25) NOT NULL,
			cdm_holder varchar2(255) NOT NULL,
			-- 32767 bytes if MAX_STRING_SIZE = EXTENDED
            -- 4000 bytes if MAX_STRING_SIZE = STANDARD
			source_description varchar2(32767) NULL,
			source_documentation_reference varchar2(255) NULL,
			cdm_etl_reference varchar2(255) NULL,
			source_release_date date NOT NULL,
			cdm_release_date date NOT NULL,
			cdm_version varchar2(10) NULL,
			cdm_version_concept_id number NOT NULL,
			vocabulary_version varchar2(20) NOT NULL );

insert into @cdmDatabaseSchema.cdm_source 
select cdm_source_name,cdm_source_abbreviation,cdm_holder,
            source_description,source_documentation_reference,cdm_etl_reference,
			source_release_date,cdm_release_date,'5.4',
            756265,vocabulary_version
from @cdmDatabaseSchema.cdm_source_v53;


-- VOCABULARY
-- Vocabulary_reference -> Non-mandatory field
-- Vocabulary_version -> Non-mandatory field
rename @cdmDatabaseSchema.vocabulary to vocabulary_v53;

CREATE TABLE @cdmDatabaseSchema.vocabulary  (
            vocabulary_id varchar2(20) NOT NULL,
			vocabulary_name varchar2(255) NOT NULL,
			vocabulary_reference varchar2(255) NULL,
			vocabulary_version varchar2(255) NULL,
			vocabulary_concept_id number NOT NULL );

insert into @cdmDatabaseSchema.vocabulary 
select vocabulary_id,vocabulary_name,vocabulary_reference,
       vocabulary_version, vocabulary_concept_id
from @cdmDatabaseSchema.vocabulary_v53;

			
-- ATTRIBUTE_DEFINITION
drop table @cdmDatabaseSchema.attribute_definition;

-- COHORT
CREATE TABLE @cdmDatabaseSchema.cohort  (
            cohort_definition_id number NOT NULL,
			subject_id number NOT NULL,
			cohort_start_date date NOT NULL,
			cohort_end_date date NOT NULL );


