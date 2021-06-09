/*oracle OMOP CDM Indices*/


/************************

Standardized clinical data

************************/

CREATE INDEX idx_person_id ON OHDSI.person (person_id ASC);
CREATE INDEX idx_gender ON OHDSI.person (gender_concept_id ASC);

CREATE INDEX idx_observation_period_id_1 ON OHDSI.observation_period (person_id ASC);

CREATE INDEX idx_visit_person_id_1 ON OHDSI.visit_occurrence (person_id ASC);
CREATE INDEX idx_visit_concept_id_1 ON OHDSI.visit_occurrence (visit_concept_id ASC);

CREATE INDEX idx_visit_det_person_id_1 ON OHDSI.visit_detail (person_id ASC);
CREATE INDEX idx_visit_det_concept_id_1 ON OHDSI.visit_detail (visit_detail_concept_id ASC);
CREATE INDEX idx_visit_det_occ_id ON OHDSI.visit_detail (visit_occurrence_id ASC);

CREATE INDEX idx_condition_person_id_1 ON OHDSI.condition_occurrence (person_id ASC);
CREATE INDEX idx_condition_concept_id_1 ON OHDSI.condition_occurrence (condition_concept_id ASC);
CREATE INDEX idx_condition_visit_id_1 ON OHDSI.condition_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_drug_person_id_1 ON OHDSI.drug_exposure (person_id ASC);
CREATE INDEX idx_drug_concept_id_1 ON OHDSI.drug_exposure (drug_concept_id ASC);
CREATE INDEX idx_drug_visit_id_1 ON OHDSI.drug_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_procedure_person_id_1 ON OHDSI.procedure_occurrence (person_id ASC);
CREATE INDEX idx_procedure_concept_id_1 ON OHDSI.procedure_occurrence (procedure_concept_id ASC);
CREATE INDEX idx_procedure_visit_id_1 ON OHDSI.procedure_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_device_person_id_1 ON OHDSI.device_exposure (person_id ASC);
CREATE INDEX idx_device_concept_id_1 ON OHDSI.device_exposure (device_concept_id ASC);
CREATE INDEX idx_device_visit_id_1 ON OHDSI.device_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_measurement_person_id_1 ON OHDSI.measurement (person_id ASC);
CREATE INDEX idx_measurement_concept_id_1 ON OHDSI.measurement (measurement_concept_id ASC);
CREATE INDEX idx_measurement_visit_id_1 ON OHDSI.measurement (visit_occurrence_id ASC);

CREATE INDEX idx_observation_person_id_1 ON OHDSI.observation (person_id ASC);
CREATE INDEX idx_observation_concept_id_1 ON OHDSI.observation (observation_concept_id ASC);
CREATE INDEX idx_observation_visit_id_1 ON OHDSI.observation (visit_occurrence_id ASC);

CREATE INDEX idx_death_person_id_1 ON OHDSI.death (person_id ASC);

CREATE INDEX idx_note_person_id_1 ON OHDSI.note (person_id ASC);
CREATE INDEX idx_note_concept_id_1 ON OHDSI.note (note_type_concept_id ASC);
CREATE INDEX idx_note_visit_id_1 ON OHDSI.note (visit_occurrence_id ASC);

CREATE INDEX idx_note_nlp_note_id_1 ON OHDSI.note_nlp (note_id ASC);
CREATE INDEX idx_note_nlp_concept_id_1 ON OHDSI.note_nlp (note_nlp_concept_id ASC);

CREATE INDEX idx_specimen_person_id_1 ON OHDSI.specimen (person_id ASC);
CREATE INDEX idx_specimen_concept_id_1 ON OHDSI.specimen (specimen_concept_id ASC);

CREATE INDEX idx_fact_relationship_id1 ON OHDSI.fact_relationship (domain_concept_id_1 ASC);
CREATE INDEX idx_fact_relationship_id2 ON OHDSI.fact_relationship (domain_concept_id_2 ASC);
CREATE INDEX idx_fact_relationship_id3 ON OHDSI.fact_relationship (relationship_concept_id ASC);

/************************

Standardized health system data

************************/

CREATE INDEX idx_location_id_1 ON OHDSI.location (location_id ASC);

