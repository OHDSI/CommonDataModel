--ALTER TABLE ohdsi.dbo.PERSON DROP CONSTRAINT fpk_PERSON_gender_concept_id ;

--ALTER TABLE ohdsi.dbo.PERSON DROP CONSTRAINT fpk_PERSON_race_concept_id ;

--ALTER TABLE ohdsi.dbo.PERSON DROP CONSTRAINT fpk_PERSON_ethnicity_concept_id ;

--ALTER TABLE ohdsi.dbo.PERSON DROP CONSTRAINT fpk_PERSON_location_id ;

--ALTER TABLE ohdsi.dbo.PERSON DROP CONSTRAINT fpk_PERSON_provider_id ;

--ALTER TABLE ohdsi.dbo.PERSON DROP CONSTRAINT fpk_PERSON_care_site_id ;

--ALTER TABLE ohdsi.dbo.PERSON DROP CONSTRAINT fpk_PERSON_gender_source_concept_id ;

--ALTER TABLE ohdsi.dbo.PERSON DROP CONSTRAINT fpk_PERSON_race_source_concept_id ;

--ALTER TABLE ohdsi.dbo.PERSON DROP CONSTRAINT fpk_PERSON_ethnicity_source_concept_id ;

--ALTER TABLE ohdsi.dbo.OBSERVATION_PERIOD DROP CONSTRAINT fpk_OBSERVATION_PERIOD_person_id ;

--ALTER TABLE ohdsi.dbo.OBSERVATION_PERIOD DROP CONSTRAINT fpk_OBSERVATION_PERIOD_period_type_concept_id ;

--ALTER TABLE ohdsi.dbo.VISIT_OCCURRENCE DROP CONSTRAINT fpk_VISIT_OCCURRENCE_person_id ;

--ALTER TABLE ohdsi.dbo.VISIT_OCCURRENCE DROP CONSTRAINT fpk_VISIT_OCCURRENCE_visit_concept_id ;

--ALTER TABLE ohdsi.dbo.VISIT_OCCURRENCE DROP CONSTRAINT fpk_VISIT_OCCURRENCE_visit_type_concept_id ;

--ALTER TABLE ohdsi.dbo.VISIT_OCCURRENCE DROP CONSTRAINT fpk_VISIT_OCCURRENCE_provider_id ;

--ALTER TABLE ohdsi.dbo.VISIT_OCCURRENCE DROP CONSTRAINT fpk_VISIT_OCCURRENCE_care_site_id ;

--ALTER TABLE ohdsi.dbo.VISIT_OCCURRENCE DROP CONSTRAINT fpk_VISIT_OCCURRENCE_visit_source_concept_id ;

ALTER TABLE ohdsi.dbo.VISIT_OCCURRENCE DROP CONSTRAINT fpk_VISIT_OCCURRENCE_admitted_from_concept_id ;

ALTER TABLE ohdsi.dbo.VISIT_OCCURRENCE DROP CONSTRAINT fpk_VISIT_OCCURRENCE_discharge_to_concept_id ;

ALTER TABLE ohdsi.dbo.VISIT_OCCURRENCE DROP CONSTRAINT fpk_VISIT_OCCURRENCE_preceding_visit_occurrence_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_person_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_visit_detail_concept_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_visit_detail_type_concept_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_provider_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_care_site_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_visit_detail_source_concept_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_admitting_source_concept_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_discharge_to_concept_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_preceding_visit_detail_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_visit_detail_parent_id ;

ALTER TABLE ohdsi.dbo.VISIT_DETAIL DROP CONSTRAINT fpk_VISIT_DETAIL_visit_occurrence_id ;

ALTER TABLE ohdsi.dbo.CONDITION_OCCURRENCE DROP CONSTRAINT fpk_CONDITION_OCCURRENCE_person_id ;

ALTER TABLE ohdsi.dbo.CONDITION_OCCURRENCE DROP CONSTRAINT fpk_CONDITION_OCCURRENCE_condition_concept_id ;

ALTER TABLE ohdsi.dbo.CONDITION_OCCURRENCE DROP CONSTRAINT fpk_CONDITION_OCCURRENCE_condition_type_concept_id ;

ALTER TABLE ohdsi.dbo.CONDITION_OCCURRENCE DROP CONSTRAINT fpk_CONDITION_OCCURRENCE_condition_status_concept_id ;

ALTER TABLE ohdsi.dbo.CONDITION_OCCURRENCE DROP CONSTRAINT fpk_CONDITION_OCCURRENCE_provider_id ;

