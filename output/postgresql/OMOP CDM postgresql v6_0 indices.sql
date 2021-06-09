/*postgresql OMOP CDM Indices*/


/************************

Standardized clinical data

************************/

CREATE INDEX idx_person_id  ON ohdsi.person  (person_id ASC);
CLUSTER ohdsi.person  USING idx_person_id ;
CREATE INDEX idx_gender ON ohdsi.person (gender_concept_id ASC);

CREATE INDEX idx_observation_period_id_1  ON ohdsi.observation_period  (person_id ASC);
CLUSTER ohdsi.observation_period  USING idx_observation_period_id_1 ;

CREATE INDEX idx_visit_person_id_1  ON ohdsi.visit_occurrence  (person_id ASC);
CLUSTER ohdsi.visit_occurrence  USING idx_visit_person_id_1 ;
CREATE INDEX idx_visit_concept_id_1 ON ohdsi.visit_occurrence (visit_concept_id ASC);

CREATE INDEX idx_visit_det_person_id_1  ON ohdsi.visit_detail  (person_id ASC);
CLUSTER ohdsi.visit_detail  USING idx_visit_det_person_id_1 ;
CREATE INDEX idx_visit_det_concept_id_1 ON ohdsi.visit_detail (visit_detail_concept_id ASC);
CREATE INDEX idx_visit_det_occ_id ON ohdsi.visit_detail (visit_occurrence_id ASC);

CREATE INDEX idx_condition_person_id_1  ON ohdsi.condition_occurrence  (person_id ASC);
CLUSTER ohdsi.condition_occurrence  USING idx_condition_person_id_1 ;
CREATE INDEX idx_condition_concept_id_1 ON ohdsi.condition_occurrence (condition_concept_id ASC);
CREATE INDEX idx_condition_visit_id_1 ON ohdsi.condition_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_drug_person_id_1  ON ohdsi.drug_exposure  (person_id ASC);
CLUSTER ohdsi.drug_exposure  USING idx_drug_person_id_1 ;
CREATE INDEX idx_drug_concept_id_1 ON ohdsi.drug_exposure (drug_concept_id ASC);
CREATE INDEX idx_drug_visit_id_1 ON ohdsi.drug_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_procedure_person_id_1  ON ohdsi.procedure_occurrence  (person_id ASC);
CLUSTER ohdsi.procedure_occurrence  USING idx_procedure_person_id_1 ;
CREATE INDEX idx_procedure_concept_id_1 ON ohdsi.procedure_occurrence (procedure_concept_id ASC);
CREATE INDEX idx_procedure_visit_id_1 ON ohdsi.procedure_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_device_person_id_1  ON ohdsi.device_exposure  (person_id ASC);
CLUSTER ohdsi.device_exposure  USING idx_device_person_id_1 ;
CREATE INDEX idx_device_concept_id_1 ON ohdsi.device_exposure (device_concept_id ASC);
CREATE INDEX idx_device_visit_id_1 ON ohdsi.device_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_measurement_person_id_1  ON ohdsi.measurement  (person_id ASC);
CLUSTER ohdsi.measurement  USING idx_measurement_person_id_1 ;
CREATE INDEX idx_measurement_concept_id_1 ON ohdsi.measurement (measurement_concept_id ASC);
CREATE INDEX idx_measurement_visit_id_1 ON ohdsi.measurement (visit_occurrence_id ASC);

CREATE INDEX idx_observation_person_id_1  ON ohdsi.observation  (person_id ASC);
CLUSTER ohdsi.observation  USING idx_observation_person_id_1 ;
CREATE INDEX idx_observation_concept_id_1 ON ohdsi.observation (observation_concept_id ASC);
CREATE INDEX idx_observation_visit_id_1 ON ohdsi.observation (visit_occurrence_id ASC);

CREATE INDEX idx_death_person_id_1  ON ohdsi.death  (person_id ASC);
CLUSTER ohdsi.death  USING idx_death_person_id_1 ;

