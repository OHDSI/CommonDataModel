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
                                                                              

script to create OMOP common data model, version 5.0 for Oracle database

last revised: 1 Mar 2015

author:  Christian Reich


*************************/

CREATE TABLE concept
(
  concept_id        INTEGER                     NOT NULL,         
  concept_name      VARCHAR2(256 BYTE)          NOT NULL,                     
  concept_level     NUMBER                      NOT NULL,           
  concept_class     VARCHAR2(60 BYTE)           NOT NULL,                     
  vocabulary_id     INTEGER                     NOT NULL,            
  concept_code      VARCHAR2(40 BYTE)           NOT NULL,                    
  valid_start_date  DATE                        NOT NULL,            
  valid_end_date    DATE                        DEFAULT '31-Dec-2099'         NOT NULL,
  invalid_reason    CHAR(1 BYTE)                                  
) NOLOGGING;

COMMENT ON TABLE concept IS 'A list of all valid terminology concepts across domains and their attributes. Concepts are derived from existing standards.';

COMMENT ON COLUMN concept.concept_id IS 'A system-generated identifier to uniquely identify each concept across all concept types.';

COMMENT ON COLUMN concept.concept_name IS 'An unambiguous, meaningful and descriptive name for the concept.';

COMMENT ON COLUMN concept.concept_level IS 'The level of hierarchy associated with the concept. Different concept levels are assigned to concepts to depict their seniority in a clearly defined hierarchy, such as drugs, conditions, etc. A concept level of 0 is assigned to concepts that are not part of a standard vocabulary, but are part of the vocabulary for reference purposes (e.g. drug form).';

COMMENT ON COLUMN concept.concept_class IS 'The category or class of the concept along both the hierarchical tree as well as different domains within a vocabulary. Examples are ''Clinical Drug'', ''Ingredient'', ''Clinical Finding'' etc.';

COMMENT ON COLUMN concept.vocabulary_id IS 'A foreign key to the vocabulary table indicating from which source the concept has been adapted.';

COMMENT ON COLUMN concept.concept_code IS 'The concept code represents the identifier of the concept in the source data it originates from, such as SNOMED-CT concept IDs, RxNorm RXCUIs etc. Note that concept codes are not unique across vocabularies.';

COMMENT ON COLUMN concept.valid_start_date IS 'The date when the was first recorded.';

COMMENT ON COLUMN concept.valid_end_date IS 'The date when the concept became invalid because it was deleted or superseded (updated) by a new concept. The default value is 31-Dec-2099.';

COMMENT ON COLUMN concept.invalid_reason IS 'Concepts that are replaced with a new concept are designated "Updated" (U) and concepts that are removed without replacement are "Deprecated" (D).';

CREATE INDEX concept_code ON concept (concept_code, vocabulary_id);
CREATE UNIQUE INDEX XPKconcept ON concept (concept_id);

ALTER TABLE concept ADD (
  CHECK ( invalid_reason IN ('D', 'U'))
  ENABLE VALIDATE,
  CONSTRAINT XPKCONCEPT
  PRIMARY KEY
  (concept_id)
  USING INDEX XPKCONCEPT
  ENABLE VALIDATE);
  
--add table RELATIONSHIP

CREATE TABLE relationship
(
  relationship_id       INTEGER                 NOT NULL,                     
  relationship_name     VARCHAR2(256 BYTE)      NOT NULL,                                 
  is_hierarchical       INTEGER                 NOT NULL,                     
  defines_ancestry      INTEGER                 DEFAULT 1                     NOT NULL,
  reverse_relationship  INTEGER                                            
) NOLOGGING;

COMMENT ON TABLE relationship IS 'A list of relationship between concepts. Some of these relationships are generic (e.g. "Subsumes" relationship), others are domain-specific.';

COMMENT ON COLUMN relationship.relationship_id IS 'The type of relationship captured by the relationship record.';

COMMENT ON COLUMN relationship.relationship_name IS 'The text that describes the relationship type.';

COMMENT ON COLUMN relationship.is_hierarchical IS 'Defines whether a relationship defines concepts into classes or hierarchies. Values are Y for hierarchical relationship or NULL if not';

COMMENT ON COLUMN relationship.defines_ancestry IS 'Defines whether a hierarchical relationship contributes to the concept_ancestor table. These are subsets of the hierarchical relationships. Valid values are Y or NULL.';

COMMENT ON COLUMN relationship.reverse_relationship IS 'relationship ID of the reverse relationship to this one. Corresponding records of reverse relationships have their concept_id_1 and concept_id_2 swapped.';

