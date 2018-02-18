/*********************************************************************************
# Copyright 2018 Observational Health Data Sciences and Informatics
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
                                                                              

Script to load the common data model, version 5.0 vocabulary tables for SQL Server database

Notes

1) There is no data file load for the SOURCE_TO_CONCEPT_MAP table because that table is deprecated in CDM version 5.0
2) This script assumes the CDM version 5 vocabulary zip file has been unzipped into the "/export/home/nz/OMOPCDM53/VocabImport/" directory on the Netezza appliance. 
3) If you unzipped your CDM version 5 vocabulary files into a different directory then replace all file paths below, with your directory path.
4) Log files are written to the "/export/home/nz/OMOPCDM53/VocabImport/log" directory on the Netezza appliance
5) Run this SQL query script in the database where you created your CDM Version 5 tables
6) The MAXERRORS parameter is set to 1000. You will likely want this to be 0 in a prouduction environment. 
7) There are two records that will not load. 
	- CONCEPT table CONCEPT_ID = 4080894. This failes because the CONCEPT_NAME is the literial 'Null', and the Netezza bulk loader treats this as NULL, and CONCEPT.CONCEPT_NAME is defined as NOT NULL. 
    - CONCEPT_SYNONYM table CONCEPT_ID = 4080894. This failes because the CONCEPT_SYNONYM_NAME is the literial 'Null', and the Netezza bulk loader treats this as NULL, and CONCEPT_SYNONYM.CONCEPT_SYNONYM_NAME is defined as NOT NULL. 
    (Note the above are for the same exact CONCEPT_ID)
	
last revised: 18 Feb 2018

author:  Chris Sindoni 


*************************/

TRUNCATE TABLE DRUG_STRENGTH ;
CREATE EXTERNAL TABLE extDRUG_STRENGTH 
SAMEAS DBO.DRUG_STRENGTH
USING(
  DATAOBJECT ('/export/home/nz/OMOPCDM53/VocabImport/DRUG_STRENGTH.csv') 
  DATEDELIM ''
  DATESTYLE 'YMD'
  DELIMITER '\t' 
  FORMAT 'text' 
  LOGDIR '/export/home/nz/OMOPCDM53/VocabImport/log'
  MAXERRORS 1000
  SKIPROWS 1
  ) ; 
INSERT INTO DBO.DRUG_STRENGTH SELECT * FROM extDRUG_STRENGTH ;
DROP TABLE extDRUG_STRENGTH ;

TRUNCATE TABLE CONCEPT ;
CREATE EXTERNAL TABLE extCONCEPT 
SAMEAS DBO.CONCEPT
USING(
  DATAOBJECT ('/export/home/nz/OMOPCDM53/VocabImport/CONCEPT.csv') 
  DATEDELIM ''
  DATESTYLE 'YMD'
  DELIMITER '\t' 
  FORMAT 'text' 
  LOGDIR '/export/home/nz/OMOPCDM53/VocabImport/log'
  MAXERRORS 1000
  SKIPROWS 1
  ) ; 
INSERT INTO DBO.CONCEPT SELECT * FROM extCONCEPT ;
DROP TABLE extCONCEPT ;

-- SELECT COUNT(*) FROM DBO.CONCEPT
-- 4,133,307
-- 4,133,308
-- Note there is one more record in SQL Server. I think there is probably one error row in Netezza. 


TRUNCATE TABLE CONCEPT_RELATIONSHIP ;
CREATE EXTERNAL TABLE extCONCEPT_RELATIONSHIP 
SAMEAS DBO.CONCEPT_RELATIONSHIP
USING(
  DATAOBJECT ('/export/home/nz/OMOPCDM53/VocabImport/CONCEPT_RELATIONSHIP.csv') 
  DATEDELIM ''
  DATESTYLE 'YMD'
  DELIMITER '\t' 
  FORMAT 'text' 
  LOGDIR '/export/home/nz/OMOPCDM53/VocabImport/log'
  MAXERRORS 1000
  SKIPROWS 1
  ) ; 
INSERT INTO DBO.CONCEPT_RELATIONSHIP SELECT * FROM extCONCEPT_RELATIONSHIP ;
DROP TABLE extCONCEPT_RELATIONSHIP ;


