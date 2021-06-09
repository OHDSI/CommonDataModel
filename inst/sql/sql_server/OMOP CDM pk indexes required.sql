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

 ####### #     # ####### ######      #####  ######  #     #            #####        ###      ######  #    #      ##       ###
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #     #      #   #     #     # #   #      #  #       #  #    # #####  #  ####  ######  ####
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #           #     #    #     # #  #        ##        #  ##   # #    # # #    # #      #
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######      #     #    ######  ###        ###        #  # #  # #    # # #      #####   ####
 #     # #     # #     # #          #       #     # #     #    #    # #     # ### #     #    #       #  #      #   # #     #  #  # # #    # # #      #           #
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ###  #   #     #       #   #     #    #      #  #   ## #    # # #    # #      #    #
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ###   ###      #       #    #     ###  #    ### #    # #####  #  ####  ######  ####


@targetdialect script to create the required primary keys and indices within the OMOP common data model, version 6.0

last revised: 30-Aug-2017

author:  Patrick Ryan, Clair Blacketer

description:  These primary keys and indices are considered a minimal requirement to ensure adequate performance of analyses.

*************************/


/************************
*************************
*************************
*************************

Primary key constraints

*************************
*************************
*************************
************************/



/************************

Standardized vocabulary

************************/



ALTER TABLE @cdmDatabaseSchema.concept ADD CONSTRAINT xpk_concept PRIMARY KEY NONCLUSTERED (concept_id);

ALTER TABLE @cdmDatabaseSchema.vocabulary ADD CONSTRAINT xpk_vocabulary PRIMARY KEY NONCLUSTERED (vocabulary_id);

ALTER TABLE @cdmDatabaseSchema.domain ADD CONSTRAINT xpk_domain PRIMARY KEY NONCLUSTERED (domain_id);

ALTER TABLE @cdmDatabaseSchema.concept_class ADD CONSTRAINT xpk_concept_class PRIMARY KEY NONCLUSTERED (concept_class_id);

ALTER TABLE @cdmDatabaseSchema.concept_relationship ADD CONSTRAINT xpk_concept_relationship PRIMARY KEY NONCLUSTERED (concept_id_1,concept_id_2,relationship_id);

ALTER TABLE @cdmDatabaseSchema.relationship ADD CONSTRAINT xpk_relationship PRIMARY KEY NONCLUSTERED (relationship_id);

ALTER TABLE @cdmDatabaseSchema.concept_ancestor ADD CONSTRAINT xpk_concept_ancestor PRIMARY KEY NONCLUSTERED (ancestor_concept_id,descendant_concept_id);

ALTER TABLE @cdmDatabaseSchema.source_to_concept_map ADD CONSTRAINT xpk_source_to_concept_map PRIMARY KEY NONCLUSTERED (source_vocabulary_id,target_concept_id,source_code,valid_end_date);

ALTER TABLE @cdmDatabaseSchema.drug_strength ADD CONSTRAINT xpk_drug_strength PRIMARY KEY NONCLUSTERED (drug_concept_id, ingredient_concept_id);


/**************************

Standardized meta-data

***************************/


/************************

Standardized clinical data

************************/


/**PRIMARY KEY NONCLUSTERED constraints**/

ALTER TABLE @cdmDatabaseSchema.person ADD CONSTRAINT xpk_person PRIMARY KEY NONCLUSTERED ( person_id ) ;

ALTER TABLE @cdmDatabaseSchema.observation_period ADD CONSTRAINT xpk_observation_period PRIMARY KEY NONCLUSTERED ( observation_period_id ) ;

ALTER TABLE @cdmDatabaseSchema.specimen ADD CONSTRAINT xpk_specimen PRIMARY KEY NONCLUSTERED ( specimen_id ) ;

ALTER TABLE @cdmDatabaseSchema.visit_occurrence ADD CONSTRAINT xpk_visit_occurrence PRIMARY KEY NONCLUSTERED ( visit_occurrence_id ) ;

ALTER TABLE @cdmDatabaseSchema.visit_detail ADD CONSTRAINT xpk_visit_detail PRIMARY KEY NONCLUSTERED ( visit_detail_id ) ;

ALTER TABLE @cdmDatabaseSchema.procedure_occurrence ADD CONSTRAINT xpk_procedure_occurrence PRIMARY KEY NONCLUSTERED ( procedure_occurrence_id ) ;