ALTER TABLE ohdsi.dbo.CONDITION_OCCURRENCE DROP CONSTRAINT fpk_CONDITION_OCCURRENCE_visit_occurrence_id ;

ALTER TABLE ohdsi.dbo.CONDITION_OCCURRENCE DROP CONSTRAINT fpk_CONDITION_OCCURRENCE_visit_detail_id ;

ALTER TABLE ohdsi.dbo.CONDITION_OCCURRENCE DROP CONSTRAINT fpk_CONDITION_OCCURRENCE_condition_source_concept_id ;

ALTER TABLE ohdsi.dbo.DRUG_EXPOSURE DROP CONSTRAINT fpk_DRUG_EXPOSURE_person_id ;

ALTER TABLE ohdsi.dbo.DRUG_EXPOSURE DROP CONSTRAINT fpk_DRUG_EXPOSURE_drug_concept_id ;

ALTER TABLE ohdsi.dbo.DRUG_EXPOSURE DROP CONSTRAINT fpk_DRUG_EXPOSURE_drug_type_concept_id ;

ALTER TABLE ohdsi.dbo.DRUG_EXPOSURE DROP CONSTRAINT fpk_DRUG_EXPOSURE_route_concept_id ;

ALTER TABLE ohdsi.dbo.DRUG_EXPOSURE DROP CONSTRAINT fpk_DRUG_EXPOSURE_provider_id ;

ALTER TABLE ohdsi.dbo.DRUG_EXPOSURE DROP CONSTRAINT fpk_DRUG_EXPOSURE_visit_occurrence_id ;

ALTER TABLE ohdsi.dbo.DRUG_EXPOSURE DROP CONSTRAINT fpk_DRUG_EXPOSURE_visit_detail_id ;

ALTER TABLE ohdsi.dbo.DRUG_EXPOSURE DROP CONSTRAINT fpk_DRUG_EXPOSURE_drug_source_concept_id ;

ALTER TABLE ohdsi.dbo.PROCEDURE_OCCURRENCE DROP CONSTRAINT fpk_PROCEDURE_OCCURRENCE_person_id ;

ALTER TABLE ohdsi.dbo.PROCEDURE_OCCURRENCE DROP CONSTRAINT fpk_PROCEDURE_OCCURRENCE_procedure_concept_id ;

ALTER TABLE ohdsi.dbo.PROCEDURE_OCCURRENCE DROP CONSTRAINT fpk_PROCEDURE_OCCURRENCE_procedure_type_concept_id ;

ALTER TABLE ohdsi.dbo.PROCEDURE_OCCURRENCE DROP CONSTRAINT fpk_PROCEDURE_OCCURRENCE_modifier_concept_id ;

ALTER TABLE ohdsi.dbo.DEVICE_EXPOSURE DROP CONSTRAINT fpk_DEVICE_EXPOSURE_person_id ;

ALTER TABLE ohdsi.dbo.DEVICE_EXPOSURE DROP CONSTRAINT fpk_DEVICE_EXPOSURE_device_concept_id ;

ALTER TABLE ohdsi.dbo.DEVICE_EXPOSURE DROP CONSTRAINT fpk_DEVICE_EXPOSURE_device_type_concept_id ;

ALTER TABLE ohdsi.dbo.DEVICE_EXPOSURE DROP CONSTRAINT fpk_DEVICE_EXPOSURE_provider_id ;

ALTER TABLE ohdsi.dbo.DEVICE_EXPOSURE DROP CONSTRAINT fpk_DEVICE_EXPOSURE_visit_occurrence_id ;

ALTER TABLE ohdsi.dbo.DEVICE_EXPOSURE DROP CONSTRAINT fpk_DEVICE_EXPOSURE_visit_detail_id ;

ALTER TABLE ohdsi.dbo.DEVICE_EXPOSURE DROP CONSTRAINT fpk_DEVICE_EXPOSURE_device_source_concept_id ;

ALTER TABLE ohdsi.dbo.MEASUREMENT DROP CONSTRAINT fpk_MEASUREMENT_person_id ;

ALTER TABLE ohdsi.dbo.MEASUREMENT DROP CONSTRAINT fpk_MEASUREMENT_measurement_concept_id ;

ALTER TABLE ohdsi.dbo.MEASUREMENT DROP CONSTRAINT fpk_MEASUREMENT_measurement_type_concept_id ;

ALTER TABLE ohdsi.dbo.MEASUREMENT DROP CONSTRAINT fpk_MEASUREMENT_operator_concept_id ;

