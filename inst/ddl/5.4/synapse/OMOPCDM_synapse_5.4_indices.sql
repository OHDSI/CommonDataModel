-- azure synapse OMOP CDM Indices


/************************

Standardized clinical data

************************/

CREATE INDEX idx_gender ON @cdmDatabaseSchema.person (gender_concept_id ASC);

CREATE INDEX idx_visit_concept_id_1 ON @cdmDatabaseSchema.visit_occurrence (visit_concept_id ASC);

CREATE INDEX idx_visit_det_concept_id_1 ON @cdmDatabaseSchema.visit_detail (visit_detail_concept_id ASC);
CREATE INDEX idx_visit_det_occ_id ON @cdmDatabaseSchema.visit_detail (visit_occurrence_id ASC);

CREATE INDEX idx_condition_concept_id_1 ON @cdmDatabaseSchema.condition_occurrence (condition_concept_id ASC);
CREATE INDEX idx_condition_visit_id_1 ON @cdmDatabaseSchema.condition_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_drug_concept_id_1 ON @cdmDatabaseSchema.drug_exposure (drug_concept_id ASC);
CREATE INDEX idx_drug_visit_id_1 ON @cdmDatabaseSchema.drug_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_procedure_concept_id_1 ON @cdmDatabaseSchema.procedure_occurrence (procedure_concept_id ASC);
CREATE INDEX idx_procedure_visit_id_1 ON @cdmDatabaseSchema.procedure_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_device_concept_id_1 ON @cdmDatabaseSchema.device_exposure (device_concept_id ASC);
CREATE INDEX idx_device_visit_id_1 ON @cdmDatabaseSchema.device_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_measurement_concept_id_1 ON @cdmDatabaseSchema.measurement (measurement_concept_id ASC);
CREATE INDEX idx_measurement_visit_id_1 ON @cdmDatabaseSchema.measurement (visit_occurrence_id ASC);

CREATE INDEX idx_observation_concept_id_1 ON @cdmDatabaseSchema.observation (observation_concept_id ASC);
CREATE INDEX idx_observation_visit_id_1 ON @cdmDatabaseSchema.observation (visit_occurrence_id ASC);

CREATE INDEX idx_note_concept_id_1 ON @cdmDatabaseSchema.note (note_type_concept_id ASC);
CREATE INDEX idx_note_visit_id_1 ON @cdmDatabaseSchema.note (visit_occurrence_id ASC);

CREATE INDEX idx_note_nlp_concept_id_1 ON @cdmDatabaseSchema.note_nlp (note_nlp_concept_id ASC);

CREATE INDEX idx_specimen_concept_id_1 ON @cdmDatabaseSchema.specimen (specimen_concept_id ASC);

CREATE INDEX idx_fact_relationship_id1 ON @cdmDatabaseSchema.fact_relationship (domain_concept_id_1 ASC);
CREATE INDEX idx_fact_relationship_id2 ON @cdmDatabaseSchema.fact_relationship (domain_concept_id_2 ASC);
CREATE INDEX idx_fact_relationship_id3 ON @cdmDatabaseSchema.fact_relationship (relationship_concept_id ASC);

/************************

Standardized health economics

************************/

CREATE INDEX idx_cost_event_id  ON @cdmDatabaseSchema.cost (cost_event_id ASC);

/************************

Standardized derived elements

************************/
CREATE INDEX idx_drug_era_concept_id_1 ON @cdmDatabaseSchema.drug_era (drug_concept_id ASC);

CREATE INDEX idx_dose_era_concept_id_1 ON @cdmDatabaseSchema.dose_era (drug_concept_id ASC);

CREATE INDEX idx_condition_era_concept_id_1 ON @cdmDatabaseSchema.condition_era (condition_concept_id ASC);

/**************************

Standardized vocabularies

***************************/
CREATE INDEX idx_concept_code ON @cdmDatabaseSchema.concept (concept_code ASC);
CREATE INDEX idx_concept_vocabluary_id ON @cdmDatabaseSchema.concept (vocabulary_id ASC);
CREATE INDEX idx_concept_domain_id ON @cdmDatabaseSchema.concept (domain_id ASC);
CREATE INDEX idx_concept_class_id ON @cdmDatabaseSchema.concept (concept_class_id ASC);

CREATE INDEX idx_concept_relationship_id_2 ON @cdmDatabaseSchema.concept_relationship (concept_id_2 ASC);
CREATE INDEX idx_concept_relationship_id_3 ON @cdmDatabaseSchema.concept_relationship (relationship_id ASC);

CREATE INDEX idx_concept_ancestor_id_2 ON @cdmDatabaseSchema.concept_ancestor (descendant_concept_id ASC);

CREATE INDEX idx_source_to_concept_map_1 ON @cdmDatabaseSchema.source_to_concept_map (source_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_2 ON @cdmDatabaseSchema.source_to_concept_map (target_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_c ON @cdmDatabaseSchema.source_to_concept_map (source_code ASC);

CREATE INDEX idx_drug_strength_id_2 ON @cdmDatabaseSchema.drug_strength (ingredient_concept_id ASC);