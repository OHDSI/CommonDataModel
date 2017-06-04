
/*********************************************************************************
# Copyright 2015 Observational Health Data Sciences and Informatics
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
# limitations under the License.4
********************************************************************************/

/************************

 ####### #     # ####### ######      #####  ######  #     #              ##   ####### 
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    #   # #   #       
 #     # # # # # #     # #     #    #       #     # # # # #    #    #  #  #   #       
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ####### #######  
 #     # #     # #     # #          #       #     # #     #    #    #     #         # 
 #     # #     # #     # #          #     # #     # #     #     #  #      #   #     # 
 ####### #     # ####### #           #####  ######  #     #      ##       # #  #####  
                                                                              

script to create OMOP common data model, version 4.5 for PostgreSQL database

last revised: 20 Mar 2015

author:  Lee Evans


*************************/

CREATE TABLE concept (
  concept_id integer NOT NULL,
  concept_name varchar(256) NOT NULL,
  concept_level integer NOT NULL,
  concept_class varchar(60) NOT NULL,
  vocabulary_id integer NOT NULL,
  concept_code varchar(40) NOT NULL,
  valid_start_date date NOT NULL,
  valid_end_date date NOT NULL DEFAULT '2099-12-31'::date,
  invalid_reason varchar(1)
)
;


CREATE TABLE concept_ancestor (
  ancestor_concept_id		INTEGER		NOT NULL,
  descendant_concept_id		INTEGER		NOT NULL,
  min_levels_of_separation	INTEGER		NOT NULL,
  max_levels_of_separation	INTEGER		NOT NULL
)
;


CREATE TABLE concept_relationship (
  concept_id_1 integer NOT NULL,
  concept_id_2 integer NOT NULL,
  relationship_id integer NOT NULL,
  valid_start_date date NOT NULL,
  valid_end_date date NOT NULL DEFAULT '2099-12-31'::date,
  invalid_reason varchar(1)
)
;


CREATE TABLE concept_synonym (
  concept_synonym_id integer NOT NULL,
  concept_id integer NOT NULL,
  concept_synonym_name varchar(1000) NOT NULL
)
;



CREATE TABLE drug_strength (
  drug_concept_id integer NOT NULL,
  ingredient_concept_id integer NOT NULL,
  amount_value double precision,
  amount_unit varchar(60),
  concentration_value double precision,
  concentration_enum_unit character varying(60),
  concentration_denom_unit character varying(60),
  valid_start_date date NOT NULL,
  valid_end_date date NOT NULL,
  invalid_reason varchar(1)
)
;




CREATE TABLE relationship (
  relationship_id			VARCHAR(20)	NOT NULL,
  relationship_name			VARCHAR(256)	NOT NULL,
  is_hierarchical			integer		NOT NULL,
  defines_ancestry			integer		DEFAULT 1,
  reverse_relationship			integer		
)
;



CREATE TABLE source_to_concept_map (
  source_code				VARCHAR(40)		NOT NULL,
  source_vocabulary_id		INTEGER		NOT NULL,
  source_code_description	VARCHAR(256),
  target_concept_id			INTEGER			NOT NULL,
  target_vocabulary_id		INTEGER		NOT NULL,
  mapping_type			VARCHAR(256),
  primary_map			VARCHAR(1),
  valid_start_date			DATE			NOT NULL,
  valid_end_date			DATE			NOT NULL,
  invalid_reason			VARCHAR(1)		NULL
)
;




CREATE TABLE vocabulary (
  vocabulary_id			integer		NOT NULL,
  vocabulary_name		VARCHAR(256)	NOT NULL
)
;