ALTER TABLE ohdsi.dbo.MEASUREMENT DROP CONSTRAINT fpk_MEASUREMENT_value_as_concept_id ;

ALTER TABLE ohdsi.dbo.MEASUREMENT DROP CONSTRAINT fpk_MEASUREMENT_unit_concept_id ;

ALTER TABLE ohdsi.dbo.MEASUREMENT DROP CONSTRAINT fpk_MEASUREMENT_provider_id ;

ALTER TABLE ohdsi.dbo.MEASUREMENT DROP CONSTRAINT fpk_MEASUREMENT_visit_occurrence_id ;

ALTER TABLE ohdsi.dbo.MEASUREMENT DROP CONSTRAINT fpk_MEASUREMENT_visit_detail_id ;

ALTER TABLE ohdsi.dbo.MEASUREMENT DROP CONSTRAINT fpk_MEASUREMENT_measurement_source_concept_id ;

ALTER TABLE ohdsi.dbo.OBSERVATION DROP CONSTRAINT fpk_OBSERVATION_person_id ;

ALTER TABLE ohdsi.dbo.OBSERVATION DROP CONSTRAINT fpk_OBSERVATION_observation_concept_id ;

ALTER TABLE ohdsi.dbo.OBSERVATION DROP CONSTRAINT fpk_OBSERVATION_observation_type_concept_id ;

ALTER TABLE ohdsi.dbo.OBSERVATION DROP CONSTRAINT fpk_OBSERVATION_value_as_concept_id ;

ALTER TABLE ohdsi.dbo.OBSERVATION DROP CONSTRAINT fpk_OBSERVATION_qualifier_concept_id ;

ALTER TABLE ohdsi.dbo.OBSERVATION DROP CONSTRAINT fpk_OBSERVATION_unit_concept_id ;

ALTER TABLE ohdsi.dbo.OBSERVATION DROP CONSTRAINT fpk_OBSERVATION_provider_id ;

ALTER TABLE ohdsi.dbo.OBSERVATION DROP CONSTRAINT fpk_OBSERVATION_visit_occurrence_id ;

ALTER TABLE ohdsi.dbo.OBSERVATION DROP CONSTRAINT fpk_OBSERVATION_visit_detail_id ;

ALTER TABLE ohdsi.dbo.OBSERVATION DROP CONSTRAINT fpk_OBSERVATION_observation_source_concept_id ;

ALTER TABLE ohdsi.dbo.NOTE DROP CONSTRAINT fpk_NOTE_person_id ;

ALTER TABLE ohdsi.dbo.NOTE DROP CONSTRAINT fpk_NOTE_note_type_concept_id ;

ALTER TABLE ohdsi.dbo.NOTE DROP CONSTRAINT fpk_NOTE_note_class_concept_id ;

ALTER TABLE ohdsi.dbo.NOTE DROP CONSTRAINT fpk_NOTE_encoding_concept_id ;

ALTER TABLE ohdsi.dbo.NOTE DROP CONSTRAINT fpk_NOTE_language_concept_id ;

ALTER TABLE ohdsi.dbo.NOTE DROP CONSTRAINT fpk_NOTE_provider_id ;

ALTER TABLE ohdsi.dbo.NOTE DROP CONSTRAINT fpk_NOTE_visit_occurrence_id ;

ALTER TABLE ohdsi.dbo.NOTE DROP CONSTRAINT fpk_NOTE_visit_detail_id ;

ALTER TABLE ohdsi.dbo.NOTE_NLP DROP CONSTRAINT fpk_NOTE_NLP_section_concept_id ;

ALTER TABLE ohdsi.dbo.NOTE_NLP DROP CONSTRAINT fpk_NOTE_NLP_note_nlp_concept_id ;

ALTER TABLE ohdsi.dbo.NOTE_NLP DROP CONSTRAINT fpk_NOTE_NLP_note_nlp_source_concept_id ;

ALTER TABLE ohdsi.dbo.SPECIMEN DROP CONSTRAINT fpk_SPECIMEN_person_id ;

ALTER TABLE ohdsi.dbo.SPECIMEN DROP CONSTRAINT fpk_SPECIMEN_specimen_concept_id ;

ALTER TABLE ohdsi.dbo.SPECIMEN DROP CONSTRAINT fpk_SPECIMEN_specimen_type_concept_id ;

ALTER TABLE ohdsi.dbo.SPECIMEN DROP CONSTRAINT fpk_SPECIMEN_unit_concept_id ;

