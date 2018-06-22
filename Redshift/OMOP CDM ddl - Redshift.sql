/*********************************************************************************
# Copyright 2017 Observational Health Data Sciences and Informatics
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

 ####### #     # ####### ######      #####  ######  #     #           #######      #####  
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #           #     # 
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #                 # 
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######       #####  
 #     # #     # #     # #          #       #     # #     #    #    #       # ### #       
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ### #       
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ### #######
                                                                              

script to create OMOP common data model, version 5.2.0 for Amazon Redshift database

last revised: 20-July-2017

Authors:  Patrick Ryan, Christian Reich
Editors:  Komathi Sunilkumar, Ajit Londhe

*************************/


/************************

Standardized vocabulary

************************/


create table concept
(
    concept_id			integer			not	null, 
    concept_name		varchar(255)	null, 
    domain_id        	varchar(20)		not null, 
    vocabulary_id 		varchar(20)		not null, 
    concept_class_id 	varchar(20)		not null, 
    standard_concept 	char(1)			null, 
    concept_code 		varchar(50)		null, 
    valid_start_date 	date			not null, 
    valid_end_date 		date			not null, 
    invalid_reason 		varchar(1)		null
)
diststyle all;


create table vocabulary
(
  vocabulary_id			varchar(20)		not null,
  vocabulary_name		varchar(255)	not null,
  vocabulary_reference	varchar(255)	null,
  vocabulary_version	varchar(255)	null,
  vocabulary_concept_id	integer			not null
)
diststyle all;

create table domain
(
    domain_id 			varchar(20)		not null, 
    domain_name 		varchar(255)	not null, 
    domain_concept_id 	integer			not null
)
diststyle all;

create table concept_class
(
    concept_class_id 			varchar(20) 	not null, 
    concept_class_name 			varchar(255) 	not null, 
    concept_class_concept_id 	integer 		not null
)
diststyle all;

create table concept_relationship
(
    concept_id_1		integer		not null, 
    concept_id_2		integer		not null, 
    relationship_id		varchar(20) not null, 
    valid_start_date	date 		not null, 
    valid_end_date 		date 		not null, 
    invalid_reason 		varchar(1) 	null
)
diststyle all;


create table relationship
(
  relationship_id			varchar(20)		not null,
  relationship_name			varchar(255)	not null,
  is_hierarchical			varchar(1)		not null,
  defines_ancestry			varchar(1)		not null,
  reverse_relationship_id	varchar(20)		not null,
  relationship_concept_id	integer			not null
)
diststyle all;


create table concept_synonym
(
  concept_id			integer			not null,
  concept_synonym_name	varchar(1000)	not null,
  language_concept_id	integer			not null
)
diststyle all;


create table concept_ancestor
(
  ancestor_concept_id		integer		not null,
  descendant_concept_id		integer		not null,
  min_levels_of_separation	integer		not null,
  max_levels_of_separation	integer		not null
)
diststyle all;

create table source_to_concept_map
(
  source_code				varchar(50)		not null,
  source_concept_id			integer			not null,
  source_vocabulary_id		varchar(20)		not null,
  source_code_description	varchar(255)	null,
  target_concept_id			integer			not null,
  target_vocabulary_id		varchar(20)		not null,
  valid_start_date			date			not null,
  valid_end_date			date			not null,
  invalid_reason			varchar(1)		null
)
diststyle all;

create table drug_strength
(
  drug_concept_id				integer		not null,
  ingredient_concept_id			integer		not null,
  amount_value					float		null,
  amount_unit_concept_id		integer		null,
  numerator_value				float		null,
  numerator_unit_concept_id		integer		null,
  denominator_value				float		null,
  denominator_unit_concept_id	integer		null,
  box_size						integer		null,
  valid_start_date				date		not null,
  valid_end_date				date		not null,
  invalid_reason				varchar(1)	null
)
diststyle all;


create table cohort_definition
(
  cohort_definition_id				integer			not null,
  cohort_definition_name			varchar(255)	not null,
  cohort_definition_description		varchar(8000)	null,
  definition_type_concept_id		integer			not null,
  cohort_definition_syntax			varchar(8000)	null,
  subject_concept_id				integer			not null,
  cohort_initiation_date			date			null
)
diststyle all;


