/*sql server OMOP CDM Indices*/


/************************

Standardized clinical data

************************/

CREATE CLUSTERED INDEX idx_person_id ON ohdsi.dbo.person (person_id ASC);
CREATE INDEX idx_gender ON ohdsi.dbo.person (gender_concept_id ASC);

CREATE CLUSTERED INDEX idx_observation_period_id_1 ON ohdsi.dbo.observation_period (person_id ASC);

CREATE CLUSTERED INDEX idx_visit_person_id_1 ON ohdsi.dbo.visit_occurrence (person_id ASC);
CREATE INDEX idx_visit_concept_id_1 ON ohdsi.dbo.visit_occurrence (visit_concept_id ASC);

CREATE CLUSTERED INDEX idx_visit_det_person_id_1 ON ohdsi.dbo.visit_detail (person_id ASC);
CREATE INDEX idx_visit_det_concept_id_1 ON ohdsi.dbo.visit_detail (visit_detail_concept_id ASC);
CREATE INDEX idx_visit_det_occ_id ON ohdsi.dbo.visit_detail (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_condition_person_id_1 ON ohdsi.dbo.condition_occurrence (person_id ASC);
CREATE INDEX idx_condition_concept_id_1 ON ohdsi.dbo.condition_occurrence (condition_concept_id ASC);
CREATE INDEX idx_condition_visit_id_1 ON ohdsi.dbo.condition_occurrence (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_drug_person_id_1 ON ohdsi.dbo.drug_exposure (person_id ASC);
CREATE INDEX idx_drug_concept_id_1 ON ohdsi.dbo.drug_exposure (drug_concept_id ASC);
CREATE INDEX idx_drug_visit_id_1 ON ohdsi.dbo.drug_exposure (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_procedure_person_id_1 ON ohdsi.dbo.procedure_occurrence (person_id ASC);
CREATE INDEX idx_procedure_concept_id_1 ON ohdsi.dbo.procedure_occurrence (procedure_concept_id ASC);
CREATE INDEX idx_procedure_visit_id_1 ON ohdsi.dbo.procedure_occurrence (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_device_person_id_1 ON ohdsi.dbo.device_exposure (person_id ASC);
CREATE INDEX idx_device_concept_id_1 ON ohdsi.dbo.device_exposure (device_concept_id ASC);
CREATE INDEX idx_device_visit_id_1 ON ohdsi.dbo.device_exposure (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_measurement_person_id_1 ON ohdsi.dbo.measurement (person_id ASC);
CREATE INDEX idx_measurement_concept_id_1 ON ohdsi.dbo.measurement (measurement_concept_id ASC);
CREATE INDEX idx_measurement_visit_id_1 ON ohdsi.dbo.measurement (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_observation_person_id_1 ON ohdsi.dbo.observation (person_id ASC);
CREATE INDEX idx_observation_concept_id_1 ON ohdsi.dbo.observation (observation_concept_id ASC);
CREATE INDEX idx_observation_visit_id_1 ON ohdsi.dbo.observation (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_death_person_id_1 ON ohdsi.dbo.death (person_id ASC);

CREATE CLUSTERED INDEX idx_note_person_id_1 ON ohdsi.dbo.note (person_id ASC);
CREATE INDEX idx_note_concept_id_1 ON ohdsi.dbo.note (note_type_concept_id ASC);
CREATE INDEX idx_note_visit_id_1 ON ohdsi.dbo.note (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_note_nlp_note_id_1 ON ohdsi.dbo.note_nlp (note_id ASC);
CREATE INDEX idx_note_nlp_concept_id_1 ON ohdsi.dbo.note_nlp (note_nlp_concept_id ASC);

CREATE CLUSTERED INDEX idx_specimen_person_id_1 ON ohdsi.dbo.specimen (person_id ASC);
CREATE INDEX idx_specimen_concept_id_1 ON ohdsi.dbo.specimen (specimen_concept_id ASC);

CREATE INDEX idx_fact_relationship_id1 ON ohdsi.dbo.fact_relationship (domain_concept_id_1 ASC);
CREATE INDEX idx_fact_relationship_id2 ON ohdsi.dbo.fact_relationship (domain_concept_id_2 ASC);
CREATE INDEX idx_fact_relationship_id3 ON ohdsi.dbo.fact_relationship (relationship_concept_id ASC);

/************************

Standardized health system data

************************/

CREATE CLUSTERED INDEX idx_location_id_1 ON ohdsi.dbo.location (location_id ASC);

CREATE CLUSTERED INDEX idx_care_site_id_1 ON ohdsi.dbo.care_site (care_site_id ASC);

CREATE CLUSTERED INDEX idx_provider_id_1 ON ohdsi.dbo.provider (provider_id ASC);

/************************

Standardized health economics

************************/

CREATE CLUSTERED INDEX idx_period_person_id_1 ON ohdsi.dbo.payer_plan_period (person_id ASC);

CREATE INDEX idx_cost_event_id  ON ohdsi.dbo.cost (cost_event_id ASC);

/************************

Standardized derived elements

************************/

CREATE CLUSTERED INDEX idx_drug_era_person_id_1 ON ohdsi.dbo.drug_era (person_id ASC);
CREATE INDEX idx_drug_era_concept_id_1 ON ohdsi.dbo.drug_era (drug_concept_id ASC);

CREATE CLUSTERED INDEX idx_dose_era_person_id_1 ON ohdsi.dbo.dose_era (person_id ASC);
CREATE INDEX idx_dose_era_concept_id_1 ON ohdsi.dbo.dose_era (drug_concept_id ASC);

CREATE CLUSTERED INDEX idx_condition_era_person_id_1 ON ohdsi.dbo.condition_era (person_id ASC);
CREATE INDEX idx_condition_era_concept_id_1 ON ohdsi.dbo.condition_era (condition_concept_id ASC);

/**************************

Standardized meta-data

***************************/

CREATE CLUSTERED INDEX idx_metadata_concept_id_1 ON ohdsi.dbo.metadata (metadata_concept_id ASC);

/**************************

Standardized vocabularies

***************************/

CREATE CLUSTERED INDEX idx_concept_concept_id ON ohdsi.dbo.concept (concept_id ASC);
CREATE INDEX idx_concept_code ON ohdsi.dbo.concept (concept_code ASC);
CREATE INDEX idx_concept_vocabluary_id ON ohdsi.dbo.concept (vocabulary_id ASC);
CREATE INDEX idx_concept_domain_id ON ohdsi.dbo.concept (domain_id ASC);
CREATE INDEX idx_concept_class_id ON ohdsi.dbo.concept (concept_class_id ASC);

CREATE CLUSTERED INDEX idx_vocabulary_vocabulary_id ON ohdsi.dbo.vocabulary (vocabulary_id ASC);

CREATE CLUSTERED INDEX idx_domain_domain_id ON ohdsi.dbo.domain (domain_id ASC);

CREATE CLUSTERED INDEX idx_concept_class_class_id ON ohdsi.dbo.concept_class (concept_class_id ASC);

CREATE CLUSTERED INDEX idx_concept_relationship_id_1 ON ohdsi.dbo.concept_relationship (concept_id_1 ASC);
CREATE INDEX idx_concept_relationship_id_2 ON ohdsi.dbo.concept_relationship (concept_id_2 ASC);
CREATE INDEX idx_concept_relationship_id_3 ON ohdsi.dbo.concept_relationship (relationship_id ASC);

CREATE CLUSTERED INDEX idx_relationship_rel_id ON ohdsi.dbo.relationship (relationship_id ASC);

CREATE CLUSTERED INDEX idx_concept_synonym_id ON ohdsi.dbo.concept_synonym (concept_id ASC);

CREATE CLUSTERED INDEX idx_concept_ancestor_id_1 ON ohdsi.dbo.concept_ancestor (ancestor_concept_id ASC);
CREATE INDEX idx_concept_ancestor_id_2 ON ohdsi.dbo.concept_ancestor (descendant_concept_id ASC);

CREATE CLUSTERED INDEX idx_source_to_concept_map_3 ON ohdsi.dbo.source_to_concept_map (target_concept_id ASC);
CREATE INDEX idx_source_to_concept_map_1 ON ohdsi.dbo.source_to_concept_map (source_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_2 ON ohdsi.dbo.source_to_concept_map (target_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_c ON ohdsi.dbo.source_to_concept_map (source_code ASC);

CREATE CLUSTERED INDEX idx_drug_strength_id_1 ON ohdsi.dbo.drug_strength (drug_concept_id ASC);
CREATE INDEX idx_drug_strength_id_2 ON ohdsi.dbo.drug_strength (ingredient_concept_id ASC);


--Additional v6.0 indices

CREATE CLUSTERED INDEX idx_survey_person_id_1 ON ohdsi.dbo.survey_conduct (person_id ASC);

CREATE CLUSTERED INDEX idx_episode_person_id_1 ON ohdsi.dbo.episode (person_id ASC);
CREATE INDEX idx_episode_concept_id_1 ON ohdsi.dbo.episode (episode_concept_id ASC);

CREATE CLUSTERED INDEX idx_episode_event_id_1 ON ohdsi.dbo.episode_event (episode_id ASC);
CREATE INDEX idx_ee_field_concept_id_1 ON ohdsi.dbo.episode_event (event_field_concept_id ASC);