ALTER TABLE ohdsi.dbo.SPECIMEN DROP CONSTRAINT fpk_SPECIMEN_anatomic_site_concept_id ;

ALTER TABLE ohdsi.dbo.SPECIMEN DROP CONSTRAINT fpk_SPECIMEN_disease_status_concept_id ;

ALTER TABLE ohdsi.dbo.FACT_RELATIONSHIP DROP CONSTRAINT fpk_FACT_RELATIONSHIP_domain_concept_id_1 ;

ALTER TABLE ohdsi.dbo.FACT_RELATIONSHIP DROP CONSTRAINT fpk_FACT_RELATIONSHIP_domain_concept_id_2 ;

ALTER TABLE ohdsi.dbo.FACT_RELATIONSHIP DROP CONSTRAINT fpk_FACT_RELATIONSHIP_relationship_concept_id ;

ALTER TABLE ohdsi.dbo.CARE_SITE DROP CONSTRAINT fpk_CARE_SITE_place_of_service_concept_id ;

ALTER TABLE ohdsi.dbo.CARE_SITE DROP CONSTRAINT fpk_CARE_SITE_location_id ;

ALTER TABLE ohdsi.dbo.PROVIDER DROP CONSTRAINT fpk_PROVIDER_specialty_concept_id ;

ALTER TABLE ohdsi.dbo.PROVIDER DROP CONSTRAINT fpk_PROVIDER_care_site_id ;

ALTER TABLE ohdsi.dbo.PROVIDER DROP CONSTRAINT fpk_PROVIDER_gender_concept_id ;

