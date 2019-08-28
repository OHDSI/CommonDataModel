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

bigquery script to create OMOP common data model version 6.0

last revised: 27-Aug-2018

Authors:  Patrick Ryan, Christian Reich, Clair Blacketer


*************************/


/************************

Standardized vocabulary

************************/


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.concept (
  concept_id			      INT64			not null ,
  concept_name			  	STRING	not null ,
  domain_id				      STRING		not null ,
  vocabulary_id			  	STRING		not null ,
  concept_class_id			STRING		not null ,
  standard_concept			STRING ,
  concept_code			  	STRING		not null ,
  valid_start_date			date			not null ,
  valid_end_date		  	date			not null ,
  invalid_reason		  	STRING
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.vocabulary (
  vocabulary_id			      STRING		not null,
  vocabulary_name		      STRING	not null,
  vocabulary_reference		STRING	not null,
  vocabulary_version	  	STRING,
  vocabulary_concept_id		INT64			not null
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.domain (
  domain_id			      STRING		not null,
  domain_name		      STRING	not null,
  domain_concept_id		INT64			not null
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.concept_class (
  concept_class_id			      STRING		not null,
  concept_class_name		      STRING	not null,
  concept_class_concept_id		INT64			not null
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.concept_relationship (
  concept_id_1			  INT64			not null,
  concept_id_2			  INT64			not null,
  relationship_id		  STRING		not null,
  valid_start_date		date			not null,
  valid_end_date		  date			not null,
  invalid_reason		  STRING
  )
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.relationship (
  relationship_id			  STRING		not null,
  relationship_name			  STRING	not null,
  is_hierarchical			    STRING		not null,
  defines_ancestry			  STRING		not null,
  reverse_relationship_id	STRING		not null,
  relationship_concept_id	INT64			  not null
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.concept_synonym (
  concept_id			        INT64		    not null,
  concept_synonym_name	  STRING	not null,
  language_concept_id	    INT64		    not null
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.concept_ancestor (
  ancestor_concept_id		      INT64		not null,
  descendant_concept_id		  	INT64		not null,
  min_levels_of_separation		INT64		not null,
  max_levels_of_separation		INT64		not null
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.source_to_concept_map (
  source_code				  	    STRING		not null,
  source_concept_id			  	INT64			  not null,
  source_vocabulary_id			STRING		not null,
  source_code_description		STRING,
  target_concept_id			  	INT64			  not null,
  target_vocabulary_id			STRING		not null,
  valid_start_date			  	date			    not null,
  valid_end_date			      date			    not null,
  invalid_reason			      STRING
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.drug_strength (
  drug_concept_id				      INT64		  not null,
  ingredient_concept_id			  INT64		  not null,
  amount_value					      FLOAT64		    null,
  amount_unit_concept_id		  INT64,
  numerator_value				      FLOAT64		    null,
  numerator_unit_concept_id		INT64,
  denominator_value				    FLOAT64		    null,
  denominator_unit_concept_id	INT64,
  box_size						        INT64,
  valid_start_date				    date		    not null,
  valid_end_date				      date		    not null,
  invalid_reason				      STRING
)
;


/**************************

Standardized meta-data

***************************/


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.cdm_source
(
  cdm_source_name					        STRING	not null ,
  cdm_source_abbreviation			    STRING ,
  cdm_holder						          STRING ,
  source_description				      STRING ,
  source_documentation_reference	STRING ,
  cdm_etl_reference					      STRING ,
  source_release_date				      date			    null ,
  cdm_release_date					      date			    null ,
  cdm_version						          STRING ,
  vocabulary_version				      STRING
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.metadata
(
  metadata_concept_id       INT64       not null ,
  metadata_type_concept_id  INT64       not null ,
  name                      STRING  not null ,
  value_as_string           STRING ,
  value_as_concept_id       INT64 ,
  metadata_date             date          null ,
  metadata_datetime         datetime     null
)
;

insert into ohdsi.metadata (metadata_concept_id, metadata_type_concept_id, name, value_as_string, value_as_concept_id, metadata_date, metadata_datetime) --Added cdm version record
values (0,0,'CDM Version', '6.0',0,null,null)
;


/************************

Standardized clinical data

************************/


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.person
(
  person_id						        INT64	  	  not null ,
  gender_concept_id				    INT64	  	  not null ,
  year_of_birth					      INT64	  	  not null ,
  month_of_birth				      INT64,
  day_of_birth					      INT64,
  birth_datetime				      datetime	  	null,
  death_datetime					    datetime		  null,
  race_concept_id				      INT64		    not null,
  ethnicity_concept_id			  INT64	  	  not null,
  location_id					        INT64,
  provider_id					        INT64,
  care_site_id					      INT64,
  person_source_value			    STRING,
  gender_source_value			    STRING,
  gender_source_concept_id    INT64		    not null,
  race_source_value				    STRING,
  race_source_concept_id		  INT64		    not null,
  ethnicity_source_value		  STRING,
  ethnicity_source_concept_id INT64		    not null
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.observation_period
(
  observation_period_id				  INT64		not null ,
  person_id							        INT64		not null ,
  observation_period_start_date	date		  not null ,
  observation_period_end_date   date		  not null ,
  period_type_concept_id			  INT64		not null
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.specimen
(
  specimen_id					        INT64		  	not null ,
  person_id						        INT64		  	not null ,
  specimen_concept_id			    INT64			  not null ,
  specimen_type_concept_id		INT64			  not null ,
  specimen_date					      date			    null ,
  specimen_datetime				    datetime		  not null ,
  quantity						        FLOAT64			    null ,
  unit_concept_id				      INT64 ,
  anatomic_site_concept_id		INT64			  not null ,
  disease_status_concept_id		INT64			  not null ,
  specimen_source_id			    STRING ,
  specimen_source_value			  STRING ,
  unit_source_value				    STRING ,
  anatomic_site_source_value	STRING ,
  disease_status_source_value	STRING
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.visit_occurrence
(
  visit_occurrence_id			      INT64			  not null ,
  person_id						          INT64			  not null ,
  visit_concept_id				      INT64			  not null ,
  visit_start_date				      date			    null ,
  visit_start_datetime			    datetime		  not null ,
  visit_end_date				        date			    null ,
  visit_end_datetime			      datetime		  not null ,
  visit_type_concept_id			    INT64			  not null ,
  provider_id					          INT64,
  care_site_id					        INT64,
  visit_source_value			      STRING,
  visit_source_concept_id		    INT64			  not null ,
  admitted_from_concept_id      INT64     	not null ,
  admitted_from_source_value    STRING ,
  discharge_to_source_value		  STRING ,
  discharge_to_concept_id		    INT64   		not null ,
  preceding_visit_occurrence_id	INT64
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.visit_detail
(
  visit_detail_id                    INT64      not null ,
  person_id                          INT64      not null ,
  visit_detail_concept_id            INT64     not null ,
  visit_detail_start_date            date        null ,
  visit_detail_start_datetime        datetime   not null ,
  visit_detail_end_date              date        null ,
  visit_detail_end_datetime          datetime   not null ,
  visit_detail_type_concept_id       INT64     not null ,
  provider_id                        INT64 ,
  care_site_id                       INT64 ,
  discharge_to_concept_id            INT64     not null ,
  admitted_from_concept_id           INT64     not null ,
  admitted_from_source_value         STRING ,
  visit_detail_source_value          STRING ,
  visit_detail_source_concept_id     INT64     not null ,
  discharge_to_source_value          STRING ,
  preceding_visit_detail_id          INT64 ,
  visit_detail_parent_id             INT64 ,
  visit_occurrence_id                INT64      not null
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.procedure_occurrence
(
  procedure_occurrence_id		  INT64			not null ,
  person_id						        INT64			not null ,
  procedure_concept_id			  INT64			not null ,
  procedure_date				      date			  null ,
  procedure_datetime			    datetime		not null ,
  procedure_type_concept_id		INT64			not null ,
  modifier_concept_id			    INT64			not null ,
  quantity						        INT64 ,
  provider_id					        INT64 ,
  visit_occurrence_id			    INT64 ,
  visit_detail_id             INT64 ,
  procedure_source_value		  STRING ,
  procedure_source_concept_id	INT64			not null ,
  modifier_source_value		    STRING
)
;

--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.drug_exposure
(
  drug_exposure_id				      INT64			  not null ,
  person_id						          INT64			  not null ,
  drug_concept_id				        INT64			  not null ,
  drug_exposure_start_date		  date			    null ,
  drug_exposure_start_datetime	datetime		  not null ,
  drug_exposure_end_date		    date			    null ,
  drug_exposure_end_datetime	  datetime		  not null ,
  verbatim_end_date				      date			    null ,
  drug_type_concept_id			    INT64			  not null ,
  stop_reason					          STRING ,
  refills						            INT64 ,
  quantity						          FLOAT64			    null ,
  days_supply					          INT64 ,
  sig							              STRING ,
  route_concept_id				      INT64			  not null ,
  lot_number					          STRING ,
  provider_id					          INT64 ,
  visit_occurrence_id			      INT64 ,
  visit_detail_id               INT64 ,
  drug_source_value				      STRING ,
  drug_source_concept_id		    INT64			  not null ,
  route_source_value			      STRING ,
  dose_unit_source_value		    STRING
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.device_exposure
(
  device_exposure_id			        INT64		    not null ,
  person_id						            INT64		    not null ,
  device_concept_id			          INT64		    not null ,
  device_exposure_start_date	    date			    null ,
  device_exposure_start_datetime  datetime		  not null ,
  device_exposure_end_date		    date			    null ,
  device_exposure_end_datetime    datetime		  null ,
  device_type_concept_id		      INT64		    not null ,
  unique_device_id			          STRING ,
  quantity						            INT64 ,
  provider_id					            INT64 ,
  visit_occurrence_id			        INT64 ,
  visit_detail_id                 INT64 ,
  device_source_value			        STRING ,
  device_source_concept_id		    INT64		    not null
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.condition_occurrence
(
  condition_occurrence_id		    INT64			not null ,
  person_id						          INT64			not null ,
  condition_concept_id			    INT64			not null ,
  condition_start_date			    date			  null ,
  condition_start_datetime		  datetime		not null ,
  condition_end_date			      date			  null ,
  condition_end_datetime		    datetime		null ,
  condition_type_concept_id		  INT64			not null ,
  condition_status_concept_id	  INT64			not null ,
  stop_reason					          STRING ,
  provider_id					          INT64 ,
  visit_occurrence_id			      INT64 ,
  visit_detail_id               INT64 ,
  condition_source_value		    STRING ,
  condition_source_concept_id	  INT64			not null ,
  condition_status_source_value	STRING
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.measurement
(
  measurement_id				        INT64			not null ,
  person_id						          INT64			not null ,
  measurement_concept_id		    INT64			not null ,
  measurement_date				      date			null ,
  measurement_datetime			    datetime		not null ,
  measurement_time              STRING,
  measurement_type_concept_id	  INT64			not null ,
  operator_concept_id			      INT64 ,
  value_as_number				        FLOAT64			null ,
  value_as_concept_id			      INT64 ,
  unit_concept_id				        INT64 ,
  range_low					            FLOAT64			null ,
  range_high					          FLOAT64			null ,
  provider_id					          INT64 ,
  visit_occurrence_id			      INT64 ,
  visit_detail_id               INT64 ,
  measurement_source_value		  STRING ,
  measurement_source_concept_id	INT64			not null ,
  unit_source_value				      STRING ,
  value_source_value			      STRING,
  modifier_of_event_id 		INT64,
  modifier_of_field_concept_id 	INT64
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.note
(
  note_id						          INT64			  not null ,
  person_id						        INT64			  not null ,
  note_event_id         		  INT64 ,
  note_event_field_concept_id	INT64 		  not null ,
  note_date						        date			    null ,
  note_datetime					      datetime		  not null ,
  note_type_concept_id			  INT64			  not null ,
  note_class_concept_id 		  INT64			  not null ,
  note_title					        STRING ,
  note_text						        STRING ,
  encoding_concept_id			    INT64			  not null ,
  language_concept_id			    INT64			  not null ,
  provider_id					        INT64 ,
  visit_occurrence_id			    INT64 ,
  visit_detail_id       		  INT64 ,
  note_source_value				    STRING
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.note_nlp
(
  note_nlp_id					        INT64			  not null ,
  note_id						          INT64			  not null ,
  section_concept_id			    INT64			  not null ,
  snippet						          STRING ,
  "offset"					          STRING ,
  lexical_variant				      STRING	not null ,
  note_nlp_concept_id			    INT64			  not null ,
  nlp_system					        STRING ,
  nlp_date						        date			    not null ,
  nlp_datetime					      datetime		  null ,
  term_exists					        STRING ,
  term_temporal					      STRING ,
  term_modifiers				      STRING ,
  note_nlp_source_concept_id	INT64			  not null
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.observation
(
  observation_id					      INT64			not null ,
  person_id						          INT64			not null ,
  observation_concept_id			  INT64			not null ,
  observation_date				      date			  null ,
  observation_datetime				  datetime		not null ,
  observation_type_concept_id   INT64			not null ,
  value_as_number				        FLOAT64			  null ,
  value_as_string				        STRING ,
  value_as_concept_id			      INT64 ,
  qualifier_concept_id			    INT64 ,
  unit_concept_id				   	    INT64 ,
  provider_id					          INT64 ,
  visit_occurrence_id			      INT64 ,
  visit_detail_id               INT64 ,
  observation_source_value		  STRING ,
  observation_source_concept_id INT64			not null ,
  unit_source_value				      STRING ,
  qualifier_source_value			  STRING ,
  observation_event_id				  INT64 ,
  obs_event_field_concept_id		INT64			not null ,
  value_as_datetime					    datetime		null
)
;


--HINT DISTRIBUTE ON KEY(person_id)
create table ohdsi.survey_conduct
(
  survey_conduct_id					      INT64			  not null ,
  person_id						            INT64			  not null ,
  survey_concept_id			  		    INT64			  not null ,
  survey_start_date				        date			    null ,
  survey_start_datetime				    datetime		  null ,
  survey_end_date					        date			    null ,
  survey_end_datetime				      datetime		  not null ,
  provider_id						          INT64 ,
  assisted_concept_id	  			    INT64			  not null ,
  respondent_type_concept_id		  INT64			  not null ,
  timing_concept_id					      INT64			  not null ,
  collection_method_concept_id		INT64			  not null ,
  assisted_source_value		  		  STRING ,
  respondent_type_source_value		STRING ,
  timing_source_value				      STRING ,
  collection_method_source_value	STRING ,
  survey_source_value				      STRING ,
  survey_source_concept_id			  INT64			  not null ,
  survey_source_identifier			  STRING ,
  validated_survey_concept_id		  INT64			  not null ,
  validated_survey_source_value		STRING ,
  survey_version_number				    STRING ,
  visit_occurrence_id				      INT64 ,
  visit_detail_id					        INT64 ,
  response_visit_occurrence_id		INT64
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.fact_relationship
(
  domain_concept_id_1			INT64			not null ,
  fact_id_1						    INT64			not null ,
  domain_concept_id_2			INT64			not null ,
  fact_id_2						    INT64			not null ,
  relationship_concept_id	INT64			not null
)
;


create table ohdsi.episode (
	episode_id 			            INT64 		    not null,
	person_id 			            INT64 		    not null,
	episode_start_datetime 		  datetime 	  not null,
	episode_end_datetime 		    datetime 	  not null,
	episode_concept_id 		      INT64 	    not null,
	episode_parent_id 		      INT64,
	episode_number 			        INT64,
	episode_object_concept_id 	INT64 	    not null,
	episode_type_concept_id 	  INT64 	    not null,
	episode_source_value 		    STRING,
	episode_source_concept_id 	INT64
)
;

-- Episode_Event
create table ohdsi.episode_event (
	episode_id 		          INT64 	not null,
	event_id 		            INT64 	not null,
	event_field_concept_id 	INT64 not null
)
;


/************************

Standardized health system data

************************/


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.location
(
  location_id					  INT64			  not null ,
  address_1						  STRING ,
  address_2						  STRING ,
  city							    STRING ,
  state							    STRING ,
  zip							      STRING ,
  county						    STRING ,
  country						    STRING ,
  location_source_value STRING ,
  latitude						  FLOAT64				  null ,
  longitude						  FLOAT64				  null ,
  region_concept_id     INT64
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.location_history --Table added
(
  location_history_id           INT64      not null ,
  location_id			              INT64		  not null ,
  relationship_type_concept_id	INT64		  not null ,
  domain_id				              STRING not null ,
  entity_id				              INT64			not null ,
  start_date			              date			  not null ,
  end_date				              date			  null
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.care_site
(
  care_site_id						      INT64			  not null ,
  care_site_name						    STRING ,
  place_of_service_concept_id	  INT64			  not null ,
  location_id						        INT64 ,
  care_site_source_value			  STRING ,
  place_of_service_source_value STRING
)
;


--HINT DISTRIBUTE ON RANDOM
create table ohdsi.provider
(
  provider_id					        INT64			  not null ,
  provider_name					      STRING ,
  npi							            STRING ,
  dea							            STRING ,
  specialty_concept_id			  INT64			  not null ,
  care_site_id					      INT64 ,
  year_of_birth					      INT64 ,
  gender_concept_id				    INT64			  not null ,
  provider_source_value			  STRING ,
  specialty_source_value		  STRING ,
  specialty_source_concept_id	INT64			  not null ,
  gender_source_value			    STRING ,
  gender_source_concept_id		INT64			  not null
)
;


/************************

Standardized health economics

************************/


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.payer_plan_period
(
  payer_plan_period_id			    INT64			    not null ,
  person_id						          INT64			    not null ,
  contract_person_id            INT64 ,
  payer_plan_period_start_date  date			      not null ,
  payer_plan_period_end_date	  date			      not null ,
  payer_concept_id              INT64       	not null ,
  plan_concept_id               INT64       	not null ,
  contract_concept_id           INT64       	not null ,
  sponsor_concept_id            INT64       	not null ,
  stop_reason_concept_id        INT64       	not null ,
  payer_source_value			      STRING ,
  payer_source_concept_id       INT64       	not null ,
  plan_source_value				      STRING ,
  plan_source_concept_id        INT64       	not null ,
  contract_source_value         STRING ,
  contract_source_concept_id    INT64       	not null ,
  sponsor_source_value          STRING ,
  sponsor_source_concept_id     INT64       	not null ,
  family_source_value			      STRING ,
  stop_reason_source_value      STRING ,
  stop_reason_source_concept_id INT64       	not null
)
;


--HINT DISTRIBUTE ON KEY(person_id)
create table ohdsi.cost
(
  cost_id						          INT64	    	not null ,
  person_id						        INT64		  	not null,
  cost_event_id					      INT64      	not null ,
  cost_event_field_concept_id	INT64			  not null ,
  cost_concept_id				      INT64		  	not null ,
  cost_type_concept_id		  	INT64     	not null ,
  currency_concept_id			    INT64		  	not null ,
  cost							          FLOAT64		      null ,
  incurred_date					      date		      not null ,
  billed_date					        date		      null ,
  paid_date					        	date		      null ,
  revenue_code_concept_id		  INT64		  	not null ,
  drg_concept_id			        INT64		  	not null ,
  cost_source_value				    STRING ,
  cost_source_concept_id	  	INT64		  	not null ,
  revenue_code_source_value		STRING ,
  drg_source_value			      STRING ,
  payer_plan_period_id			  INT64
)
;


/************************

Standardized derived elements

************************/


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.drug_era
(
  drug_era_id					    INT64			not null ,
  person_id						    INT64			not null ,
  drug_concept_id			    INT64			not null ,
  drug_era_start_datetime	datetime			  not null ,
  drug_era_end_datetime		datetime			  not null ,
  drug_exposure_count	    INT64 ,
  gap_days						    INT64
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.dose_era
(
  dose_era_id					      INT64			not null ,
  person_id						      INT64			not null ,
  drug_concept_id				    INT64			not null ,
  unit_concept_id				    INT64			not null ,
  dose_value						    FLOAT64			  not null ,
  dose_era_start_datetime		datetime			  not null ,
  dose_era_end_datetime	    datetime			  not null
)
;


--HINT DISTRIBUTE_ON_KEY(person_id)
create table ohdsi.condition_era
(
  condition_era_id				        INT64			not null ,
  person_id						            INT64			not null ,
  condition_concept_id			      INT64			not null ,
  condition_era_start_datetime		datetime			  not null ,
  condition_era_end_datetime			datetime			  not null ,
  condition_occurrence_count	    INT64
)
;