CREATE INDEX idx_note_person_id_1  ON ohdsi.note  (person_id ASC);
CLUSTER ohdsi.note  USING idx_note_person_id_1 ;
CREATE INDEX idx_note_concept_id_1 ON ohdsi.note (note_type_concept_id ASC);
CREATE INDEX idx_note_visit_id_1 ON ohdsi.note (visit_occurrence_id ASC);

CREATE INDEX idx_note_nlp_note_id_1  ON ohdsi.note_nlp  (note_id ASC);
CLUSTER ohdsi.note_nlp  USING idx_note_nlp_note_id_1 ;
CREATE INDEX idx_note_nlp_concept_id_1 ON ohdsi.note_nlp (note_nlp_concept_id ASC);

CREATE INDEX idx_specimen_person_id_1  ON ohdsi.specimen  (person_id ASC);
CLUSTER ohdsi.specimen  USING idx_specimen_person_id_1 ;
CREATE INDEX idx_specimen_concept_id_1 ON ohdsi.specimen (specimen_concept_id ASC);

CREATE INDEX idx_fact_relationship_id1 ON ohdsi.fact_relationship (domain_concept_id_1 ASC);
CREATE INDEX idx_fact_relationship_id2 ON ohdsi.fact_relationship (domain_concept_id_2 ASC);
CREATE INDEX idx_fact_relationship_id3 ON ohdsi.fact_relationship (relationship_concept_id ASC);

/************************

Standardized health system data

************************/

CREATE INDEX idx_location_id_1  ON ohdsi.location  (location_id ASC);
CLUSTER ohdsi.location  USING idx_location_id_1 ;

CREATE INDEX idx_care_site_id_1  ON ohdsi.care_site  (care_site_id ASC);
CLUSTER ohdsi.care_site  USING idx_care_site_id_1 ;

CREATE INDEX idx_provider_id_1  ON ohdsi.provider  (provider_id ASC);
CLUSTER ohdsi.provider  USING idx_provider_id_1 ;

/************************

Standardized health economics

************************/

CREATE INDEX idx_period_person_id_1  ON ohdsi.payer_plan_period  (person_id ASC);
CLUSTER ohdsi.payer_plan_period  USING idx_period_person_id_1 ;

CREATE INDEX idx_cost_event_id  ON ohdsi.cost (cost_event_id ASC);

/************************

Standardized derived elements

************************/

CREATE INDEX idx_drug_era_person_id_1  ON ohdsi.drug_era  (person_id ASC);
CLUSTER ohdsi.drug_era  USING idx_drug_era_person_id_1 ;
CREATE INDEX idx_drug_era_concept_id_1 ON ohdsi.drug_era (drug_concept_id ASC);

CREATE INDEX idx_dose_era_person_id_1  ON ohdsi.dose_era  (person_id ASC);
CLUSTER ohdsi.dose_era  USING idx_dose_era_person_id_1 ;
CREATE INDEX idx_dose_era_concept_id_1 ON ohdsi.dose_era (drug_concept_id ASC);

CREATE INDEX idx_condition_era_person_id_1  ON ohdsi.condition_era  (person_id ASC);
CLUSTER ohdsi.condition_era  USING idx_condition_era_person_id_1 ;
CREATE INDEX idx_condition_era_concept_id_1 ON ohdsi.condition_era (condition_concept_id ASC);

/**************************

Standardized meta-data

***************************/

CREATE INDEX idx_metadata_concept_id_1  ON ohdsi.metadata  (metadata_concept_id ASC);
CLUSTER ohdsi.metadata  USING idx_metadata_concept_id_1 ;

/**************************

Standardized vocabularies

***************************/

