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
                                                                              

script to load the Vocabulary related tables in the OMOP common data model, version 4.5 for Oracle database

last revised: 19 Mar 2015

author:  Lee Evans

Notes

1) This script assumes the CDM version 4.5 vocabulary zip file has been unzipped into the "C:\CDM" directory. 
2) If you unzipped your CDM version 4.5 vocabulary files into a different directory then replace all file paths below, with your directory path.
3) If you have existing data in your CDM vocabulary tables then backup that data (if needed) and truncate those tables before loading


*************************/

sqlldr CDM/<password> CONTROL=CONCEPT.ctl LOG=C:\CDM\CONCEPT.log BAD=C:\CDM\CONCEPT.bad  
sqlldr CDM/<password> CONTROL=CONCEPT_ANCESTOR.ctl LOG=C:\CDM\CONCEPT_ANCESTOR.log BAD=C:\CDM\CONCEPT_ANCESTOR.bad  
sqlldr CDM/<password> CONTROL=CONCEPT_RELATIONSHIP.ctl LOG=C:\CDM\CONCEPT_RELATIONSHIP.log BAD=C:\CDM\CONCEPT_RELATIONSHIP.bad
sqlldr CDM/<password> CONTROL=CONCEPT_SYNONYM.ctl LOG=C:\CDM\CONCEPT_SYNONYM.log BAD=C:\CDM\CONCEPT_SYNONYM.bad
sqlldr CDM/<password> CONTROL=DRUG_STRENGTH.ctl LOG=C:\CDM\DRUG_STRENGTH.log BAD=C:\CDM\DRUG_STRENGTH.bad
sqlldr CDM/<password> CONTROL=RELATIONSHIP.ctl LOG=C:\CDM\RELATIONSHIP.log BAD=C:\CDM\RELATIONSHIP.bad
sqlldr CDM/<password> CONTROL=VOCABULARY.ctl LOG=C:\CDM\VOCABULARY.log BAD=C:\CDM\VOCABULARY.bad 
sqlldr CDM/<password> CONTROL=SOURCE_TO_CONCEPT_MAP.ctl LOG=C:\CDM\SOURCE_TO_CONCEPT_MAP.log BAD=C:\CDM\SOURCE_TO_CONCEPT_MAP.bad 
