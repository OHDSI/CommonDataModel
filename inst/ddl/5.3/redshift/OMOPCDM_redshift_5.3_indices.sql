/*redshift OMOP CDM Indices
  There are no unique indices created because it is assumed that the primary key constraints have been run prior to
  implementing indices.
*/
/************************
Standardized clinical data
************************/
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
/************************
Standardized health system data
************************/
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
/************************
Standardized health economics
************************/
-- redshift does not support indexes
-- redshift does not support indexes
/************************
Standardized derived elements
************************/
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
/**************************
Standardized meta-data
***************************/
-- redshift does not support indexes
/**************************
Standardized vocabularies
***************************/
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
-- redshift does not support indexes
--Additional v6.0 indices
--CREATE CLUSTERED INDEX idx_survey_person_id_1 ON @cdmDatabaseSchema.survey_conduct (person_id ASC);
--CREATE CLUSTERED INDEX idx_episode_person_id_1 ON @cdmDatabaseSchema.episode (person_id ASC);
--CREATE INDEX idx_episode_concept_id_1 ON @cdmDatabaseSchema.episode (episode_concept_id ASC);
--CREATE CLUSTERED INDEX idx_episode_event_id_1 ON @cdmDatabaseSchema.episode_event (episode_id ASC);
--CREATE INDEX idx_ee_field_concept_id_1 ON @cdmDatabaseSchema.episode_event (event_field_concept_id ASC);