create table attribute_definition
(
  attribute_definition_id		integer			not null,
  attribute_name				varchar(255)	not null,
  attribute_description			varchar(8000)	null,
  attribute_type_concept_id		integer			not null,
  attribute_syntax				varchar(8000)	null
)
diststyle all;


/**************************

standardized meta-data

***************************/


create table cdm_source
(
  cdm_source_name					varchar(255)	not null,
  cdm_source_abbreviation			varchar(25)		null,
  cdm_holder						varchar(255)	null,
  source_description				varchar(8000)	null,
  source_documentation_reference	varchar(255)	null,
  cdm_etl_reference					varchar(255)	null,
  source_release_date				date			null,
  cdm_release_date					date			null,
  cdm_version						varchar(10)		null,
  vocabulary_version				varchar(20)		null
)
diststyle all;




/************************

standardized clinical data

************************/


create table person
(
  person_id						integer		not null ,
  gender_concept_id				integer		not null ,
  year_of_birth					integer		not null ,
  month_of_birth				integer		null,
  day_of_birth					integer		null,
  birth_datetime				timestamp	null,
  race_concept_id				integer		not null,
  ethnicity_concept_id			integer		not null,
  location_id					integer		null,
  provider_id					integer		null,
  care_site_id					integer		null,
  person_source_value			varchar(50) null,
  gender_source_value			varchar(50) null,
  gender_source_concept_id		integer		null,
  race_source_value				varchar(50) null,
  race_source_concept_id		integer		null,
  ethnicity_source_value		varchar(50) null,
  ethnicity_source_concept_id	integer		null
)
distkey(person_id)
sortkey(person_id);





create table observation_period
(
  observation_period_id					integer		not null ,
  person_id								integer		not null ,
  observation_period_start_date			date		not null ,
  observation_period_end_date			date		not null ,
  period_type_concept_id				integer		not null
)
distkey(person_id)
interleaved sortkey(person_id, observation_period_start_date, observation_period_end_date);



create table specimen
(
  specimen_id						integer			not null ,
  person_id							integer			not null ,
  specimen_concept_id				integer			not null ,
  specimen_type_concept_id			integer			not null ,
  specimen_date						date			not null ,
  specimen_datetime					timestamp		null ,
  quantity							float			null ,
  unit_concept_id					integer			null ,
  anatomic_site_concept_id			integer			null ,
  disease_status_concept_id			integer			null ,
  specimen_source_id				varchar(50)		null ,
  specimen_source_value				varchar(50)		null ,
  unit_source_value					varchar(50)		null ,
  anatomic_site_source_value		varchar(50)		null ,
  disease_status_source_value		varchar(50)		null
)
distkey(person_id)
sortkey(person_id);



create table death
(
  person_id							integer			not null ,
  death_date						date			not null ,
  death_datetime					timestamp		null ,
  death_type_concept_id				integer			not null ,
  cause_concept_id					integer			null ,
  cause_source_value				varchar(50)		null,
  cause_source_concept_id			integer			null
)
distkey(person_id)
sortkey(person_id);



create table visit_occurrence
(
  visit_occurrence_id			integer			not null ,
  person_id						integer			not null ,
  visit_concept_id				integer			not null ,
  visit_start_date				date			not null ,
  visit_start_datetime			timestamp		null ,
  visit_end_date				date			not null ,
  visit_end_datetime			timestamp		null ,
  visit_type_concept_id			integer			not null ,
  provider_id					integer			null,
  care_site_id					integer			null,
  visit_source_value			varchar(50)		null,
  visit_source_concept_id		integer			null,
  admitting_source_concept_id	integer			null,
  admitting_source_value		varchar(50)		null,
  discharge_to_concept_id		integer			null,
  discharge_to_source_value		varchar(50)		null,
  preceding_visit_occurrence_id	integer			null
)
distkey(payer_plan_period_id)
sortkey(payer_plan_period_id);



create table procedure_occurrence
(
  procedure_occurrence_id		integer			not null ,
  person_id						integer			not null ,
  procedure_concept_id			integer			not null ,
  procedure_date				date			not null ,
  procedure_datetime			timestamp		not null ,
  procedure_type_concept_id		integer			not null ,
  modifier_concept_id			integer			null ,
  quantity						integer			null ,
  provider_id					integer			null ,
  visit_occurrence_id			integer			null ,
  procedure_source_value		varchar(50)		null ,
  procedure_source_concept_id	integer			null ,
  qualifier_source_value		varchar(50)		null
)
distkey(person_id)
interleaved sortkey(person_id, procedure_date);




