/*********************************************************************************
# Copyright 2014-6 Observational Health Data Sciences and Informatics
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

 ####### #     # ####### ######      #####  ######  #     #           #######       #         ###   
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #            ##        #   #  
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #           # #       #     # 
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######        #       #     # 
 #     # #     # #     # #          #       #     # #     #    #    #       # ###   #   ### #     # 
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ###   #   ###  #   #  
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ### ##### ###   ###   
                                                                                                    

script to create OMOP common data model, version 5.1.0 for Hadoop (Hive/Impala) database

Based on the PostgreSQL version, with the following changes:
* NULL/NOT NULL is not used.
* Dates are stored as VARCHAR(8). See http://stackoverflow.com/questions/33024309/convert-yyyymmdd-string-to-date-in-impala for how to treat date columns as dates.
* PostgreSQL NUMERIC is stored as DOUBLE for amounts, and DECIMAL(19,4) for prices.
* PostgreSQL TEXT is stored as STRING.

*************************/


/************************

Standardized vocabulary

************************/


CREATE TABLE concept (
 concept_id INTEGER,
 concept_name VARCHAR(255),
 domain_id VARCHAR(20),
 vocabulary_id VARCHAR(20),
 concept_class_id VARCHAR(20),
 standard_concept VARCHAR(1),
 concept_code VARCHAR(50),
 valid_start_date VARCHAR(8), -- DATE
 valid_end_date VARCHAR(8), -- DATE
 invalid_reason VARCHAR(1)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="1")
;




CREATE TABLE vocabulary (
 vocabulary_id VARCHAR(20),
 vocabulary_name VARCHAR(255),
 vocabulary_reference VARCHAR(255),
 vocabulary_version VARCHAR(255),
 vocabulary_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="1")
;




