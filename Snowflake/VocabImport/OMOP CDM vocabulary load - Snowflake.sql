/*********************************************************************************
# Copyright 2019 Observational Health Data Sciences and Informatics
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

snowflake script to truncate the existing vocabulary tables, stage the files, and load the data into the OMOP common data model version 6.0 vocabulary tables

Notes:

1) These scripts have been written to reflect a manual execution via SnowSQL CLI scenario; the SnowSQL CLI client can be downloaded from the Snowflake User/Web Interface for your account.
2) These scripts assume the user has already logged in to the SnowSQL CLI and set the Warehouse, Database, and Schema contexts for his session.
3) This script assumes the CDM version 5 vocabulary zip file has been unzipped into the "<<User Home>>/Desktop/CDMVocabularies" directory on a Mac; modify as required for your OS and file directory. 
4) Execution options:
   a. Manual Execution: Run individual components of this script as needed, or run the entire script in full after logging in to the SnowSQL CLI.
   b. Automated/Production Execution: Use these scripts as a template for the steps you must script in an automated code base and/or for translation into your selected data integration tool.

last revised: 06-Aug-2019

Authors:  Kathryn Watson


*************************/


/************************

Concept

************************/


PUT file://~/Desktop/CDMVocabularies/CONCEPT.csv @%CONCEPT;
BEGIN;
	TRUNCATE TABLE CONCEPT;
	COPY INTO CONCEPT FROM @%CONCEPT/CONCEPT.csv.gz
		FILE_FORMAT = ( FORMAT_NAME = 'OHDSI_VOCABULARIES_FF' )
		ON_ERROR = ABORT_STATEMENT
		PURGE = TRUE
		FORCE = TRUE;
COMMIT;



/************************

Concept Ancestor

************************/


PUT file://~/Desktop/CDMVocabularies/CONCEPT_ANCESTOR.csv @%CONCEPT_ANCESTOR;
BEGIN;
	TRUNCATE TABLE CONCEPT_ANCESTOR;
	COPY INTO CONCEPT_ANCESTOR FROM @%CONCEPT_ANCESTOR/CONCEPT_ANCESTOR.csv.gz
		FILE_FORMAT = ( FORMAT_NAME = 'OHDSI_VOCABULARIES_FF' )
		ON_ERROR = ABORT_STATEMENT
		PURGE = TRUE
		FORCE = TRUE;
COMMIT;



/************************

Concept Class

************************/


PUT file://~/Desktop/CDMVocabularies/CONCEPT_CLASS.csv @%CONCEPT_CLASS;
BEGIN;
	TRUNCATE TABLE CONCEPT_CLASS;
	COPY INTO CONCEPT_CLASS FROM @%CONCEPT_CLASS/CONCEPT_CLASS.csv.gz
		FILE_FORMAT = ( FORMAT_NAME = 'OHDSI_VOCABULARIES_FF' )
		ON_ERROR = ABORT_STATEMENT
		PURGE = TRUE
		FORCE = TRUE;
COMMIT;



/************************

Concept Relationship

************************/


PUT file://~/Desktop/CDMVocabularies/CONCEPT_RELATIONSHIP.csv @%CONCEPT_RELATIONSHIP;
BEGIN;
	TRUNCATE TABLE CONCEPT_RELATIONSHIP;
	COPY INTO CONCEPT_RELATIONSHIP FROM @%CONCEPT_RELATIONSHIP/CONCEPT_RELATIONSHIP.csv.gz
		FILE_FORMAT = ( FORMAT_NAME = 'OHDSI_VOCABULARIES_FF' )
		ON_ERROR = ABORT_STATEMENT
		PURGE = TRUE
		FORCE = TRUE;
COMMIT;



/************************

Concept Synonym

************************/


PUT file://~/Desktop/CDMVocabularies/CONCEPT_SYNONYM.csv @%CONCEPT_SYNONYM;
BEGIN;
	TRUNCATE TABLE CONCEPT_SYNONYM;
	COPY INTO CONCEPT_SYNONYM FROM @%CONCEPT_SYNONYM/CONCEPT_SYNONYM.csv.gz
		FILE_FORMAT = ( FORMAT_NAME = 'OHDSI_VOCABULARIES_FF' )
		ON_ERROR = ABORT_STATEMENT
		PURGE = TRUE
		FORCE = TRUE;
COMMIT;



/************************

Domain

************************/


PUT file://~/Desktop/CDMVocabularies/DOMAIN.csv @%DOMAIN;
BEGIN;
	TRUNCATE TABLE DOMAIN;
	COPY INTO DOMAIN FROM @%DOMAIN/DOMAIN.csv.gz
		FILE_FORMAT = ( FORMAT_NAME = 'OHDSI_VOCABULARIES_FF' )
		ON_ERROR = ABORT_STATEMENT
		PURGE = TRUE
		FORCE = TRUE;
COMMIT;



/************************

Drug Strength

************************/


PUT file://~/Desktop/CDMVocabularies/DRUG_STRENGTH.csv @%DRUG_STRENGTH;
BEGIN;
	TRUNCATE TABLE DRUG_STRENGTH;
	COPY INTO DRUG_STRENGTH FROM @%DRUG_STRENGTH/DRUG_STRENGTH.csv.gz
		FILE_FORMAT = ( FORMAT_NAME = 'OHDSI_VOCABULARIES_FF' )
		ON_ERROR = ABORT_STATEMENT
		PURGE = TRUE
		FORCE = TRUE;
COMMIT;



/************************

Relationship

************************/


PUT file://~/Desktop/CDMVocabularies/RELATIONSHIP.csv @%RELATIONSHIP;
BEGIN;
	TRUNCATE TABLE RELATIONSHIP;
	COPY INTO RELATIONSHIP FROM @%RELATIONSHIP/RELATIONSHIP.csv.gz
		FILE_FORMAT = ( FORMAT_NAME = 'OHDSI_VOCABULARIES_FF' )
		ON_ERROR = ABORT_STATEMENT
		PURGE = TRUE
		FORCE = TRUE;
COMMIT;



/************************

Vocabulary

************************/


PUT file://~/Desktop/CDMVocabularies/VOCABULARY.csv @%VOCABULARY;
BEGIN;
	TRUNCATE TABLE VOCABULARY;
	COPY INTO VOCABULARY FROM @%VOCABULARY/VOCABULARY.csv.gz
		FILE_FORMAT = ( FORMAT_NAME = 'OHDSI_VOCABULARIES_FF' )
		ON_ERROR = ABORT_STATEMENT
		PURGE = TRUE
		FORCE = TRUE;
COMMIT;