create table drug_exposure
(
  drug_exposure_id				integer			not null ,
  person_id						integer			not null ,
  drug_concept_id				integer			not null ,
  drug_exposure_start_date		date			not null ,
  drug_exposure_start_datetime	timestamp		not null ,
  drug_exposure_end_date		date			null ,
  drug_exposure_end_datetime	timestamp		null ,
  verbatim_end_date				date			null,
  drug_type_concept_id			integer			not null ,
  stop_reason					varchar(20)		null ,
  refills						integer			null ,
  quantity						float			null ,
  days_supply					integer			null ,
  sig							varchar(8000)	null ,
  route_concept_id				integer			null ,
  lot_number					varchar(50)		null ,
  provider_id					integer			null ,
  visit_occurrence_id			integer			null ,
  drug_source_value				varchar(50)		null ,
  drug_source_concept_id		integer			null ,
  route_source_value			varchar(50)		null ,
  dose_unit_source_value		varchar(50)		null
)
distkey(person_id)
INTERLEAVED SORTKEY(person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date); 


create table device_exposure
(
  device_exposure_id				integer			not null ,
  person_id							integer			not null ,
  device_concept_id					integer			not null ,
  device_exposure_start_date		date			not null ,
  device_exposure_start_datetime	timestamp		not null ,
  device_exposure_end_date			date			null ,
  device_exposure_end_datetime		timestamp		null ,
  device_type_concept_id			integer			not null ,
  unique_device_id					varchar(50)		null ,
  quantity							integer			null ,
  provider_id						integer			null ,
  visit_occurrence_id				integer			null ,
  device_source_value				varchar(100)	null ,
  device_source_concept_id			integer			null
)
distkey(person_id)
interleaved sortkey(person_id, device_concept_id, device_exposure_start_date, device_exposure_end_date);


create table condition_occurrence
(
  condition_occurrence_id		integer			not null ,
  person_id						integer			not null ,
  condition_concept_id			integer			not null ,
  condition_start_date			date			not null ,
  condition_start_datetime		timestamp		not null ,
  condition_end_date			date			null ,
  condition_end_datetime		timestamp		null ,
  condition_type_concept_id		integer			not null ,
  stop_reason					varchar(20)		null ,
  provider_id					integer			null ,
  visit_occurrence_id			integer			null ,
  condition_source_value		varchar(50)		null ,
  condition_source_concept_id	integer			null ,
  condition_status_source_value	varchar(50)		null ,
  condition_status_concept_id	integer			null 
)
distkey(person_id)
interleaved sortkey(person_id, condition_concept_id, condition_start_date, condition_end_date);




create table measurement
(
  measurement_id				integer			not null ,
  person_id						integer			not null ,
  measurement_concept_id		integer			not null ,
  measurement_date				date			not null ,
  measurement_datetime			timestamp		null ,
  measurement_type_concept_id	integer			not null ,
  operator_concept_id			integer			null ,
  value_as_number				float			null ,
  value_as_concept_id			integer			null ,
  unit_concept_id				integer			null ,
  range_low						float			null ,
  range_high					float			null ,
  provider_id					integer			null ,
  visit_occurrence_id			integer			null ,
  measurement_source_value		varchar(50)		null ,
  measurement_source_concept_id	integer			null ,
  unit_source_value				varchar(50)		null ,
  value_source_value			varchar(50)		null
)
distkey(person_id)
interleaved sortkey(person_id, measurement_concept_id, measurement_date);



create table note
(
  note_id						integer			not null ,
  person_id						integer			not null ,
  note_date						date			not null ,
  note_datetime					timestamp		null ,
  note_type_concept_id			integer			not null ,
  note_text						varchar(max)	not null ,
  provider_id					integer			null ,
  visit_occurrence_id			integer			null ,
  note_source_value				varchar(50)		null
)
distkey(person_id)
sortkey(person_id);



