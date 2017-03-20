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

 ####### #     # ####### ######      #####  ######  #     #           ####### 
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #       
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #       
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######  
 #     # #     # #     # #          #       #     # #     #    #    #       # 
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # 
 ####### #     # ####### #           #####  ######  #     #      ##    #####  
                                                                              

script to create OMOP common data model, version 5.0 for MySQL database

last revised: 03 Mar 2015

original author:  Patrick Ryan
modified by Colin Erdman for MySQL;

*************************/


/************************

Standardized vocabulary

************************/


CREATE TABLE concept (
  concept_id			INT(11)			NOT NULL,
  concept_name			VARCHAR(255)	NOT NULL,
  domain_id				VARCHAR(20)		NOT NULL,
  vocabulary_id			VARCHAR(20)		NOT NULL,
  concept_class_id		VARCHAR(20)		NOT NULL,
  standard_concept		VARCHAR(1)		NULL,
  concept_code			VARCHAR(50)		NOT NULL,
  valid_start_date		DATE			NOT NULL,
  valid_end_date		DATE			NOT NULL,
  invalid_reason		VARCHAR(1)		NULL
);




CREATE TABLE vocabulary (
  vocabulary_id			VARCHAR(20)		NOT NULL,
  vocabulary_name		VARCHAR(255)	NOT NULL,
  vocabulary_reference	VARCHAR(255)	NULL,
  vocabulary_version	VARCHAR(255)	NULL,
  vocabulary_concept_id	INT(11)			NOT NULL
);




CREATE TABLE domain (
  domain_id			VARCHAR(20)		NOT NULL,
  domain_name		VARCHAR(255)	NOT NULL,
  domain_concept_id	INT(11)			NOT NULL
);



CREATE TABLE concept_class (
  concept_class_id			VARCHAR(20)		NOT NULL,
  concept_class_name		VARCHAR(255)	NOT NULL,
  concept_class_concept_id	INT(11)			NOT NULL
);




CREATE TABLE concept_relationship (
  concept_id_1			INT(11)			NOT NULL,
  concept_id_2			INT(11)			NOT NULL,
  relationship_id		VARCHAR(20)		NOT NULL,
  valid_start_date		DATE			NOT NULL,
  valid_end_date		DATE			NOT NULL,
  invalid_reason		VARCHAR(1)		NULL
);



CREATE TABLE relationship (
  relationship_id			VARCHAR(20)		NOT NULL,
  relationship_name			VARCHAR(255)	NOT NULL,
  is_hierarchical			VARCHAR(1)		NOT NULL,
  defines_ancestry			VARCHAR(1)		NOT NULL,
  reverse_relationship_id	VARCHAR(20)		NOT NULL,
  relationship_concept_id	INT(11)			NOT NULL
);


CREATE TABLE concept_synonym (
  concept_id			INT(11)			NOT NULL,
  concept_synonym_name	VARCHAR(1000)	NOT NULL,
  language_concept_id	INT(11)			NOT NULL
);


CREATE TABLE concept_ancestor (
  ancestor_concept_id		INT(11)		NOT NULL,
  descendant_concept_id		INT(11)		NOT NULL,
  min_levels_of_separation	INT(11)		NOT NULL,
  max_levels_of_separation	INT(11)		NOT NULL
);



CREATE TABLE source_to_concept_map (
  source_code				VARCHAR(50)		NOT NULL,
  source_concept_id			INT(11)			NOT NULL,
  source_vocabulary_id		VARCHAR(20)		NOT NULL,
  source_code_description	VARCHAR(255)	NULL,
  target_concept_id			INT(11)			NOT NULL,
  target_vocabulary_id		VARCHAR(20)		NOT NULL,
  valid_start_date			DATE			NOT NULL,
  valid_end_date			DATE			NOT NULL,
  invalid_reason			VARCHAR(1)		NULL
);




CREATE TABLE drug_strength (
  drug_concept_id				INT(11)		NOT NULL,
  ingredient_concept_id			INT(11)		NOT NULL,
  amount_value					NUMERIC		NULL,
  amount_unit_concept_id		INT(11)		NULL,
  numerator_value				NUMERIC		NULL,
  numerator_unit_concept_id		INT(11)		NULL,
  denominator_unit_concept_id	INT(11)		NULL,
  valid_start_date				DATE		NOT NULL,
  valid_end_date				DATE		NOT NULL,
  invalid_reason				VARCHAR(1)	NULL
);



