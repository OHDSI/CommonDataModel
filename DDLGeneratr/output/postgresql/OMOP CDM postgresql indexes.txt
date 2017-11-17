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

 ####### #     # ####### ######      #####  ######  #     #           #######      #####     ###
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #           #     #     #  #    # #####  ###### #    # ######  ####
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #                 #     #  ##   # #    # #       #  #  #      #
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######       #####      #  # #  # #    # #####    ##   #####   ####
 #     # #     # #     # #          #       #     # #     #    #    #       # ###       #     #  #  # # #    # #        ##   #           #
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ### #     #     #  #   ## #    # #       #  #  #      #    #
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ###  #####     ### #    # #####  ###### #    # ######  ####


postgresql script to create the required indexes within OMOP common data model, version 5.3

last revised: 14-November-2017

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



ALTER TABLE concept ADD CONSTRAINT xpk_concept PRIMARY KEY (concept_id);

ALTER TABLE vocabulary ADD CONSTRAINT xpk_vocabulary PRIMARY KEY (vocabulary_id);

ALTER TABLE domain ADD CONSTRAINT xpk_domain PRIMARY KEY (domain_id);

ALTER TABLE concept_class ADD CONSTRAINT xpk_concept_class PRIMARY KEY (concept_class_id);

ALTER TABLE concept_relationship ADD CONSTRAINT xpk_concept_relationship PRIMARY KEY (concept_id_1,concept_id_2,relationship_id);

ALTER TABLE relationship ADD CONSTRAINT xpk_relationship PRIMARY KEY (relationship_id);

ALTER TABLE concept_ancestor ADD CONSTRAINT xpk_concept_ancestor PRIMARY KEY (ancestor_concept_id,descendant_concept_id);

ALTER TABLE source_to_concept_map ADD CONSTRAINT xpk_source_to_concept_map PRIMARY KEY (source_vocabulary_id,target_concept_id,source_code,valid_end_date);

ALTER TABLE drug_strength ADD CONSTRAINT xpk_drug_strength PRIMARY KEY (drug_concept_id, ingredient_concept_id);

ALTER TABLE cohort_definition ADD CONSTRAINT xpk_cohort_definition PRIMARY KEY (cohort_definition_id);

ALTER TABLE attribute_definition ADD CONSTRAINT xpk_attribute_definition PRIMARY KEY (attribute_definition_id);


/**************************

Standardized meta-data

***************************/



/************************

Standardized clinical data

************************/


/**PRIMARY KEY NONCLUSTERED constraints**/

ALTER TABLE person ADD CONSTRAINT xpk_person PRIMARY KEY ( person_id ) ;

ALTER TABLE observation_period ADD CONSTRAINT xpk_observation_period PRIMARY KEY ( observation_period_id ) ;

ALTER TABLE specimen ADD CONSTRAINT xpk_specimen PRIMARY KEY ( specimen_id ) ;

ALTER TABLE death ADD CONSTRAINT xpk_death PRIMARY KEY ( person_id ) ;

ALTER TABLE visit_occurrence ADD CONSTRAINT xpk_visit_occurrence PRIMARY KEY ( visit_occurrence_id ) ;

ALTER TABLE visit_detail ADD CONSTRAINT xpk_visit_detail PRIMARY KEY ( visit_detail_id ) ;

ALTER TABLE procedure_occurrence ADD CONSTRAINT xpk_procedure_occurrence PRIMARY KEY ( procedure_occurrence_id ) ;

ALTER TABLE drug_exposure ADD CONSTRAINT xpk_drug_exposure PRIMARY KEY ( drug_exposure_id ) ;

ALTER TABLE device_exposure ADD CONSTRAINT xpk_device_exposure PRIMARY KEY ( device_exposure_id ) ;

ALTER TABLE condition_occurrence ADD CONSTRAINT xpk_condition_occurrence PRIMARY KEY ( condition_occurrence_id ) ;

ALTER TABLE measurement ADD CONSTRAINT xpk_measurement PRIMARY KEY ( measurement_id ) ;

ALTER TABLE note ADD CONSTRAINT xpk_note PRIMARY KEY ( note_id ) ;

ALTER TABLE note_nlp ADD CONSTRAINT xpk_note_nlp PRIMARY KEY ( note_nlp_id ) ;

ALTER TABLE observation  ADD CONSTRAINT xpk_observation PRIMARY KEY ( observation_id ) ;




/************************

Standardized health system data

************************/


ALTER TABLE location ADD CONSTRAINT xpk_location PRIMARY KEY ( location_id ) ;

ALTER TABLE care_site ADD CONSTRAINT xpk_care_site PRIMARY KEY ( care_site_id ) ;

ALTER TABLE provider ADD CONSTRAINT xpk_provider PRIMARY KEY ( provider_id ) ;



/************************

Standardized health economics

************************/