ALTER TABLE @cdmDatabaseSchema.drug_exposure ADD CONSTRAINT xpk_drug_exposure PRIMARY KEY NONCLUSTERED ( drug_exposure_id ) ;

ALTER TABLE @cdmDatabaseSchema.device_exposure ADD CONSTRAINT xpk_device_exposure PRIMARY KEY NONCLUSTERED ( device_exposure_id ) ;

ALTER TABLE @cdmDatabaseSchema.condition_occurrence ADD CONSTRAINT xpk_condition_occurrence PRIMARY KEY NONCLUSTERED ( condition_occurrence_id ) ;

ALTER TABLE @cdmDatabaseSchema.measurement ADD CONSTRAINT xpk_measurement PRIMARY KEY NONCLUSTERED ( measurement_id ) ;

ALTER TABLE @cdmDatabaseSchema.note ADD CONSTRAINT xpk_note PRIMARY KEY NONCLUSTERED ( note_id ) ;

ALTER TABLE @cdmDatabaseSchema.note_nlp ADD CONSTRAINT xpk_note_nlp PRIMARY KEY NONCLUSTERED ( note_nlp_id ) ;

ALTER TABLE @cdmDatabaseSchema.observation  ADD CONSTRAINT xpk_observation PRIMARY KEY NONCLUSTERED ( observation_id ) ;

ALTER TABLE @cdmDatabaseSchema.survey_conduct ADD CONSTRAINT xpk_survey PRIMARY KEY NONCLUSTERED ( survey_conduct_id ) ;

ALTER TABLE @cdmDatabaseSchema.episode ADD CONSTRAINT episode_pk PRIMARY KEY NONCLUSTERED ( episode_id);

ALTER TABLE @cdmDatabaseSchema.episode_event ADD CONSTRAINT episode_event_pk PRIMARY KEY NONCLUSTERED ( episode_id, event_id, event_field_concept_id );


/************************

Standardized health system data

************************/


ALTER TABLE @cdmDatabaseSchema.location ADD CONSTRAINT xpk_location PRIMARY KEY NONCLUSTERED ( location_id ) ;

ALTER TABLE @cdmDatabaseSchema.location_history ADD CONSTRAINT xpk_location_history PRIMARY KEY NONCLUSTERED ( location_history_id ) ;

ALTER TABLE @cdmDatabaseSchema.care_site ADD CONSTRAINT xpk_care_site PRIMARY KEY NONCLUSTERED ( care_site_id ) ;

ALTER TABLE @cdmDatabaseSchema.provider ADD CONSTRAINT xpk_provider PRIMARY KEY NONCLUSTERED ( provider_id ) ;



/************************

Standardized health economics

************************/


ALTER TABLE @cdmDatabaseSchema.payer_plan_period ADD CONSTRAINT xpk_payer_plan_period PRIMARY KEY NONCLUSTERED ( payer_plan_period_id ) ;

ALTER TABLE @cdmDatabaseSchema.cost ADD CONSTRAINT xpk_visit_cost PRIMARY KEY NONCLUSTERED ( cost_id ) ;


/************************

Standardized derived elements

************************/

ALTER TABLE @cdmDatabaseSchema.drug_era ADD CONSTRAINT xpk_drug_era PRIMARY KEY NONCLUSTERED ( drug_era_id ) ;

ALTER TABLE @cdmDatabaseSchema.dose_era  ADD CONSTRAINT xpk_dose_era PRIMARY KEY NONCLUSTERED ( dose_era_id ) ;

ALTER TABLE @cdmDatabaseSchema.condition_era ADD CONSTRAINT xpk_condition_era PRIMARY KEY NONCLUSTERED ( condition_era_id ) ;


/************************
*************************
*************************
*************************

Indices

*************************
*************************
*************************
************************/

/************************

Standardized vocabulary

************************/

CREATE UNIQUE CLUSTERED INDEX idx_concept_concept_id ON @cdmDatabaseSchema.concept (concept_id ASC);
CREATE INDEX idx_concept_code ON @cdmDatabaseSchema.concept (concept_code ASC);
CREATE INDEX idx_concept_vocabluary_id ON @cdmDatabaseSchema.concept (vocabulary_id ASC);
CREATE INDEX idx_concept_domain_id ON @cdmDatabaseSchema.concept (domain_id ASC);
CREATE INDEX idx_concept_class_id ON @cdmDatabaseSchema.concept (concept_class_id ASC);