CREATE TABLE cohort_definition (
  cohort_definition_id				INT(11)			NOT NULL,
  cohort_definition_name			VARCHAR(255)	NOT NULL,
  cohort_definition_description		TEXT	NULL,
  definition_type_concept_id		INT(11)			NOT NULL,
  cohort_definition_syntax			TEXT	NULL,
  subject_concept_id				INT(11)			NOT NULL,
  cohort_initiation_date			DATE			NULL
)
;


CREATE TABLE attribute_definition (
  attribute_definition_id		INT(11)			NOT NULL,
  attribute_name				VARCHAR(255)	NOT NULL,
  attribute_description			TEXT	NULL,
  attribute_type_concept_id		INT(11)			NOT NULL,
  attribute_syntax				TEXT	NULL
)
;


/**************************

Standardized meta-data

***************************/


CREATE TABLE cdm_source 
    (  
     cdm_source_name					VARCHAR(255)	NOT NULL,
	 cdm_source_abbreviation			VARCHAR(25)		NULL,
	 cdm_holder							VARCHAR(255)	NULL,
	 source_description					TEXT	NULL,
	 source_documentation_reference		VARCHAR(255)	NULL,
	 cdm_etl_reference					VARCHAR(255)	NULL,
	 source_release_date				DATE			NULL,
	 cdm_release_date					DATE			NULL,
	 cdm_version						VARCHAR(10)		NULL,
	 vocabulary_version					VARCHAR(20)		NULL
    ) 
;







/************************

Standardized clinical data

************************/


CREATE TABLE person 
    (
     person_id						INT(11)		NOT NULL , 
     gender_concept_id				INT(11)		NOT NULL , 
     year_of_birth					INT(11)		NOT NULL , 
     month_of_birth					INT(11)		NULL, 
     day_of_birth					INT(11)		NULL, 
	 time_of_birth					VARCHAR(10)	NULL,
     race_concept_id				INT(11)		NOT NULL, 
     ethnicity_concept_id			INT(11)		NOT NULL, 
     location_id					INT(11)		NULL, 
     provider_id					INT(11)		NULL, 
     care_site_id					INT(11)		NULL, 
     person_source_value			VARCHAR(50) NULL, 
     gender_source_value			VARCHAR(50) NULL,
	 gender_source_concept_id		INT(11)		NULL, 
     race_source_value				VARCHAR(50) NULL, 
	 race_source_concept_id			INT(11)		NULL, 
     ethnicity_source_value			VARCHAR(50) NULL,
	 ethnicity_source_concept_id	INT(11)		NULL
    ) 
;





CREATE TABLE observation_period 
    ( 
     observation_period_id				INT(11)		NOT NULL , 
     person_id							INT(11)		NOT NULL , 
     observation_period_start_date		DATE		NOT NULL , 
     observation_period_end_date		DATE		NOT NULL ,
	 period_type_concept_id				INT(11)		NOT NULL
    ) 
;



CREATE TABLE specimen
    ( 
     specimen_id						INT(11)			NOT NULL ,
	 person_id							INT(11)			NOT NULL ,
	 specimen_concept_id				INT(11)			NOT NULL ,
	 specimen_type_concept_id			INT(11)			NOT NULL ,
	 specimen_date						DATE			NOT NULL ,
	 specimen_time						VARCHAR(10)		NULL ,
	 quantity							NUMERIC			NULL ,
	 unit_concept_id					INT(11)			NULL ,
	 anatomic_site_concept_id			INT(11)			NULL ,
	 disease_status_concept_id			INT(11)			NULL ,
	 specimen_source_id					VARCHAR(50)		NULL ,
	 specimen_source_value				VARCHAR(50)		NULL ,
	 unit_source_value					VARCHAR(50)		NULL ,
	 anatomic_site_source_value			VARCHAR(50)		NULL ,
	 disease_status_source_value		VARCHAR(50)		NULL
	)
;



CREATE TABLE death 
    ( 
     person_id							INT(11)			NOT NULL , 
     death_date							DATE			NOT NULL , 
     death_type_concept_id				INT(11)			NOT NULL , 
     cause_concept_id					INT(11)			NULL , 
     cause_source_value					VARCHAR(50)		NULL,
	 cause_source_concept_id			INT(11)			NULL
    ) 
;



