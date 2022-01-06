-- http://ohdsi.github.io/CommonDataModel/cdm54Changes.html
-- SQL SERVER SQL References:
--	https://docs.microsoft.com/en-us/sql/relational-databases/tables/rename-columns-database-engine?view=sql-server-ver15
--	https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-rename-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/en-us/sql/relational-databases/tables/add-columns-to-a-table-database-engine?view=sql-server-ver15
--	https://docs.microsoft.com/en-us/sql/relational-databases/tables/modify-columns-database-engine?view=sql-server-ver15
--	https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver15
--
-- VISIT_OCCURRENCE
-- admitting_source_concept_id -> admitted_from_concept_id
-- admitting_source_value -> admitted_from_source_value
-- discharge_to_concept_id -> discharged_to_concept_id
-- discharge_to_source_value -> discharged_to_source_value

EXEC sp_rename '@cdmDatabaseSchema.visit_occurrence.admitting_source_concept_id', 'admitted_from_concept_id', 'COLUMN';
EXEC sp_rename '@cdmDatabaseSchema.visit_occurrence.admitting_source_value', 'admitted_from_source_value', 'COLUMN';
EXEC sp_rename '@cdmDatabaseSchema.visit_occurrence.discharge_to_concept_id', 'discharged_to_concept_id', 'COLUMN';
EXEC sp_rename '@cdmDatabaseSchema.visit_occurrence.discharge_to_source_value', 'discharged_to_source_value', 'COLUMN';

--
-- VISIT_DETAIL
-- admitting_source_concept_id -> admitted_from_concept_id
-- admitting_source_value -> admitted_from_source_value
-- discharge_to_concept_id -> discharged_to_concept_id
-- discharge_to_source_value -> discharged_to_source_value
-- visit_detail_parent_id -> parent_visit_detail_id

EXEC sp_rename '@cdmDatabaseSchema.visit_detail.admitting_source_concept_id', 'admitted_from_concept_id', 'COLUMN';
EXEC sp_rename '@cdmDatabaseSchema.visit_detail.admitting_source_value', 'admitted_from_source_value', 'COLUMN';
EXEC sp_rename '@cdmDatabaseSchema.visit_detail.discharge_to_concept_id', 'discharged_to_concept_id', 'COLUMN';
EXEC sp_rename '@cdmDatabaseSchema.visit_detail.discharge_to_source_value', 'discharged_to_source_value', 'COLUMN';
EXEC sp_rename '@cdmDatabaseSchema.visit_detail.visit_detail_parent_id', 'parent_visit_detail_id', 'COLUMN';

-- PROCEDURE_OCCURRENCE
-- + Procedure_end_date
-- + Procedure_end_datetime

alter table @cdmDatabaseSchema.procedure_occurrence add procedure_end_date date null;
alter table @cdmDatabaseSchema.procedure_occurrence add procedure_end_datetime datetime null;

-- DEVICE_EXPOSURE
-- Unique_device_id -> Changed to varchar(255)
-- + Production_id
-- + Unit_concept_id
-- + Unit_source_value
-- + Unit_source_concept_id

alter table @cdmDatabaseSchema.device_exposure alter column unique_device_id varchar(300);
alter table @cdmDatabaseSchema.device_exposure add production_id int null;
alter table @cdmDatabaseSchema.device_exposure add unit_concept_id int null;
alter table @cdmDatabaseSchema.device_exposure add unit_source_value varchar(50) null;
alter table @cdmDatabaseSchema.device_exposure add unit_source_concept_id int null;

-- MEASUREMENT
-- + Unit_source_concept_id
-- + Measurement_event_id
-- + Meas_event_field_concept_id

alter table @cdmDatabaseSchema.measurement add unit_source_id int null;
alter table @cdmDatabaseSchema.measurement add measurement_event_id bigint null;
alter table @cdmDatabaseSchema.measurement add meas_event_field_concept_id int null;

-- OBSERVATION
-- + Value_source_value
-- + Observation_event_id
-- + Obs_event_field_concept_id

