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
                                                                              

Script to load the common data model, version 4.5 vocabulary tables for SQL Server database

Notes

1) This script assumes the CDM version 4.5 vocabulary zip file has been unzipped into the "C:\CDM" directory. 
2) If you unzipped your CDM version 4.5 vocabulary files into a different directory then replace all file paths below, with your directory path.
3) Run this SQL query script in the database where you created your CDM Version 4.5 tables

last revised: 20th March 2015

author:  Lee Evans


*************************/

TRUNCATE TABLE CONCEPT;
BULK INSERT CONCEPT 
FROM 'C:\CDM\CONCEPT.csv' 
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '0x0a',
ERRORFILE = 'C:\CDM\CONCEPT.bad',
TABLOCK
);

TRUNCATE TABLE CONCEPT_ANCESTOR;
BULK INSERT CONCEPT_ANCESTOR 
FROM 'C:\CDM\CONCEPT_ANCESTOR.csv' 
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '0x0a',
ERRORFILE = 'C:\CDM\CONCEPT_ANCESTOR.bad',
TABLOCK
);

TRUNCATE TABLE CONCEPT_RELATIONSHIP;
BULK INSERT CONCEPT_RELATIONSHIP 
FROM 'C:\CDM\CONCEPT_RELATIONSHIP.csv' 
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '0x0a',
ERRORFILE = 'C:\CDM\CONCEPT_RELATIONSHIP.bad',
TABLOCK
);

TRUNCATE TABLE CONCEPT_SYNONYM;
BULK INSERT CONCEPT_SYNONYM 
FROM 'C:\CDM\CONCEPT_SYNONYM.csv' 
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '0x0a',
ERRORFILE = 'C:\CDM\CONCEPT_SYNONYM.bad',
TABLOCK
);

TRUNCATE TABLE DRUG_STRENGTH;
BULK INSERT DRUG_STRENGTH 
FROM 'C:\CDM\DRUG_STRENGTH.csv' 
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '0x0a',
ERRORFILE = 'C:\CDM\DRUG_STRENGTH.bad',
TABLOCK
);

TRUNCATE TABLE RELATIONSHIP;
BULK INSERT RELATIONSHIP 
FROM 'C:\CDM\RELATIONSHIP.csv' 
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '0x0a',
ERRORFILE = 'C:\CDM\RELATIONSHIP.bad',
TABLOCK
);

TRUNCATE TABLE SOURCE_TO_CONCEPT_MAP;
BULK INSERT SOURCE_TO_CONCEPT_MAP 
FROM 'C:\CDM\SOURCE_TO_CONCEPT_MAP.csv' 
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '0x0a',
ERRORFILE = 'C:\CDM\SOURCE_TO_CONCEPT_MAP.bad',
TABLOCK
);

TRUNCATE TABLE VOCABULARY;
BULK INSERT VOCABULARY 
FROM 'C:\CDM\VOCABULARY.csv' 
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '0x0a',
ERRORFILE = 'C:\CDM\VOCABULARY.bad',
TABLOCK
);
