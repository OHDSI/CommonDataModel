-- Derived from the OMOP CDM v5.4 and v5.5 SQL Server DDLs in this repository.
-- SQL Server SQL references:
--   https://learn.microsoft.com/sql/t-sql/statements/alter-table-transact-sql
--
-- MEASUREMENT
-- + value_as_source_concept_id

alter table @cdmDatabaseSchema.measurement add value_as_source_concept_Id int null;

-- OBSERVATION
-- + value_as_date
-- + unit_source_concept_id
-- + value_as_source_concept_id

alter table @cdmDatabaseSchema.observation add value_as_date date null;
alter table @cdmDatabaseSchema.observation add unit_source_concept_id int null;
alter table @cdmDatabaseSchema.observation add value_as_source_concept_Id int null;

-- SPECIMEN
-- + visit_occurrence_id
-- + visit_detail_id

alter table @cdmDatabaseSchema.specimen add visit_occurrence_id int null;
alter table @cdmDatabaseSchema.specimen add visit_detail_id int null;

-- CDM_SOURCE
-- + cdm_release_identifier

alter table @cdmDatabaseSchema.cdm_source add cdm_release_identifier varchar(255) null;

-- PACK_CONTENT
create table @cdmDatabaseSchema.pack_content (
            pack_concept_id int NOT NULL,
            drug_concept_id int NOT NULL,
            amount int NULL,
            box_size int NULL );

-- CONCEPT_METADATA
create table @cdmDatabaseSchema.concept_metadata (
            concept_id int NULL,
            concept_category varchar(20) NULL,
            reuse_status varchar(20) NULL );

-- CONCEPT_RELATIONSHIP_METADATA
create table @cdmDatabaseSchema.concept_relationship_metadata (
            concept_id_1 int NOT NULL,
            concept_id_2 int NOT NULL,
            relationship_id varchar(20) NOT NULL,
            relationship_predicate_id varchar(20) NULL,
            relationship_group int NULL,
            mapping_source varchar(50) NULL,
            confidence float NULL,
            mapping_tool varchar(50) NULL,
            mapper varchar(50) NULL,
            reviewer varchar(50) NULL );