CREATE TABLE visit_occurrence 
    ( 
     visit_occurrence_id			INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     visit_concept_id				INT(11)			NOT NULL , 
	 visit_start_date				DATE			NOT NULL , 
	 visit_start_time				VARCHAR(10)		NULL ,
     visit_end_date					DATE			NOT NULL ,
	 visit_end_time					VARCHAR(10)		NULL , 
	 visit_type_concept_id			INT(11)			NOT NULL ,
	 provider_id					INT(11)			NULL,
     care_site_id					INT(11)			NULL, 
     visit_source_value				VARCHAR(50)		NULL,
	 visit_source_concept_id		INT(11)			NULL
    ) 
;



CREATE TABLE procedure_occurrence 
    ( 
     procedure_occurrence_id		INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     procedure_concept_id			INT(11)			NOT NULL , 
     procedure_date					DATE			NOT NULL , 
     procedure_type_concept_id		INT(11)			NOT NULL ,
	 modifier_concept_id			INT(11)			NULL ,
	 quantity						INT(11)			NULL , 
     provider_id					INT(11)			NULL , 
     visit_occurrence_id			INT(11)			NULL , 
     procedure_source_value			VARCHAR(50)		NULL ,
	 procedure_source_concept_id	INT(11)			NULL ,
	 qualifier_source_value			VARCHAR(50)		NULL
    ) 
;



CREATE TABLE drug_exposure 
    ( 
     drug_exposure_id				INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     drug_concept_id				INT(11)			NOT NULL , 
     drug_exposure_start_date		DATE			NOT NULL , 
     drug_exposure_end_date			DATE			NULL , 
     drug_type_concept_id			INT(11)			NOT NULL , 
     stop_reason					VARCHAR(20)		NULL , 
     refills						INT(11)			NULL , 
     quantity						NUMERIC			NULL , 
     days_supply					INT(11)			NULL , 
     sig							TEXT	NULL , 
	 route_concept_id				INT(11)			NULL ,
	 effective_drug_dose			NUMERIC			NULL ,
	 dose_unit_concept_id			INT(11)			NULL ,
	 lot_number						VARCHAR(50)		NULL ,
     provider_id					INT(11)			NULL , 
     visit_occurrence_id			INT(11)			NULL , 
     drug_source_value				VARCHAR(50)		NULL ,
	 drug_source_concept_id			INT(11)			NULL ,
	 route_source_value				VARCHAR(50)		NULL ,
	 dose_unit_source_value			VARCHAR(50)		NULL
    ) 
;


CREATE TABLE device_exposure 
    ( 
     device_exposure_id				INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     device_concept_id				INT(11)			NOT NULL , 
     device_exposure_start_date		DATE			NOT NULL , 
     device_exposure_end_date		DATE			NULL , 
     device_type_concept_id			INT(11)			NOT NULL , 
	 unique_device_id				VARCHAR(50)		NULL ,
	 quantity						INT(11)			NULL ,
     provider_id					INT(11)			NULL , 
     visit_occurrence_id			INT(11)			NULL , 
     device_source_value			VARCHAR(100)	NULL ,
	 device_source_concept_id		INT(11)			NULL
    ) 
;


CREATE TABLE condition_occurrence 
    ( 
     condition_occurrence_id		INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     condition_concept_id			INT(11)			NOT NULL , 
     condition_start_date			DATE			NOT NULL , 
     condition_end_date				DATE			NULL , 
     condition_type_concept_id		INT(11)			NOT NULL , 
     stop_reason					VARCHAR(20)		NULL , 
     provider_id					INT(11)			NULL , 
     visit_occurrence_id			INT(11)			NULL , 
     condition_source_value			VARCHAR(50)		NULL ,
	 condition_source_concept_id	INT(11)			NULL
    ) 
;



CREATE TABLE measurement 
    ( 
     measurement_id					INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     measurement_concept_id			INT(11)			NOT NULL , 
     measurement_date				DATE			NOT NULL , 
     measurement_time				VARCHAR(10)		NULL ,
	 measurement_type_concept_id	INT(11)			NOT NULL ,
	 operator_concept_id			INT(11)			NULL , 
     value_as_number				NUMERIC			NULL , 
     value_as_concept_id			INT(11)			NULL , 
     unit_concept_id				INT(11)			NULL , 
     range_low						NUMERIC			NULL , 
     range_high						NUMERIC			NULL , 
     provider_id					INT(11)			NULL , 
     visit_occurrence_id			INT(11)			NULL ,  
     measurement_source_value		VARCHAR(50)		NULL , 
	 measurement_source_concept_id	INT(11)			NULL ,
     unit_source_value				VARCHAR(50)		NULL ,
	 value_source_value				VARCHAR(50)		NULL
    ) 