/*This table is new in CDM v5.2*/
CREATE TABLE note_nlp
(
  note_nlp_id					bigint			not null ,
  note_id						integer			not null ,
  section_concept_id			integer			null ,
  snippet						varchar(250)	null ,
  offset						varchar(250)	null ,
  lexical_variant				varchar(250)	not null ,
  note_nlp_concept_id			integer			null ,
  note_nlp_source_concept_id	integer			null ,
  nlp_system					varchar(250)	null ,
  nlp_date						date			not null ,
  nlp_datetime					timestamp		null ,
  term_exists					varchar(1)		null ,
  term_temporal					varchar(50)		null ,
  term_modifiers				varchar(2000)	null
)
distkey(note_id)
sortkey(note_id);


create table observation
(
  observation_id				integer			not null ,
  person_id						integer			not null ,
  observation_concept_id		integer			not null ,
  observation_date				date			not null ,
  observation_datetime			timestamp		null ,
  observation_type_concept_id	integer			not null ,
  value_as_number				float			null ,
  value_as_string				varchar(60)		null ,
  value_as_concept_id			integer			null ,
  qualifier_concept_id			integer			null ,
  unit_concept_id				integer			null ,
  provider_id					integer			null ,
  visit_occurrence_id			integer			null ,
  observation_source_value		varchar(50)		null ,
  observation_source_concept_id	integer			null ,
  unit_source_value				varchar(50)		null ,
  qualifier_source_value		varchar(50)		null
)
distkey(person_id)
interleaved sortkey(person_id, observation_concept_id, observation_date);



create table fact_relationship
(
  domain_concept_id_1			integer			not null ,
  fact_id_1						integer			not null ,
  domain_concept_id_2			integer			not null ,
  fact_id_2						integer			not null ,
  relationship_concept_id		integer			not null
)
diststyle all;




/************************

standardized health system data

************************/



create table location
(
  location_id					integer			not null ,
  address_1						varchar(50)		null ,
  address_2						varchar(50)		null ,
  city							varchar(50)		null ,
  state							varchar(2)		null ,
  zip							varchar(9)		null ,
  county						varchar(20)		null ,
  location_source_value			varchar(50)		null
)
diststyle all;



create table care_site
(
  care_site_id						integer			not null ,
  care_site_name						varchar(255)	null ,
  place_of_service_concept_id		integer			null ,
  location_id						integer			null ,
  care_site_source_value				varchar(50)		null ,
  place_of_service_source_value		varchar(50)		null
)
diststyle all;



create table provider
(
  provider_id					integer			not null ,
  provider_name					varchar(255)	null ,
  npi							varchar(20)		null ,
  dea							varchar(20)		null ,
  specialty_concept_id			integer			null ,
  care_site_id					integer			null ,
  year_of_birth					integer			null ,
  gender_concept_id				integer			null ,
  provider_source_value			varchar(50)		null ,
  specialty_source_value		varchar(50)		null ,
  specialty_source_concept_id	integer			null ,
  gender_source_value			varchar(50)		null ,
  gender_source_concept_id		integer			null
)
distkey(provider_id);




/************************

standardized health economics

************************/


create table payer_plan_period
(
  payer_plan_period_id			integer			not null ,
  person_id						integer			not null ,
  payer_plan_period_start_date	date			not null ,
  payer_plan_period_end_date	date			not null ,
  payer_source_value			varchar (50)	null ,
  plan_source_value				varchar (50)	null ,
  family_source_value			varchar (50)	null
)
distkey(person_id)
interleaved sortkey(person_id, payer_plan_period_start_date, payer_plan_period_end_date);