CREATE UNIQUE CLUSTERED INDEX idx_vocabulary_vocabulary_id ON @cdmDatabaseSchema.vocabulary (vocabulary_id ASC);

CREATE UNIQUE CLUSTERED INDEX idx_domain_domain_id ON @cdmDatabaseSchema.domain (domain_id ASC);

CREATE UNIQUE CLUSTERED INDEX idx_concept_class_class_id ON @cdmDatabaseSchema.concept_class (concept_class_id ASC);

CREATE INDEX idx_concept_relationship_id_1 ON @cdmDatabaseSchema.concept_relationship (concept_id_1 ASC);
CREATE INDEX idx_concept_relationship_id_2 ON @cdmDatabaseSchema.concept_relationship (concept_id_2 ASC);
CREATE INDEX idx_concept_relationship_id_3 ON @cdmDatabaseSchema.concept_relationship (relationship_id ASC);

CREATE UNIQUE CLUSTERED INDEX idx_relationship_rel_id ON @cdmDatabaseSchema.relationship (relationship_id ASC);

CREATE CLUSTERED INDEX idx_concept_synonym_id ON @cdmDatabaseSchema.concept_synonym (concept_id ASC);

CREATE CLUSTERED INDEX idx_concept_ancestor_id_1 ON @cdmDatabaseSchema.concept_ancestor (ancestor_concept_id ASC);
CREATE INDEX idx_concept_ancestor_id_2 ON @cdmDatabaseSchema.concept_ancestor (descendant_concept_id ASC);