;



CREATE TABLE note 
    ( 
     note_id						INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     note_date						DATE			NOT NULL ,
	 note_time						VARCHAR(10)		NULL ,
	 note_type_concept_id			INT(11)			NOT NULL ,
	 note_text						TEXT	NOT NULL ,
     provider_id					INT(11)			NULL ,
	 visit_occurrence_id			INT(11)			NULL ,
	 note_source_value				VARCHAR(50)		NULL
    ) 
;



CREATE TABLE observation 
    ( 
     observation_id					INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     observation_concept_id			INT(11)			NOT NULL , 
     observation_date				DATE			NOT NULL , 
     observation_time				VARCHAR(10)		NULL , 
     observation_type_concept_id	INT(11)			NOT NULL , 
	 value_as_number				NUMERIC			NULL , 
     value_as_string				VARCHAR(60)		NULL , 
     value_as_concept_id			INT(11)			NULL , 
	 qualifier_concept_id			INT(11)			NULL ,
     unit_concept_id				INT(11)			NULL , 
     provider_id					INT(11)			NULL , 
     visit_occurrence_id			INT(11)			NULL , 
     observation_source_value		VARCHAR(50)		NULL ,
	 observation_source_concept_id	INT(11)			NULL , 
     unit_source_value				VARCHAR(50)		NULL ,
	 qualifier_source_value			VARCHAR(50)		NULL
    ) 
;



CREATE TABLE fact_relationship 
    ( 
     domain_concept_id_1			INT(11)			NOT NULL , 
	 fact_id_1						INT(11)			NOT NULL ,
	 domain_concept_id_2			INT(11)			NOT NULL ,
	 fact_id_2						INT(11)			NOT NULL ,
	 relationship_concept_id		INT(11)			NOT NULL
	)
;




/************************

Standardized health system data

************************/



CREATE TABLE location 
    ( 
     location_id					INT(11)			NOT NULL , 
     address_1						VARCHAR(50)		NULL , 
     address_2						VARCHAR(50)		NULL , 
     city							VARCHAR(50)		NULL , 
     state							VARCHAR(2)		NULL , 
     zip							VARCHAR(9)		NULL , 
     county							VARCHAR(20)		NULL , 
     location_source_value			VARCHAR(50)		NULL
    ) 
;



CREATE TABLE care_site 
    ( 
     care_site_id						INT(11)			NOT NULL , 
	 care_site_name						VARCHAR(255)	NULL ,
     place_of_service_concept_id		INT(11)			NULL ,
     location_id						INT(11)			NULL , 
     care_site_source_value				VARCHAR(50)		NULL , 
     place_of_service_source_value		VARCHAR(50)		NULL
    ) 
;


	
CREATE TABLE provider 
    ( 
     provider_id					INT(11)			NOT NULL ,
	 provider_name					VARCHAR(255)	NULL , 
     NPI							VARCHAR(20)		NULL , 
     DEA							VARCHAR(20)		NULL , 
     specialty_concept_id			INT(11)			NULL , 
     care_site_id					INT(11)			NULL , 
	 year_of_birth					INT(11)			NULL ,
	 gender_concept_id				INT(11)			NULL ,
     provider_source_value			VARCHAR(50)		NULL , 
     specialty_source_value			VARCHAR(50)		NULL ,
	 specialty_source_concept_id	INT(11)			NULL , 
	 gender_source_value			VARCHAR(50)		NULL ,
	 gender_source_concept_id		INT(11)			NULL
    ) 
;




/************************

Standardized health economics

************************/


CREATE TABLE payer_plan_period 
    ( 
     payer_plan_period_id			INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     payer_plan_period_start_date	DATE			NOT NULL , 
     payer_plan_period_end_date		DATE			NOT NULL , 
     payer_source_value				VARCHAR (50)	NULL , 
     plan_source_value				VARCHAR (50)	NULL , 
     family_source_value			VARCHAR (50)	NULL 
    ) 
;



CREATE TABLE visit_cost 
    ( 
     visit_cost_id					INT(11)			NOT NULL , 
     visit_occurrence_id			INT(11)			NOT NULL , 
	 currency_concept_id			INT(11)			NULL ,
     paid_copay						NUMERIC			NULL , 
     paid_coinsurance				NUMERIC			NULL , 
     paid_toward_deductible			NUMERIC			NULL , 
     paid_by_payer					NUMERIC			NULL , 
     paid_by_coordination_benefits	NUMERIC			NULL , 
     total_out_of_pocket			NUMERIC			NULL , 
     total_paid						NUMERIC			NULL ,  
     payer_plan_period_id			INT(11)			NULL
    ) 
