/*bigquery OMOP CDM Indices
  There are no unique indices created because it is assumed that the primary key constraints have been run prior to
  implementing indices.
*/
/************************
Standardized clinical data
************************/
create clustered index idx_person_id on @cdmDatabaseSchema.person (person_id asc);
-- bigquery does not support indexes
create clustered index idx_observation_period_id_1 on @cdmDatabaseSchema.observation_period (person_id asc);
create clustered index idx_visit_person_id_1 on @cdmDatabaseSchema.visit_occurrence (person_id asc);
-- bigquery does not support indexes
create clustered index idx_visit_det_person_id_1 on @cdmDatabaseSchema.visit_detail (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_condition_person_id_1 on @cdmDatabaseSchema.condition_occurrence (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_drug_person_id_1 on @cdmDatabaseSchema.drug_exposure (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_procedure_person_id_1 on @cdmDatabaseSchema.procedure_occurrence (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_device_person_id_1 on @cdmDatabaseSchema.device_exposure (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_measurement_person_id_1 on @cdmDatabaseSchema.measurement (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_observation_person_id_1 on @cdmDatabaseSchema.observation (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_death_person_id_1 on @cdmDatabaseSchema.death (person_id asc);
create clustered index idx_note_person_id_1 on @cdmDatabaseSchema.note (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_note_nlp_note_id_1 on @cdmDatabaseSchema.note_nlp (note_id asc);
-- bigquery does not support indexes
create clustered index idx_specimen_person_id_1 on @cdmDatabaseSchema.specimen (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
-- bigquery does not support indexes
-- bigquery does not support indexes
/************************
Standardized health system data
************************/
create clustered index idx_location_id_1 on @cdmDatabaseSchema.location (location_id asc);
create clustered index idx_care_site_id_1 on @cdmDatabaseSchema.care_site (care_site_id asc);
create clustered index idx_provider_id_1 on @cdmDatabaseSchema.provider (provider_id asc);
/************************
Standardized health economics
************************/
create clustered index idx_period_person_id_1 on @cdmDatabaseSchema.payer_plan_period (person_id asc);
-- bigquery does not support indexes
/************************
Standardized derived elements
************************/
create clustered index idx_drug_era_person_id_1 on @cdmDatabaseSchema.drug_era (person_id asc);
-- bigquery does not support indexes
create clustered index idx_dose_era_person_id_1 on @cdmDatabaseSchema.dose_era (person_id asc);
-- bigquery does not support indexes
create clustered index idx_condition_era_person_id_1 on @cdmDatabaseSchema.condition_era (person_id asc);
-- bigquery does not support indexes
/**************************
Standardized meta-data
***************************/
create clustered index idx_metadata_concept_id_1 on @cdmDatabaseSchema.metadata (metadata_concept_id asc);
/**************************
Standardized vocabularies
***************************/
create clustered index idx_concept_concept_id on @cdmDatabaseSchema.concept (concept_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_vocabulary_vocabulary_id on @cdmDatabaseSchema.vocabulary (vocabulary_id asc);
create clustered index idx_domain_domain_id on @cdmDatabaseSchema.domain (domain_id asc);
create clustered index idx_concept_class_class_id on @cdmDatabaseSchema.concept_class (concept_class_id asc);
create clustered index idx_concept_relationship_id_1 on @cdmDatabaseSchema.concept_relationship (concept_id_1 asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_relationship_rel_id on @cdmDatabaseSchema.relationship (relationship_id asc);
create clustered index idx_concept_synonym_id on @cdmDatabaseSchema.concept_synonym (concept_id asc);
create clustered index idx_concept_ancestor_id_1 on @cdmDatabaseSchema.concept_ancestor (ancestor_concept_id asc);
-- bigquery does not support indexes
create clustered index idx_source_to_concept_map_3 on @cdmDatabaseSchema.source_to_concept_map (target_concept_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_drug_strength_id_1 on @cdmDatabaseSchema.drug_strength (drug_concept_id asc);
-- bigquery does not support indexes
--Additional v6.0 indices
--CREATE CLUSTERED INDEX idx_survey_person_id_1 ON @cdmDatabaseSchema.survey_conduct (person_id ASC);
--CREATE CLUSTERED INDEX idx_episode_person_id_1 ON @cdmDatabaseSchema.episode (person_id ASC);
--CREATE INDEX idx_episode_concept_id_1 ON @cdmDatabaseSchema.episode (episode_concept_id ASC);
--CREATE CLUSTERED INDEX idx_episode_event_id_1 ON @cdmDatabaseSchema.episode_event (episode_id ASC);
--CREATE INDEX idx_ee_field_concept_id_1 ON @cdmDatabaseSchema.episode_event (event_field_concept_id ASC);
