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

 ####### #     # ####### ######      #####  ######  #     #    ######  ####### #     # 
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #     # #       #     # 
 #     # # # # # #     # #     #    #       #     # # # # #    #     # #       #     # 
 #     # #  #  # #     # ######     #       #     # #  #  #    #     # #####   #     # 
 #     # #     # #     # #          #       #     # #     #    #     # #        #   #  
 #     # #     # #     # #          #     # #     # #     #    #     # #         # #   
 ####### #     # ####### #           #####  ######  #     #    ######  #######    #    
                                                                                       


Dev script to create the COST table as described in github issue #81: https://github.com/OHDSI/CommonDataModel/issues/81#issuecomment-333811290

last revised: 21-December-2017

author:  Clair Blacketer, Gowtham Rao

*************************/

CREATE TABLE cost
(
  cost_id						INTEGER	    NOT NULL ,
  person_id						INTEGER		NOT NULL,
  cost_event_id					INTEGER     NOT NULL ,
  cost_domain_id				VARCHAR(20) NOT NULL ,
  cost_event_table_concept_id	INTEGER		NOT NULL , /*This is still in discussion and subject to change*/ 
  cost_concept_id				INTEGER		NOT NULL ,
  cost_type_concept_id			INTEGER     NOT NULL ,
  cost_source_concept_id		INTEGER		NULL ,
  cost_source_value				VARCHAR(50)	NULL ,
  currency_concept_id			INTEGER		NULL ,
  cost							FLOAT		NULL ,
  incurred_date					DATE		NOT NULL ,
  billed_date					DATE		NULL ,
  paid_date						DATE		NULL ,
  revenue_code_concept_id		INTEGER		NULL ,
  reveue_code_source_value		VARCHAR(50) NULL,
  drg_concept_id			    INTEGER		NULL,
  drg_source_value			    VARCHAR(3)	NULL ,
  payer_plan_period_id			INTEGER		NULL
)
;