;



CREATE TABLE procedure_cost 
    ( 
     procedure_cost_id				INT(11)			NOT NULL , 
     procedure_occurrence_id		INT(11)			NOT NULL , 
     currency_concept_id			INT(11)			NULL ,
     paid_copay						NUMERIC			NULL , 
     paid_coinsurance				NUMERIC			NULL , 
     paid_toward_deductible			NUMERIC			NULL , 
     paid_by_payer					NUMERIC			NULL , 
     paid_by_coordination_benefits	NUMERIC			NULL , 
     total_out_of_pocket			NUMERIC			NULL , 
     total_paid						NUMERIC			NULL ,
	 revenue_code_concept_id		INT(11)			NULL ,  
     payer_plan_period_id			INT(11)			NULL ,
	 revenue_code_source_value		VARCHAR(50)		NULL
	) 
;



CREATE TABLE drug_cost 
    (
     drug_cost_id					INT(11)			NOT NULL , 
     drug_exposure_id				INT(11)			NOT NULL , 
     currency_concept_id			INT(11)			NULL ,
     paid_copay						NUMERIC			NULL , 
     paid_coinsurance				NUMERIC			NULL , 
     paid_toward_deductible			NUMERIC			NULL , 
     paid_by_payer					NUMERIC			NULL , 
     paid_by_coordination_benefits	NUMERIC			NULL , 
     total_out_of_pocket			NUMERIC			NULL , 
     total_paid						NUMERIC			NULL , 
     ingredient_cost				NUMERIC			NULL , 
     dispensing_fee					NUMERIC			NULL , 
     average_wholesale_price		NUMERIC			NULL , 
     payer_plan_period_id			INT(11)			NULL
    ) 
;





CREATE TABLE device_cost 
    (
     device_cost_id					INT(11)			NOT NULL , 
     device_exposure_id				INT(11)			NOT NULL , 
     currency_concept_id			INT(11)			NULL ,
     paid_copay						NUMERIC			NULL , 
     paid_coinsurance				NUMERIC			NULL , 
     paid_toward_deductible			NUMERIC			NULL , 
     paid_by_payer					NUMERIC			NULL , 
     paid_by_coordination_benefits	NUMERIC			NULL , 
     total_out_of_pocket			NUMERIC			NULL , 
     total_paid						NUMERIC			NULL , 
     payer_plan_period_id			INT(11)			NULL
    ) 
;




/************************

Standardized derived elements

************************/

CREATE TABLE cohort 
    ( 
	 cohort_definition_id			INT(11)			NOT NULL , 
     subject_id						INT(11)			NOT NULL ,
	 cohort_start_date				DATE			NOT NULL , 
     cohort_end_date				DATE			NOT NULL
    ) 
;


CREATE TABLE cohort_attribute 
    ( 
	 cohort_definition_id			INT(11)			NOT NULL , 
     cohort_start_date				DATE			NOT NULL , 
     cohort_end_date				DATE			NOT NULL , 
     subject_id						INT(11)			NOT NULL , 
     attribute_definition_id		INT(11)			NOT NULL ,
	 value_as_number				NUMERIC			NULL ,
	 value_as_concept_id			INT(11)			NULL
    ) 
;




CREATE TABLE drug_era 
    ( 
     drug_era_id					INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     drug_concept_id				INT(11)			NOT NULL , 
     drug_era_start_date			DATE			NOT NULL , 
     drug_era_end_date				DATE			NOT NULL , 
     drug_exposure_count			INT(11)			NULL ,
	 gap_days						INT(11)			NULL
    ) 
;


CREATE TABLE dose_era 
    (
     dose_era_id					INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     drug_concept_id				INT(11)			NOT NULL , 
	 unit_concept_id				INT(11)			NOT NULL ,
	 dose_value						NUMERIC			NOT NULL ,
     dose_era_start_date			DATE			NOT NULL , 
     dose_era_end_date				DATE			NOT NULL 
    ) 
;




CREATE TABLE condition_era 
    ( 
     condition_era_id				INT(11)			NOT NULL , 
     person_id						INT(11)			NOT NULL , 
     condition_concept_id			INT(11)			NOT NULL , 
     condition_era_start_date		DATE			NOT NULL , 
     condition_era_end_date			DATE			NOT NULL , 
     condition_occurrence_count		INT(11)			NULL
    ) 
;







