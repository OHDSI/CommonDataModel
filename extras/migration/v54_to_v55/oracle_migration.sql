-- Derived from the OMOP CDM v5.4 and v5.5 Oracle DDLs in this repository.
-- Oracle SQL references:
--   https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/ALTER-TABLE.html
--
-- MEASUREMENT
-- + value_as_source_concept_id

alter table @cdmDatabaseSchema.measurement add (value_as_source_concept_id number default null);

-- OBSERVATION
-- + value_as_date
-- + unit_source_concept_id
-- + value_as_source_concept_id

alter table @cdmDatabaseSchema.observation add (value_as_date date default null);
alter table @cdmDatabaseSchema.observation add (unit_source_concept_id number default null);
alter table @cdmDatabaseSchema.observation add (value_as_source_concept_id number default null);

-- SPECIMEN
-- + visit_occurrence_id
-- + visit_detail_id

alter table @cdmDatabaseSchema.specimen add (visit_occurrence_id number default null);
alter table @cdmDatabaseSchema.specimen add (visit_detail_id number default null);

-- CDM_SOURCE
-- + cdm_release_identifier

alter table @cdmDatabaseSchema.cdm_source add (cdm_release_identifier varchar2(255) default null);

-- PACK_CONTENT
create table @cdmDatabaseSchema.pack_content (
    pack_concept_id number NOT NULL,
    drug_concept_id number NOT NULL,
    amount number NULL,
    box_size number NULL
);

-- CONCEPT_METADATA
create table @cdmDatabaseSchema.concept_metadata (
    concept_id number NULL,
    concept_category varchar2(20) NULL,
    reuse_status varchar2(20) NULL
);

-- CONCEPT_RELATIONSHIP_METADATA
create table @cdmDatabaseSchema.concept_relationship_metadata (
    concept_id_1 number NOT NULL,
    concept_id_2 number NOT NULL,
    relationship_id varchar2(20) NOT NULL,
    relationship_predicate_id varchar2(20) NULL,
    relationship_group number NULL,
    mapping_source varchar2(50) NULL,
    confidence float NULL,
    mapping_tool varchar2(50) NULL,
    mapper varchar2(50) NULL,
    reviewer varchar2(50) NULL
);