CREATE INDEX idx_care_site_id_1 ON OHDSI.care_site (care_site_id ASC);

CREATE INDEX idx_provider_id_1 ON OHDSI.provider (provider_id ASC);

/************************

Standardized health economics

************************/

CREATE INDEX idx_period_person_id_1 ON OHDSI.payer_plan_period (person_id ASC);

CREATE INDEX idx_cost_event_id  ON OHDSI.cost (cost_event_id ASC);

/************************

Standardized derived elements

************************/

CREATE INDEX idx_drug_era_person_id_1 ON OHDSI.drug_era (person_id ASC);
CREATE INDEX idx_drug_era_concept_id_1 ON OHDSI.drug_era (drug_concept_id ASC);

CREATE INDEX idx_dose_era_person_id_1 ON OHDSI.dose_era (person_id ASC);
CREATE INDEX idx_dose_era_concept_id_1 ON OHDSI.dose_era (drug_concept_id ASC);

CREATE INDEX idx_condition_era_person_id_1 ON OHDSI.condition_era (person_id ASC);
CREATE INDEX idx_condition_era_concept_id_1 ON OHDSI.condition_era (condition_concept_id ASC);

/**************************

Standardized meta-data

***************************/

CREATE INDEX idx_metadata_concept_id_1 ON OHDSI.metadata (metadata_concept_id ASC);

/**************************

Standardized vocabularies

***************************/

CREATE INDEX idx_concept_concept_id ON OHDSI.concept (concept_id ASC);
CREATE INDEX idx_concept_code ON OHDSI.concept (concept_code ASC);
CREATE INDEX idx_concept_vocabluary_id ON OHDSI.concept (vocabulary_id ASC);
CREATE INDEX idx_concept_domain_id ON OHDSI.concept (domain_id ASC);
CREATE INDEX idx_concept_class_id ON OHDSI.concept (concept_class_id ASC);

CREATE INDEX idx_vocabulary_vocabulary_id ON OHDSI.vocabulary (vocabulary_id ASC);

CREATE INDEX idx_domain_domain_id ON OHDSI.domain (domain_id ASC);

CREATE INDEX idx_concept_class_class_id ON OHDSI.concept_class (concept_class_id ASC);

CREATE INDEX idx_concept_relationship_id_1 ON OHDSI.concept_relationship (concept_id_1 ASC);
CREATE INDEX idx_concept_relationship_id_2 ON OHDSI.concept_relationship (concept_id_2 ASC);
CREATE INDEX idx_concept_relationship_id_3 ON OHDSI.concept_relationship (relationship_id ASC);

CREATE INDEX idx_relationship_rel_id ON OHDSI.relationship (relationship_id ASC);

CREATE INDEX idx_concept_synonym_id ON OHDSI.concept_synonym (concept_id ASC);

CREATE INDEX idx_concept_ancestor_id_1 ON OHDSI.concept_ancestor (ancestor_concept_id ASC);
CREATE INDEX idx_concept_ancestor_id_2 ON OHDSI.concept_ancestor (descendant_concept_id ASC);

CREATE INDEX idx_source_to_concept_map_3 ON OHDSI.source_to_concept_map (target_concept_id ASC);
CREATE INDEX idx_source_to_concept_map_1 ON OHDSI.source_to_concept_map (source_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_2 ON OHDSI.source_to_concept_map (target_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_c ON OHDSI.source_to_concept_map (source_code ASC);

CREATE INDEX idx_drug_strength_id_1 ON OHDSI.drug_strength (drug_concept_id ASC);
CREATE INDEX idx_drug_strength_id_2 ON OHDSI.drug_strength (ingredient_concept_id ASC);


--Additional v6.0 indices

CREATE INDEX idx_survey_person_id_1 ON OHDSI.survey_conduct (person_id ASC);

CREATE INDEX idx_episode_person_id_1 ON OHDSI.episode (person_id ASC);
CREATE INDEX idx_episode_concept_id_1 ON OHDSI.episode (episode_concept_id ASC);

CREATE INDEX idx_episode_event_id_1 ON OHDSI.episode_event (episode_id ASC);
CREATE INDEX idx_ee_field_concept_id_1 ON OHDSI.episode_event (event_field_concept_id ASC);