CREATE CLUSTERED INDEX idx_source_to_concept_map_3 ON @cdmDatabaseSchema.source_to_concept_map (target_concept_id ASC);
CREATE INDEX idx_source_to_concept_map_1 ON @cdmDatabaseSchema.source_to_concept_map (source_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_2 ON @cdmDatabaseSchema.source_to_concept_map (target_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_c ON @cdmDatabaseSchema.source_to_concept_map (source_code ASC);

CREATE CLUSTERED INDEX idx_drug_strength_id_1 ON @cdmDatabaseSchema.drug_strength (drug_concept_id ASC);
CREATE INDEX idx_drug_strength_id_2 ON @cdmDatabaseSchema.drug_strength (ingredient_concept_id ASC);


/**************************

Standardized meta-data

***************************/

CREATE INDEX idx_metadata_concept_id_1 ON @cdmDatabaseSchema.metadata (metadata_concept_id ASC);

/************************

Standardized clinical data

************************/

CREATE UNIQUE CLUSTERED INDEX idx_person_id ON @cdmDatabaseSchema.person (person_id ASC);

CREATE CLUSTERED INDEX idx_observation_period_id_1 ON @cdmDatabaseSchema.observation_period (person_id ASC);

CREATE CLUSTERED INDEX idx_specimen_person_id_1 ON @cdmDatabaseSchema.specimen (person_id ASC);
CREATE INDEX idx_specimen_concept_id_1 ON @cdmDatabaseSchema.specimen (specimen_concept_id ASC);

CREATE CLUSTERED INDEX idx_visit_person_id_1 ON @cdmDatabaseSchema.visit_occurrence (person_id ASC);
CREATE INDEX idx_visit_concept_id_1 ON @cdmDatabaseSchema.visit_occurrence (visit_concept_id ASC);

CREATE CLUSTERED INDEX idx_visit_det_person_id_1 ON @cdmDatabaseSchema.visit_detail (person_id ASC);
CREATE INDEX idx_visit_det_concept_id_1 ON @cdmDatabaseSchema.visit_detail (visit_detail_concept_id ASC);

CREATE CLUSTERED INDEX idx_procedure_person_id_1 ON @cdmDatabaseSchema.procedure_occurrence (person_id ASC);
CREATE INDEX idx_procedure_concept_id_1 ON @cdmDatabaseSchema.procedure_occurrence (procedure_concept_id ASC);
CREATE INDEX idx_procedure_visit_id_1 ON @cdmDatabaseSchema.procedure_occurrence (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_drug_person_id_1 ON @cdmDatabaseSchema.drug_exposure (person_id ASC);
CREATE INDEX idx_drug_concept_id_1 ON @cdmDatabaseSchema.drug_exposure (drug_concept_id ASC);
CREATE INDEX idx_drug_visit_id_1 ON @cdmDatabaseSchema.drug_exposure (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_device_person_id_1 ON @cdmDatabaseSchema.device_exposure (person_id ASC);
CREATE INDEX idx_device_concept_id_1 ON @cdmDatabaseSchema.device_exposure (device_concept_id ASC);
CREATE INDEX idx_device_visit_id_1 ON @cdmDatabaseSchema.device_exposure (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_condition_person_id_1 ON @cdmDatabaseSchema.condition_occurrence (person_id ASC);
CREATE INDEX idx_condition_concept_id_1 ON @cdmDatabaseSchema.condition_occurrence (condition_concept_id ASC);
CREATE INDEX idx_condition_visit_id_1 ON @cdmDatabaseSchema.condition_occurrence (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_measurement_person_id_1 ON @cdmDatabaseSchema.measurement (person_id ASC);
CREATE INDEX idx_measurement_concept_id_1 ON @cdmDatabaseSchema.measurement (measurement_concept_id ASC);
CREATE INDEX idx_measurement_visit_id_1 ON @cdmDatabaseSchema.measurement (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_note_person_id_1 ON @cdmDatabaseSchema.note (person_id ASC);
CREATE INDEX idx_note_concept_id_1 ON @cdmDatabaseSchema.note (note_type_concept_id ASC);
CREATE INDEX idx_note_visit_id_1 ON @cdmDatabaseSchema.note (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_note_nlp_note_id_1 ON @cdmDatabaseSchema.note_nlp (note_id ASC);
CREATE INDEX idx_note_nlp_concept_id_1 ON @cdmDatabaseSchema.note_nlp (note_nlp_concept_id ASC);

CREATE CLUSTERED INDEX idx_observation_person_id_1 ON @cdmDatabaseSchema.observation (person_id ASC);
CREATE INDEX idx_observation_concept_id_1 ON @cdmDatabaseSchema.observation (observation_concept_id ASC);
CREATE INDEX idx_observation_visit_id_1 ON @cdmDatabaseSchema.observation (visit_occurrence_id ASC);

CREATE CLUSTERED INDEX idx_survey_person_id_1 ON @cdmDatabaseSchema.survey_conduct (person_id ASC);

CREATE INDEX idx_fact_relationship_id1 ON @cdmDatabaseSchema.fact_relationship (domain_concept_id_1 ASC);
CREATE INDEX idx_fact_relationship_id2 ON @cdmDatabaseSchema.fact_relationship (domain_concept_id_2 ASC);
CREATE INDEX idx_fact_relationship_id3 ON @cdmDatabaseSchema.fact_relationship (relationship_concept_id ASC);

CREATE CLUSTERED INDEX idx_episode_person_id_1 ON @cdmDatabaseSchema.episode (person_id ASC);
CREATE INDEX idx_episode_concept_id_1 ON @cdmDatabaseSchema.episode (episode_concept_id ASC);

CREATE CLUSTERED INDEX idx_episode_event_id_1 ON @cdmDatabaseSchema.episode_event (episode_id ASC);
CREATE INDEX idx_ee_field_concept_id_1 ON @cdmDatabaseSchema.episode_event (event_field_concept_id ASC);

/************************

Standardized health system data

************************/





/************************

Standardized health economics

************************/

CREATE CLUSTERED INDEX idx_period_person_id_1 ON @cdmDatabaseSchema.payer_plan_period (person_id ASC);

CREATE CLUSTERED INDEX idx_cost_person_id_1 ON @cdmDatabaseSchema.cost (person_id ASC);


/************************

Standardized derived elements

************************/


CREATE CLUSTERED INDEX idx_drug_era_person_id_1 ON @cdmDatabaseSchema.drug_era (person_id ASC);
CREATE INDEX idx_drug_era_concept_id_1 ON @cdmDatabaseSchema.drug_era (drug_concept_id ASC);

CREATE CLUSTERED INDEX idx_dose_era_person_id_1 ON @cdmDatabaseSchema.dose_era (person_id ASC);
CREATE INDEX idx_dose_era_concept_id_1 ON @cdmDatabaseSchema.dose_era (drug_concept_id ASC);

CREATE CLUSTERED INDEX idx_condition_era_person_id_1 ON @cdmDatabaseSchema.condition_era (person_id ASC);
CREATE INDEX idx_condition_era_concept_id_1 ON @cdmDatabaseSchema.condition_era (condition_concept_id ASC);