ALTER TABLE payer_plan_period ADD CONSTRAINT xpk_payer_plan_period PRIMARY KEY ( payer_plan_period_id ) ;

ALTER TABLE cost ADD CONSTRAINT xpk_visit_cost PRIMARY KEY ( cost_id ) ;


/************************

Standardized derived elements

************************/

ALTER TABLE cohort ADD CONSTRAINT xpk_cohort PRIMARY KEY ( cohort_definition_id, subject_id, cohort_start_date, cohort_end_date  ) ;

ALTER TABLE cohort_attribute ADD CONSTRAINT xpk_cohort_attribute PRIMARY KEY ( cohort_definition_id, subject_id, cohort_start_date, cohort_end_date, attribute_definition_id ) ;

ALTER TABLE drug_era ADD CONSTRAINT xpk_drug_era PRIMARY KEY ( drug_era_id ) ;

ALTER TABLE dose_era  ADD CONSTRAINT xpk_dose_era PRIMARY KEY ( dose_era_id ) ;

ALTER TABLE condition_era ADD CONSTRAINT xpk_condition_era PRIMARY KEY ( condition_era_id ) ;


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

CREATE UNIQUE INDEX idx_concept_concept_id  ON concept  (concept_id ASC);
CLUSTER concept  USING idx_concept_concept_id ;
CREATE INDEX idx_concept_code ON concept (concept_code ASC);
CREATE INDEX idx_concept_vocabluary_id ON concept (vocabulary_id ASC);
CREATE INDEX idx_concept_domain_id ON concept (domain_id ASC);
CREATE INDEX idx_concept_class_id ON concept (concept_class_id ASC);

CREATE UNIQUE INDEX idx_vocabulary_vocabulary_id  ON vocabulary  (vocabulary_id ASC);
CLUSTER vocabulary  USING idx_vocabulary_vocabulary_id ;

CREATE UNIQUE INDEX idx_domain_domain_id  ON domain  (domain_id ASC);
CLUSTER domain  USING idx_domain_domain_id ;

CREATE UNIQUE INDEX idx_concept_class_class_id  ON concept_class  (concept_class_id ASC);
CLUSTER concept_class  USING idx_concept_class_class_id ;

CREATE INDEX idx_concept_relationship_id_1 ON concept_relationship (concept_id_1 ASC);
CREATE INDEX idx_concept_relationship_id_2 ON concept_relationship (concept_id_2 ASC);
CREATE INDEX idx_concept_relationship_id_3 ON concept_relationship (relationship_id ASC);

CREATE UNIQUE INDEX idx_relationship_rel_id  ON relationship  (relationship_id ASC);
CLUSTER relationship  USING idx_relationship_rel_id ;

CREATE INDEX idx_concept_synonym_id  ON concept_synonym  (concept_id ASC);
CLUSTER concept_synonym  USING idx_concept_synonym_id ;

CREATE INDEX idx_concept_ancestor_id_1  ON concept_ancestor  (ancestor_concept_id ASC);
CLUSTER concept_ancestor  USING idx_concept_ancestor_id_1 ;
CREATE INDEX idx_concept_ancestor_id_2 ON concept_ancestor (descendant_concept_id ASC);

