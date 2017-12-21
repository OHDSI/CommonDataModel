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

 ####### #     # ####### ######      #####  ######  #     #    ######  ####### #     #    ### #     # ######  ####### #     # #######  #####  
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #     # #       #     #     #  ##    # #     # #        #   #  #       #     # 
 #     # # # # # #     # #     #    #       #     # # # # #    #     # #       #     #     #  # #   # #     # #         # #   #       #       
 #     # #  #  # #     # ######     #       #     # #  #  #    #     # #####   #     #     #  #  #  # #     # #####      #    #####    #####  
 #     # #     # #     # #          #       #     # #     #    #     # #        #   #      #  #   # # #     # #         # #   #             # 
 #     # #     # #     # #          #     # #     # #     #    #     # #         # #       #  #    ## #     # #        #   #  #       #     # 
 ####### #     # ####### #           #####  ######  #     #    ######  #######    #       ### #     # ######  ####### #     # #######  ##### 

Dev script to create the required indexes for the recently accepted COST table proposal as described in github issue #81: https://github.com/OHDSI/CommonDataModel/issues/81#issuecomment-333811290

last revised: 21-December-2017

author:  Clair Blacketer

description:  These indices and primary keys and indices are considered a minimal requirement to ensure adequate performance of analyses.

*************************/

/*Primary Key*/

ALTER TABLE cost ADD CONSTRAINT xpk_visit_cost PRIMARY KEY NONCLUSTERED ( cost_id ) ;

/*Indices and Constraints*/

CREATE CLUSTERED INDEX idx_cost_person_id ON cost (person_id ASC);


ALTER TABLE cost ADD CONSTRAINT fpk_cost_person FOREIGN KEY (person_id)  REFERENCES person (person_id);

ALTER TABLE cost ADD CONSTRAINT fpk_cost_currency FOREIGN KEY (currency_concept_id)  REFERENCES concept (concept_id);

ALTER TABLE cost ADD CONSTRAINT fpk_cost_concept FOREIGN KEY (cost_concept_id)  REFERENCES concept (concept_id);

ALTER TABLE cost ADD CONSTRAINT fpk_cost_type FOREIGN KEY (cost_type_concept_id)  REFERENCES concept (concept_id);

ALTER TABLE cost ADD CONSTRAINT fpk_cost_source FOREIGN KEY (cost_source_concept_id)  REFERENCES concept (concept_id);

ALTER TABLE cost ADD CONSTRAINT fpk_cost_period FOREIGN KEY (payer_plan_period_id)  REFERENCES payer_plan_period (payer_plan_period_id);

ALTER TABLE cost ADD CONSTRAINT fpk_revenue_concept FOREIGN KEY (revenue_concept_id) REFERENCES concept (concept_id);

ALTER TABLE cost ADD CONSTRAINT fpk_drg_concept FOREIGN KEY (drg_concept_id) REFERENCES concept (concept_id);