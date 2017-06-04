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
                                                                              

Script to load the common data model, version 4.5 vocabulary tables for PostgreSQL database

Notes

1) This script assumes the CDM version 4.5 vocabulary zip file has been unzipped into the "C:\CDM" directory. 
2) If you unzipped your CDM version 4.5 vocabulary files into a different directory then replace all file paths below, with your directory path.
3) Run this SQL query script in the database where you created your CDM Version 4.5 tables

last revised: 20th March 2015

author:  Lee Evans


*************************/

COPY CONCEPT FROM 'C:\CDM\CONCEPT.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b' ;
COPY CONCEPT_ANCESTOR FROM 'C:\CDM\CONCEPT_ANCESTOR.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b' ;
COPY CONCEPT_RELATIONSHIP FROM 'C:\CDM\CONCEPT_RELATIONSHIP.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b' ;
COPY CONCEPT_SYNONYM FROM 'C:\CDM\CONCEPT_SYNONYM.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b' ;
COPY DRUG_STRENGTH FROM 'C:\CDM\DRUG_STRENGTH.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b' ;
COPY RELATIONSHIP FROM 'C:\CDM\RELATIONSHIP.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b' ;
COPY SOURCE_TO_CONCEPT_MAP FROM 'C:\CDM\SOURCE_TO_CONCEPT_MAP.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b' ;
COPY VOCABULARY FROM 'C:\CDM\VOCABULARY.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b' ;



