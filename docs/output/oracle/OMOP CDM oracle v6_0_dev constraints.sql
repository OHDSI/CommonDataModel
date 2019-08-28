/*********************************************************************************
# Copyright 2014 Observational Health Data Sciences and Informatics
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
********************************************************************************/

/************************

 ####### #     # ####### ######      #####  ######  #     #            #####        ###       #####
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #     #      #   #     #     #  ####  #    #  ####  ##### #####    ##   # #    # #####  ####
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #           #     #    #       #    # ##   # #        #   #    #  #  #  # ##   #   #   #
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######      #     #    #       #    # # #  #  ####    #   #    # #    # # # #  #   #    ####
 #     # #     # #     # #          #       #     # #     #    #    # #     # ### #     #    #       #    # #  # #      #   #   #####  ###### # #  # #   #        #
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ###  #   #     #     # #    # #   ## #    #   #   #   #  #    # # #   ##   #   #    #
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ###   ###       #####   ####  #    #  ####    #   #    # #    # # #    #   #    ####


oracle script to create foreign key, unique, and check constraints within the OMOP common data model, version 6.0

last revised: 30-AugÃ¢â€Å’-2018

author:  Patrick Ryan, Clair Blacketer


*************************/


/************************
*************************
*************************
*************************

Foreign key constraints

*************************
*************************
*************************
************************/


/************************

Standardized vocabulary

************************/


ALTER TABLE OHDSI.concept ADD CONSTRAINT fpk_concept_domain FOREIGN KEY (domain_id)  REFERENCES OHDSI.domain (domain_id);

ALTER TABLE OHDSI.concept ADD CONSTRAINT fpk_concept_class FOREIGN KEY (concept_class_id)  REFERENCES OHDSI.concept_class (concept_class_id);

ALTER TABLE OHDSI.concept ADD CONSTRAINT fpk_concept_vocabulary FOREIGN KEY (vocabulary_id)  REFERENCES OHDSI.vocabulary (vocabulary_id);


