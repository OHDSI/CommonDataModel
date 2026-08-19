-- Derived from the OMOP CDM v5.4 and v5.5 Netezza DDLs in this repository.
-- Netezza SQL references:
--   https://www.ibm.com/docs/en/psfa
--
-- MEASUREMENT
-- + value_as_source_concept_id

alter table @cdmDatabaseSchema.measurement add column value_as_source_concept_Id integer null;

-- OBSERVATION
-- + value_as_date
-- + unit_source_concept_id
-- + value_as_source_concept_id

alter table @cdmDatabaseSchema.observation add column value_as_date date null;
alter table @cdmDatabaseSchema.observation add column unit_source_concept_id integer null;
alter table @cdmDatabaseSchema.observation add column value_as_source_concept_Id integer null;

-- SPECIMEN
-- + visit_occurrence_id
-- + visit_detail_id

alter table @cdmDatabaseSchema.specimen add column visit_occurrence_id integer null;
alter table @cdmDatabaseSchema.specimen add column visit_detail_id integer null;

-- CDM_SOURCE
-- + cdm_release_identifier

alter table @cdmDatabaseSchema.cdm_source add column cdm_release_identifier varchar(255) null;

-- PACK_CONTENT
create table @cdmDatabaseSchema.pack_content (
            pack_concept_id integer NOT NULL,
            drug_concept_id integer NOT NULL,
            amount integer NULL,
            box_size integer NULL );

-- CONCEPT_METADATA
create table @cdmDatabaseSchema.concept_metadata (
            concept_id integer NULL,
            concept_category varchar(20) NULL,
            reuse_status varchar(20) NULL );

-- CONCEPT_RELATIONSHIP_METADATA
create table @cdmDatabaseSchema.concept_relationship_metadata (
            concept_id_1 integer NOT NULL,
            concept_id_2 integer NOT NULL,
            relationship_id varchar(20) NOT NULL,
            relationship_predicate_id varchar(20) NULL,
            relationship_group integer NULL,
            mapping_source varchar(50) NULL,
            confidence float NULL,
            mapping_tool varchar(50) NULL,
            mapper varchar(50) NULL,
            reviewer varchar(50) NULL );