CREATE UNIQUE INDEX XPKRELATIONHIP_TYPE ON relationship
(relationship_id);

ALTER TABLE relationship ADD (
  CONSTRAINT xpkrelationship_type
  PRIMARY KEY
  (relationship_id)
  USING INDEX xpkrelationship_type
  ENABLE VALIDATE);

--add table concept_relationship
  
CREATE TABLE concept_relationship
(
   concept_id_1 INTEGER NOT NULL,
   concept_id_2 INTEGER NOT NULL,
   relationship_id INTEGER NOT NULL,
   valid_start_date DATE NOT NULL,
   valid_end_date DATE DEFAULT '31-Dec-2099' NOT NULL,
   invalid_reason CHAR(1 BYTE)
) NOLOGGING;

COMMENT ON TABLE concept_relationship IS 'A list of relationship between concepts. Some of these relationships are generic (e.g. ''Subsumes'' relationship), others are domain-specific.';

COMMENT ON COLUMN concept_relationship.concept_id_1 IS 'A foreign key to the concept in the concept table associated with the relationship. relationships are directional, and this field represents the source concept designation.';

COMMENT ON COLUMN concept_relationship.concept_id_2 IS 'A foreign key to the concept in the concept table associated with the relationship. relationships are directional, and this field represents the destination concept designation.';

COMMENT ON COLUMN concept_relationship.relationship_id IS 'The type of relationship as defined in the relationship table.';

COMMENT ON COLUMN concept_relationship.valid_start_date IS 'The date when the the relationship was first recorded.';

COMMENT ON COLUMN concept_relationship.valid_end_date IS 'The date when the relationship became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.';

COMMENT ON COLUMN concept_relationship.invalid_reason IS 'Reason the relationship was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default  value.';

CREATE UNIQUE INDEX xpkconcept_relationship ON concept_relationship
(concept_id_1, concept_id_2, relationship_id); 


ALTER TABLE concept_relationship ADD (
  CHECK ( invalid_reason IN ('D', 'U'))
  ENABLE VALIDATE,
  CHECK ( invalid_reason IN ('D', 'U'))
  ENABLE VALIDATE,
  CHECK (invalid_reason in ('D', 'U'))
  ENABLE VALIDATE,
  CONSTRAINT xpkconcept_relationship
  PRIMARY KEY
  (concept_id_1, concept_id_2, relationship_id)
  USING INDEX xpkconcept_relationship
  ENABLE VALIDATE);

 
ALTER TABLE concept_relationship ADD (
  CONSTRAINT concept_REL_CHILD_FK 
  FOREIGN KEY (concept_id_2) 
  REFERENCES concept (concept_id)
  ENABLE VALIDATE,
  CONSTRAINT concept_REL_PARENT_FK 
  FOREIGN KEY (concept_id_1) 
  REFERENCES concept (concept_id)
  ENABLE VALIDATE,
  CONSTRAINT concept_REL_REL_type_FK 
  FOREIGN KEY (relationship_id) 
  REFERENCES relationship (relationship_id)
  ENABLE VALIDATE);

--add table concept_ancestor

CREATE TABLE concept_ancestor
(
  ancestor_concept_id       INTEGER             NOT NULL,
  descendant_concept_id     INTEGER             NOT NULL,  
  max_levels_of_separation  NUMBER,                   
  min_levels_of_separation  NUMBER                   
) NOLOGGING;  

COMMENT ON TABLE concept_ancestor IS 'A specialized table containing only hierarchical relationship between concepts that may span several generations.';

COMMENT ON COLUMN concept_ancestor.ancestor_concept_id IS 'A foreign key to the concept code in the concept table for the higher-level concept that forms the ancestor in the relationship.';

COMMENT ON COLUMN concept_ancestor.descendant_concept_id IS 'A foreign key to the concept code in the concept table for the lower-level concept that forms the descendant in the relationship.';

COMMENT ON COLUMN concept_ancestor.max_levels_of_separation IS 'The maximum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an optional attribute that is used to simplify hierarchic analysis. ';

COMMENT ON COLUMN concept_ancestor.min_levels_of_separation IS 'The minimum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an optional attribute that is used to simplify hierarchic analysis.';

CREATE UNIQUE INDEX xpkconcept_ancestor ON concept_ancestor
(ancestor_concept_id, descendant_concept_id);