/* the individual cost tables are being phased out and will disappear 

create table visit_cost 
( 
	 visit_cost_id					integer			not null , 
	 visit_occurrence_id			integer			not null , 
	 currency_concept_id			integer			null ,
	 paid_copay						float			null , 
	 paid_coinsurance				float			null , 
	 paid_toward_deductible			float			null , 
	 paid_by_payer					float			null , 
	 paid_by_coordination_benefits	float			null , 
	 total_out_of_pocket			float			null , 
	 total_paid						float			null ,  
	 payer_plan_period_id			integer			null
) 
distkey(payer_plan_period_id)
sortkey(payer_plan_period_id);



create table procedure_cost 
( 
     procedure_cost_id				integer			not null , 
     procedure_occurrence_id		integer			not null , 
     currency_concept_id			integer			null ,
     paid_copay						float			null , 
     paid_coinsurance				float			null , 
     paid_toward_deductible			float			null , 
     paid_by_payer					float			null , 
     paid_by_coordination_benefits	float			null , 
     total_out_of_pocket			float			null , 
     total_paid						float			null ,
	 revenue_code_concept_id		integer			null ,  
     payer_plan_period_id			integer			null ,
	 revenue_code_source_value		varchar(50)		null
) 
distkey(procedure_occurrence_id)
sortkey(procedure_occurrence_id);



create table drug_cost 
(
     drug_cost_id					integer			not null , 
     drug_exposure_id				integer			not null , 
     currency_concept_id			integer			null ,
     paid_copay						float			null , 
     paid_coinsurance				float			null , 
     paid_toward_deductible			float			null , 
     paid_by_payer					float			null , 
     paid_by_coordination_benefits	float			null , 
     total_out_of_pocket			float			null , 
     total_paid						float			null , 
     ingredient_cost				float			null , 
     dispensing_fee					float			null , 
     average_wholesale_price		float			null , 
     payer_plan_period_id			integer			null
) 
distkey(payer_plan_period_id)
sortkey(payer_plan_period_id);



create table device_cost 
(
     device_cost_id					integer			not null , 
     device_exposure_id				integer			not null , 
     currency_concept_id			integer			null ,
     paid_copay						float			null , 
     paid_coinsurance				float			null , 
     paid_toward_deductible			float			null , 
     paid_by_payer					float			null , 
     paid_by_coordination_benefits	float			null , 
     total_out_of_pocket			float			null , 
     total_paid						float			null , 
     payer_plan_period_id			integer			null
) 
distkey(payer_plan_period_id)
sortkey(payer_plan_period_id);
*/


create table cost
(
  cost_id					integer	   		not null ,
  cost_event_id       		integer     	not null ,
  cost_domain_id       		varchar(20)		not null ,
  cost_type_concept_id      integer     	not null ,
  currency_concept_id		integer			null ,
  total_charge				float			null ,
  total_cost				float			null ,
  total_paid				float			null ,
  paid_by_payer				float			null ,
  paid_by_patient			float			null ,
  paid_patient_copay		float			null ,
  paid_patient_coinsurance	float			null ,
  paid_patient_deductible	float			null ,
  paid_by_primary			float			null ,
  paid_ingredient_cost		float			null ,
  paid_dispensing_fee		float			null ,
  payer_plan_period_id		integer			null ,
  amount_allowed			float			null ,
  revenue_code_concept_id	integer			null ,
  reveue_code_source_value  varchar(50)		null ,
  drg_concept_id			integer			null,
  drg_source_value			varchar(3)		null
)
distkey(payer_plan_period_id)
sortkey(payer_plan_period_id);





/************************

standardized derived elements

************************/

create table cohort
(
  cohort_definition_id			integer			not null ,
  subject_id					integer			not null ,
  cohort_start_date				date			not null ,
  cohort_end_date				date			not null
)
distkey(subject_id)
sortkey(subject_id);


create table cohort_attribute
(
  cohort_definition_id			integer			not null ,
  cohort_start_date				date			not null ,
  cohort_end_date				date			not null ,
  subject_id					integer			not null ,
  attribute_definition_id		integer			not null ,
  value_as_number				float			null ,
  value_as_concept_id			integer			null
)
distkey(subject_id)
sortkey(subject_id);





create table drug_era
(
  drug_era_id					integer			not null ,
  person_id						integer			not null ,
  drug_concept_id				integer			not null ,
  drug_era_start_date			date			not null ,
  drug_era_end_date				date			not null ,
  drug_exposure_count			integer			null ,
  gap_days						integer			null
)
distkey(person_id)
interleaved sortkey(person_id, drug_concept_id, drug_era_start_date, drug_era_end_date);


create table dose_era
(
  dose_era_id					integer			not null ,
  person_id						integer			not null ,
  drug_concept_id				integer			not null ,
  unit_concept_id				integer			not null ,
  dose_value					float			not null ,
  dose_era_start_date			date			not null ,
  dose_era_end_date				date			not null
)
distkey(person_id)
sortkey(person_id);




create table condition_era
(
  condition_era_id				integer			not null ,
  person_id						integer			not null ,
  condition_concept_id			integer			not null ,
  condition_era_start_date		date			not null ,
  condition_era_end_date		date			not null ,
  condition_occurrence_count	integer			null
)
distkey(person_id)
interleaved sortkey(person_id, condition_concept_id, condition_era_start_date, condition_era_end_date);







