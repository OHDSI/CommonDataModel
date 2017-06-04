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
                                                                              

script to create OMOP common data model, version 4.5 for Sql Server database

last revised: 20 Mar 2015

author:  Lee Evans


*************************/


CREATE TABLE CONCEPT(
	CONCEPT_ID int NOT NULL,
	CONCEPT_NAME varchar(256) NOT NULL,
	CONCEPT_LEVEL int NOT NULL,
	CONCEPT_CLASS varchar(60) NOT NULL,
	VOCABULARY_ID int NOT NULL,
	CONCEPT_CODE varchar(40) NOT NULL,
	VALID_START_DATE date NOT NULL,
	VALID_END_DATE date NOT NULL DEFAULT ('31-Dec-2099'),
	INVALID_REASON char(1) NULL
);


CREATE TABLE CONCEPT_ANCESTOR(
	ANCESTOR_CONCEPT_ID int NOT NULL,
	DESCENDANT_CONCEPT_ID int NOT NULL,
	MAX_LEVELS_OF_SEPARATION int NULL,
	MIN_LEVELS_OF_SEPARATION int NULL
);


CREATE TABLE CONCEPT_RELATIONSHIP(
	CONCEPT_ID_1 int NOT NULL,
	CONCEPT_ID_2 int NOT NULL,
	RELATIONSHIP_ID int NOT NULL,
	VALID_START_DATE date NOT NULL,
	VALID_END_DATE date NOT NULL DEFAULT ('31-Dec-2099'),
	INVALID_REASON char(1) NULL
);


CREATE TABLE CONCEPT_SYNONYM(
	CONCEPT_SYNONYM_ID int NOT NULL,
	CONCEPT_ID int NOT NULL,
	CONCEPT_SYNONYM_NAME varchar(1000) NOT NULL
);


CREATE TABLE DRUG_STRENGTH(
	DRUG_CONCEPT_ID int NOT NULL,
	INGREDIENT_CONCEPT_ID int NOT NULL,
	AMOUNT_VALUE float NULL,
	AMOUNT_UNIT varchar(60) NULL,
	CONCENTRATION_VALUE float NULL,
	CONCENTRATION_ENUM_UNIT varchar(60) NULL,
	CONCENTRATION_DENOM_UNIT varchar(60) NULL,
	VALID_START_DATE date NOT NULL,
	VALID_END_DATE date NOT NULL,
	INVALID_REASON varchar(1) NULL
);


CREATE TABLE RELATIONSHIP(
	RELATIONSHIP_ID int NOT NULL,
	RELATIONSHIP_NAME varchar(256) NOT NULL,
	IS_HIERARCHICAL int NOT NULL,
	DEFINES_ANCESTRY int NOT NULL DEFAULT ((1)),
	REVERSE_RELATIONSHIP int NULL
);


CREATE TABLE SOURCE_TO_CONCEPT_MAP(
	SOURCE_CODE varchar(40) NOT NULL,
	SOURCE_VOCABULARY_ID int NOT NULL,
	SOURCE_CODE_DESCRIPTION varchar(256) NULL,
	TARGET_CONCEPT_ID int NOT NULL,
	TARGET_VOCABULARY_ID int NOT NULL,
	MAPPING_TYPE varchar(256) NULL,
	PRIMARY_MAP char(1) NULL,
	VALID_START_DATE date NOT NULL,
	VALID_END_DATE date NOT NULL DEFAULT ('31-Dec-2099'),
	INVALID_REASON char(1) NULL
);


CREATE TABLE VOCABULARY(
	VOCABULARY_ID int NOT NULL,
	VOCABULARY_NAME varchar(256) NOT NULL
);
