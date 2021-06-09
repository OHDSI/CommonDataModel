/*********************************************************************************
# Copyright 2018-08 Observational Health Data Sciences and Informatics
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

 ####### #     # ####### ######      #####  ######  #     #            #####        ###
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #     #      #   #
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #           #     #
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######      #     #
 #     # #     # #     # #          #       #     # #     #    #    # #     # ### #     #
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ###  #   #
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ###   ###

impala script to create OMOP common data model version 6.0

last revised: 27-Aug-2018

Authors:  Patrick Ryan, Christian Reich, Clair Blacketer


*************************/


/************************

Standardized vocabulary

************************/


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.concept (
  concept_id			      INTEGER			NOT NULL ,
  concept_name			  	VARCHAR(255) ,
  domain_id				      VARCHAR(20) ,
  vocabulary_id			  	VARCHAR(20) ,
  concept_class_id			VARCHAR(20) ,
  standard_concept			VARCHAR(1) ,
  concept_code			  	VARCHAR(50) ,
  valid_start_date			TIMESTAMP ,
  valid_end_date		  	TIMESTAMP ,
  invalid_reason		  	VARCHAR(1)
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.vocabulary (
  vocabulary_id			      VARCHAR(20),
  vocabulary_name		      VARCHAR(255),
  vocabulary_reference		VARCHAR(255),
  vocabulary_version	  	VARCHAR(255),
  vocabulary_concept_id		INTEGER			NOT NULL
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.domain (
  domain_id			      VARCHAR(20),
  domain_name		      VARCHAR(255),
  domain_concept_id		INTEGER			NOT NULL
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.concept_class (
  concept_class_id			      VARCHAR(20),
  concept_class_name		      VARCHAR(255),
  concept_class_concept_id		INTEGER			NOT NULL
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.concept_relationship (
  concept_id_1			  INTEGER			NOT NULL,
  concept_id_2			  INTEGER			NOT NULL,
  relationship_id		  VARCHAR(20),
  valid_start_date		TIMESTAMP,
  valid_end_date		  TIMESTAMP,
  invalid_reason		  VARCHAR(1)
  )
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.relationship (
  relationship_id			  VARCHAR(20),
  relationship_name			  VARCHAR(255),
  is_hierarchical			    VARCHAR(1),
  defines_ancestry			  VARCHAR(1),
  reverse_relationship_id	VARCHAR(20),
  relationship_concept_id	INTEGER			  NOT NULL
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.concept_synonym (
  concept_id			        INTEGER		    NOT NULL,
  concept_synonym_name	  VARCHAR(1000),
  language_concept_id	    INTEGER		    NOT NULL
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.concept_ancestor (
  ancestor_concept_id		      INTEGER		NOT NULL,
  descendant_concept_id		  	INTEGER		NOT NULL,
  min_levels_of_separation		INTEGER		NOT NULL,
  max_levels_of_separation		INTEGER		NOT NULL
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.source_to_concept_map (
  source_code				  	    VARCHAR(50),
  source_concept_id			  	INTEGER			  NOT NULL,
  source_vocabulary_id			VARCHAR(20),
  source_code_description		VARCHAR(255),
  target_concept_id			  	INTEGER			  NOT NULL,
  target_vocabulary_id			VARCHAR(20),
  valid_start_date			  	TIMESTAMP,
  valid_end_date			      TIMESTAMP,
  invalid_reason			      VARCHAR(1)
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.drug_strength (
  drug_concept_id				      INTEGER		  NOT NULL,
  ingredient_concept_id			  INTEGER		  NOT NULL,
  amount_value					      FLOAT,
  amount_unit_concept_id		  INTEGER		  NULL,
  numerator_value				      FLOAT,
  numerator_unit_concept_id		INTEGER		  NULL,
  denominator_value				    FLOAT,
  denominator_unit_concept_id	INTEGER		  NULL,
  box_size						        INTEGER		  NULL,
  valid_start_date				    TIMESTAMP,
  valid_end_date				      TIMESTAMP,
  invalid_reason				      VARCHAR(1)
)
;


/**************************

Standardized meta-data

***************************/


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.cdm_source
(
  cdm_source_name					        VARCHAR(255) ,
  cdm_source_abbreviation			    VARCHAR(25) ,
  cdm_holder						          VARCHAR(255) ,
  source_description				      VARCHAR(MAX) ,
  source_documentation_reference	VARCHAR(255) ,
  cdm_etl_reference					      VARCHAR(255) ,
  source_release_date				      TIMESTAMP ,
  cdm_release_date					      TIMESTAMP ,
  cdm_version						          VARCHAR(10) ,
  vocabulary_version				      VARCHAR(20)
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.metadata
(
  metadata_concept_id       INTEGER       NOT NULL ,
  metadata_type_concept_id  INTEGER       NOT NULL ,
  name                      VARCHAR(250) ,
  value_as_string           VARCHAR(MAX) ,
  value_as_concept_id       INTEGER       NULL ,
  metadata_date             TIMESTAMP ,
  metadata_datetime         TIMESTAMP
)
;

INSERT INTO ohdsi.metadata (metadata_concept_id, metadata_type_concept_id, name, value_as_string, value_as_concept_id, metadata_date, metadata_datetime) --Added cdm version record
VALUES (0,0,'CDM Version', '6.0',0,NULL,NULL)
;


/************************

Standardized clinical data

************************/


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.person
(
  person_id						        BIGINT ,
  gender_concept_id				    INTEGER	  	  NOT NULL ,
  year_of_birth					      INTEGER	  	  NOT NULL ,
  month_of_birth				      INTEGER	  	  NULL,
  day_of_birth					      INTEGER	  	  NULL,
  birth_datetime				      TIMESTAMP,
  death_datetime					    TIMESTAMP,
  race_concept_id				      INTEGER		    NOT NULL,
  ethnicity_concept_id			  INTEGER	  	  NOT NULL,
  location_id					        BIGINT,
  provider_id					        BIGINT,
  care_site_id					      BIGINT,
  person_source_value			    VARCHAR(50),
  gender_source_value			    VARCHAR(50),
  gender_source_concept_id    INTEGER		    NOT NULL,
  race_source_value				    VARCHAR(50),
  race_source_concept_id		  INTEGER		    NOT NULL,
  ethnicity_source_value		  VARCHAR(50),
  ethnicity_source_concept_id INTEGER		    NOT NULL
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.observation_period
(
  observation_period_id				  BIGINT ,
  person_id							        BIGINT ,
  observation_period_start_date	TIMESTAMP ,
  observation_period_end_date   TIMESTAMP ,
  period_type_concept_id			  INTEGER		NOT NULL
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.specimen
(
  specimen_id					        BIGINT ,
  person_id						        BIGINT ,
  specimen_concept_id			    INTEGER			  NOT NULL ,
  specimen_type_concept_id		INTEGER			  NOT NULL ,
  specimen_date					      TIMESTAMP ,
  specimen_datetime				    TIMESTAMP ,
  quantity						        FLOAT ,
  unit_concept_id				      INTEGER			  NULL ,
  anatomic_site_concept_id		INTEGER			  NOT NULL ,
  disease_status_concept_id		INTEGER			  NOT NULL ,
  specimen_source_id			    VARCHAR(50) ,
  specimen_source_value			  VARCHAR(50) ,
  unit_source_value				    VARCHAR(50) ,
  anatomic_site_source_value	VARCHAR(50) ,
  disease_status_source_value	VARCHAR(50)
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.visit_occurrence
(
  visit_occurrence_id			      BIGINT ,
  person_id						          BIGINT ,
  visit_concept_id				      INTEGER			  NOT NULL ,
  visit_start_date				      TIMESTAMP ,
  visit_start_datetime			    TIMESTAMP ,
  visit_end_date				        TIMESTAMP ,
  visit_end_datetime			      TIMESTAMP ,
  visit_type_concept_id			    INTEGER			  NOT NULL ,
  provider_id					          BIGINT,
  care_site_id					        BIGINT,
  visit_source_value			      VARCHAR(50),
  visit_source_concept_id		    INTEGER			  NOT NULL ,
  admitted_from_concept_id      INTEGER     	NOT NULL ,
  admitted_from_source_value    VARCHAR(50) ,
  discharge_to_source_value		  VARCHAR(50) ,
  discharge_to_concept_id		    INTEGER   		NOT NULL ,
  preceding_visit_occurrence_id	BIGINT
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.visit_detail
(
  visit_detail_id                    BIGINT ,
  person_id                          BIGINT ,
  visit_detail_concept_id            INTEGER     NOT NULL ,
  visit_detail_start_date            TIMESTAMP ,
  visit_detail_start_datetime        TIMESTAMP ,
  visit_detail_end_date              TIMESTAMP ,
  visit_detail_end_datetime          TIMESTAMP ,
  visit_detail_type_concept_id       INTEGER     NOT NULL ,
  provider_id                        BIGINT ,
  care_site_id                       BIGINT ,
  discharge_to_concept_id            INTEGER     NOT NULL ,
  admitted_from_concept_id           INTEGER     NOT NULL ,
  admitted_from_source_value         VARCHAR(50) ,
  visit_detail_source_value          VARCHAR(50) ,
  visit_detail_source_concept_id     INTEGER     NOT NULL ,
  discharge_to_source_value          VARCHAR(50) ,
  preceding_visit_detail_id          BIGINT ,
  visit_detail_parent_id             BIGINT ,
  visit_occurrence_id                BIGINT
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.procedure_occurrence
(
  procedure_occurrence_id		  BIGINT ,
  person_id						        BIGINT ,
  procedure_concept_id			  INTEGER			NOT NULL ,
  procedure_date				      TIMESTAMP ,
  procedure_datetime			    TIMESTAMP ,
  procedure_type_concept_id		INTEGER			NOT NULL ,
  modifier_concept_id			    INTEGER			NOT NULL ,
  quantity						        INTEGER			NULL ,
  provider_id					        BIGINT ,
  visit_occurrence_id			    BIGINT ,
  visit_detail_id             BIGINT ,
  procedure_source_value		  VARCHAR(50) ,
  procedure_source_concept_id	INTEGER			NOT NULL ,
  modifier_source_value		    VARCHAR(50)
)
;

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.drug_exposure
(
  drug_exposure_id				      BIGINT ,
  person_id						          BIGINT ,
  drug_concept_id				        INTEGER			  NOT NULL ,
  drug_exposure_start_date		  TIMESTAMP ,
  drug_exposure_start_datetime	TIMESTAMP ,
  drug_exposure_end_date		    TIMESTAMP ,
  drug_exposure_end_datetime	  TIMESTAMP ,
  verbatim_end_date				      TIMESTAMP ,
  drug_type_concept_id			    INTEGER			  NOT NULL ,
  stop_reason					          VARCHAR(20) ,
  refills						            INTEGER		  	NULL ,
  quantity						          FLOAT ,
  days_supply					          INTEGER		  	NULL ,
  sig							              VARCHAR(MAX) ,
  route_concept_id				      INTEGER			  NOT NULL ,
  lot_number					          VARCHAR(50) ,
  provider_id					          BIGINT ,
  visit_occurrence_id			      BIGINT ,
  visit_detail_id               BIGINT ,
  drug_source_value				      VARCHAR(50) ,
  drug_source_concept_id		    INTEGER			  NOT NULL ,
  route_source_value			      VARCHAR(50) ,
  dose_unit_source_value		    VARCHAR(50)
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.device_exposure
(
  device_exposure_id			        BIGINT ,
  person_id						            BIGINT ,
  device_concept_id			          INTEGER		    NOT NULL ,
  device_exposure_start_date	    TIMESTAMP ,
  device_exposure_start_datetime  TIMESTAMP ,
  device_exposure_end_date		    TIMESTAMP ,
  device_exposure_end_datetime    TIMESTAMP ,
  device_type_concept_id		      INTEGER		    NOT NULL ,
  unique_device_id			          VARCHAR(50) ,
  quantity						            INTEGER		    NULL ,
  provider_id					            BIGINT ,
  visit_occurrence_id			        BIGINT ,
  visit_detail_id                 BIGINT ,
  device_source_value			        VARCHAR(100) ,
  device_source_concept_id		    INTEGER		    NOT NULL
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.condition_occurrence
(
  condition_occurrence_id		    BIGINT ,
  person_id						          BIGINT ,
  condition_concept_id			    INTEGER			NOT NULL ,
  condition_start_date			    TIMESTAMP ,
  condition_start_datetime		  TIMESTAMP ,
  condition_end_date			      TIMESTAMP ,
  condition_end_datetime		    TIMESTAMP ,
  condition_type_concept_id		  INTEGER			NOT NULL ,
  condition_status_concept_id	  INTEGER			NOT NULL ,
  stop_reason					          VARCHAR(20) ,
  provider_id					          BIGINT ,
  visit_occurrence_id			      BIGINT ,
  visit_detail_id               BIGINT ,
  condition_source_value		    VARCHAR(50) ,
  condition_source_concept_id	  INTEGER			NOT NULL ,
  condition_status_source_value	VARCHAR(50)
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.measurement
(
  measurement_id				        BIGINT ,
  person_id						          BIGINT ,
  measurement_concept_id		    INTEGER			NOT NULL ,
  measurement_date				      TIMESTAMP ,
  measurement_datetime			    TIMESTAMP ,
  measurement_time              VARCHAR(10),
  measurement_type_concept_id	  INTEGER			NOT NULL ,
  operator_concept_id			      INTEGER			NULL ,
  value_as_number				        FLOAT ,
  value_as_concept_id			      INTEGER			NULL ,
  unit_concept_id				        INTEGER			NULL ,
  range_low					            FLOAT ,
  range_high					          FLOAT ,
  provider_id					          BIGINT ,
  visit_occurrence_id			      BIGINT ,
  visit_detail_id               BIGINT ,
  measurement_source_value		  VARCHAR(50) ,
  measurement_source_concept_id	INTEGER			NOT NULL ,
  unit_source_value				      VARCHAR(50) ,
  value_source_value			      VARCHAR(50),
  modifier_of_event_id 		BIGINT,
  modifier_of_field_concept_id 	INTEGER 	NULL
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.note
(
  note_id						          BIGINT ,
  person_id						        BIGINT ,
  note_event_id         		  BIGINT ,
  note_event_field_concept_id	INTEGER 		  NOT NULL ,
  note_date						        TIMESTAMP ,
  note_datetime					      TIMESTAMP ,
  note_type_concept_id			  INTEGER			  NOT NULL ,
  note_class_concept_id 		  INTEGER			  NOT NULL ,
  note_title					        VARCHAR(250) ,
  note_text						        VARCHAR(MAX) ,
  encoding_concept_id			    INTEGER			  NOT NULL ,
  language_concept_id			    INTEGER			  NOT NULL ,
  provider_id					        BIGINT ,
  visit_occurrence_id			    BIGINT ,
  visit_detail_id       		  BIGINT ,
  note_source_value				    VARCHAR(50)
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.note_nlp
(
  note_nlp_id					        BIGINT ,
  note_id						          BIGINT ,
  section_concept_id			    INTEGER			  NOT NULL ,
  snippet						          VARCHAR(250) ,
  "offset"					          VARCHAR(250) ,
  lexical_variant				      VARCHAR(250) ,
  note_nlp_concept_id			    INTEGER			  NOT NULL ,
  nlp_system					        VARCHAR(250) ,
  nlp_date						        TIMESTAMP ,
  nlp_datetime					      TIMESTAMP ,
  term_exists					        VARCHAR(1) ,
  term_temporal					      VARCHAR(50) ,
  term_modifiers				      VARCHAR(2000) ,
  note_nlp_source_concept_id	INTEGER			  NOT NULL
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.observation
(
  observation_id					      BIGINT ,
  person_id						          BIGINT ,
  observation_concept_id			  INTEGER			NOT NULL ,
  observation_date				      TIMESTAMP ,
  observation_datetime				  TIMESTAMP ,
  observation_type_concept_id   INTEGER			NOT NULL ,
  value_as_number				        FLOAT ,
  value_as_string				        VARCHAR(60) ,
  value_as_concept_id			      INTEGER			NULL ,
  qualifier_concept_id			    INTEGER			NULL ,
  unit_concept_id				   	    INTEGER			NULL ,
  provider_id					          INTEGER			NULL ,
  visit_occurrence_id			      BIGINT ,
  visit_detail_id               BIGINT ,
  observation_source_value		  VARCHAR(50) ,
  observation_source_concept_id INTEGER			NOT NULL ,
  unit_source_value				      VARCHAR(50) ,
  qualifier_source_value			  VARCHAR(50) ,
  observation_event_id				  BIGINT ,
  obs_event_field_concept_id		INTEGER			NOT NULL ,
  value_as_datetime					    TIMESTAMP
)
;


--HINT DISTRIBUTE ON KEY(person_id)
CREATE TABLE ohdsi.survey_conduct
(
  survey_conduct_id					      BIGINT ,
  person_id						            BIGINT ,
  survey_concept_id			  		    INTEGER			  NOT NULL ,
  survey_start_date				        TIMESTAMP ,
  survey_start_datetime				    TIMESTAMP ,
  survey_end_date					        TIMESTAMP ,
  survey_end_datetime				      TIMESTAMP ,
  provider_id						          BIGINT ,
  assisted_concept_id	  			    INTEGER			  NOT NULL ,
  respondent_type_concept_id		  INTEGER			  NOT NULL ,
  timing_concept_id					      INTEGER			  NOT NULL ,
  collection_method_concept_id		INTEGER			  NOT NULL ,
  assisted_source_value		  		  VARCHAR(50) ,
  respondent_type_source_value		VARCHAR(100) ,
  timing_source_value				      VARCHAR(100) ,
  collection_method_source_value	VARCHAR(100) ,
  survey_source_value				      VARCHAR(100) ,
  survey_source_concept_id			  INTEGER			  NOT NULL ,
  survey_source_identifier			  VARCHAR(100) ,
  validated_survey_concept_id		  INTEGER			  NOT NULL ,
  validated_survey_source_value		VARCHAR(100) ,
  survey_version_number				    VARCHAR(20) ,
  visit_occurrence_id				      BIGINT ,
  visit_detail_id					        BIGINT ,
  response_visit_occurrence_id		BIGINT
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.fact_relationship
(
  domain_concept_id_1			INTEGER			NOT NULL ,
  fact_id_1						    BIGINT ,
  domain_concept_id_2			INTEGER			NOT NULL ,
  fact_id_2						    BIGINT ,
  relationship_concept_id	INTEGER			NOT NULL
)
;


CREATE TABLE ohdsi.episode (
	episode_id 			            BIGINT,
	person_id 			            BIGINT,
	episode_start_datetime 		  TIMESTAMP,
	episode_end_datetime 		    TIMESTAMP,
	episode_concept_id 		      INTEGER 	    NOT NULL,
	episode_parent_id 		      INTEGER 	    NULL,
	episode_number 			        INTEGER 	    NULL,
	episode_object_concept_id 	INTEGER 	    NOT NULL,
	episode_type_concept_id 	  INTEGER 	    NOT NULL,
	episode_source_value 		    VARCHAR(50),
	episode_source_concept_id 	INTEGER 	    NULL
)
;

-- Episode_Event
CREATE TABLE ohdsi.episode_event (
	episode_id 		          BIGINT,
	event_id 		            BIGINT,
	event_field_concept_id 	INTEGER NOT NULL
)
;


/************************

Standardized health system data

************************/


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.`location`
(
  location_id					  BIGINT ,
  address_1						  VARCHAR(50) ,
  address_2						  VARCHAR(50) ,
  city							    VARCHAR(50) ,
  state							    VARCHAR(2) ,
  zip							      VARCHAR(9) ,
  county						    VARCHAR(20) ,
  country						    VARCHAR(100) ,
  location_source_value VARCHAR(50) ,
  latitude						  FLOAT ,
  longitude						  FLOAT ,
  region_concept_id     INTEGER       NULL
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.location_history --Table added
(
  location_history_id           BIGINT ,
  location_id			              BIGINT ,
  relationship_type_concept_id	INTEGER		  NOT NULL ,
  domain_id				              VARCHAR(50) ,
  entity_id				              BIGINT ,
  start_date			              TIMESTAMP ,
  end_date				              TIMESTAMP
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.care_site
(
  care_site_id						      BIGINT ,
  care_site_name						    VARCHAR(255) ,
  place_of_service_concept_id	  INTEGER			  NOT NULL ,
  location_id						        BIGINT ,
  care_site_source_value			  VARCHAR(50) ,
  place_of_service_source_value VARCHAR(50)
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE ohdsi.provider
(
  provider_id					        BIGINT ,
  provider_name					      VARCHAR(255) ,
  NPI							            VARCHAR(20) ,
  DEA							            VARCHAR(20) ,
  specialty_concept_id			  INTEGER			  NOT NULL ,
  care_site_id					      BIGINT ,
  year_of_birth					      INTEGER			  NULL ,
  gender_concept_id				    INTEGER			  NOT NULL ,
  provider_source_value			  VARCHAR(50) ,
  specialty_source_value		  VARCHAR(50) ,
  specialty_source_concept_id	INTEGER			  NOT NULL ,
  gender_source_value			    VARCHAR(50) ,
  gender_source_concept_id		INTEGER			  NOT NULL
)
;


/************************

Standardized health economics

************************/


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.payer_plan_period
(
  payer_plan_period_id			    BIGINT ,
  person_id						          BIGINT ,
  contract_person_id            BIGINT ,
  payer_plan_period_start_date  TIMESTAMP ,
  payer_plan_period_end_date	  TIMESTAMP ,
  payer_concept_id              INTEGER       	NOT NULL ,
  plan_concept_id               INTEGER       	NOT NULL ,
  contract_concept_id           INTEGER       	NOT NULL ,
  sponsor_concept_id            INTEGER       	NOT NULL ,
  stop_reason_concept_id        INTEGER       	NOT NULL ,
  payer_source_value			      VARCHAR(50) ,
  payer_source_concept_id       INTEGER       	NOT NULL ,
  plan_source_value				      VARCHAR(50) ,
  plan_source_concept_id        INTEGER       	NOT NULL ,
  contract_source_value         VARCHAR(50) ,
  contract_source_concept_id    INTEGER       	NOT NULL ,
  sponsor_source_value          VARCHAR(50) ,
  sponsor_source_concept_id     INTEGER       	NOT NULL ,
  family_source_value			      VARCHAR(50) ,
  stop_reason_source_value      VARCHAR(50) ,
  stop_reason_source_concept_id INTEGER       	NOT NULL
)
;


--HINT DISTRIBUTE ON KEY(person_id)
CREATE TABLE ohdsi.cost
(
  cost_id						          BIGINT ,
  person_id						        BIGINT,
  cost_event_id					      BIGINT ,
  cost_event_field_concept_id	INTEGER			  NOT NULL ,
  cost_concept_id				      INTEGER		  	NOT NULL ,
  cost_type_concept_id		  	INTEGER     	NOT NULL ,
  currency_concept_id			    INTEGER		  	NOT NULL ,
  cost							          FLOAT ,
  incurred_date					      TIMESTAMP ,
  billed_date					        TIMESTAMP ,
  paid_date					        	TIMESTAMP ,
  revenue_code_concept_id		  INTEGER		  	NOT NULL ,
  drg_concept_id			        INTEGER		  	NOT NULL ,
  cost_source_value				    VARCHAR(50) ,
  cost_source_concept_id	  	INTEGER		  	NOT NULL ,
  revenue_code_source_value		VARCHAR(50) ,
  drg_source_value			      VARCHAR(3) ,
  payer_plan_period_id			  BIGINT
)
;


/************************

Standardized derived elements

************************/


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.drug_era
(
  drug_era_id					    BIGINT ,
  person_id						    BIGINT ,
  drug_concept_id			    INTEGER			NOT NULL ,
  drug_era_start_datetime	TIMESTAMP ,
  drug_era_end_datetime		TIMESTAMP ,
  drug_exposure_count	    INTEGER			NULL ,
  gap_days						    INTEGER			NULL
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.dose_era
(
  dose_era_id					      BIGINT ,
  person_id						      BIGINT ,
  drug_concept_id				    INTEGER			NOT NULL ,
  unit_concept_id				    INTEGER			NOT NULL ,
  dose_value						    FLOAT ,
  dose_era_start_datetime		TIMESTAMP ,
  dose_era_end_datetime	    TIMESTAMP
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE ohdsi.condition_era
(
  condition_era_id				        BIGINT ,
  person_id						            BIGINT ,
  condition_concept_id			      INTEGER			NOT NULL ,
  condition_era_start_datetime		TIMESTAMP ,
  condition_era_end_datetime			TIMESTAMP ,
  condition_occurrence_count	    INTEGER			NULL
)
;