alter table @cdmDatabaseSchema.observation add value_source_value varchar(50) null;
alter table @cdmDatabaseSchema.observation add observation_event_id bigint null;
alter table @cdmDatabaseSchema.observation add obs_event_field_concept_id int null;

-- NOTE
-- + Note_event_id
-- + Note_event_field_concept_id

alter table @cdmDatabaseSchema.note add note_event_id bigint null;
alter table @cdmDatabaseSchema.note add note_event_field_concept_id int null;

-- LOCATION
-- + Country_concept_id
-- + Country_source_value
-- + Latitude
-- + Longitude

alter table @cdmDatabaseSchema.location add country_concept_id int null;
alter table @cdmDatabaseSchema.location add country_source_value varchar(80) null;
alter table @cdmDatabaseSchema.location add latitude numeric null;
alter table @cdmDatabaseSchema.location add longitude numeric null;

-- EPISODE
CREATE TABLE @cdmDatabaseSchema.EPISODE  (
            episode_id bigint NOT NULL,
			person_id bigint NOT NULL,
			episode_concept_id int NOT NULL,
			episode_start_date date NOT NULL,
			episode_start_datetime datetime NULL,
			episode_end_date date NULL,
			episode_end_datetime datetime NULL,
			episode_parent_id bigint NULL,
			episode_number int NULL,
			episode_object_concept_id int NOT NULL,
			episode_type_concept_id int NOT NULL,
			episode_source_value varchar(50) NULL,
			episode_source_concept_id int NULL );

-- EPISODE_EVENT
CREATE TABLE @cdmDatabaseSchema.EPISODE_EVENT  (
            episode_id bigint NOT NULL,
			event_id bigint NOT NULL,
			episode_event_field_concept_id int NOT NULL );
			

-- METADATA
-- + Metadata_id
-- + Value_as_number

alter table @cdmDatabaseSchema.metadata add metadata_id int null;
alter table @cdmDatabaseSchema.metadata add value_as_number numeric null;

-- CDM_SOURCE
-- Cdm_source_name -> Mandatory field
-- Cdm_source_abbreviation -> Mandatory field
-- Cdm_holder -> Mandatory field
-- Source_release_date -> Mandatory field
-- Cdm_release_date -> Mandatory field
-- + Cdm_version_concept_id

EXEC sp_rename '@cdmDatabaseSchema.cdm_source', 'cdm_source_v53';

CREATE TABLE @cdmDatabaseSchema.cdm_source  (
            cdm_source_name varchar(255) NOT NULL,
			cdm_source_abbreviation varchar(25) NOT NULL,
			cdm_holder varchar(255) NOT NULL,
			source_description varchar(MAX) NULL,
			source_documentation_reference varchar(255) NULL,
			cdm_etl_reference varchar(255) NULL,
			source_release_date date NOT NULL,
			cdm_release_date date NOT NULL,
			cdm_version varchar(10) NULL,
			cdm_version_concept_id int NOT NULL,
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
EXEC sp_rename '@cdmDatabaseSchema.vocabulary', 'vocabulary_v53';

CREATE TABLE @cdmDatabaseSchema.vocabulary  (
            vocabulary_id varchar(20) NOT NULL,
			vocabulary_name varchar(255) NOT NULL,
			vocabulary_reference varchar(255) NULL,
			vocabulary_version varchar(255) NULL,
			vocabulary_concept_id int NOT NULL );

insert into @cdmDatabaseSchema.vocabulary 
select vocabulary_id,vocabulary_name,vocabulary_reference,
       vocabulary_version, vocabulary_concept_id
from @cdmDatabaseSchema.vocabulary_v53;

			
-- ATTRIBUTE_DEFINITION
drop table @cdmDatabaseSchema.attribute_definition;

-- COHORT
CREATE TABLE @cdmDatabaseSchema.cohort  (
            cohort_definition_id int NOT NULL,
			subject_id int NOT NULL,
			cohort_start_date date NOT NULL,
			cohort_end_date date NOT NULL );


