-- Derived from the OMOP CDM v5.4 and v5.5 BigQuery DDLs in this repository.
-- BigQuery SQL references:
--   https://cloud.google.com/bigquery/docs/reference/standard-sql/data-definition-language
--
-- MEASUREMENT
-- + value_as_source_concept_id

alter table @cdmDatabaseSchema.measurement add column value_as_source_concept_id int64;

-- OBSERVATION
-- + value_as_date
-- + unit_source_concept_id
-- + value_as_source_concept_id

alter table @cdmDatabaseSchema.observation add column value_as_date date;
alter table @cdmDatabaseSchema.observation add column unit_source_concept_id int64;
alter table @cdmDatabaseSchema.observation add column value_as_source_concept_id int64;

-- SPECIMEN
-- + visit_occurrence_id
-- + visit_detail_id

alter table @cdmDatabaseSchema.specimen add column visit_occurrence_id int64;
alter table @cdmDatabaseSchema.specimen add column visit_detail_id int64;

-- CDM_SOURCE
-- + cdm_release_identifier

alter table @cdmDatabaseSchema.cdm_source add column cdm_release_identifier string;

-- PACK_CONTENT
create table @cdmDatabaseSchema.pack_content (
            pack_concept_id INT64 not null,
            drug_concept_id INT64 not null,
            amount INT64,
            box_size INT64 );

-- CONCEPT_METADATA
create table @cdmDatabaseSchema.concept_metadata (
            concept_id INT64,
            concept_category STRING,
            reuse_status STRING );

-- CONCEPT_RELATIONSHIP_METADATA
create table @cdmDatabaseSchema.concept_relationship_metadata (
            concept_id_1 INT64 not null,
            concept_id_2 INT64 not null,
            relationship_id STRING not null,
            relationship_predicate_id STRING,
            relationship_group INT64,
            mapping_source STRING,
            confidence FLOAT64,
            mapping_tool STRING,
            mapper STRING,
            reviewer STRING );
