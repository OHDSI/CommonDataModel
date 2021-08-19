--bigquery CDM Foreign Key Constraints for OMOP Common Data Model 5.3

alter table @cdmDatabaseSchema.person add constraint fpk_person_gender_concept_id foreign key (gender_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.person add constraint fpk_person_race_concept_id foreign key (race_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.person add constraint fpk_person_ethnicity_concept_id foreign key (ethnicity_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.person add constraint fpk_person_location_id foreign key (location_id) references @cdmDatabaseSchema.location (location_id);

alter table @cdmDatabaseSchema.person add constraint fpk_person_provider_id foreign key (provider_id) references @cdmDatabaseSchema.provider (provider_id);

alter table @cdmDatabaseSchema.person add constraint fpk_person_care_site_id foreign key (care_site_id) references @cdmDatabaseSchema.care_site (care_site_id);

alter table @cdmDatabaseSchema.person add constraint fpk_person_gender_source_concept_id foreign key (gender_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.person add constraint fpk_person_race_source_concept_id foreign key (race_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.person add constraint fpk_person_ethnicity_source_concept_id foreign key (ethnicity_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.observation_period add constraint fpk_observation_period_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.observation_period add constraint fpk_observation_period_period_type_concept_id foreign key (period_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_occurrence add constraint fpk_visit_occurrence_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.visit_occurrence add constraint fpk_visit_occurrence_visit_concept_id foreign key (visit_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_occurrence add constraint fpk_visit_occurrence_visit_type_concept_id foreign key (visit_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_occurrence add constraint fpk_visit_occurrence_provider_id foreign key (provider_id) references @cdmDatabaseSchema.provider (provider_id);

alter table @cdmDatabaseSchema.visit_occurrence add constraint fpk_visit_occurrence_care_site_id foreign key (care_site_id) references @cdmDatabaseSchema.care_site (care_site_id);

alter table @cdmDatabaseSchema.visit_occurrence add constraint fpk_visit_occurrence_visit_source_concept_id foreign key (visit_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_occurrence add constraint fpk_visit_occurrence_admitting_source_concept_id foreign key (admitting_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_occurrence add constraint fpk_visit_occurrence_discharge_to_concept_id foreign key (discharge_to_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_occurrence add constraint fpk_visit_occurrence_preceding_visit_occurrence_id foreign key (preceding_visit_occurrence_id) references @cdmDatabaseSchema.visit_occurrence (visit_occurrence_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_visit_detail_concept_id foreign key (visit_detail_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_visit_detail_type_concept_id foreign key (visit_detail_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_provider_id foreign key (provider_id) references @cdmDatabaseSchema.provider (provider_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_care_site_id foreign key (care_site_id) references @cdmDatabaseSchema.care_site (care_site_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_visit_detail_source_concept_id foreign key (visit_detail_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_admitting_source_concept_id foreign key (admitting_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_discharge_to_concept_id foreign key (discharge_to_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_preceding_visit_detail_id foreign key (preceding_visit_detail_id) references @cdmDatabaseSchema.visit_detail (visit_detail_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_visit_detail_parent_id foreign key (visit_detail_parent_id) references @cdmDatabaseSchema.visit_detail (visit_detail_id);

alter table @cdmDatabaseSchema.visit_detail add constraint fpk_visit_detail_visit_occurrence_id foreign key (visit_occurrence_id) references @cdmDatabaseSchema.visit_occurrence (visit_occurrence_id);

alter table @cdmDatabaseSchema.condition_occurrence add constraint fpk_condition_occurrence_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.condition_occurrence add constraint fpk_condition_occurrence_condition_concept_id foreign key (condition_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.condition_occurrence add constraint fpk_condition_occurrence_condition_type_concept_id foreign key (condition_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.condition_occurrence add constraint fpk_condition_occurrence_condition_status_concept_id foreign key (condition_status_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.condition_occurrence add constraint fpk_condition_occurrence_provider_id foreign key (provider_id) references @cdmDatabaseSchema.provider (provider_id);

alter table @cdmDatabaseSchema.condition_occurrence add constraint fpk_condition_occurrence_visit_occurrence_id foreign key (visit_occurrence_id) references @cdmDatabaseSchema.visit_occurrence (visit_occurrence_id);

alter table @cdmDatabaseSchema.condition_occurrence add constraint fpk_condition_occurrence_visit_detail_id foreign key (visit_detail_id) references @cdmDatabaseSchema.visit_detail (visit_detail_id);

alter table @cdmDatabaseSchema.condition_occurrence add constraint fpk_condition_occurrence_condition_source_concept_id foreign key (condition_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.drug_exposure add constraint fpk_drug_exposure_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.drug_exposure add constraint fpk_drug_exposure_drug_concept_id foreign key (drug_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.drug_exposure add constraint fpk_drug_exposure_drug_type_concept_id foreign key (drug_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.drug_exposure add constraint fpk_drug_exposure_route_concept_id foreign key (route_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.drug_exposure add constraint fpk_drug_exposure_provider_id foreign key (provider_id) references @cdmDatabaseSchema.provider (provider_id);

alter table @cdmDatabaseSchema.drug_exposure add constraint fpk_drug_exposure_visit_occurrence_id foreign key (visit_occurrence_id) references @cdmDatabaseSchema.visit_occurrence (visit_occurrence_id);

alter table @cdmDatabaseSchema.drug_exposure add constraint fpk_drug_exposure_visit_detail_id foreign key (visit_detail_id) references @cdmDatabaseSchema.visit_detail (visit_detail_id);

alter table @cdmDatabaseSchema.drug_exposure add constraint fpk_drug_exposure_drug_source_concept_id foreign key (drug_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.procedure_occurrence add constraint fpk_procedure_occurrence_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.procedure_occurrence add constraint fpk_procedure_occurrence_procedure_concept_id foreign key (procedure_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.procedure_occurrence add constraint fpk_procedure_occurrence_procedure_type_concept_id foreign key (procedure_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.procedure_occurrence add constraint fpk_procedure_occurrence_modifier_concept_id foreign key (modifier_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.device_exposure add constraint fpk_device_exposure_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.device_exposure add constraint fpk_device_exposure_device_concept_id foreign key (device_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.device_exposure add constraint fpk_device_exposure_device_type_concept_id foreign key (device_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.device_exposure add constraint fpk_device_exposure_provider_id foreign key (provider_id) references @cdmDatabaseSchema.provider (provider_id);

alter table @cdmDatabaseSchema.device_exposure add constraint fpk_device_exposure_visit_occurrence_id foreign key (visit_occurrence_id) references @cdmDatabaseSchema.visit_occurrence (visit_occurrence_id);

alter table @cdmDatabaseSchema.device_exposure add constraint fpk_device_exposure_visit_detail_id foreign key (visit_detail_id) references @cdmDatabaseSchema.visit_detail (visit_detail_id);

alter table @cdmDatabaseSchema.device_exposure add constraint fpk_device_exposure_device_source_concept_id foreign key (device_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.measurement add constraint fpk_measurement_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.measurement add constraint fpk_measurement_measurement_concept_id foreign key (measurement_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.measurement add constraint fpk_measurement_measurement_type_concept_id foreign key (measurement_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.measurement add constraint fpk_measurement_operator_concept_id foreign key (operator_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.measurement add constraint fpk_measurement_value_as_concept_id foreign key (value_as_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.measurement add constraint fpk_measurement_unit_concept_id foreign key (unit_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.measurement add constraint fpk_measurement_provider_id foreign key (provider_id) references @cdmDatabaseSchema.provider (provider_id);

alter table @cdmDatabaseSchema.measurement add constraint fpk_measurement_visit_occurrence_id foreign key (visit_occurrence_id) references @cdmDatabaseSchema.visit_occurrence (visit_occurrence_id);

alter table @cdmDatabaseSchema.measurement add constraint fpk_measurement_visit_detail_id foreign key (visit_detail_id) references @cdmDatabaseSchema.visit_detail (visit_detail_id);

alter table @cdmDatabaseSchema.measurement add constraint fpk_measurement_measurement_source_concept_id foreign key (measurement_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.observation add constraint fpk_observation_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.observation add constraint fpk_observation_observation_concept_id foreign key (observation_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.observation add constraint fpk_observation_observation_type_concept_id foreign key (observation_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.observation add constraint fpk_observation_value_as_concept_id foreign key (value_as_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.observation add constraint fpk_observation_qualifier_concept_id foreign key (qualifier_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.observation add constraint fpk_observation_unit_concept_id foreign key (unit_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.observation add constraint fpk_observation_provider_id foreign key (provider_id) references @cdmDatabaseSchema.provider (provider_id);

alter table @cdmDatabaseSchema.observation add constraint fpk_observation_visit_occurrence_id foreign key (visit_occurrence_id) references @cdmDatabaseSchema.visit_occurrence (visit_occurrence_id);

alter table @cdmDatabaseSchema.observation add constraint fpk_observation_visit_detail_id foreign key (visit_detail_id) references @cdmDatabaseSchema.visit_detail (visit_detail_id);

alter table @cdmDatabaseSchema.observation add constraint fpk_observation_observation_source_concept_id foreign key (observation_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.death add constraint fpk_death_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.death add constraint fpk_death_death_type_concept_id foreign key (death_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.death add constraint fpk_death_cause_concept_id foreign key (cause_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.death add constraint fpk_death_cause_source_concept_id foreign key (cause_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.note add constraint fpk_note_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.note add constraint fpk_note_note_type_concept_id foreign key (note_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.note add constraint fpk_note_note_class_concept_id foreign key (note_class_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.note add constraint fpk_note_encoding_concept_id foreign key (encoding_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.note add constraint fpk_note_language_concept_id foreign key (language_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.note add constraint fpk_note_provider_id foreign key (provider_id) references @cdmDatabaseSchema.provider (provider_id);

alter table @cdmDatabaseSchema.note add constraint fpk_note_visit_occurrence_id foreign key (visit_occurrence_id) references @cdmDatabaseSchema.visit_occurrence (visit_occurrence_id);

alter table @cdmDatabaseSchema.note add constraint fpk_note_visit_detail_id foreign key (visit_detail_id) references @cdmDatabaseSchema.visit_detail (visit_detail_id);

alter table @cdmDatabaseSchema.note_nlp add constraint fpk_note_nlp_section_concept_id foreign key (section_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.note_nlp add constraint fpk_note_nlp_note_nlp_concept_id foreign key (note_nlp_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.note_nlp add constraint fpk_note_nlp_note_nlp_source_concept_id foreign key (note_nlp_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.specimen add constraint fpk_specimen_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.specimen add constraint fpk_specimen_specimen_concept_id foreign key (specimen_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.specimen add constraint fpk_specimen_specimen_type_concept_id foreign key (specimen_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.specimen add constraint fpk_specimen_unit_concept_id foreign key (unit_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.specimen add constraint fpk_specimen_anatomic_site_concept_id foreign key (anatomic_site_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.specimen add constraint fpk_specimen_disease_status_concept_id foreign key (disease_status_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.fact_relationship add constraint fpk_fact_relationship_domain_concept_id_1 foreign key (domain_concept_id_1) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.fact_relationship add constraint fpk_fact_relationship_domain_concept_id_2 foreign key (domain_concept_id_2) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.fact_relationship add constraint fpk_fact_relationship_relationship_concept_id foreign key (relationship_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.care_site add constraint fpk_care_site_place_of_service_concept_id foreign key (place_of_service_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.care_site add constraint fpk_care_site_location_id foreign key (location_id) references @cdmDatabaseSchema.location (location_id);

alter table @cdmDatabaseSchema.provider add constraint fpk_provider_specialty_concept_id foreign key (specialty_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.provider add constraint fpk_provider_care_site_id foreign key (care_site_id) references @cdmDatabaseSchema.care_site (care_site_id);

alter table @cdmDatabaseSchema.provider add constraint fpk_provider_gender_concept_id foreign key (gender_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.provider add constraint fpk_provider_specialty_source_concept_id foreign key (specialty_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.provider add constraint fpk_provider_gender_source_concept_id foreign key (gender_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint fpk_payer_plan_period_payer_plan_period_id foreign key (payer_plan_period_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint fpk_payer_plan_period_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint fpk_payer_plan_period_payer_concept_id foreign key (payer_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint fpk_payer_plan_period_payer_source_concept_id foreign key (payer_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint fpk_payer_plan_period_plan_concept_id foreign key (plan_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint fpk_payer_plan_period_plan_source_concept_id foreign key (plan_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint fpk_payer_plan_period_sponsor_concept_id foreign key (sponsor_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint fpk_payer_plan_period_sponsor_source_concept_id foreign key (sponsor_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint fpk_payer_plan_period_stop_reason_concept_id foreign key (stop_reason_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.payer_plan_period add constraint fpk_payer_plan_period_stop_reason_source_concept_id foreign key (stop_reason_source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.cost add constraint fpk_cost_cost_domain_id foreign key (cost_domain_id) references @cdmDatabaseSchema.domain (domain_id);

alter table @cdmDatabaseSchema.cost add constraint fpk_cost_cost_type_concept_id foreign key (cost_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.cost add constraint fpk_cost_currency_concept_id foreign key (currency_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.cost add constraint fpk_cost_revenue_code_concept_id foreign key (revenue_code_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.cost add constraint fpk_cost_drg_concept_id foreign key (drg_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.drug_era add constraint fpk_drug_era_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.drug_era add constraint fpk_drug_era_drug_concept_id foreign key (drug_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.dose_era add constraint fpk_dose_era_person_id foreign key (person_id) references @cdmDatabaseSchema.person (person_id);

alter table @cdmDatabaseSchema.dose_era add constraint fpk_dose_era_drug_concept_id foreign key (drug_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.dose_era add constraint fpk_dose_era_unit_concept_id foreign key (unit_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.condition_era add constraint fpk_condition_era_condition_concept_id foreign key (condition_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.metadata add constraint fpk_metadata_metadata_concept_id foreign key (metadata_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.metadata add constraint fpk_metadata_metadata_type_concept_id foreign key (metadata_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.metadata add constraint fpk_metadata_value_as_concept_id foreign key (value_as_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.concept add constraint fpk_concept_domain_id foreign key (domain_id) references @cdmDatabaseSchema.domain (domain_id);

alter table @cdmDatabaseSchema.concept add constraint fpk_concept_vocabulary_id foreign key (vocabulary_id) references @cdmDatabaseSchema.vocabulary (vocabulary_id);

alter table @cdmDatabaseSchema.concept add constraint fpk_concept_concept_class_id foreign key (concept_class_id) references @cdmDatabaseSchema.concept_class (concept_class_id);

alter table @cdmDatabaseSchema.vocabulary add constraint fpk_vocabulary_vocabulary_concept_id foreign key (vocabulary_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.domain add constraint fpk_domain_domain_concept_id foreign key (domain_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.concept_class add constraint fpk_concept_class_concept_class_concept_id foreign key (concept_class_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.concept_relationship add constraint fpk_concept_relationship_concept_id_1 foreign key (concept_id_1) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.concept_relationship add constraint fpk_concept_relationship_concept_id_2 foreign key (concept_id_2) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.concept_relationship add constraint fpk_concept_relationship_relationship_id foreign key (relationship_id) references @cdmDatabaseSchema.relationship (relationship_id);

alter table @cdmDatabaseSchema.relationship add constraint fpk_relationship_relationship_concept_id foreign key (relationship_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.concept_synonym add constraint fpk_concept_synonym_concept_id foreign key (concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.concept_synonym add constraint fpk_concept_synonym_language_concept_id foreign key (language_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.concept_ancestor add constraint fpk_concept_ancestor_ancestor_concept_id foreign key (ancestor_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.concept_ancestor add constraint fpk_concept_ancestor_descendant_concept_id foreign key (descendant_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.source_to_concept_map add constraint fpk_source_to_concept_map_source_concept_id foreign key (source_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.source_to_concept_map add constraint fpk_source_to_concept_map_target_concept_id foreign key (target_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.source_to_concept_map add constraint fpk_source_to_concept_map_target_vocabulary_id foreign key (target_vocabulary_id) references @cdmDatabaseSchema.vocabulary (vocabulary_id);

alter table @cdmDatabaseSchema.drug_strength add constraint fpk_drug_strength_drug_concept_id foreign key (drug_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.drug_strength add constraint fpk_drug_strength_ingredient_concept_id foreign key (ingredient_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.drug_strength add constraint fpk_drug_strength_amount_unit_concept_id foreign key (amount_unit_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.drug_strength add constraint fpk_drug_strength_numerator_unit_concept_id foreign key (numerator_unit_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.drug_strength add constraint fpk_drug_strength_denominator_unit_concept_id foreign key (denominator_unit_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.cohort_definition add constraint fpk_cohort_definition_definition_type_concept_id foreign key (definition_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.cohort_definition add constraint fpk_cohort_definition_subject_concept_id foreign key (subject_concept_id) references @cdmDatabaseSchema.concept (concept_id);

alter table @cdmDatabaseSchema.attribute_definition add constraint fpk_attribute_definition_attribute_type_concept_id foreign key (attribute_type_concept_id) references @cdmDatabaseSchema.concept (concept_id);