ALTER TABLE ohdsi.dbo.PROVIDER DROP CONSTRAINT fpk_PROVIDER_specialty_source_concept_id ;
ALTER TABLE ohdsi.dbo.PROVIDER DROP CONSTRAINT fpk_PROVIDER_gender_source_concept_id ;
ALTER TABLE ohdsi.dbo.PAYER_PLAN_PERIOD DROP CONSTRAINT fpk_PAYER_PLAN_PERIOD_payer_plan_period_id ;
ALTER TABLE ohdsi.dbo.PAYER_PLAN_PERIOD DROP CONSTRAINT fpk_PAYER_PLAN_PERIOD_person_id ;
ALTER TABLE ohdsi.dbo.PAYER_PLAN_PERIOD DROP CONSTRAINT fpk_PAYER_PLAN_PERIOD_payer_concept_id ;
ALTER TABLE ohdsi.dbo.PAYER_PLAN_PERIOD DROP CONSTRAINT fpk_PAYER_PLAN_PERIOD_payer_source_concept_id ;
ALTER TABLE ohdsi.dbo.PAYER_PLAN_PERIOD DROP CONSTRAINT fpk_PAYER_PLAN_PERIOD_plan_concept_id ;
ALTER TABLE ohdsi.dbo.PAYER_PLAN_PERIOD DROP CONSTRAINT fpk_PAYER_PLAN_PERIOD_plan_source_concept_id ;
ALTER TABLE ohdsi.dbo.PAYER_PLAN_PERIOD DROP CONSTRAINT fpk_PAYER_PLAN_PERIOD_sponsor_concept_id;
ALTER TABLE ohdsi.dbo.PAYER_PLAN_PERIOD DROP CONSTRAINT fpk_PAYER_PLAN_PERIOD_sponsor_source_concept_id ;
ALTER TABLE ohdsi.dbo.PAYER_PLAN_PERIOD DROP CONSTRAINT fpk_PAYER_PLAN_PERIOD_stop_reason_concept_id ;
ALTER TABLE ohdsi.dbo.PAYER_PLAN_PERIOD DROP CONSTRAINT fpk_PAYER_PLAN_PERIOD_stop_reason_source_concept_id ;
ALTER TABLE ohdsi.dbo.COST DROP CONSTRAINT fpk_COST_cost_domain_id ;
ALTER TABLE ohdsi.dbo.COST DROP CONSTRAINT fpk_COST_cost_type_concept_id ;
ALTER TABLE ohdsi.dbo.COST DROP CONSTRAINT fpk_COST_currency_concept_id ;
ALTER TABLE ohdsi.dbo.COST DROP CONSTRAINT fpk_COST_revenue_code_concept_id ;
ALTER TABLE ohdsi.dbo.COST DROP CONSTRAINT fpk_COST_drg_concept_id ;
ALTER TABLE ohdsi.dbo.DRUG_ERA DROP CONSTRAINT fpk_DRUG_ERA_person_id ;
ALTER TABLE ohdsi.dbo.DRUG_ERA DROP CONSTRAINT fpk_DRUG_ERA_drug_concept_id ;
ALTER TABLE ohdsi.dbo.DOSE_ERA DROP CONSTRAINT fpk_DOSE_ERA_person_id ;
ALTER TABLE ohdsi.dbo.DOSE_ERA DROP CONSTRAINT fpk_DOSE_ERA_drug_concept_id ;
ALTER TABLE ohdsi.dbo.DOSE_ERA DROP CONSTRAINT fpk_DOSE_ERA_unit_concept_id ;
ALTER TABLE ohdsi.dbo.CONDITION_ERA DROP CONSTRAINT fpk_CONDITION_ERA_condition_concept_id ;
ALTER TABLE ohdsi.dbo.METADATA DROP CONSTRAINT fpk_METADATA_metadata_concept_id ;
ALTER TABLE ohdsi.dbo.METADATA DROP CONSTRAINT fpk_METADATA_metadata_type_concept_id ;
ALTER TABLE ohdsi.dbo.METADATA DROP CONSTRAINT fpk_METADATA_value_as_concept_id ;
ALTER TABLE ohdsi.dbo.CONCEPT DROP CONSTRAINT fpk_CONCEPT_domain_id ;
ALTER TABLE ohdsi.dbo.CONCEPT DROP CONSTRAINT fpk_CONCEPT_vocabulary_id ;
ALTER TABLE ohdsi.dbo.CONCEPT DROP CONSTRAINT fpk_CONCEPT_concept_class_id ;
ALTER TABLE ohdsi.dbo.VOCABULARY DROP CONSTRAINT fpk_VOCABULARY_vocabulary_concept_id ;
ALTER TABLE ohdsi.dbo.DOMAIN DROP CONSTRAINT fpk_DOMAIN_domain_concept_id ;
ALTER TABLE ohdsi.dbo.CONCEPT_CLASS DROP CONSTRAINT fpk_CONCEPT_CLASS_concept_class_concept_id ;
ALTER TABLE ohdsi.dbo.CONCEPT_RELATIONSHIP DROP CONSTRAINT fpk_CONCEPT_RELATIONSHIP_concept_id_1 ;
ALTER TABLE ohdsi.dbo.CONCEPT_RELATIONSHIP DROP CONSTRAINT fpk_CONCEPT_RELATIONSHIP_concept_id_2 ;
ALTER TABLE ohdsi.dbo.CONCEPT_RELATIONSHIP DROP CONSTRAINT fpk_CONCEPT_RELATIONSHIP_relationship_id ;
ALTER TABLE ohdsi.dbo.RELATIONSHIP DROP CONSTRAINT fpk_RELATIONSHIP_relationship_concept_id ;
ALTER TABLE ohdsi.dbo.CONCEPT_SYNONYM DROP CONSTRAINT fpk_CONCEPT_SYNONYM_concept_id ;
ALTER TABLE ohdsi.dbo.CONCEPT_SYNONYM DROP CONSTRAINT fpk_CONCEPT_SYNONYM_language_concept_id ;
ALTER TABLE ohdsi.dbo.CONCEPT_ANCESTOR DROP CONSTRAINT fpk_CONCEPT_ANCESTOR_ancestor_concept_id ;
ALTER TABLE ohdsi.dbo.CONCEPT_ANCESTOR DROP CONSTRAINT fpk_CONCEPT_ANCESTOR_descendant_concept_id ;
ALTER TABLE ohdsi.dbo.SOURCE_TO_CONCEPT_MAP DROP CONSTRAINT fpk_SOURCE_TO_CONCEPT_MAP_source_concept_id ;
ALTER TABLE ohdsi.dbo.SOURCE_TO_CONCEPT_MAP DROP CONSTRAINT fpk_SOURCE_TO_CONCEPT_MAP_target_concept_id ;
ALTER TABLE ohdsi.dbo.SOURCE_TO_CONCEPT_MAP DROP CONSTRAINT fpk_SOURCE_TO_CONCEPT_MAP_target_vocabulary_id ;
ALTER TABLE ohdsi.dbo.DRUG_STRENGTH DROP CONSTRAINT fpk_DRUG_STRENGTH_drug_concept_id ;
ALTER TABLE ohdsi.dbo.DRUG_STRENGTH DROP CONSTRAINT fpk_DRUG_STRENGTH_ingredient_concept_id ;
ALTER TABLE ohdsi.dbo.DRUG_STRENGTH DROP CONSTRAINT fpk_DRUG_STRENGTH_amount_unit_concept_id ;
ALTER TABLE ohdsi.dbo.DRUG_STRENGTH DROP CONSTRAINT fpk_DRUG_STRENGTH_numerator_unit_concept_id ;
ALTER TABLE ohdsi.dbo.DRUG_STRENGTH DROP CONSTRAINT fpk_DRUG_STRENGTH_denominator_unit_concept_id ;
ALTER TABLE ohdsi.dbo.COHORT_DEFINITION DROP CONSTRAINT fpk_COHORT_DEFINITION_definition_type_concept_id ;
ALTER TABLE ohdsi.dbo.COHORT_DEFINITION DROP CONSTRAINT fpk_COHORT_DEFINITION_subject_concept_id ;
ALTER TABLE ohdsi.dbo.ATTRIBUTE_DEFINITION DROP CONSTRAINT fpk_ATTRIBUTE_DEFINITION_attribute_type_concept_id ;





