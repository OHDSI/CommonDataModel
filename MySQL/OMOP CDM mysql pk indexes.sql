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


MySQL script to create the required primary keys and indices within the OMOP common data model, version 6.0

Original authors:  Patrick Ryan, Clair Blacketer
Derived from postgres OMOP CDM scripts. 

author:  Lieven Vaneeckhaute

description:  These primary keys and indices are considered a minimal requirement to ensure adequate performance of analyses.

Primary keys defined in original ddl definitions.

*************************/



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
CREATE INDEX idx_concept_code ON concept (concept_code ASC);
CREATE INDEX idx_concept_vocabluary_id ON concept (vocabulary_id ASC);
CREATE INDEX idx_concept_domain_id ON concept (domain_id ASC);
CREATE INDEX idx_concept_class_id ON concept (concept_class_id ASC);

CREATE UNIQUE INDEX idx_vocabulary_vocabulary_id  ON vocabulary  (vocabulary_id ASC);

CREATE UNIQUE INDEX idx_domain_domain_id  ON domain  (domain_id ASC);

CREATE UNIQUE INDEX idx_concept_class_class_id  ON concept_class  (concept_class_id ASC);

CREATE INDEX idx_concept_relationship_id_1 ON concept_relationship (concept_id_1 ASC);
CREATE INDEX idx_concept_relationship_id_2 ON concept_relationship (concept_id_2 ASC);
CREATE INDEX idx_concept_relationship_id_3 ON concept_relationship (relationship_id ASC);

CREATE UNIQUE INDEX idx_relationship_rel_id  ON relationship  (relationship_id ASC);
CREATE INDEX idx_concept_synonym_id  ON concept_synonym  (concept_id ASC);

CREATE INDEX idx_concept_ancestor_id_1  ON concept_ancestor  (ancestor_concept_id ASC);
CREATE INDEX idx_concept_ancestor_id_2 ON concept_ancestor (descendant_concept_id ASC);

CREATE INDEX idx_source_to_concept_map_id_3  ON source_to_concept_map  (target_concept_id ASC);
CREATE INDEX idx_source_to_concept_map_id_1 ON source_to_concept_map (source_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_id_2 ON source_to_concept_map (target_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_code ON source_to_concept_map (source_code ASC);

CREATE INDEX idx_drug_strength_id_1  ON drug_strength  (drug_concept_id ASC);
CREATE INDEX idx_drug_strength_id_2 ON drug_strength (ingredient_concept_id ASC);


/**************************

Standardized meta-data

***************************/





/************************

Standardized clinical data

************************/

CREATE UNIQUE INDEX idx_person_id  ON person  (person_id ASC);

CREATE INDEX idx_observation_period_id  ON observation_period  (person_id ASC);

CREATE INDEX idx_specimen_person_id  ON specimen  (person_id ASC);
CREATE INDEX idx_specimen_concept_id ON specimen (specimen_concept_id ASC);

CREATE INDEX idx_visit_person_id  ON visit_occurrence  (person_id ASC);
CREATE INDEX idx_visit_concept_id ON visit_occurrence (visit_concept_id ASC);

CREATE INDEX idx_visit_detail_person_id  ON visit_detail  (person_id ASC);
CREATE INDEX idx_visit_detail_concept_id ON visit_detail (visit_detail_concept_id ASC);

CREATE INDEX idx_procedure_person_id  ON procedure_occurrence  (person_id ASC);
CREATE INDEX idx_procedure_concept_id ON procedure_occurrence (procedure_concept_id ASC);
CREATE INDEX idx_procedure_visit_id ON procedure_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_drug_person_id  ON drug_exposure  (person_id ASC);
CREATE INDEX idx_drug_concept_id ON drug_exposure (drug_concept_id ASC);
CREATE INDEX idx_drug_visit_id ON drug_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_device_person_id  ON device_exposure  (person_id ASC);
CREATE INDEX idx_device_concept_id ON device_exposure (device_concept_id ASC);
CREATE INDEX idx_device_visit_id ON device_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_condition_person_id  ON condition_occurrence  (person_id ASC);
CREATE INDEX idx_condition_concept_id ON condition_occurrence (condition_concept_id ASC);
CREATE INDEX idx_condition_visit_id ON condition_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_measurement_person_id  ON measurement  (person_id ASC);
CREATE INDEX idx_measurement_concept_id ON measurement (measurement_concept_id ASC);
CREATE INDEX idx_measurement_visit_id ON measurement (visit_occurrence_id ASC);

CREATE INDEX idx_note_person_id  ON note  (person_id ASC);
CREATE INDEX idx_note_concept_id ON note (note_type_concept_id ASC);
CREATE INDEX idx_note_visit_id ON note (visit_occurrence_id ASC);

CREATE INDEX idx_note_nlp_note_id  ON note_nlp  (note_id ASC);
CREATE INDEX idx_note_nlp_concept_id ON note_nlp (note_nlp_concept_id ASC);

CREATE INDEX idx_observation_person_id  ON observation  (person_id ASC);
CREATE INDEX idx_observation_concept_id ON observation (observation_concept_id ASC);
CREATE INDEX idx_observation_visit_id ON observation (visit_occurrence_id ASC);

CREATE INDEX idx_survey_person_id  ON survey_conduct  (person_id ASC);

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

CREATE INDEX idx_cost_person_id  ON cost  (person_id ASC);


/************************

Standardized derived elements

************************/


CREATE INDEX idx_drug_era_person_id  ON drug_era  (person_id ASC);
CREATE INDEX idx_drug_era_concept_id ON drug_era (drug_concept_id ASC);

CREATE INDEX idx_dose_era_person_id  ON dose_era  (person_id ASC);
CREATE INDEX idx_dose_era_concept_id ON dose_era (drug_concept_id ASC);

CREATE INDEX idx_condition_era_person_id  ON condition_era  (person_id ASC);
CREATE INDEX idx_condition_era_concept_id ON condition_era (condition_concept_id ASC);

