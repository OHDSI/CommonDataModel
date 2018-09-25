/*********************************************************************************
# Copyright 2018-08 Observational Health Data Sciences and Informatics
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

postgresql script to create OMOP common data model results schema version 6.0

last revised: 27-Aug-2018

Authors:  Patrick Ryan, Christian Reich, Clair Blacketer


*************************/



--HINT DISTRIBUTE_ON_KEY(subject_id)
CREATE TABLE cohort
(
  cohort_definition_id	BIGINT		NOT NULL ,
  subject_id			BIGINT		NOT NULL ,
  cohort_start_date		DATE		NOT NULL ,
  cohort_end_date		DATE		NOT NULL
)
;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cohort_definition (
  cohort_definition_id				INTEGER			NOT NULL,
  cohort_definition_name			VARCHAR(255)	NOT NULL,
  cohort_definition_description		TEXT			NULL,
  definition_type_concept_id		INTEGER			NOT NULL,
  cohort_definition_syntax			TEXT			NULL,
  subject_concept_id				INTEGER			NOT NULL,
  cohort_initiation_date			DATE			NULL
)
;


ALTER TABLE cohort ADD CONSTRAINT xpk_cohort PRIMARY KEY ( cohort_definition_id, subject_id, cohort_start_date, cohort_end_date  ) ;

ALTER TABLE cohort_definition ADD CONSTRAINT xpk_cohort_definition PRIMARY KEY (cohort_definition_id);


CREATE INDEX idx_cohort_definition_id  ON cohort_definition  (cohort_definition_id ASC);
CLUSTER cohort_definition  USING idx_cohort_definition_id ;

CREATE INDEX idx_cohort_subject_id ON cohort (subject_id ASC);
CREATE INDEX idx_cohort_c_definition_id ON cohort (cohort_definition_id ASC);


ALTER TABLE cohort_definition ADD CONSTRAINT fpk_cohort_definition_concept FOREIGN KEY (definition_type_concept_id)  REFERENCES concept (concept_id);

ALTER TABLE cohort_definition ADD CONSTRAINT fpk_subject_concept FOREIGN KEY (subject_concept_id)  REFERENCES concept (concept_id);


ALTER TABLE cohort ADD CONSTRAINT fpk_cohort_definition FOREIGN KEY (cohort_definition_id)  REFERENCES cohort_definition (cohort_definition_id);