CREATE INDEX idx_concept_concept_id  ON ohdsi.concept  (concept_id ASC);
CLUSTER ohdsi.concept  USING idx_concept_concept_id ;
CREATE INDEX idx_concept_code ON ohdsi.concept (concept_code ASC);
CREATE INDEX idx_concept_vocabluary_id ON ohdsi.concept (vocabulary_id ASC);
CREATE INDEX idx_concept_domain_id ON ohdsi.concept (domain_id ASC);
CREATE INDEX idx_concept_class_id ON ohdsi.concept (concept_class_id ASC);

CREATE INDEX idx_vocabulary_vocabulary_id  ON ohdsi.vocabulary  (vocabulary_id ASC);
CLUSTER ohdsi.vocabulary  USING idx_vocabulary_vocabulary_id ;

CREATE INDEX idx_domain_domain_id  ON ohdsi.domain  (domain_id ASC);
CLUSTER ohdsi.domain  USING idx_domain_domain_id ;

CREATE INDEX idx_concept_class_class_id  ON ohdsi.concept_class  (concept_class_id ASC);
CLUSTER ohdsi.concept_class  USING idx_concept_class_class_id ;

CREATE INDEX idx_concept_relationship_id_1  ON ohdsi.concept_relationship  (concept_id_1 ASC);
CLUSTER ohdsi.concept_relationship  USING idx_concept_relationship_id_1 ;
CREATE INDEX idx_concept_relationship_id_2 ON ohdsi.concept_relationship (concept_id_2 ASC);
CREATE INDEX idx_concept_relationship_id_3 ON ohdsi.concept_relationship (relationship_id ASC);

CREATE INDEX idx_relationship_rel_id  ON ohdsi.relationship  (relationship_id ASC);
CLUSTER ohdsi.relationship  USING idx_relationship_rel_id ;

CREATE INDEX idx_concept_synonym_id  ON ohdsi.concept_synonym  (concept_id ASC);
CLUSTER ohdsi.concept_synonym  USING idx_concept_synonym_id ;

CREATE INDEX idx_concept_ancestor_id_1  ON ohdsi.concept_ancestor  (ancestor_concept_id ASC);
CLUSTER ohdsi.concept_ancestor  USING idx_concept_ancestor_id_1 ;
CREATE INDEX idx_concept_ancestor_id_2 ON ohdsi.concept_ancestor (descendant_concept_id ASC);

CREATE INDEX idx_source_to_concept_map_3  ON ohdsi.source_to_concept_map  (target_concept_id ASC);
CLUSTER ohdsi.source_to_concept_map  USING idx_source_to_concept_map_3 ;
CREATE INDEX idx_source_to_concept_map_1 ON ohdsi.source_to_concept_map (source_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_2 ON ohdsi.source_to_concept_map (target_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_c ON ohdsi.source_to_concept_map (source_code ASC);

CREATE INDEX idx_drug_strength_id_1  ON ohdsi.drug_strength  (drug_concept_id ASC);
CLUSTER ohdsi.drug_strength  USING idx_drug_strength_id_1 ;
CREATE INDEX idx_drug_strength_id_2 ON ohdsi.drug_strength (ingredient_concept_id ASC);


--Additional v6.0 indices

CREATE INDEX idx_survey_person_id_1  ON ohdsi.survey_conduct  (person_id ASC);
CLUSTER ohdsi.survey_conduct  USING idx_survey_person_id_1 ;

CREATE INDEX idx_episode_person_id_1  ON ohdsi.episode  (person_id ASC);
CLUSTER ohdsi.episode  USING idx_episode_person_id_1 ;
CREATE INDEX idx_episode_concept_id_1 ON ohdsi.episode (episode_concept_id ASC);

CREATE INDEX idx_episode_event_id_1  ON ohdsi.episode_event  (episode_id ASC);
CLUSTER ohdsi.episode_event  USING idx_episode_event_id_1 ;
CREATE INDEX idx_ee_field_concept_id_1 ON ohdsi.episode_event (event_field_concept_id ASC);