CREATE TABLE domain (
 domain_id VARCHAR(20),
 domain_name VARCHAR(255),
 domain_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE concept_class (
 concept_class_id VARCHAR(20),
 concept_class_name VARCHAR(255),
 concept_class_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="1")
;




CREATE TABLE concept_relationship (
 concept_id_1 INTEGER,
 concept_id_2 INTEGER,
 relationship_id VARCHAR(20),
 valid_start_date VARCHAR(8), -- DATE
 valid_end_date VARCHAR(8), -- DATE
 invalid_reason VARCHAR(1)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE relationship (
 relationship_id VARCHAR(20),
 relationship_name VARCHAR(255),
 is_hierarchical VARCHAR(1),
 defines_ancestry VARCHAR(1),
 reverse_relationship_id VARCHAR(20),
 relationship_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="1")
;


CREATE TABLE concept_synonym (
 concept_id INTEGER,
 concept_synonym_name VARCHAR(1000),
 language_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="1")
;


CREATE TABLE concept_ancestor (
 ancestor_concept_id INTEGER,
 descendant_concept_id INTEGER,
 min_levels_of_separation INTEGER,
 max_levels_of_separation INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE source_to_concept_map (
 source_code VARCHAR(50),
 source_concept_id INTEGER,
 source_vocabulary_id VARCHAR(20),
 source_code_description VARCHAR(255),
 target_concept_id INTEGER,
 target_vocabulary_id VARCHAR(20),
 valid_start_date VARCHAR(8), -- DATE
 valid_end_date VARCHAR(8), -- DATE
 invalid_reason VARCHAR(1)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="1")
;




CREATE TABLE drug_strength (
 drug_concept_id INTEGER,
 ingredient_concept_id INTEGER,
 amount_value DOUBLE, -- NUMERIC
 amount_unit_concept_id INTEGER,
 numerator_value DOUBLE, -- NUMERIC
 numerator_unit_concept_id INTEGER,
 denominator_value DOUBLE, -- NUMERIC
 denominator_unit_concept_id INTEGER,
 box_size INTEGER,
 valid_start_date VARCHAR(8), -- DATE
 valid_end_date VARCHAR(8), -- DATE
 invalid_reason VARCHAR(1)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE cohort_definition (
 cohort_definition_id INTEGER,
 cohort_definition_name VARCHAR(255),
 cohort_definition_description STRING, -- TEXT
 definition_type_concept_id INTEGER,
 cohort_definition_syntax STRING, -- TEXT
 subject_concept_id INTEGER,
 cohort_initiation_date VARCHAR(8) -- DATE
)
;


CREATE TABLE attribute_definition (
 attribute_definition_id INTEGER,
 attribute_name VARCHAR(255),
 attribute_description STRING, -- TEXT
 attribute_type_concept_id INTEGER,
 attribute_syntax STRING -- TEXT
)
;

/**************************

Standardized meta-data

***************************/


CREATE TABLE cdm_source 
 ( 
 cdm_source_name VARCHAR(255),
 cdm_source_abbreviation VARCHAR(25),
 cdm_holder VARCHAR(255),
 source_description STRING, -- TEXT
 source_documentation_reference VARCHAR(255),
 cdm_etl_reference VARCHAR(255),
 source_release_date VARCHAR(8), -- DATE
 cdm_release_date VARCHAR(8), -- DATE
 cdm_version VARCHAR(10),
 vocabulary_version VARCHAR(20)
 ) 
;






/************************

Standardized clinical data

************************/


CREATE TABLE person (
 person_id INTEGER,
 gender_concept_id INTEGER,
 year_of_birth INTEGER,
 month_of_birth INTEGER,
 day_of_birth INTEGER,
 time_of_birth VARCHAR(10),
 race_concept_id INTEGER,
 ethnicity_concept_id INTEGER,
 location_id INTEGER,
 provider_id INTEGER,
 care_site_id INTEGER,
 person_source_value VARCHAR(50),
 gender_source_value VARCHAR(50),
 gender_source_concept_id INTEGER,
 race_source_value VARCHAR(50),
 race_source_concept_id INTEGER,
 ethnicity_source_value VARCHAR(50),
 ethnicity_source_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;





CREATE TABLE observation_period (
 observation_period_id INTEGER,
 person_id INTEGER,
 observation_period_start_date VARCHAR(8), -- DATE
 observation_period_end_date VARCHAR(8), -- DATE
 period_type_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE specimen (
 specimen_id INTEGER,
 person_id INTEGER,
 specimen_concept_id INTEGER,
 specimen_type_concept_id INTEGER,
 specimen_date VARCHAR(8), -- DATE
 specimen_time VARCHAR(10),
 quantity DOUBLE, -- NUMERIC
 unit_concept_id INTEGER,
 anatomic_site_concept_id INTEGER,
 disease_status_concept_id INTEGER,
 specimen_source_id VARCHAR(50),
 specimen_source_value VARCHAR(50),
 unit_source_value VARCHAR(50),
 anatomic_site_source_value VARCHAR(50),
 disease_status_source_value VARCHAR(50)
)
;



CREATE TABLE death (
 person_id INTEGER,
 death_date VARCHAR(8), -- DATE
 death_type_concept_id INTEGER,
 cause_concept_id INTEGER,
 cause_source_value VARCHAR(50),
 cause_source_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE visit_occurrence (
 visit_occurrence_id INTEGER,
 person_id INTEGER,
 visit_concept_id INTEGER,
 visit_start_date VARCHAR(8), -- DATE
 visit_start_time VARCHAR(10),
 visit_end_date VARCHAR(8), -- DATE
 visit_end_time VARCHAR(10),
 visit_type_concept_id INTEGER,
 provider_id INTEGER,
 care_site_id INTEGER,
 visit_source_value VARCHAR(50),
 visit_source_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE procedure_occurrence (
 procedure_occurrence_id INTEGER,
 person_id INTEGER,
 procedure_concept_id INTEGER,
 procedure_date VARCHAR(8), -- DATE
 procedure_type_concept_id INTEGER,
 modifier_concept_id INTEGER,
 quantity INTEGER,
 provider_id INTEGER,
 visit_occurrence_id INTEGER,
 procedure_source_value VARCHAR(50),
 procedure_source_concept_id INTEGER,
 qualifier_source_value VARCHAR(50)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE drug_exposure (
 drug_exposure_id INTEGER,
 person_id INTEGER,
 drug_concept_id INTEGER,
 drug_exposure_start_date VARCHAR(8), -- DATE
 drug_exposure_end_date VARCHAR(8), -- DATE
 drug_type_concept_id INTEGER,
 stop_reason VARCHAR(20),
 refills INTEGER,
 quantity DOUBLE, -- NUMERIC
 days_supply INTEGER,
 sig STRING, -- TEXT
 route_concept_id INTEGER,
 effective_drug_dose DOUBLE, -- NUMERIC
 dose_unit_concept_id INTEGER,
 lot_number VARCHAR(50),
 provider_id INTEGER,
 visit_occurrence_id INTEGER,
 drug_source_value VARCHAR(50),
 drug_source_concept_id INTEGER,
 route_source_value VARCHAR(50),
 dose_unit_source_value VARCHAR(50)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;


CREATE TABLE device_exposure (
 device_exposure_id INTEGER,
 person_id INTEGER,
 device_concept_id INTEGER,
 device_exposure_start_date VARCHAR(8), -- DATE
 device_exposure_end_date VARCHAR(8), -- DATE
 device_type_concept_id INTEGER,
 unique_device_id VARCHAR(50),
 quantity INTEGER,
 provider_id INTEGER,
 visit_occurrence_id INTEGER,
 device_source_value VARCHAR(100),
 device_source_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;


CREATE TABLE condition_occurrence (
 condition_occurrence_id INTEGER,
 person_id INTEGER,
 condition_concept_id INTEGER,
 condition_start_date VARCHAR(8), -- DATE
 condition_end_date VARCHAR(8), -- DATE
 condition_type_concept_id INTEGER,
 stop_reason VARCHAR(20),
 provider_id INTEGER,
 visit_occurrence_id INTEGER,
 condition_source_value VARCHAR(50),
 condition_source_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE measurement (
 measurement_id INTEGER,
 person_id INTEGER,
 measurement_concept_id INTEGER,
 measurement_date VARCHAR(8), -- DATE
 measurement_time VARCHAR(10),
 measurement_type_concept_id INTEGER,
 operator_concept_id INTEGER,
 value_as_number DOUBLE, -- NUMERIC
 value_as_concept_id INTEGER,
 unit_concept_id INTEGER,
 range_low DOUBLE, -- NUMERIC
 range_high DOUBLE, -- NUMERIC
 provider_id INTEGER,
 visit_occurrence_id INTEGER,
 measurement_source_value VARCHAR(50),
 measurement_source_concept_id INTEGER,
 unit_source_value VARCHAR(50),
 value_source_value VARCHAR(50)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE note (
 note_id INTEGER,
 person_id INTEGER,
 note_date VARCHAR(8), -- DATE
 note_time VARCHAR(10),
 note_type_concept_id INTEGER,
 note_text STRING, -- TEXT
 provider_id INTEGER,
 visit_occurrence_id INTEGER,
 note_source_value VARCHAR(50)
)
;



CREATE TABLE observation (
 observation_id INTEGER,
 person_id INTEGER,
 observation_concept_id INTEGER,
 observation_date VARCHAR(8), -- DATE
 observation_time VARCHAR(10),
 observation_type_concept_id INTEGER,
 value_as_number DOUBLE, -- NUMERIC
 value_as_string VARCHAR(60),
 value_as_concept_id INTEGER,
 qualifier_concept_id INTEGER,
 unit_concept_id INTEGER,
 provider_id INTEGER,
 visit_occurrence_id INTEGER,
 observation_source_value VARCHAR(50),
 observation_source_concept_id INTEGER,
 unit_source_value VARCHAR(50),
 qualifier_source_value VARCHAR(50)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE fact_relationship (
 domain_concept_id_1 INTEGER,
 fact_id_1 INTEGER,
 domain_concept_id_2 INTEGER,
 fact_id_2 INTEGER,
 relationship_concept_id INTEGER
)
;




/************************

Standardized health system data

************************/



CREATE TABLE `location` (
 location_id INTEGER,
 address_1 VARCHAR(50),
 address_2 VARCHAR(50),
 city VARCHAR(50),
 state VARCHAR(2),
 zip VARCHAR(9),
 county VARCHAR(20),
 location_source_value VARCHAR(50)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE care_site (
 care_site_id INTEGER,
 care_site_name VARCHAR(255),
 place_of_service_concept_id INTEGER,
 location_id INTEGER,
 care_site_source_value VARCHAR(50),
 place_of_service_source_value VARCHAR(50)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;



CREATE TABLE provider (
 provider_id INTEGER,
 provider_name VARCHAR(255),
 NPI VARCHAR(20),
 DEA VARCHAR(20),
 specialty_concept_id INTEGER,
 care_site_id INTEGER,
 year_of_birth INTEGER,
 gender_concept_id INTEGER,
 provider_source_value VARCHAR(50),
 specialty_source_value VARCHAR(50),
 specialty_source_concept_id INTEGER,
 gender_source_value VARCHAR(50),
 gender_source_concept_id INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;




/************************

Standardized health economics

************************/


CREATE TABLE payer_plan_period (
 payer_plan_period_id INTEGER,
 person_id INTEGER,
 payer_plan_period_start_date VARCHAR(8), -- DATE
 payer_plan_period_end_date VARCHAR(8), -- DATE
 payer_source_value VARCHAR (50),
 plan_source_value VARCHAR (50),
 family_source_value VARCHAR (50)
)
;


/* The individual cost tables are being phased out and will disappear soon

CREATE TABLE visit_cost (
 visit_cost_id INTEGER,
 visit_occurrence_id INTEGER,
 currency_concept_id INTEGER,
 paid_copay DECIMAL(19,4), -- NUMERIC
 paid_coinsurance DECIMAL(19,4), -- NUMERIC
 paid_toward_deductible DECIMAL(19,4), -- NUMERIC
 paid_by_payer DECIMAL(19,4), -- NUMERIC
 paid_by_coordination_benefits DECIMAL(19,4), -- NUMERIC
 total_out_of_pocket DECIMAL(19,4), -- NUMERIC
 total_paid DECIMAL(19,4), -- NUMERIC
 payer_plan_period_id INTEGER
)
;



CREATE TABLE procedure_cost (
 procedure_cost_id INTEGER,
 procedure_occurrence_id INTEGER,
 currency_concept_id INTEGER,
 paid_copay DECIMAL(19,4), -- NUMERIC
 paid_coinsurance DECIMAL(19,4), -- NUMERIC
 paid_toward_deductible DECIMAL(19,4), -- NUMERIC
 paid_by_payer DECIMAL(19,4), -- NUMERIC
 paid_by_coordination_benefits DECIMAL(19,4), -- NUMERIC
 total_out_of_pocket DECIMAL(19,4), -- NUMERIC
 total_paid DECIMAL(19,4), -- NUMERIC
 revenue_code_concept_id INTEGER,
 payer_plan_period_id INTEGER,
 revenue_code_source_value VARCHAR(50)
)
;



CREATE TABLE drug_cost (
 drug_cost_id INTEGER,
 drug_exposure_id INTEGER,
 currency_concept_id INTEGER,
 paid_copay DECIMAL(19,4), -- NUMERIC
 paid_coinsurance DECIMAL(19,4), -- NUMERIC
 paid_toward_deductible DECIMAL(19,4), -- NUMERIC
 paid_by_payer DECIMAL(19,4), -- NUMERIC
 paid_by_coordination_benefits DECIMAL(19,4), -- NUMERIC
 total_out_of_pocket DECIMAL(19,4), -- NUMERIC
 total_paid DECIMAL(19,4), -- NUMERIC
 ingredient_cost DECIMAL(19,4), -- NUMERIC
 dispensing_fee DECIMAL(19,4), -- NUMERIC
 average_wholesale_price DECIMAL(19,4), -- NUMERIC
 payer_plan_period_id INTEGER
)
;





CREATE TABLE device_cost (
 device_cost_id INTEGER,
 device_exposure_id INTEGER,
 currency_concept_id INTEGER,
 paid_copay DECIMAL(19,4), -- NUMERIC
 paid_coinsurance DECIMAL(19,4), -- NUMERIC
 paid_toward_deductible DECIMAL(19,4), -- NUMERIC
 paid_by_payer DECIMAL(19,4), -- NUMERIC
 paid_by_coordination_benefits DECIMAL(19,4), -- NUMERIC
 total_out_of_pocket DECIMAL(19,4), -- NUMERIC
 total_paid DECIMAL(19,4), -- NUMERIC
 payer_plan_period_id INTEGER
)
;
*/


CREATE TABLE cost (
 cost_id INTEGER,
 cost_event_id INTEGER,
 cost_domain_id VARCHAR(20),
 cost_type_concept_id INTEGER,
 currency_concept_id INTEGER,
 total_charge DECIMAL(19,4), -- NUMERIC
 total_cost DECIMAL(19,4), -- NUMERIC
 total_paid DECIMAL(19,4), -- NUMERIC
 paid_by_payer DECIMAL(19,4), -- NUMERIC
 paid_by_patient DECIMAL(19,4), -- NUMERIC
 paid_patient_copay DECIMAL(19,4), -- NUMERIC
 paid_patient_coinsurance DECIMAL(19,4), -- NUMERIC
 paid_patient_deductible DECIMAL(19,4), -- NUMERIC
 paid_by_primary DECIMAL(19,4), -- NUMERIC
 paid_ingredient_cost DECIMAL(19,4), -- NUMERIC
 paid_dispensing_fee DECIMAL(19,4), -- NUMERIC
 payer_plan_period_id INTEGER,
 amount_allowed DECIMAL(19,4), -- NUMERIC
 revenue_code_concept_id INTEGER,
 reveue_code_source_value VARCHAR(50) 
)
;





/************************

Standardized derived elements

************************/

CREATE TABLE cohort (
 cohort_definition_id INTEGER,
 subject_id INTEGER,
 cohort_start_date VARCHAR(8), -- DATE
 cohort_end_date VARCHAR(8) -- DATE
)
;


CREATE TABLE cohort_attribute (
 cohort_definition_id INTEGER,
 cohort_start_date VARCHAR(8), -- DATE
 cohort_end_date VARCHAR(8), -- DATE
 subject_id INTEGER,
 attribute_definition_id INTEGER,
 value_as_number DOUBLE, -- NUMERIC
 value_as_concept_id INTEGER
)
;




CREATE TABLE drug_era (
 drug_era_id INTEGER,
 person_id INTEGER,
 drug_concept_id INTEGER,
 drug_era_start_date VARCHAR(8), -- DATE
 drug_era_end_date VARCHAR(8), -- DATE
 drug_exposure_count INTEGER,
 gap_days INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;


CREATE TABLE dose_era (
 dose_era_id INTEGER,
 person_id INTEGER,
 drug_concept_id INTEGER,
 unit_concept_id INTEGER,
 dose_value DOUBLE, -- NUMERIC
 dose_era_start_date VARCHAR(8), -- DATE
 dose_era_end_date VARCHAR(8) -- DATE
)
;




CREATE TABLE condition_era (
 condition_era_id INTEGER,
 person_id INTEGER,
 condition_concept_id INTEGER,
 condition_era_start_date VARCHAR(8), -- DATE
 condition_era_end_date VARCHAR(8), -- DATE
 condition_occurrence_count INTEGER
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES ("skip.header.line.count"="1")
;







