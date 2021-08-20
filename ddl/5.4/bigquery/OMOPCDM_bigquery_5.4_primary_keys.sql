--bigquery CDM Primary Key Constraints for OMOP Common Data Model 5.4

alter table @cdmDatabaseSchema.person add constraint xpk_person primary key nonclustered (person_id);

alter table @cdmDatabaseSchema.observation_period add constraint xpk_observation_period primary key nonclustered (observation_period_id);

alter table @cdmDatabaseSchema.visit_occurrence add constraint xpk_visit_occurrence primary key nonclustered (visit_occurrence_id);

alter table @cdmDatabaseSchema.visit_detail add constraint xpk_visit_detail primary key nonclustered (visit_detail_id);

alter table @cdmDatabaseSchema.condition_occurrence add constraint xpk_condition_occurrence primary key nonclustered (condition_occurrence_id);

alter table @cdmDatabaseSchema.drug_exposure add constraint xpk_drug_exposure primary key nonclustered (drug_exposure_id);

alter table @cdmDatabaseSchema.procedure_occurrence add constraint xpk_procedure_occurrence primary key nonclustered (procedure_occurrence_id);

alter table @cdmDatabaseSchema.device_exposure add constraint xpk_device_exposure primary key nonclustered (device_exposure_id);

alter table @cdmDatabaseSchema.measurement add constraint xpk_measurement primary key nonclustered (measurement_id);

alter table @cdmDatabaseSchema.observation add constraint xpk_observation primary key nonclustered (observation_id);

alter table @cdmDatabaseSchema.note add constraint xpk_note primary key nonclustered (note_id);

alter table @cdmDatabaseSchema.note_nlp add constraint xpk_note_nlp primary key nonclustered (note_nlp_id);

alter table @cdmDatabaseSchema.specimen add constraint xpk_specimen primary key nonclustered (specimen_id);

alter table @cdmDatabaseSchema.location add constraint xpk_location primary key nonclustered (location_id);

alter table @cdmDatabaseSchema.care_site add constraint xpk_care_site primary key nonclustered (care_site_id);

alter table @cdmDatabaseSchema.provider add constraint xpk_provider primary key nonclustered (provider_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint xpk_payer_plan_period primary key nonclustered (payer_plan_period_id);

alter table @cdmDatabaseSchema.cost add constraint xpk_cost primary key nonclustered (cost_id);

alter table @cdmDatabaseSchema.drug_era add constraint xpk_drug_era primary key nonclustered (drug_era_id);

alter table @cdmDatabaseSchema.dose_era add constraint xpk_dose_era primary key nonclustered (dose_era_id);

alter table @cdmDatabaseSchema.condition_era add constraint xpk_condition_era primary key nonclustered (condition_era_id);

alter table @cdmDatabaseSchema.episode add constraint xpk_episode primary key nonclustered (episode_id);

alter table @cdmDatabaseSchema.metadata add constraint xpk_metadata primary key nonclustered (metadata_id);

alter table @cdmDatabaseSchema.concept add constraint xpk_concept primary key nonclustered (concept_id);

alter table @cdmDatabaseSchema.vocabulary add constraint xpk_vocabulary primary key nonclustered (vocabulary_id);

alter table @cdmDatabaseSchema.domain add constraint xpk_domain primary key nonclustered (domain_id);

alter table @cdmDatabaseSchema.concept_class add constraint xpk_concept_class primary key nonclustered (concept_class_id);

alter table @cdmDatabaseSchema.relationship add constraint xpk_relationship primary key nonclustered (relationship_id);