IF OBJECT_ID('ohdsi.dbo.concept', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.concept;
IF OBJECT_ID('ohdsi.dbo.vocabulary', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.vocabulary;
IF OBJECT_ID('ohdsi.dbo.domain', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.domain;
IF OBJECT_ID('ohdsi.dbo.concept_class', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.concept_class;
IF OBJECT_ID('ohdsi.dbo.concept_relationship', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.concept_relationship;
IF OBJECT_ID('ohdsi.dbo.relationship', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.relationship;
IF OBJECT_ID('ohdsi.dbo.concept_synonym', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.concept_synonym;
IF OBJECT_ID('ohdsi.dbo.concept_ancestor', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.concept_ancestor;
IF OBJECT_ID('ohdsi.dbo.source_to_concept_map', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.source_to_concept_map;
IF OBJECT_ID('ohdsi.dbo.drug_strength', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.drug_strength;

IF OBJECT_ID('ohdsi.dbo.cdm_source', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.cdm_source;
IF OBJECT_ID('ohdsi.dbo.metadata', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.metadata;
IF OBJECT_ID('ohdsi.dbo.person', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.person;
IF OBJECT_ID('ohdsi.dbo.observation_period', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.observation_period;
IF OBJECT_ID('ohdsi.dbo.specimen', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.specimen;
IF OBJECT_ID('ohdsi.dbo.visit_occurrence', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.visit_occurrence;
IF OBJECT_ID('ohdsi.dbo.visit_detail', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.visit_detail;
IF OBJECT_ID('ohdsi.dbo.procedure_occurrence', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.procedure_occurrence;
IF OBJECT_ID('ohdsi.dbo.drug_exposure', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.drug_exposure;
IF OBJECT_ID('ohdsi.dbo.device_exposure', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.device_exposure;
IF OBJECT_ID('ohdsi.dbo.condition_occurrence', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.condition_occurrence;
IF OBJECT_ID('ohdsi.dbo.measurement', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.measurement;
IF OBJECT_ID('ohdsi.dbo.note', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.note;
IF OBJECT_ID('ohdsi.dbo.note_nlp', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.note_nlp;
IF OBJECT_ID('ohdsi.dbo.observation', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.observation;
IF OBJECT_ID('ohdsi.dbo.survey_conduct', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.survey_conduct;
IF OBJECT_ID('ohdsi.dbo.fact_relationship', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.fact_relationship;
IF OBJECT_ID('ohdsi.dbo.survey_conduct', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.survey_conduct;

IF OBJECT_ID('ohdsi.dbo.location', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.location;
IF OBJECT_ID('ohdsi.dbo.location_history', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.location_history;
IF OBJECT_ID('ohdsi.dbo.care_site', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.care_site;
IF OBJECT_ID('ohdsi.dbo.provider', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.provider;

IF OBJECT_ID('ohdsi.dbo.payer_plan_period', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.payer_plan_period;
IF OBJECT_ID('ohdsi.dbo.cost', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.cost;

IF OBJECT_ID('ohdsi.dbo.drug_era', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.drug_era;
IF OBJECT_ID('ohdsi.dbo.dose_era', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.dose_era;
IF OBJECT_ID('ohdsi.dbo.condition_era', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.condition_era;

IF OBJECT_ID('ohdsi.dbo.attribute_definition', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.attribute_definition;
IF OBJECT_ID('ohdsi.dbo.cohort_definition', 'U') IS NOT NULL  DROP TABLE ohdsi.dbo.cohort_definition;
