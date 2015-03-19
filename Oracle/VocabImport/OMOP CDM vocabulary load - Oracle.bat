REM *********************************************************************************
REM  Copyright 2014 Observational Health Data Sciences and Informatics
REM 
REM  
REM  Licensed under the Apache License, Version 2.0 (the "License");
REM  you may not use this file except in compliance with the License.
REM  You may obtain a copy of the License at
REM  
REM      http://www.apache.org/licenses/LICENSE-2.0
REM  
REM  Unless required by applicable law or agreed to in writing, software
REM  distributed under the License is distributed on an "AS IS" BASIS,
REM  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM  See the License for the specific language governing permissions and
REM  limitations under the License.
REM *******************************************************************************/

REM ************************
REM 
REM  ####### #     # ####### ######      #####  ######  #     #           ####### 
REM  #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #       
REM  #     # # # # # #     # #     #    #       #     # # # # #    #    # #       
REM  #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######  
REM  #     # #     # #     # #          #       #     # #     #    #    #       # 
REM  #     # #     # #     # #          #     # #     # #     #     #  #  #     # 
REM  ####### #     # ####### #           #####  ######  #     #      ##    #####  
REM                                                                               
REM 
REM Script to load the common data model, version 5.0 vocabulary tables for PostgreSQL database on Windows (MS-DOS style file paths)
REM 
REM Notes
REM 
REM 1) There is no data file load for the SOURCE_TO_CONCEPT_MAP table because that table is deprecated in CDM version 5.0
REM 2) This script assumes the CDM version 5 vocabulary zip file has been unzipped into the "C:\CDMV5VOCAB" directory. 
REM 3) If you unzipped your CDM version 5 vocabulary files into a different directory then replace all file paths below, with your directory path.
REM 
REM last revised: 26 Nov 2014
REM 
REM author:  Lee Evans
REM 
REM 
REM *************************/

sqlldr CDMV5/<password> CONTROL=CONCEPT.ctl LOG=C:\CDMV5VOCAB\CONCEPT.log BAD=C:\CDMV5VOCAB\CONCEPT.bad  
sqlldr CDMV5/<password> CONTROL=CONCEPT_ANCESTOR.ctl LOG=C:\CDMV5VOCAB\CONCEPT_ANCESTOR.log BAD=C:\CDMV5VOCAB\CONCEPT_ANCESTOR.bad  
sqlldr CDMV5/<password> CONTROL=CONCEPT_CLASS.ctl LOG=C:\CDMV5VOCAB\CONCEPT_CLASS.log BAD=C:\CDMV5VOCAB\CONCEPT_CLASS.bad  
sqlldr CDMV5/<password> CONTROL=CONCEPT_RELATIONSHIP.ctl LOG=C:\CDMV5VOCAB\CONCEPT_RELATIONSHIP.log BAD=C:\CDMV5VOCAB\CONCEPT_RELATIONSHIP.bad
sqlldr CDMV5/<password> CONTROL=CONCEPT_SYNONYM.ctl LOG=C:\CDMV5VOCAB\CONCEPT_SYNONYM.log BAD=C:\CDMV5VOCAB\CONCEPT_SYNONYM.bad
sqlldr CDMV5/<password> CONTROL=DOMAIN.ctl LOG=C:\CDMV5VOCAB\DOMAIN.log BAD=C:\CDMV5VOCAB\DOMAIN.bad
sqlldr CDMV5/<password> CONTROL=DRUG_STRENGTH.ctl LOG=C:\CDMV5VOCAB\DRUG_STRENGTH.log BAD=C:\CDMV5VOCAB\DRUG_STRENGTH.bad
sqlldr CDMV5/<password> CONTROL=RELATIONSHIP.ctl LOG=C:\CDMV5VOCAB\RELATIONSHIP.log BAD=C:\CDMV5VOCAB\RELATIONSHIP.bad
sqlldr CDMV5/<password> CONTROL=VOCABULARY.ctl LOG=C:\CDMV5VOCAB\VOCABULARY.log BAD=C:\CDMV5VOCAB\VOCABULARY.bad 