ALTER TABLE OHDSI.vocabulary ADD CONSTRAINT fpk_vocabulary_concept FOREIGN KEY (vocabulary_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.domain ADD CONSTRAINT fpk_domain_concept FOREIGN KEY (domain_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.concept_class ADD CONSTRAINT fpk_concept_class_concept FOREIGN KEY (concept_class_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.concept_relationship ADD CONSTRAINT fpk_concept_relationship_c_1 FOREIGN KEY (concept_id_1)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.concept_relationship ADD CONSTRAINT fpk_concept_relationship_c_2 FOREIGN KEY (concept_id_2)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.concept_relationship ADD CONSTRAINT fpk_concept_relationship_id FOREIGN KEY (relationship_id)  REFERENCES OHDSI.relationship (relationship_id);


ALTER TABLE OHDSI.relationship ADD CONSTRAINT fpk_relationship_concept FOREIGN KEY (relationship_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.relationship ADD CONSTRAINT fpk_relationship_reverse FOREIGN KEY (reverse_relationship_id)  REFERENCES OHDSI.relationship (relationship_id);


ALTER TABLE OHDSI.concept_synonym ADD CONSTRAINT fpk_concept_synonym_concept FOREIGN KEY (concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.concept_synonym ADD CONSTRAINT fpk_concept_synonym_lang FOREIGN KEY (language_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.concept_ancestor ADD CONSTRAINT fpk_concept_ancestor_concept_1 FOREIGN KEY (ancestor_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.concept_ancestor ADD CONSTRAINT fpk_concept_ancestor_concept_2 FOREIGN KEY (descendant_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.source_to_concept_map ADD CONSTRAINT fpk_source_to_concept_map_v_1 FOREIGN KEY (source_vocabulary_id)  REFERENCES OHDSI.vocabulary (vocabulary_id);

ALTER TABLE OHDSI.source_to_concept_map ADD CONSTRAINT fpk_source_to_concept_map_v_2 FOREIGN KEY (target_vocabulary_id)  REFERENCES OHDSI.vocabulary (vocabulary_id);

ALTER TABLE OHDSI.source_to_concept_map ADD CONSTRAINT fpk_source_to_concept_map_c_1 FOREIGN KEY (target_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.drug_strength ADD CONSTRAINT fpk_drug_strength_concept_1 FOREIGN KEY (drug_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.drug_strength ADD CONSTRAINT fpk_drug_strength_concept_2 FOREIGN KEY (ingredient_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.drug_strength ADD CONSTRAINT fpk_drug_strength_unit_1 FOREIGN KEY (amount_unit_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.drug_strength ADD CONSTRAINT fpk_drug_strength_unit_2 FOREIGN KEY (numerator_unit_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.drug_strength ADD CONSTRAINT fpk_drug_strength_unit_3 FOREIGN KEY (denominator_unit_concept_id)  REFERENCES OHDSI.concept (concept_id);


/**************************

Standardized meta-data

***************************/


--ALTER TABLE OHDSI.metadata ADD CONSTRAINT fpk_metadata_concept FOREIGN KEY (metadata_concept_id) REFERENCES OHDSI.concept (concept_id);

--ALTER TABLE OHDSI.metadata ADD CONSTRAINT fpk_metadata_type_concept FOREIGN KEY (metadata_type_concept_id) REFERENCES OHDSI.concept (concept_id);


/************************

Standardized clinical data

************************/

ALTER TABLE OHDSI.person ADD CONSTRAINT fpk_person_gender_concept FOREIGN KEY (gender_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.person ADD CONSTRAINT fpk_person_race_concept FOREIGN KEY (race_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.person ADD CONSTRAINT fpk_person_ethnicity_concept FOREIGN KEY (ethnicity_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.person ADD CONSTRAINT fpk_person_gender_concept_s FOREIGN KEY (gender_source_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.person ADD CONSTRAINT fpk_person_race_concept_s FOREIGN KEY (race_source_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.person ADD CONSTRAINT fpk_person_ethnicity_concept_s FOREIGN KEY (ethnicity_source_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.person ADD CONSTRAINT fpk_person_location FOREIGN KEY (location_id)  REFERENCES OHDSI.location (location_id);

ALTER TABLE OHDSI.person ADD CONSTRAINT fpk_person_provider FOREIGN KEY (provider_id)  REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.person ADD CONSTRAINT fpk_person_care_site FOREIGN KEY (care_site_id)  REFERENCES OHDSI.care_site (care_site_id);


ALTER TABLE OHDSI.observation_period ADD CONSTRAINT fpk_observation_period_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.observation_period ADD CONSTRAINT fpk_observation_period_concept FOREIGN KEY (period_type_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.specimen ADD CONSTRAINT fpk_specimen_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.specimen ADD CONSTRAINT fpk_specimen_concept FOREIGN KEY (specimen_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.specimen ADD CONSTRAINT fpk_specimen_type_concept FOREIGN KEY (specimen_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.specimen ADD CONSTRAINT fpk_specimen_unit_concept FOREIGN KEY (unit_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.specimen ADD CONSTRAINT fpk_specimen_site_concept FOREIGN KEY (anatomic_site_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.specimen ADD CONSTRAINT fpk_specimen_status_concept FOREIGN KEY (disease_status_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.visit_occurrence ADD CONSTRAINT fpk_visit_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.visit_occurrence ADD CONSTRAINT fpk_visit_concept FOREIGN KEY (visit_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.visit_occurrence ADD CONSTRAINT fpk_visit_type_concept FOREIGN KEY (visit_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.visit_occurrence ADD CONSTRAINT fpk_visit_provider FOREIGN KEY (provider_id)  REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.visit_occurrence ADD CONSTRAINT fpk_visit_care_site FOREIGN KEY (care_site_id)  REFERENCES OHDSI.care_site (care_site_id);

ALTER TABLE OHDSI.visit_occurrence ADD CONSTRAINT fpk_visit_concept_s FOREIGN KEY (visit_source_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.visit_occurrence ADD CONSTRAINT fpk_visit_admitting_s FOREIGN KEY (admitted_from_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.visit_occurrence ADD CONSTRAINT fpk_visit_discharge FOREIGN KEY (discharge_to_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.visit_occurrence ADD CONSTRAINT fpk_visit_preceding FOREIGN KEY (preceding_visit_occurrence_id) REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);


ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpk_v_detail_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpk_v_detail_concept FOREIGN KEY (visit_detail_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpk_v_detail_type_concept FOREIGN KEY (visit_detail_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpk_v_detail_provider FOREIGN KEY (provider_id)  REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpk_v_detail_care_site FOREIGN KEY (care_site_id)  REFERENCES OHDSI.care_site (care_site_id);

ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpk_v_detail_discharge FOREIGN KEY (discharge_to_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpk_v_detail_admitting_s FOREIGN KEY (admitted_from_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpk_v_detail_concept_s FOREIGN KEY (visit_detail_source_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpk_v_detail_preceding FOREIGN KEY (preceding_visit_detail_id) REFERENCES OHDSI.visit_detail (visit_detail_id);

ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpk_v_detail_parent FOREIGN KEY (visit_detail_parent_id) REFERENCES OHDSI.visit_detail (visit_detail_id);

ALTER TABLE OHDSI.visit_detail ADD CONSTRAINT fpd_v_detail_visit FOREIGN KEY (visit_occurrence_id) REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);


ALTER TABLE OHDSI.procedure_occurrence ADD CONSTRAINT fpk_procedure_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.procedure_occurrence ADD CONSTRAINT fpk_procedure_concept FOREIGN KEY (procedure_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.procedure_occurrence ADD CONSTRAINT fpk_procedure_type_concept FOREIGN KEY (procedure_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.procedure_occurrence ADD CONSTRAINT fpk_procedure_modifier FOREIGN KEY (modifier_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.procedure_occurrence ADD CONSTRAINT fpk_procedure_provider FOREIGN KEY (provider_id)  REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.procedure_occurrence ADD CONSTRAINT fpk_procedure_visit FOREIGN KEY (visit_occurrence_id)  REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);

ALTER TABLE OHDSI.procedure_occurrence ADD CONSTRAINT fpk_procedure_v_detail FOREIGN KEY (visit_detail_id) REFERENCES OHDSI.visit_detail (visit_detail_id);

ALTER TABLE OHDSI.procedure_occurrence ADD CONSTRAINT fpk_procedure_concept_s FOREIGN KEY (procedure_source_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.drug_exposure ADD CONSTRAINT fpk_drug_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.drug_exposure ADD CONSTRAINT fpk_drug_concept FOREIGN KEY (drug_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.drug_exposure ADD CONSTRAINT fpk_drug_type_concept FOREIGN KEY (drug_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.drug_exposure ADD CONSTRAINT fpk_drug_route_concept FOREIGN KEY (route_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.drug_exposure ADD CONSTRAINT fpk_drug_provider FOREIGN KEY (provider_id)  REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.drug_exposure ADD CONSTRAINT fpk_drug_visit FOREIGN KEY (visit_occurrence_id)  REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);

ALTER TABLE OHDSI.drug_exposure ADD CONSTRAINT fpk_drug_v_detail FOREIGN KEY (visit_detail_id) REFERENCES OHDSI.visit_detail (visit_detail_id);

ALTER TABLE OHDSI.drug_exposure ADD CONSTRAINT fpk_drug_concept_s FOREIGN KEY (drug_source_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.device_exposure ADD CONSTRAINT fpk_device_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.device_exposure ADD CONSTRAINT fpk_device_concept FOREIGN KEY (device_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.device_exposure ADD CONSTRAINT fpk_device_type_concept FOREIGN KEY (device_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.device_exposure ADD CONSTRAINT fpk_device_provider FOREIGN KEY (provider_id)  REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.device_exposure ADD CONSTRAINT fpk_device_visit FOREIGN KEY (visit_occurrence_id)  REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);

ALTER TABLE OHDSI.device_exposure ADD CONSTRAINT fpk_device_v_detail FOREIGN KEY (visit_detail_id) REFERENCES OHDSI.visit_detail (visit_detail_id);

ALTER TABLE OHDSI.device_exposure ADD CONSTRAINT fpk_device_concept_s FOREIGN KEY (device_source_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.condition_occurrence ADD CONSTRAINT fpk_condition_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.condition_occurrence ADD CONSTRAINT fpk_condition_concept FOREIGN KEY (condition_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.condition_occurrence ADD CONSTRAINT fpk_condition_type_concept FOREIGN KEY (condition_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.condition_occurrence ADD CONSTRAINT fpk_condition_status_concept FOREIGN KEY (condition_status_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.condition_occurrence ADD CONSTRAINT fpk_condition_provider FOREIGN KEY (provider_id)  REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.condition_occurrence ADD CONSTRAINT fpk_condition_visit FOREIGN KEY (visit_occurrence_id)  REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);

ALTER TABLE OHDSI.condition_occurrence ADD CONSTRAINT fpk_condition_v_detail FOREIGN KEY (visit_detail_id) REFERENCES OHDSI.visit_detail (visit_detail_id);

ALTER TABLE OHDSI.condition_occurrence ADD CONSTRAINT fpk_condition_concept_s FOREIGN KEY (condition_source_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_measurement_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_measurement_concept FOREIGN KEY (measurement_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_measurement_type_concept FOREIGN KEY (measurement_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_measurement_operator FOREIGN KEY (operator_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_measurement_value FOREIGN KEY (value_as_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_measurement_unit FOREIGN KEY (unit_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_measurement_provider FOREIGN KEY (provider_id)  REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_measurement_visit FOREIGN KEY (visit_occurrence_id)  REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);

ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_measurement_v_detail FOREIGN KEY (visit_detail_id) REFERENCES OHDSI.visit_detail (visit_detail_id);

ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_measurement_concept_s FOREIGN KEY (measurement_source_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.measurement ADD CONSTRAINT fpk_modifier_of_fld_concept FOREIGN KEY (modifier_of_field_concept_id) REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.note ADD CONSTRAINT fpk_note_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.note ADD CONSTRAINT fpk_note_type_concept FOREIGN KEY (note_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.note ADD CONSTRAINT fpk_note_class_concept FOREIGN KEY (note_class_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.note ADD CONSTRAINT fpk_note_encoding_concept FOREIGN KEY (encoding_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.note ADD CONSTRAINT fpk_language_concept FOREIGN KEY (language_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.note ADD CONSTRAINT fpk_note_provider FOREIGN KEY (provider_id)  REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.note ADD CONSTRAINT fpk_note_visit FOREIGN KEY (visit_occurrence_id)  REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);

ALTER TABLE OHDSI.note ADD CONSTRAINT fpk_note_v_detail FOREIGN KEY (visit_detail_id) REFERENCES OHDSI.visit_detail (visit_detail_id);


ALTER TABLE OHDSI.note_nlp ADD CONSTRAINT fpk_note_nlp_note FOREIGN KEY (note_id) REFERENCES OHDSI.note (note_id);

ALTER TABLE OHDSI.note_nlp ADD CONSTRAINT fpk_note_nlp_section_concept FOREIGN KEY (section_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.note_nlp ADD CONSTRAINT fpk_note_nlp_concept FOREIGN KEY (note_nlp_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.note_nlp ADD CONSTRAINT fpk_note_nlp_concept_s FOREIGN KEY (note_nlp_source_concept_id) REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.observation ADD CONSTRAINT fpk_observation_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.observation ADD CONSTRAINT fpk_observation_concept FOREIGN KEY (observation_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.observation ADD CONSTRAINT fpk_observation_type_concept FOREIGN KEY (observation_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.observation ADD CONSTRAINT fpk_observation_value FOREIGN KEY (value_as_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.observation ADD CONSTRAINT fpk_observation_qualifier FOREIGN KEY (qualifier_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.observation ADD CONSTRAINT fpk_observation_unit FOREIGN KEY (unit_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.observation ADD CONSTRAINT fpk_observation_provider FOREIGN KEY (provider_id)  REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.observation ADD CONSTRAINT fpk_observation_visit FOREIGN KEY (visit_occurrence_id)  REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);

ALTER TABLE OHDSI.observation ADD CONSTRAint fpk_observation_v_detail FOREIGN KEY (visit_detail_id) REFERENCES OHDSI.visit_detail (visit_detail_id);

ALTER TABLE OHDSI.observation ADD CONSTRAINT fpk_observation_concept_s FOREIGN KEY (observation_source_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_survey_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_survey_concept FOREIGN KEY (survey_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_survey_provider FOREIGN KEY (provider_id) REFERENCES OHDSI.provider (provider_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_survey_assist FOREIGN KEY (assisted_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_respondent_type FOREIGN KEY (respondent_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_survey_timing FOREIGN KEY (timing_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_collection_method FOREIGN KEY (collection_method_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_survey_source FOREIGN KEY (survey_source_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_validation FOREIGN KEY (validated_survey_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_survey_visit FOREIGN KEY (visit_occurrence_id) REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_survey_v_detail FOREIGN KEY (visit_detail_id) REFERENCES OHDSI.visit_detail (visit_detail_id);

ALTER TABLE OHDSI.survey_conduct ADD CONSTRAINT fpk_response_visit FOREIGN KEY (response_visit_occurrence_id) REFERENCES OHDSI.visit_occurrence (visit_occurrence_id);


ALTER TABLE OHDSI.fact_relationship ADD CONSTRAINT fpk_fact_domain_1 FOREIGN KEY (domain_concept_id_1)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.fact_relationship ADD CONSTRAINT fpk_fact_domain_2 FOREIGN KEY (domain_concept_id_2)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.fact_relationship ADD CONSTRAINT fpk_fact_relationship FOREIGN KEY (relationship_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.episode ADD CONSTRAINT person_id_fk FOREIGN KEY (person_id) REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.episode ADD CONSTRAINT episode_concept_id_fk FOREIGN KEY (episode_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.episode ADD CONSTRAINT episode_object_concept_id_fk FOREIGN KEY (episode_object_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.episode ADD CONSTRAINT episode_parent_id_fk FOREIGN KEY (episode_parent_id) REFERENCES OHDSI.episode (episode_id);

ALTER TABLE OHDSI.episode ADD CONSTRAINT episode_source_concept_id_fk FOREIGN KEY (episode_source_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.episode ADD CONSTRAINT episode_type_concept_id_fk FOREIGN KEY (episode_type_concept_id) REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.episode_event ADD CONSTRAINT event_field_concept_id_fk FOREIGN KEY (event_field_concept_id) REFERENCES OHDSI.concept (concept_id);


/************************

Standardized health system data

************************/

ALTER TABLE OHDSI.location ADD CONSTRAINT fpk_region_concept FOREIGN KEY ( region_concept_id ) REFERENCES OHDSI.concept ( concept_id ) ;


ALTER TABLE OHDSI.location_history ADD CONSTRAINT fpk_location_history FOREIGN KEY ( location_id ) REFERENCES OHDSI.location ( location_id ) ;

ALTER TABLE OHDSI.location_history ADD CONSTRAINT fpk_relationship_type FOREIGN KEY (relationship_type_concept_id) REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.care_site ADD CONSTRAINT fpk_care_site_place FOREIGN KEY (place_of_service_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.care_site ADD CONSTRAINT fpk_care_site_location FOREIGN KEY (location_id)  REFERENCES OHDSI.location (location_id);


ALTER TABLE OHDSI.provider ADD CONSTRAINT fpk_provider_specialty FOREIGN KEY (specialty_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.provider ADD CONSTRAINT fpk_provider_care_site FOREIGN KEY (care_site_id)  REFERENCES OHDSI.care_site (care_site_id);

ALTER TABLE OHDSI.provider ADD CONSTRAINT fpk_provider_gender FOREIGN KEY (gender_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.provider ADD CONSTRAINT fpk_provider_specialty_s FOREIGN KEY (specialty_source_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.provider ADD CONSTRAINT fpk_provider_gender_s FOREIGN KEY (gender_source_concept_id)  REFERENCES OHDSI.concept (concept_id);



/************************

Standardized health economics

************************/

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_payer_plan_period FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_contract_person FOREIGN KEY (contract_person_id) REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_payer_concept FOREIGN KEY (payer_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_plan_concept_id FOREIGN KEY (plan_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_contract_concept FOREIGN KEY (contract_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_sponsor_concept FOREIGN KEY (sponsor_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_stop_reason_concept FOREIGN KEY (stop_reason_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_payer_s FOREIGN KEY (payer_source_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_plan_s FOREIGN KEY (plan_source_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_contract_s FOREIGN KEY (contract_source_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_sponsor_s FOREIGN KEY (sponsor_source_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.payer_plan_period ADD CONSTRAINT fpk_stop_reason_s FOREIGN KEY (stop_reason_source_concept_id) REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.cost ADD CONSTRAINT fpk_cost_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.cost ADD CONSTRAINT fpk_cost_concept FOREIGN KEY (cost_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.cost ADD CONSTRAINT fpk_cost_type FOREIGN KEY (cost_type_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.cost ADD CONSTRAINT fpk_cost_currency FOREIGN KEY (currency_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.cost ADD CONSTRAINT fpk_revenue_concept FOREIGN KEY (revenue_code_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.cost ADD CONSTRAINT fpk_drg_concept FOREIGN KEY (drg_concept_id) REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.cost ADD CONSTRAINT fpk_cost_s FOREIGN KEY (cost_source_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.cost ADD CONSTRAINT fpk_cost_period FOREIGN KEY (payer_plan_period_id)  REFERENCES OHDSI.payer_plan_period (payer_plan_period_id);


/************************

Standardized derived elements

************************/


ALTER TABLE OHDSI.drug_era ADD CONSTRAINT fpk_drug_era_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.drug_era ADD CONSTRAINT fpk_drug_era_concept FOREIGN KEY (drug_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.dose_era ADD CONSTRAINT fpk_dose_era_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.dose_era ADD CONSTRAINT fpk_dose_era_concept FOREIGN KEY (drug_concept_id)  REFERENCES OHDSI.concept (concept_id);

ALTER TABLE OHDSI.dose_era ADD CONSTRAINT fpk_dose_era_unit_concept FOREIGN KEY (unit_concept_id)  REFERENCES OHDSI.concept (concept_id);


ALTER TABLE OHDSI.condition_era ADD CONSTRAINT fpk_condition_era_person FOREIGN KEY (person_id)  REFERENCES OHDSI.person (person_id);

ALTER TABLE OHDSI.condition_era ADD CONSTRAINT fpk_condition_era_concept FOREIGN KEY (condition_concept_id)  REFERENCES OHDSI.concept (concept_id);


/************************
*************************
*************************
*************************

Unique constraints

*************************
*************************
*************************
************************/

ALTER TABLE OHDSI.concept_synonym ADD CONSTRAINT uq_concept_synonym UNIQUE (concept_id, concept_synonym_name, language_concept_id);

/************************
*************************
*************************
*************************

Check constraints

*************************
*************************
*************************
************************/

ALTER TABLE OHDSI.concept ADD CONSTRAINT chk_c_concept_name CHECK (concept_name <> '');

ALTER TABLE OHDSI.concept ADD CONSTRAINT chk_c_standard_concept CHECK (COALESCE(standard_concept,'C') in ('C','S'));

ALTER TABLE OHDSI.concept ADD CONSTRAINT chk_c_concept_code CHECK (concept_code <> '');

ALTER TABLE OHDSI.concept ADD CONSTRAINT chk_c_invalid_reason CHECK (COALESCE(invalid_reason,'D') in ('D','U'));


ALTER TABLE OHDSI.concept_relationship ADD CONSTRAINT chk_cr_invalid_reason CHECK (COALESCE(invalid_reason,'D')='D');


ALTER TABLE OHDSI.concept_synonym ADD CONSTRAINT chk_csyn_concept_synonym_name CHECK (concept_synonym_name <> '');