CREATE INDEX idx_source_to_concept_map_id_3  ON source_to_concept_map  (target_concept_id ASC);
CLUSTER source_to_concept_map  USING idx_source_to_concept_map_id_3 ;
CREATE INDEX idx_source_to_concept_map_id_1 ON source_to_concept_map (source_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_id_2 ON source_to_concept_map (target_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_code ON source_to_concept_map (source_code ASC);

CREATE INDEX idx_drug_strength_id_1  ON drug_strength  (drug_concept_id ASC);
CLUSTER drug_strength  USING idx_drug_strength_id_1 ;
CREATE INDEX idx_drug_strength_id_2 ON drug_strength (ingredient_concept_id ASC);

CREATE INDEX idx_cohort_definition_id  ON cohort_definition  (cohort_definition_id ASC);
CLUSTER cohort_definition  USING idx_cohort_definition_id ;

CREATE INDEX idx_attribute_definition_id  ON attribute_definition  (attribute_definition_id ASC);
CLUSTER attribute_definition  USING idx_attribute_definition_id ;


/**************************

Standardized meta-data

***************************/





/************************

Standardized clinical data

************************/

CREATE UNIQUE INDEX idx_person_id  ON person  (person_id ASC);
CLUSTER person  USING idx_person_id ;

CREATE INDEX idx_observation_period_id  ON observation_period  (person_id ASC);
CLUSTER observation_period  USING idx_observation_period_id ;

CREATE INDEX idx_specimen_person_id  ON specimen  (person_id ASC);
CLUSTER specimen  USING idx_specimen_person_id ;
CREATE INDEX idx_specimen_concept_id ON specimen (specimen_concept_id ASC);

CREATE INDEX idx_death_person_id  ON death  (person_id ASC);
CLUSTER death  USING idx_death_person_id ;

CREATE INDEX idx_visit_person_id  ON visit_occurrence  (person_id ASC);
CLUSTER visit_occurrence  USING idx_visit_person_id ;
CREATE INDEX idx_visit_concept_id ON visit_occurrence (visit_concept_id ASC);

CREATE INDEX idx_visit_detail_person_id  ON visit_detail  (person_id ASC);
CLUSTER visit_detail  USING idx_visit_detail_person_id ;
CREATE INDEX idx_visit_detail_concept_id ON visit_detail (visit_detail_concept_id ASC);

CREATE INDEX idx_procedure_person_id  ON procedure_occurrence  (person_id ASC);
CLUSTER procedure_occurrence  USING idx_procedure_person_id ;
CREATE INDEX idx_procedure_concept_id ON procedure_occurrence (procedure_concept_id ASC);
CREATE INDEX idx_procedure_visit_id ON procedure_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_drug_person_id  ON drug_exposure  (person_id ASC);
CLUSTER drug_exposure  USING idx_drug_person_id ;
CREATE INDEX idx_drug_concept_id ON drug_exposure (drug_concept_id ASC);
CREATE INDEX idx_drug_visit_id ON drug_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_device_person_id  ON device_exposure  (person_id ASC);
CLUSTER device_exposure  USING idx_device_person_id ;
CREATE INDEX idx_device_concept_id ON device_exposure (device_concept_id ASC);
CREATE INDEX idx_device_visit_id ON device_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_condition_person_id  ON condition_occurrence  (person_id ASC);
CLUSTER condition_occurrence  USING idx_condition_person_id ;
CREATE INDEX idx_condition_concept_id ON condition_occurrence (condition_concept_id ASC);
CREATE INDEX idx_condition_visit_id ON condition_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_measurement_person_id  ON measurement  (person_id ASC);
CLUSTER measurement  USING idx_measurement_person_id ;
CREATE INDEX idx_measurement_concept_id ON measurement (measurement_concept_id ASC);
CREATE INDEX idx_measurement_visit_id ON measurement (visit_occurrence_id ASC);

CREATE INDEX idx_note_person_id  ON note  (person_id ASC);
CLUSTER note  USING idx_note_person_id ;
CREATE INDEX idx_note_concept_id ON note (note_type_concept_id ASC);
CREATE INDEX idx_note_visit_id ON note (visit_occurrence_id ASC);

CREATE INDEX idx_note_nlp_note_id  ON note_nlp  (note_id ASC);
CLUSTER note_nlp  USING idx_note_nlp_note_id ;
CREATE INDEX idx_note_nlp_concept_id ON note_nlp (note_nlp_concept_id ASC);

CREATE INDEX idx_observation_person_id  ON observation  (person_id ASC);
CLUSTER observation  USING idx_observation_person_id ;
CREATE INDEX idx_observation_concept_id ON observation (observation_concept_id ASC);
CREATE INDEX idx_observation_visit_id ON observation (visit_occurrence_id ASC);

CREATE INDEX idx_fact_relationship_id_1 ON fact_relationship (domain_concept_id_1 ASC);
CREATE INDEX idx_fact_relationship_id_2 ON fact_relationship (domain_concept_id_2 ASC);
CREATE INDEX idx_fact_relationship_id_3 ON fact_relationship (relationship_concept_id ASC);



/************************

Standardized health system data

************************/





/************************

Standardized health economics

************************/

CREATE INDEX idx_period_person_id  ON payer_plan_period  (person_id ASC);
CLUSTER payer_plan_period  USING idx_period_person_id ;





/************************

Standardized derived elements

************************/


CREATE INDEX idx_cohort_subject_id ON cohort (subject_id ASC);
CREATE INDEX idx_cohort_c_definition_id ON cohort (cohort_definition_id ASC);

CREATE INDEX idx_ca_subject_id ON cohort_attribute (subject_id ASC);
CREATE INDEX idx_ca_definition_id ON cohort_attribute (cohort_definition_id ASC);

CREATE INDEX idx_drug_era_person_id  ON drug_era  (person_id ASC);
CLUSTER drug_era  USING idx_drug_era_person_id ;
CREATE INDEX idx_drug_era_concept_id ON drug_era (drug_concept_id ASC);

CREATE INDEX idx_dose_era_person_id  ON dose_era  (person_id ASC);
CLUSTER dose_era  USING idx_dose_era_person_id ;
CREATE INDEX idx_dose_era_concept_id ON dose_era (drug_concept_id ASC);

CREATE INDEX idx_condition_era_person_id  ON condition_era  (person_id ASC);
CLUSTER condition_era  USING idx_condition_era_person_id ;
CREATE INDEX idx_condition_era_concept_id ON condition_era (condition_concept_id ASC);

