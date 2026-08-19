-- Derived from the OMOP CDM v5.4 and v5.5 Impala DDLs in this repository.
-- Impala SQL references:
--   https://docs.cloudera.com/documentation/enterprise/latest/topics/impala_alter_table.html
--
-- MEASUREMENT
-- + value_as_source_concept_id

alter table @cdmDatabaseSchema.measurement add columns (value_as_source_concept_id int);

-- OBSERVATION
-- + value_as_date
-- + unit_source_concept_id
-- + value_as_source_concept_id

alter table @cdmDatabaseSchema.observation add columns (value_as_date timestamp);
alter table @cdmDatabaseSchema.observation add columns (unit_source_concept_id int);
alter table @cdmDatabaseSchema.observation add columns (value_as_source_concept_id int);

-- SPECIMEN
-- + visit_occurrence_id
-- + visit_detail_id

alter table @cdmDatabaseSchema.specimen add columns (visit_occurrence_id int);
alter table @cdmDatabaseSchema.specimen add columns (visit_detail_id int);

-- CDM_SOURCE
-- + cdm_release_identifier

alter table @cdmDatabaseSchema.cdm_source add columns (cdm_release_identifier varchar(255));

-- PACK_CONTENT
create table @cdmDatabaseSchema.pack_content (
    pack_concept_id int,
    drug_concept_id int,
    amount int,
    box_size int
);

-- CONCEPT_METADATA
create table @cdmDatabaseSchema.concept_metadata (
    concept_id int,
    concept_category varchar(20),
    reuse_status varchar(20)
);

-- CONCEPT_RELATIONSHIP_METADATA
create table @cdmDatabaseSchema.concept_relationship_metadata (
    concept_id_1 int,
    concept_id_2 int,
    relationship_id varchar(20),
    relationship_predicate_id varchar(20),
    relationship_group int,
    mapping_source varchar(50),
    confidence float,
    mapping_tool varchar(50),
    mapper varchar(50),
    reviewer varchar(50)
);