TRUNCATE TABLE CONCEPT_ANCESTOR ;
CREATE EXTERNAL TABLE extCONCEPT_ANCESTOR 
SAMEAS DBO.CONCEPT_ANCESTOR
USING(
  DATAOBJECT ('/export/home/nz/OMOPCDM53/VocabImport/CONCEPT_ANCESTOR.csv') 
  DATEDELIM ''
  DATESTYLE 'YMD'
  DELIMITER '\t' 
  FORMAT 'text' 
  LOGDIR '/export/home/nz/OMOPCDM53/VocabImport/log'
  MAXERRORS 1000
  SKIPROWS 1
  ) ; 
INSERT INTO DBO.CONCEPT_ANCESTOR SELECT * FROM extCONCEPT_ANCESTOR ;
DROP TABLE extCONCEPT_ANCESTOR ;


TRUNCATE TABLE CONCEPT_SYNONYM ;
CREATE EXTERNAL TABLE extCONCEPT_SYNONYM 
SAMEAS DBO.CONCEPT_SYNONYM
USING(
  DATAOBJECT ('/export/home/nz/OMOPCDM53/VocabImport/CONCEPT_SYNONYM.csv') 
  DATEDELIM ''
  DATESTYLE 'YMD'
  DELIMITER '\t' 
  FORMAT 'text' 
  LOGDIR '/export/home/nz/OMOPCDM53/VocabImport/log'
  MAXERRORS 1000
  SKIPROWS 1
  ) ; 
INSERT INTO DBO.CONCEPT_SYNONYM SELECT * FROM extCONCEPT_SYNONYM ;
DROP TABLE extCONCEPT_SYNONYM ;
-- 5565249 
-- 5565250 IN SQL SERVER 


TRUNCATE TABLE VOCABULARY ;
CREATE EXTERNAL TABLE extVOCABULARY 
SAMEAS DBO.VOCABULARY
USING(
  DATAOBJECT ('/export/home/nz/OMOPCDM53/VocabImport/VOCABULARY.csv') 
  DATEDELIM ''
  DATESTYLE 'YMD'
  DELIMITER '\t' 
  FORMAT 'text' 
  LOGDIR '/export/home/nz/OMOPCDM53/VocabImport/log'
  MAXERRORS 1000
  SKIPROWS 1
  ) ; 
INSERT INTO DBO.VOCABULARY SELECT * FROM extVOCABULARY ;
DROP TABLE extVOCABULARY ;

TRUNCATE TABLE RELATIONSHIP ;
CREATE EXTERNAL TABLE extRELATIONSHIP
SAMEAS DBO.RELATIONSHIP
USING(
  DATAOBJECT ('/export/home/nz/OMOPCDM53/VocabImport/RELATIONSHIP.csv') 
  DATEDELIM ''
  DATESTYLE 'YMD'
  DELIMITER '\t' 
  FORMAT 'text' 
  LOGDIR '/export/home/nz/OMOPCDM53/VocabImport/log'
  MAXERRORS 1000
  SKIPROWS 1
  ) ; 
INSERT INTO DBO.RELATIONSHIP SELECT * FROM extRELATIONSHIP ;
DROP TABLE extRELATIONSHIP ;


TRUNCATE TABLE CONCEPT_CLASS ;
CREATE EXTERNAL TABLE extCONCEPT_CLASS
SAMEAS DBO.CONCEPT_CLASS
USING(
  DATAOBJECT ('/export/home/nz/OMOPCDM53/VocabImport/CONCEPT_CLASS.csv') 
  DATEDELIM ''
  DATESTYLE 'YMD'
  DELIMITER '\t' 
  FORMAT 'text' 
  LOGDIR '/export/home/nz/OMOPCDM53/VocabImport/log'
  MAXERRORS 1000
  SKIPROWS 1
  ) ; 
INSERT INTO DBO.CONCEPT_CLASS SELECT * FROM extCONCEPT_CLASS ;
DROP TABLE extCONCEPT_CLASS ;


TRUNCATE TABLE DOMAIN ;
CREATE EXTERNAL TABLE extDOMAIN 
SAMEAS DBO.DOMAIN
USING(
  DATAOBJECT ('/export/home/nz/OMOPCDM53/VocabImport/DOMAIN.csv') 
  DATEDELIM ''
  DATESTYLE 'YMD'
  DELIMITER '\t' 
  FORMAT 'text' 
  LOGDIR '/export/home/nz/OMOPCDM53/VocabImport/log'
  MAXERRORS 1000
  SKIPROWS 1
  ) ; 
INSERT INTO DBO.DOMAIN SELECT * FROM extDOMAIN ;
DROP TABLE extDOMAIN ;