ALTER TABLE concept_ancestor ADD (
  CONSTRAINT xpkconcept_ancestor
  PRIMARY KEY
  (ancestor_concept_id, descendant_concept_id)
  USING INDEX xpkconcept_ancestor
  ENABLE VALIDATE);

ALTER TABLE concept_ancestor ADD (
  CONSTRAINT concept_ancestor_FK 
  FOREIGN KEY (ancestor_concept_id) 
  REFERENCES concept (concept_id)
  ENABLE VALIDATE,
  CONSTRAINT concept_descendant_FK 
  FOREIGN KEY (descendant_concept_id) 
  REFERENCES concept (concept_id)
  ENABLE VALIDATE);

--add table concept_synonym

CREATE TABLE concept_synonym
(
  concept_synonym_id    INTEGER                 NOT NULL,
  concept_id            INTEGER                 NOT NULL,
  concept_synonym_name  VARCHAR2(1000 BYTE)     NOT NULL
) NOLOGGING;

COMMENT ON TABLE concept_synonym IS 'A table with synonyms for concepts that have more than one valid name or description.';

COMMENT ON COLUMN concept_synonym.concept_synonym_id IS 'A system-generated unique identifier for each concept synonym.';

COMMENT ON COLUMN concept_synonym.concept_id IS 'A foreign key to the concept in the concept table. ';

COMMENT ON COLUMN concept_synonym.concept_synonym_name IS 'The alternative name for the concept.';

CREATE UNIQUE INDEX xpkconcept_synonym ON concept_synonym
(concept_synonym_id);

ALTER TABLE concept_synonym ADD (
  CONSTRAINT xpkconcept_synonym
  PRIMARY KEY
  (concept_synonym_id)
  USING INDEX xpkconcept_synonym
  ENABLE VALIDATE);

ALTER TABLE concept_synonym ADD (
  CONSTRAINT concept_synonym_concept_FK 
  FOREIGN KEY (concept_id) 
  REFERENCES concept (concept_id)
  ENABLE VALIDATE);

--add table source_to_concept_map

CREATE TABLE source_to_concept_map
(
  source_code              VARCHAR2(40 BYTE)    NOT NULL,         
  source_vocabulary_id     INTEGER              NOT NULL,         
  source_code_description  VARCHAR2(256 BYTE),                          
  target_concept_id        INTEGER              NOT NULL,      
  target_vocabulary_id     INTEGER              NOT NULL,         
  mapping_type             VARCHAR2(256 BYTE),               
  primary_map              CHAR(1 BYTE),              
  valid_start_date         DATE                 NOT NULL,  
  valid_end_date           DATE                 NOT NULL,
  invalid_reason           CHAR(1 BYTE)                 
) NOLOGGING;

CREATE INDEX SOURCE_TO_concept_SOURCE_idX ON source_to_concept_map
(SOURCE_CODE);

CREATE UNIQUE INDEX xpksource_to_concept_map ON source_to_concept_map
(SOURCE_vocabulary_id, TARGET_concept_id, SOURCE_CODE, valid_end_date);

ALTER TABLE source_to_concept_map ADD (
  CHECK (primary_map in ('Y'))
  ENABLE VALIDATE,
  CHECK (invalid_reason in ('D', 'U'))
  ENABLE VALIDATE,
  CONSTRAINT xpksource_to_concept_map
  PRIMARY KEY
  (SOURCE_vocabulary_id, TARGET_concept_id, SOURCE_CODE, valid_end_date)
  USING INDEX xpksource_to_concept_map
  ENABLE VALIDATE);

ALTER TABLE source_to_concept_map ADD (
  CONSTRAINT SOURCE_TO_concept_concept 
  FOREIGN KEY (TARGET_concept_id) 
  REFERENCES concept (concept_id)
  ENABLE VALIDATE);

--add table drug_strength

CREATE TABLE drug_strength
(
   drug_concept_id            INTEGER NOT NULL,
   ingredient_concept_id      INTEGER NOT NULL,
   amount_value               NUMBER,
   amount_unit                VARCHAR2 (60 BYTE),
   concentration_value        NUMBER,
   concentration_enum_unit    VARCHAR2 (60 BYTE),
   concentration_denom_unit   VARCHAR2 (60 BYTE),
   valid_start_date           DATE NOT NULL,
   valid_end_date             DATE NOT NULL,
   invalid_reason             VARCHAR2 (1 BYTE)
);

--add table vocabulary

CREATE TABLE VOCABULARY
(
   VOCABULARY_ID     INTEGER NOT NULL,
   VOCABULARY_NAME   VARCHAR2 (256 BYTE) NOT NULL
);

   