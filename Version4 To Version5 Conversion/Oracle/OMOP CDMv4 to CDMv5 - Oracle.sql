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

/*******************************************************************************                                                                        

PURPOSE: Use this script to convert your OMOP V4 common data model to CDM V5.

last revised: 09 July 2015
author:  Patrick Ryan, Chris Knoll
editor: Anthony Sena

!!!!!!!!!!!!!!!!!!!!! PLEASE READ THESE INSTRUCTIONS !!!!!!!!!!!!!!!!!!!!!!!!!!!

This script was authored using TemplateSQL which will require you to run this
script through SqlRender to creat a version that is compatible with your target
RDBMS. We have pre-generated these scripts using SQL Render and have placed
them in folders for each RDBMS. Depending on which script you are viewing, your
instructions will be slightly different.

General Assumptions
-------------------

This script assumes that your V4 and V5 database are located on the same
RDBMS server.

Getting Started
---------------

Before you can use this script, there are some prerequisites:

 1. Create a target CDMv5 database on your server using the appropriate script
    from https://github.com/OHDSI/CommonDataModel
 2. Load VocabV5 into the target database/schema that will contain CDMv5 using
    Athena: http://ohdsi.org/web/ATHENA

TemplateSQL File Instructions
-----------------------------
 
 1. Set parameter name of schema that contains CDMv4 instance 
    ([SOURCE_CDMV4], [SOURCE_CDMV4].[SCHEMA])
 2. Set parameter name of schema that contains CDMv5 instance 
    ([TARGET_CDMV5], [TARGET_CDMV5].[SCHEMA])
 3. Run this script through SqlRender to produce a script that will work in your
    source dialect. SqlRender can be found here: https://github.com/OHDSI/SqlRender
 4. Run the script produced by SQL Render on your target RDBDMS.

<RDBMS> File Instructions
-------------------------

 1. This script will hold a number of placeholders for your CDM V4 and CDMV5
    database/schema. In order to make this file work in your environment, you 
	should plan to do a global "FIND AND REPLACE" on this file to fill in the 
	file with values that pertain to your environment. The following are the 
	tokens you should use when doing your "FIND AND REPLACE" operation:

	a. [SOURCE_CDMV4]
	b. [SOURCE_CDMV4].[SCHEMA]
    c. [TARGET_CDMV5]
	d. [TARGET_CDMV5].[SCHEMA]

 2. Run the resulting script on your target RDBDMS.

*********************************************************************************/

/* SCRIPT PARAMETERS */
					-- The CDMv4 database name
	-- The CDMv4 database plus schema
					-- The target CDMv5 database name
	-- the target CDMv5 database plus schema
 
ALTER SESSION SET current_schema =  [TARGET_CDMV5];

/*
 * The #concept_map table will hold the mapping of source_concept_ids to target_concept_ids
 * and their respective domain_ids. As a result, the results of this table will have 
 * some source_concept_ids that map to multiple target_concept_ids which is expected.
 *
 * In some of the conversion queries below, we will use the distinct values from the
 * #concept_map table since our need in those instances is to understand the domain_id
 * that will provide the destination table in the target V5 database. To make the code
 * easier to read, we dervied a #concept_map_distinct table that holds the distinct
 * source_concept_id and target domain_id.
 *
 * As of the dateof this script, the following domains contain source_concept_ids that 
 * map to multiple target_concept_ids:
 *
 * Condition
 * Device
 * Drug
 * Measurement
 * Observation
 * Procedure
 * Spec Anatomic Site
 *
 * Also, as of the date which this script was authored, no source_concept_ids map to multiple domains
 */
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE  w3m16jd0concept_map';
  EXECUTE IMMEDIATE 'DROP TABLE  w3m16jd0concept_map';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

CREATE GLOBAL TEMPORARY TABLE w3m16jd0concept_map 
 (
	source_concept_id int,
	target_concept_id int,
	domain_id varchar(20)
) ON COMMIT PRESERVE ROWS;

--standard concepts
INSERT INTO w3m16jd0concept_map (source_concept_id, target_concept_id, domain_id)
SELECT   concept_id as source_concept_id,
	concept_id as target_concept_id,
	domain_id
 FROM  [TARGET_CDMV5].[SCHEMA].concept
  WHERE  standard_concept = 'S'
and invalid_reason is null

union

--concepts with 'map to' standard
SELECT   distinct c1.concept_id as source_concept_id,
	c2.concept_id as target_concept_id,
	c2.domain_id
 FROM 
(
select concept_id
from [TARGET_CDMV5].[SCHEMA].concept
where ((standard_concept <> 'S' or standard_concept is null)
or invalid_reason is not null
)
) c1
inner join
[TARGET_CDMV5].[SCHEMA].concept_relationship cr1
on c1.concept_id = cr1.concept_id_1
inner join
[TARGET_CDMV5].[SCHEMA].concept c2
on cr1.concept_id_2 = c2.concept_id
  WHERE  c2.standard_concept = 'S'
and c2.invalid_reason is null
and cr1.relationship_id in ('Maps to')
and cr1.invalid_reason is null


union

--concepts without 'map to' standard with another non 'is a' relation to standard
SELECT   distinct c1.concept_id as source_concept_id,
	c2.concept_id as target_concept_id,
	c2.domain_id
 FROM 
(
	SELECT A.concept_id
	FROM [TARGET_CDMV5].[SCHEMA].concept A
	LEFT JOIN
	(
			SELECT DISTINCT c1.concept_id
			FROM (
				SELECT concept_id
				FROM [TARGET_CDMV5].[SCHEMA].concept
				WHERE (
						(
							standard_concept <> 'S'
							OR standard_concept IS NULL
							)
						OR invalid_reason IS NOT NULL
						)
				) c1
			INNER JOIN [TARGET_CDMV5].[SCHEMA].concept_relationship cr1 ON c1.concept_id = cr1.concept_id_1
			INNER JOIN [TARGET_CDMV5].[SCHEMA].concept c2 ON cr1.concept_id_2 = c2.concept_id
			WHERE c2.standard_concept = 'S'
				AND c2.invalid_reason IS NULL
				AND cr1.relationship_id IN ('Maps to')
				AND cr1.invalid_reason IS NULL
	) B ON A.concept_id = B.concept_id
	WHERE (
			(
				A.standard_concept <> 'S'
				OR A.standard_concept IS NULL
				)
			OR A.invalid_reason IS NOT NULL
			)
		AND B.concept_id IS NULL
) c1
inner join [TARGET_CDMV5].[SCHEMA].concept_relationship cr1 on c1.concept_id = cr1.concept_id_1
inner join [TARGET_CDMV5].[SCHEMA].concept c2 on cr1.concept_id_2 = c2.concept_id
  WHERE  c2.standard_concept = 'S'
  and c2.invalid_reason is null
  and cr1.relationship_id in (
	'RxNorm replaced by',
	'SNOMED replaced by',
	'UCUM replaced by',
	'Concept replaced by',
	'ICD9P replaced by',
	'LOINC replaced by',
	'Concept same_as to',
	'Concept was_a to',
	'Concept alt_to to'
)
and cr1.invalid_reason is null

union

--concepts without 'map to' standard with 'is a' relation to standard
SELECT   DISTINCT c1.concept_id AS source_concept_id
	,c2.concept_id AS target_concept_id
	,c2.domain_id
 FROM  (
	SELECT A.concept_id
	FROM [TARGET_CDMV5].[SCHEMA].concept A
	LEFT JOIN 
	(
			SELECT DISTINCT c1.concept_id
			FROM (
				SELECT concept_id
				FROM [TARGET_CDMV5].[SCHEMA].concept
				WHERE (
						(
							standard_concept <> 'S'
							OR standard_concept IS NULL
							)
						OR invalid_reason IS NOT NULL
						)
				) c1
			INNER JOIN [TARGET_CDMV5].[SCHEMA].concept_relationship cr1 ON c1.concept_id = cr1.concept_id_1
			INNER JOIN [TARGET_CDMV5].[SCHEMA].concept c2 ON cr1.concept_id_2 = c2.concept_id
			WHERE c2.standard_concept = 'S'
				AND c2.invalid_reason IS NULL
				AND cr1.relationship_id IN (
					'Maps to'
					,'RxNorm replaced by'
					,'SNOMED replaced by'
					,'UCUM replaced by'
					,'Concept replaced by'
					,'ICD9P replaced by'
					,'LOINC replaced by'
					,'Concept same_as to'
					,'Concept was_a to'
					,'Concept alt_to to'
					)
				AND cr1.invalid_reason IS NULL	
	) B ON A.concept_id = B.concept_id
	WHERE (
			(
				standard_concept <> 'S'
				OR standard_concept IS NULL
				)
			OR invalid_reason IS NOT NULL
			)
		AND B.concept_id IS NULL
	) c1
INNER JOIN [TARGET_CDMV5].[SCHEMA].concept_relationship cr1 ON c1.concept_id = cr1.concept_id_1
INNER JOIN [TARGET_CDMV5].[SCHEMA].concept c2 ON cr1.concept_id_2 = c2.concept_id
  WHERE  c2.standard_concept = 'S'
	AND c2.invalid_reason IS NULL
	AND cr1.relationship_id IN ('Is a')
	AND cr1.invalid_reason IS NULL;

-- Update the source_concept_map_occurrence column
-- to contain a count to indicate the number of target_concept_ids
-- map to that source_concept_id. This will be used elsewhere in 
-- the script to ensure that we generate new primary keys
-- for the target tables when applicable 
/*
 UPDATE #concept_map
 SET #concept_map.source_concept_map_occurrence = A.targetConceptCount
 FROM 
	#concept_map, 
	(
 		 select source_concept_id, domain_id, count(*) as "targetConceptCount"
		 from #concept_map
		 group by source_concept_id, domain_id
	) AS A
WHERE #concept_map.source_concept_id = A.source_concept_id AND #concept_map.domain_id = A.domain_id;

UPDATE #concept_map
SET source_concept_map_occurrence = "targetConceptCount"
FROM 
	(
 		 select source_concept_id, domain_id, count(*) as "targetConceptCount"
		 from #concept_map
		 group by source_concept_id, domain_id
	) A
WHERE #concept_map.source_concept_id = A.source_concept_id AND #concept_map.domain_id = A.domain_id;

UPDATE #concept_map
SET source_concept_map_occurrence = ( 		 
										select count(*) as "targetConceptCount"
										from #concept_map A
										WHERE A.source_concept_id = #concept_map.source_concept_id AND A.domain_id = #concept_map.domain_id
										group by source_concept_id, domain_id
									)
*/

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE  w3m16jd0concept_map_distinct';
  EXECUTE IMMEDIATE 'DROP TABLE  w3m16jd0concept_map_distinct';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

CREATE GLOBAL TEMPORARY TABLE w3m16jd0concept_map_distinct 
 (
	source_concept_id int,
	domain_id varchar(20),
	targetConceptCount int
) ON COMMIT PRESERVE ROWS;

 INSERT INTO w3m16jd0concept_map_distinct (source_concept_id, domain_id, targetConceptCount)
 SELECT source_concept_id, domain_id, COUNT(*)
 FROM w3m16jd0concept_map
 GROUP BY source_concept_id, domain_id;

 
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE  [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS';
  EXECUTE IMMEDIATE 'DROP TABLE  [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

CREATE TABLE [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS
(
	WARNING_MESSAGE varchar(4000)
);
 
/****
 
CDM_SOURCE
 
 ****/

INSERT INTO [TARGET_CDMV5].[SCHEMA].cdm_source (cdm_source_name, cdm_version, vocabulary_version, cdm_release_date)
SELECT   '[TARGET_CDMV5]', 'V5', v.vocabulary_version, SYSDATE
 FROM  [TARGET_CDMV5].[SCHEMA].vocabulary v
  WHERE  vocabulary_id = 'Vocabulary';

/****

LOCATION

 ****/

insert into [TARGET_CDMV5].[SCHEMA].location
select location_id, address_1, address_2, city, state, zip, county, location_source_value
from [SOURCE_CDMV4].[SCHEMA].LOCATION;

/****

CARE_SITE

 ****/

insert into [TARGET_CDMV5].[SCHEMA].care_site
select care_site_id, TO_CHAR(null ) as care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value
from [SOURCE_CDMV4].[SCHEMA].CARE_SITE;

/****

Provider

****/

insert into [TARGET_CDMV5].[SCHEMA].provider
select provider_id, TO_CHAR(null ) as provider_name, NPI, DEA, specialty_concept_id, care_site_id, cast(null as integer) as year_of_birth,
	cast(null as integer) as gender_concept_id, provider_source_value, specialty_source_value, 0 as specialty_source_concept_id, 
	TO_CHAR(null ) as gender_source_value, cast(null as integer) as gender_source_concept_id
from [SOURCE_CDMV4].[SCHEMA].provider
;


 /****
 
 PERSON
 
 ****/
 
 INSERT into [TARGET_CDMV5].[SCHEMA].person 
 SELECT 
	person_id, 
	coalesce(gender.target_concept_id, 0) as gender_concept_id, 
	year_of_birth, 
	month_of_birth, 
	day_of_birth, 
	TO_CHAR(null ) time_of_birth,
	coalesce(race.target_concept_id, 0) as race_concept_id, 
	coalesce(ethnicity.target_concept_id, 0) as ethnicity_concept_id, 
	location_id, 
	provider_id, 
	care_site_id, 
	person_source_value, 
	gender_source_value,
	CAST(null as integer) gender_source_concept_id, 
	CAST(null as integer) race_source_value, 
	CAST(null as integer) race_source_concept_id, 
	ethnicity_source_value,
	CAST(null as integer) ethnicity_source_concept_id
 FROM [SOURCE_CDMV4].[SCHEMA].PERSON p
	 left JOIN w3m16jd0concept_map gender on LOWER(gender.DOMAIN_ID) IN ('gender') and p.gender_concept_id = gender.source_concept_id
	 left JOIN w3m16jd0concept_map race on LOWER(race.DOMAIN_ID) IN ('race') and p.race_concept_id = race.source_concept_id
	 LEFT JOIN w3m16jd0concept_map ethnicity on LOWER(ethnicity.DOMAIN_ID) IN ('ethnicity') and p.ETHNICITY_CONCEPT_ID = ethnicity.source_concept_id;
 
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'PERSON: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid GENDER_CONCEPT_ID'
 FROM
 (
 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
 FROM [SOURCE_CDMV4].[SCHEMA].PERSON
 WHERE GENDER_CONCEPT_ID NOT IN (
 SELECT CONCEPT_ID
 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
 WHERE CONCEPT_ID = 0
 OR
 (STANDARD_CONCEPT = 'S'
 AND LOWER(DOMAIN_ID) IN ('gender')
 )
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn
 ;
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'PERSON: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid RACE_CONCEPT_ID'
 FROM
 (
 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
 FROM [SOURCE_CDMV4].[SCHEMA].PERSON
 WHERE RACE_CONCEPT_ID IS NOT NULL 
 AND RACE_CONCEPT_ID NOT IN (
 SELECT CONCEPT_ID
 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
 WHERE CONCEPT_ID = 0
 OR
 (STANDARD_CONCEPT = 'S'
 AND LOWER(DOMAIN_ID) IN ('race'))
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn
 ;
 
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'PERSON: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid ETHNICITY_CONCEPT_ID'
 FROM
 (
 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
 FROM [SOURCE_CDMV4].[SCHEMA].PERSON
 WHERE ETHNICITY_CONCEPT_ID IS NOT NULL 
 AND ETHNICITY_CONCEPT_ID NOT IN (
 SELECT CONCEPT_ID
 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
 WHERE CONCEPT_ID = 0
 OR
 (STANDARD_CONCEPT = 'S'
 AND LOWER(DOMAIN_ID) IN ('ethnicity'))
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn
 ;
 
 /****
 
 OBSERVATION_PERIOD
 
 ****/

 INSERT INTO [TARGET_CDMV5].[SCHEMA].observation_period
 SELECT observation_period_id, person_id, observation_period_start_date, observation_period_end_date, 44814722 as period_type_concept_id
 FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION_PERIOD;
 
 /****
 
 DEATH
 
 ****/
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].death
 SELECT person_id, 
	death_date, 
	COALESCE(death_type_concept_id,0) AS death_type_concept_id, 
	cause_of_death_concept_id as cause_concept_id, 
	cause_of_death_source_value as cause_source_value, 
	CAST(null as integer) as cause_source_concept_id
 FROM [SOURCE_CDMV4].[SCHEMA].DEATH
 LEFT JOIN w3m16jd0concept_map_distinct cm1
 ON DEATH.DEATH_TYPE_CONCEPT_ID = CM1.SOURCE_CONCEPT_ID 
 AND LOWER(DOMAIN_ID) IN ('death type');
 
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'DEATH: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid DEATH_TYPE_CONCEPT_ID'
 FROM
 (
	 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	 FROM [SOURCE_CDMV4].[SCHEMA].DEATH
	 WHERE DEATH_TYPE_CONCEPT_ID NOT IN (
	 SELECT CONCEPT_ID
	 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
	 WHERE CONCEPT_ID = 0
	 OR
	 (STANDARD_CONCEPT = 'S'
	 AND LOWER(DOMAIN_ID) IN ('death type'))
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn ;
 
 
 
 /****
 
 VISIT_OCCURRENCE
 
 ****/
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].visit_occurrence
 SELECT visit_occurrence_id, person_id, 
	COALESCE(cm1.target_concept_id,0) as visit_concept_id, 
	visit_start_date, TO_CHAR(null ) visit_start_time, 
	visit_end_date, TO_CHAR(null ) visit_end_time,
	44818517 as visit_type_concept_id, 
	CAST(null as integer) provider_id, 
	care_site_id, place_of_service_source_value as visit_source_value, 
	CAST(null as integer) visit_source_concept_id
 FROM [SOURCE_CDMV4].[SCHEMA].VISIT_OCCURRENCE
 LEFT JOIN w3m16jd0concept_map cm1
 ON VISIT_OCCURRENCE.PLACE_OF_SERVICE_CONCEPT_ID = cm1.source_concept_id
 AND LOWER(cm1.domain_id) IN ('visit');
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'VISIT_OCCURRENCE: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid VISIT_CONCEPT_ID (from the CDMv4 PLACE_OF_SERVICE_CONCEPT_ID field)'
 FROM
 (
 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
 FROM [SOURCE_CDMV4].[SCHEMA].VISIT_OCCURRENCE
 WHERE PLACE_OF_SERVICE_CONCEPT_ID NOT IN (
 SELECT CONCEPT_ID
 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
 WHERE CONCEPT_ID = 0
 OR
 (STANDARD_CONCEPT = 'S'
 AND LOWER(DOMAIN_ID) IN ('visit'))
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn
 ;
 
 
 /****
 
 PROCEDURE_OCCURRENCE
 
 ****/

 -- ***************************************************************************
 -- AGS: Modifying this section to insert this information into the temp 
 --      table #po_map but this may need to be revisited for
 --      performance tuning on APS as a large temp table may cause processing
 --      time issues.
 -- ***************************************************************************
 
 BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE  w3m16jd0po_map';
  EXECUTE IMMEDIATE 'DROP TABLE  w3m16jd0po_map';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

CREATE GLOBAL TEMPORARY TABLE w3m16jd0po_map 
 (
	procedure_occurrence_id int,
	person_id int,
	procedure_concept_id int,
	procedure_date date,
	procedure_type_concept_id int,
	modifier_concept_id int,
	quantity int,
	provider_id int,
	visit_occurrence_id int,
	procedure_source_value varchar(50),
	procedure_source_concept_id int,
	qualifier_source_value varchar(50),
	origional_drug_id NUMBER(19)
) ON COMMIT PRESERVE ROWS;

 --find valid procedures from procedure table
INSERT INTO w3m16jd0po_map
(
	procedure_occurrence_id,
	person_id,
	procedure_concept_id,
	procedure_date,
	procedure_type_concept_id,
	modifier_concept_id,
	quantity,
	provider_id,
	visit_occurrence_id,
	procedure_source_value,
	procedure_source_concept_id,
	qualifier_source_value,
	origional_drug_id
)
 SELECT  
	 procedure_occurrence_id, 
	 person_id, 
	 COALESCE(cm1.target_concept_id,0) as procedure_concept_id, 
	 procedure_date, 
	 COALESCE(cm2.target_concept_id,0) as procedure_type_concept_id, 
	 CAST(null as integer) as modifier_concept_id, 
	 CAST(null as integer) as quantity, 
	 associated_provider_id as provider_id, 
	 visit_occurrence_id, 
	 procedure_source_value,
	 CAST(null as integer) procedure_source_concept_id, 
	 TO_CHAR(null ) qualifier_source_value,
	 CAST(null as NUMBER(19)) as origional_drug_id
 FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
 INNER JOIN w3m16jd0concept_map cm1
 ON PROCEDURE_OCCURRENCE.PROCEDURE_CONCEPT_ID = cm1.source_concept_id
 AND LOWER(cm1.domain_id) IN ('procedure')
 INNER JOIN w3m16jd0concept_map_distinct cmdis 
 ON cm1.source_concept_id = cmdis.source_concept_id AND cm1.domain_id = cmdis.domain_id AND cmdis.targetConceptCount = 1
 LEFT JOIN w3m16jd0concept_map cm2
 ON PROCEDURE_OCCURRENCE.PROCEDURE_TYPE_CONCEPT_ID = cm2.source_concept_id
 AND LOWER(cm2.domain_id) IN ('procedure type') 
 LEFT JOIN w3m16jd0concept_map_distinct cmdis2 
 ON cm2.source_concept_id = cmdis2.source_concept_id AND cm2.domain_id = cmdis2.domain_id AND cmdis2.targetConceptCount = 1

UNION ALL

 -- All procedures that did not map to a standard concept in V4 should also carry over to V5
 SELECT  
	 procedure_occurrence_id, 
	 person_id, 
	 procedure_concept_id, 
	 procedure_date, 
	 procedure_type_concept_id, 
	 CAST(null as integer) as modifier_concept_id, 
	 CAST(null as integer) as quantity, 
	 associated_provider_id as provider_id, 
	 visit_occurrence_id, 
	 procedure_source_value,
	 CAST(null as integer) procedure_source_concept_id, 
	 TO_CHAR(null ) qualifier_source_value,
	 CAST(null as NUMBER(19)) as origional_drug_id
 FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
  FROM
  DUAL
 FROM
  DUAL
WHERE  procedure_concept_id = 0 

UNION ALL

 -- All drug exposures that do not map to a standard concept in V5 should also carry over with condition_concept_id = 0
 SELECT   
	 procedure_occurrence_id, 
	 person_id, 
	 0 as procedure_concept_id, 
	 procedure_date, 
	 COALESCE(cm2.target_concept_id,0) as procedure_type_concept_id, 
	 CAST(null as integer) as modifier_concept_id, 
	 CAST(null as integer) as quantity, 
	 associated_provider_id as provider_id, 
	 visit_occurrence_id, 
	 procedure_source_value,
	 CAST(null as integer) procedure_source_concept_id, 
	 TO_CHAR(null ) qualifier_source_value,
	 CAST(null as NUMBER(19)) as origional_drug_id
  FROM  [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
 LEFT JOIN w3m16jd0concept_map cm1
 ON procedure_concept_id = cm1.source_concept_id
 LEFT JOIN w3m16jd0concept_map cm2
 ON procedure_concept_id = cm2.source_concept_id
 AND LOWER(cm2.domain_id) IN ('procedure type') 
   WHERE  procedure_concept_id <> 0
  and cm1.domain_id IS NULL
   
UNION ALL

 select 
	CASE WHEN MAXROW.MAXROWID IS NULL THEN 0 ELSE MAXROW.MAXROWID END + row_number() over (order by OCCURRENCE_ID)  AS procedure_occurrence_id, 
	person_id, 
	procedure_concept_id, 
	procedure_date, 
	procedure_type_concept_id, 
	modifier_concept_id, 
	quantity,
	provider_id, 
	visit_occurrence_id, 
	procedure_source_value, 
	procedure_source_concept_id, 
	qualifier_source_value,
	origional_drug_id
 FROM
 (  
	  --find valid procedures from procedure table that map to more than 1
	  --target concept in V5
	 SELECT 
		 person_id, 
		 COALESCE(cm1.target_concept_id,0) as procedure_concept_id, 
		 procedure_date, 
		 COALESCE(cm2.target_concept_id,0) as procedure_type_concept_id, 
		 CAST(null as integer) as modifier_concept_id, 
		 CAST(null as integer) as quantity, 
		 associated_provider_id as provider_id, 
		 visit_occurrence_id, 
		 procedure_source_value,
		 CAST(null as integer) procedure_source_concept_id, 
		 TO_CHAR(null ) qualifier_source_value,
		 CAST(null as NUMBER(19)) as origional_drug_id,
		 NULL as OCCURRENCE_ID
	 FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	 INNER JOIN w3m16jd0concept_map cm1
	 ON PROCEDURE_OCCURRENCE.PROCEDURE_CONCEPT_ID = cm1.source_concept_id
	 AND LOWER(cm1.domain_id) IN ('procedure') 
	 INNER JOIN w3m16jd0concept_map_distinct cmdis 
	 ON cm1.source_concept_id = cmdis.source_concept_id AND cm1.domain_id = cmdis.domain_id AND cmdis.targetConceptCount > 1
	 LEFT JOIN w3m16jd0concept_map cm2
	 ON PROCEDURE_OCCURRENCE.PROCEDURE_TYPE_CONCEPT_ID = cm2.source_concept_id
	 AND LOWER(cm2.domain_id) IN ('procedure type') 

	 UNION ALL

	 --find procedures that were previously classified as condition
	 SELECT 
		person_id, 
		cm1.target_concept_id as procedure_concept_id, 
		condition_start_date as procedure_date,
		0 as procedure_type_concept_id, 
		CAST(null as integer) modifier_concept_id, 
		CAST(null as integer) quantity, 
		associated_provider_id as provider_id, 
		visit_occurrence_id, 
		condition_source_value as procedure_source_value,
		CAST(null as integer) procedure_source_concept_id, 
		TO_CHAR(null ) qualifier_source_value,
		CAST(null as NUMBER(19)) origional_drug_id, 
		condition_occurrence_id as OCCURRENCE_ID
	 FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	  INNER JOIN w3m16jd0concept_map cm1
		 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('procedure') 
 
	UNION ALL
	
	 --find procedures that were previously classified as drug
	 SELECT person_id, 
	 cm1.target_concept_id as procedure_concept_id, 
	 drug_exposure_start_date as procedure_date,
	  0 as procedure_type_concept_id, 
	  CAST(null as integer) as modifier_concept_id, 
	  CAST(null as integer) quantity, 
		prescribing_provider_id as provider_id, 
		visit_occurrence_id, 
		drug_source_value as procedure_source_value,
		CAST(null as integer) procedure_source_concept_id, 
		TO_CHAR(null ) qualifier_source_value,
		drug_exposure_id as origional_drug_id, 
		drug_exposure_id as OCCURRENCE_ID
	 FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	INNER JOIN w3m16jd0concept_map cm1
		 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('procedure') 
		 
		 
 --find procedures that were previously classified as observation
	UNION ALL
	 SELECT person_id, 
		cm1.target_concept_id as procedure_concept_id, 
		observation_date as procedure_date,
	  0 as procedure_type_concept_id, CAST(null as integer) modifier_concept_id, CAST(null as integer) quantity, 
		associated_provider_id as provider_id, visit_occurrence_id, observation_source_value as procedure_source_value,
		CAST(null as integer) procedure_source_concept_id, TO_CHAR(null ) qualifier_source_value,
		CAST(null as NUMBER(19)) as origional_drug_id, 
		OBSERVATION_ID as OCCURRENCE_ID
	 FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
	 INNER JOIN w3m16jd0concept_map cm1
		 ON observation.observation_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('procedure') 
	 
	 
	) OTHERS,(SELECT MAX(PROCEDURE_OCCURRENCE_ID) AS MAXROWID FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE) MAXROW 
;
 
INSERT INTO [TARGET_CDMV5].[SCHEMA].procedure_occurrence
           (procedure_occurrence_id
           ,person_id
           ,procedure_concept_id
           ,procedure_date
           ,procedure_type_concept_id
           ,modifier_concept_id
           ,quantity
           ,provider_id
           ,visit_occurrence_id
           ,procedure_source_value
           ,procedure_source_concept_id
           ,qualifier_source_value)
SELECT 
           procedure_occurrence_id
           ,person_id
           ,procedure_concept_id
           ,procedure_date
           ,procedure_type_concept_id
           ,modifier_concept_id
           ,quantity
           ,provider_id
           ,visit_occurrence_id
           ,procedure_source_value
           ,procedure_source_concept_id
           ,qualifier_source_value
FROM w3m16jd0po_map;

 --warnings of invalid records
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'PROCEDURE_OCCURRENCE: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid PROCOEDURE_CONCEPT_ID'
 FROM
 (
 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
 FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
 WHERE PROCEDURE_CONCEPT_ID NOT IN (
 SELECT CONCEPT_ID
 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
 WHERE CONCEPT_ID = 0
 OR
 STANDARD_CONCEPT = 'S'
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn
 ;
 
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'PROCEDURE_OCCURRENCE: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid PROCOEDURE_TYPE_CONCEPT_ID'
 FROM
 (
 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
 FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
 WHERE PROCEDURE_TYPE_CONCEPT_ID NOT IN (
 SELECT CONCEPT_ID
 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
 WHERE CONCEPT_ID = 0
 OR
 (STANDARD_CONCEPT = 'S'
 AND LOWER(DOMAIN_ID) IN ('procedure type'))
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn
 ;
 
 
 /****
 
 DRUG_EXPOSURE
 
 ****/
 
 --find valid drugs from drug_exposure table
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE  w3m16jd0drgexp_map';
  EXECUTE IMMEDIATE 'DROP TABLE  w3m16jd0drgexp_map';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

CREATE GLOBAL TEMPORARY TABLE w3m16jd0drgexp_map 
 (
	drug_exposure_id int, 
	person_id int, 
	drug_concept_id int, 
	drug_exposure_start_date date, 
	drug_exposure_end_date date, 
	drug_type_concept_id int, 
	stop_reason varchar(20), 
	refills int, 
	quantity float, 
	days_supply int, 
	sig CLOB, 
	route_concept_id int, 
	effective_drug_dose float, 
	dose_unit_concept_id int, 
	lot_number varchar(50), 
	provider_id int, 
	visit_occurrence_id int, 
	drug_source_value varchar(50), 
	drug_source_concept_id int, 
	route_source_value varchar(50), 
	dose_unit_source_value varchar(50),
	origional_procedure_id int
) ON COMMIT PRESERVE ROWS;

INSERT INTO w3m16jd0drgexp_map
(
	drug_exposure_id, 
	person_id, 
	drug_concept_id, 
	drug_exposure_start_date, 
	drug_exposure_end_date, 
	drug_type_concept_id, 
	stop_reason, 
	refills, 
	quantity, 
	days_supply, 
	sig, 
	route_concept_id, 
	effective_drug_dose, 
	dose_unit_concept_id, 
	lot_number, 
	provider_id, 
	visit_occurrence_id, 
	drug_source_value, 
	drug_source_concept_id, 
	route_source_value, 
	dose_unit_source_value,
	origional_procedure_id
)
 SELECT   drug_exposure_id, 
	person_id, 
	COALESCE(cm1.target_concept_id,0) as drug_concept_id, 
	drug_exposure_start_date, 
	drug_exposure_end_date, 
	COALESCE(cm2.target_concept_id, 0) drug_type_concept_id, 
	stop_reason, 
	refills, 
	quantity, 
	days_supply, 
	sig, 
	CAST(null as integer) route_concept_id,
	CAST(null as float) effective_drug_dose, 
	CAST(null as integer) dose_unit_concept_id, 
	TO_CHAR(null ) lot_number,
	prescribing_provider_id as provider_id, 
	visit_occurrence_id, 
	drug_source_value,
	CAST(null as integer) drug_source_concept_id, 
	TO_CHAR(null ) route_source_value, 
	TO_CHAR(null ) dose_unit_source_value,
	CAST(null as NUMBER(19)) origional_procedure_id
  FROM  [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
 INNER JOIN w3m16jd0concept_map cm1
 ON drug_exposure.drug_concept_id = cm1.source_concept_id
 AND LOWER(cm1.domain_id) IN ('drug') 
 INNER JOIN w3m16jd0concept_map_distinct cmdis 
 ON cm1.source_concept_id = cmdis.source_concept_id AND cm1.domain_id = cmdis.domain_id AND cmdis.targetConceptCount = 1
 LEFT JOIN w3m16jd0concept_map cm2
 ON drug_exposure.drug_type_concept_id = cm2.source_concept_id
 AND LOWER(cm2.domain_id) IN ('drug type') 
 INNER JOIN w3m16jd0concept_map_distinct cmdis2 
 ON cm2.source_concept_id = cmdis2.source_concept_id AND cm2.domain_id = cmdis2.domain_id AND cmdis2.targetConceptCount = 1
   WHERE  drug_concept_id > 0 -- This condition will map those concepts that were mapped to valid concepts in V4

UNION ALL

 -- All drug exposures that did not map to a standard concept in V4 should also carry over to V5
 SELECT   drug_exposure_id, 
	person_id, 
	drug_concept_id, 
	drug_exposure_start_date, 
	drug_exposure_end_date, 
	drug_type_concept_id, 
	stop_reason, 
	refills, 
	quantity, 
	days_supply, 
	sig, 
	CAST(null as integer) route_concept_id,
	CAST(null as float) effective_drug_dose, 
	CAST(null as integer) dose_unit_concept_id, 
	TO_CHAR(null ) lot_number,
	prescribing_provider_id as provider_id, 
	visit_occurrence_id, 
	drug_source_value,
	CAST(null as integer) drug_source_concept_id, 
	TO_CHAR(null ) route_source_value, 
	TO_CHAR(null ) dose_unit_source_value,
	CAST(null as NUMBER(19)) origional_procedure_id
  FROM  [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
   WHERE  drug_concept_id = 0 

UNION ALL

 -- All drug exposures that do not map to a standard concept in V5 should also carry over with condition_concept_id = 0
 SELECT   drug_exposure_id, 
	person_id, 
	0, 
	drug_exposure_start_date, 
	drug_exposure_end_date, 
	COALESCE(cm2.target_concept_id, 0) drug_type_concept_id, 
	stop_reason, 
	refills, 
	quantity, 
	days_supply, 
	sig, 
	CAST(null as integer) route_concept_id,
	CAST(null as float) effective_drug_dose, 
	CAST(null as integer) dose_unit_concept_id, 
	TO_CHAR(null ) lot_number,
	prescribing_provider_id as provider_id, 
	visit_occurrence_id, 
	drug_source_value,
	CAST(null as integer) drug_source_concept_id, 
	TO_CHAR(null ) route_source_value, 
	TO_CHAR(null ) dose_unit_source_value,
	CAST(null as NUMBER(19)) origional_procedure_id
  FROM  [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
 LEFT JOIN w3m16jd0concept_map cm1
 ON drug_concept_id = cm1.source_concept_id
 LEFT JOIN w3m16jd0concept_map cm2
 ON drug_exposure.drug_type_concept_id = cm2.source_concept_id
 AND LOWER(cm2.domain_id) IN ('drug type') 
   WHERE  drug_concept_id <> 0
  and cm1.domain_id IS NULL
   
UNION ALL 
select CASE WHEN MAXROW.MAXROWID IS NULL THEN 0 ELSE MAXROW.MAXROWID END + row_number() over (order by OCCURRENCE_ID) AS drug_exposure_id, 
	person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, 
	drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id,
	effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value,
	drug_source_concept_id, route_source_value, dose_unit_source_value
	, origional_procedure_id
FROM 
(
	--find valid drugs from drug_exposure table that map to > 1 target concept
	SELECT 
		person_id, 
		COALESCE(cm1.target_concept_id,0) as drug_concept_id, 
		drug_exposure_start_date, 
		drug_exposure_end_date, 
		COALESCE(cm2.target_concept_id, 0) drug_type_concept_id, 
		stop_reason, 
		refills, 
		quantity, 
		days_supply, 
		sig, 
		CAST(null as integer) route_concept_id,
		CAST(null as float) effective_drug_dose, 
		CAST(null as integer) dose_unit_concept_id, 
		TO_CHAR(null ) lot_number,
		prescribing_provider_id as provider_id, 
		visit_occurrence_id, 
		drug_source_value,
		CAST(null as integer) drug_source_concept_id, 
		TO_CHAR(null ) route_source_value, 
		TO_CHAR(null ) dose_unit_source_value,
		CAST(null as NUMBER(19)) origional_procedure_id,
		NULL as OCCURRENCE_ID
	 FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	 INNER JOIN w3m16jd0concept_map cm1
	 ON drug_exposure.drug_concept_id = cm1.source_concept_id
	 AND LOWER(cm1.domain_id) IN ('drug') 
	 INNER JOIN w3m16jd0concept_map_distinct cmdis 
	 ON cm1.source_concept_id = cmdis.source_concept_id AND cm1.domain_id = cmdis.domain_id AND cmdis.targetConceptCount > 1
	 LEFT JOIN w3m16jd0concept_map cm2
	 ON drug_exposure.drug_type_concept_id = cm2.source_concept_id
	 AND LOWER(cm2.domain_id) IN ('drug type') 
 
 UNION ALL
 --find drugs that were previously classified as condition
	select person_id, 
	cm1.target_concept_id as drug_concept_id, 
	condition_start_date as drug_exposure_start_date, null as drug_exposure_end_date, 
	0 as drug_type_concept_id, null as stop_reason, null as refills, null as quantity, null as days_supply, null as sig, CAST(null as integer) route_concept_id,
	CAST(null as float) effective_drug_dose, CAST(null as integer) dose_unit_concept_id, TO_CHAR(null ) lot_number,
	null as provider_id, visit_occurrence_id, condition_source_value as drug_source_value,
	CAST(null as integer) drug_source_concept_id, TO_CHAR(null ) route_source_value, TO_CHAR(null ) dose_unit_source_value,
	CAST(null as NUMBER(19)) origional_procedure_id, condition_occurrence_id as occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	INNER JOIN w3m16jd0concept_map cm1
		 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('drug')  
 
 --find drugs that were previously classified as procedure
	UNION ALL
	select person_id, 
	cm1.target_concept_id as drug_concept_id, 
	procedure_date as drug_exposure_start_date, null as drug_exposure_end_date, 
	0 as drug_type_concept_id, null as stop_reason, null as refills, null as quantity, null as days_supply, null as sig, CAST(null as integer) route_concept_id,
	CAST(null as float) effective_drug_dose, CAST(null as integer) dose_unit_concept_id, TO_CHAR(null ) lot_number,
	null as provider_id, visit_occurrence_id, procedure_source_value as drug_source_value,
	CAST(null as integer) drug_source_concept_id, TO_CHAR(null ) route_source_value, TO_CHAR(null ) dose_unit_source_value,
	procedure_occurrence_id as origional_procedure_id, procedure_occurrence_id as occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN w3m16jd0concept_map cm1
		 ON procedure_occurrence.procedure_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('drug')  
 
 --find drugs that were previously classified as observation
	UNION ALL 
	select person_id, 
	cm1.target_concept_id as drug_concept_id, observation_date as drug_exposure_start_date, null as drug_exposure_end_date, 
	0 as drug_type_concept_id, null as stop_reason, null as refills, null as quantity, null as days_supply, null as sig, CAST(null as integer) route_concept_id,
	CAST(null as float) effective_drug_dose, CAST(null as integer) dose_unit_concept_id, TO_CHAR(null ) lot_number,
	null as provider_id, visit_occurrence_id, observation_source_value as drug_source_value,
	CAST(null as integer) drug_source_concept_id, TO_CHAR(null ) route_source_value, TO_CHAR(null ) dose_unit_source_value,
	CAST(null as NUMBER(19)) origional_procedure_id, observation_id as occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
	INNER JOIN w3m16jd0concept_map cm1
		 ON observation.observation_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('drug')  
) OTHERS,(SELECT MAX(DRUG_EXPOSURE_ID) AS MAXROWID FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE) MAXROW 
;
INSERT INTO [TARGET_CDMV5].[SCHEMA].drug_exposure
           (drug_exposure_id
           ,person_id
           ,drug_concept_id
           ,drug_exposure_start_date
           ,drug_exposure_end_date
           ,drug_type_concept_id
           ,stop_reason
           ,refills
           ,quantity
           ,days_supply
           ,sig
           ,route_concept_id
           ,effective_drug_dose
           ,dose_unit_concept_id
           ,lot_number
           ,provider_id
           ,visit_occurrence_id
           ,drug_source_value
           ,drug_source_concept_id
           ,route_source_value
           ,dose_unit_source_value)
SELECT
	drug_exposure_id
    ,person_id
    ,drug_concept_id
    ,drug_exposure_start_date
    ,drug_exposure_end_date
    ,drug_type_concept_id
    ,stop_reason
    ,refills
    ,quantity
    ,days_supply
    ,sig
    ,route_concept_id
    ,effective_drug_dose
    ,dose_unit_concept_id
    ,lot_number
    ,provider_id
    ,visit_occurrence_id
    ,drug_source_value
    ,drug_source_concept_id
    ,route_source_value
    ,dose_unit_source_value
FROM w3m16jd0drgexp_map;
 
 --warnings of invalid records
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'DRUG_EXPOSURE: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid DRUG_CONCEPT_ID'
 FROM
 (
 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
 FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
 WHERE DRUG_CONCEPT_ID NOT IN (
 SELECT CONCEPT_ID
 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
 WHERE CONCEPT_ID = 0
 OR
 STANDARD_CONCEPT = 'S'
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn
 ;
 
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'DRUG_EXPOSURE: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid DRUG_TYPE_CONCEPT_ID'
 FROM
 (
 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
 FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
 WHERE DRUG_TYPE_CONCEPT_ID NOT IN (
 SELECT CONCEPT_ID
 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
 WHERE CONCEPT_ID = 0
 OR
 (STANDARD_CONCEPT = 'S'
 AND LOWER(DOMAIN_ID) IN ('drug type'))
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn
 ;
 
 
 /****
 
 CONDITION_OCCURRENCE
 
 ****/
 
 --find valid conditions from condition_occurrence table
 INSERT INTO [TARGET_CDMV5].[SCHEMA].condition_occurrence
 SELECT   condition_occurrence_id, 
	person_id, 
	COALESCE(cm1.target_concept_id, 0) AS condition_concept_id, 
	condition_start_date, 
	condition_end_date, 
	COALESCE(cm2.target_concept_id,0) AS condition_type_concept_id, 
	stop_reason, associated_provider_id as provider_id, visit_occurrence_id, 
	condition_source_value, CAST(null as integer) condition_source_concept_id
  FROM  [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
 INNER JOIN w3m16jd0concept_map cm1
 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
 AND LOWER(cm1.domain_id) IN ('condition') 
 INNER JOIN w3m16jd0concept_map_distinct cmdis 
 ON cm1.source_concept_id = cmdis.source_concept_id AND cm1.domain_id = cmdis.domain_id AND cmdis.targetConceptCount = 1
 LEFT JOIN w3m16jd0concept_map cm2
 ON condition_occurrence.condition_type_concept_id = cm2.source_concept_id
 AND LOWER(cm2.domain_id) IN ('condition type') 
   WHERE  condition_concept_id > 0 -- This condition will map those concepts that were mapped to valid concepts in V4

UNION ALL

 -- All conditions that did not map to a standard concept in V4 should also carry over to V5
 SELECT   condition_occurrence_id, 
	person_id, 
	condition_concept_id, 
	condition_start_date, 
	condition_end_date, 
	COALESCE(condition_type_concept_id,0) AS condition_type_concept_id, 
	stop_reason, 
	associated_provider_id as provider_id, 
	visit_occurrence_id, 
	condition_source_value, 
	CAST(null as integer) condition_source_concept_id
  FROM  [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
   WHERE  condition_concept_id = 0 

UNION ALL

 -- All conditions that do not map to a standard concept in V5 should also carry over with condition_concept_id = 0
 SELECT   condition_occurrence_id, 
	person_id, 
	0 AS condition_concept_id, 
	condition_start_date, 
	condition_end_date, 
	COALESCE(cm2.target_concept_id,0) AS condition_type_concept_id, 
	stop_reason, 
	associated_provider_id as provider_id, 
	visit_occurrence_id, 
	condition_source_value, 
	CAST(null as integer) condition_source_concept_id
  FROM  [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
 LEFT JOIN w3m16jd0concept_map cm1
 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
 LEFT JOIN w3m16jd0concept_map cm2
 ON condition_occurrence.condition_type_concept_id = cm2.source_concept_id
 AND LOWER(cm2.domain_id) IN ('condition type') 
   WHERE  condition_concept_id <> 0
  and cm1.domain_id IS NULL

UNION ALL
select CASE WHEN MAXROW.MAXROWID IS NULL THEN 0 ELSE MAXROW.MAXROWID END + row_number() over (order by OCCURRENCE_ID) AS drug_exposure_id, 
	person_id, condition_concept_id, condition_start_date, condition_end_date, 
	condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, 
	condition_source_value, condition_source_concept_id
FROM (

	--find valid conditions from condition_occurrence table that map to > 1 target concept
	 SELECT 
		person_id, 
		COALESCE(cm1.target_concept_id, 0) AS condition_concept_id, 
		condition_start_date, 
		condition_end_date, 
		COALESCE(cm2.target_concept_id,0) AS condition_type_concept_id, 
		stop_reason, associated_provider_id as provider_id, visit_occurrence_id, 
		condition_source_value, CAST(null as integer) condition_source_concept_id,
		NULL as OCCURRENCE_ID
	 FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	 INNER JOIN w3m16jd0concept_map cm1
	 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
	 AND LOWER(cm1.domain_id) IN ('condition') 
	 INNER JOIN w3m16jd0concept_map_distinct cmdis 
	 ON cm1.source_concept_id = cmdis.source_concept_id AND cm1.domain_id = cmdis.domain_id AND cmdis.targetConceptCount > 1
	 LEFT JOIN w3m16jd0concept_map cm2
	 ON condition_occurrence.condition_type_concept_id = cm2.source_concept_id
	 AND LOWER(cm2.domain_id) IN ('condition type') 
	 WHERE condition_concept_id > 0 -- This condition will map those concepts that were mapped to valid concepts in V4
 
 UNION ALL

	 --find conditions that were previously classified as procedure
	select person_id, 
	cm1.target_concept_id as condition_concept_id, 
	procedure_date as condition_start_date, null as condition_end_date, 
	0 as condition_type_concept_id, null as stop_reason, associated_provider_id as provider_id, visit_occurrence_id, 
	procedure_source_value as condition_source_value, CAST(null as integer) condition_source_concept_id,
	procedure_occurrence_id as OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN w3m16jd0concept_map cm1
		 ON procedure_occurrence.procedure_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('condition')  

 --find conditions that were previously classified as drug
	UNION ALL
	SELECT person_id, 
		cm1.target_concept_id as condition_concept_id, 
		drug_exposure_start_date as condition_start_date, null as condition_end_date, 
		0 as condition_type_concept_id, null as stop_reason, prescribing_provider_id as provider_id, visit_occurrence_id, 
		drug_source_value as condition_source_value, CAST(null as integer) condition_source_concept_id,
		drug_exposure_id as OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	INNER JOIN w3m16jd0concept_map cm1
		 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('condition')  
 
 --find conditions that were previously classified as observation
	UNION ALL
	SELECT person_id, 
		cm1.target_concept_id as condition_concept_id, 
		observation_date as condition_start_date, null as condition_end_date, 
		0 as condition_type_concept_id, null as stop_reason, associated_provider_id as provider_id, visit_occurrence_id, 
		observation_source_value as condition_source_value, CAST(null as integer) condition_source_concept_id,
		observation_id as OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
	INNER JOIN w3m16jd0concept_map cm1
		 ON observation.observation_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('condition') 
) OTHERS,(SELECT MAX(condition_occurrence_id) AS MAXROWID FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE) MAXROW 
;
 
 
 --warnings of invalid records
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'CONDITION_OCCURRENCE: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid CONDITION_CONCEPT_ID'
 FROM
 (
 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
 FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
 WHERE CONDITION_CONCEPT_ID NOT IN (
 SELECT CONCEPT_ID
 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
 WHERE CONCEPT_ID = 0
 OR
 STANDARD_CONCEPT = 'S'
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn
 ;
 
 
 INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
 SELECT 'CONDIITON_OCCURRENCE: ' || TO_CHAR(NUM_INVALID_RECORDS ) || ' records in the source CDMv4 database have invalid CONDITION_TYPE_CONCEPT_ID'
 FROM
 (
 SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
 FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
 WHERE CONDITION_TYPE_CONCEPT_ID NOT IN (
 SELECT CONCEPT_ID
 FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
 WHERE CONCEPT_ID = 0
 OR
 (STANDARD_CONCEPT = 'S'
 AND LOWER(DOMAIN_ID) IN ('condition type'))
 )
 HAVING COUNT(PERSON_ID) > 0
 ) warn
 ;
 
 
 

 /****
 
 DEVICE_EXPOSURE
 
 ****/
 
INSERT INTO [TARGET_CDMV5].[SCHEMA].device_exposure
select row_number() over (order by OCCURRENCE_ID) AS device_exposure_id, 
	person_id, device_concept_id, device_exposure_start_date, device_exposure_end_date, device_type_concept_id,
	unique_device_id, quantity, provider_id, visit_occurrence_id, device_source_value, device_source_concept_id
FROM
(
	--find devices that were previously classified as procedures
	SELECT PERSON_ID, 
		cm1.target_concept_id AS DEVICE_CONCEPT_ID, 
		PROCEDURE_DATE AS DEVICE_EXPOSURE_START_DATE, 
		TO_DATE(NULL , 'yyyymmdd') AS DEVICE_EXPOSURE_END_DATE, 0 AS DEVICE_TYPE_CONCEPT_ID, TO_CHAR(NULL ) unique_device_id,
		CAST(null as integer) quantity, ASSOCIATED_PROVIDER_ID AS PROVIDER_ID, 
		VISIT_OCCURRENCE_ID, PROCEDURE_SOURCE_VALUE AS DEVICE_SOURCE_VALUE, 0 as device_source_concept_id,
		PROCEDURE_OCCURRENCE_ID as OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN w3m16jd0concept_map cm1
		 ON procedure_occurrence.procedure_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('device')  
 
	--find devices that were previously classified as drug exposure
	UNION ALL 
	SELECT PERSON_ID, 
		cm1.target_concept_id AS DEVICE_CONCEPT_ID, 
		DRUG_EXPOSURE_START_DATE AS DEVICE_EXPOSURE_START_DATE, 
		TO_DATE(NULL , 'yyyymmdd') AS DEVICE_EXPOSURE_END_DATE, 0 AS DEVICE_TYPE_CONCEPT_ID, TO_CHAR(NULL ) unique_device_id, 
		quantity, PRESCRIBING_PROVIDER_ID AS PROVIDER_ID, 
		VISIT_OCCURRENCE_ID, DRUG_SOURCE_VALUE AS DEVICE_SOURCE_VALUE, 0 as device_source_concept_id,
		DRUG_EXPOSURE_ID as OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	INNER JOIN w3m16jd0concept_map cm1
		 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('device')  
 
	--find devices that were previously classified as conditions
	UNION ALL
	SELECT PERSON_ID, 
		cm1.target_concept_id AS DEVICE_CONCEPT_ID, 
		CONDITION_START_DATE AS DEVICE_EXPOSURE_START_DATE, 
		TO_DATE(NULL , 'yyyymmdd') AS DEVICE_EXPOSURE_END_DATE, 0 AS DEVICE_TYPE_CONCEPT_ID, TO_CHAR(NULL ) unique_device_id, 
		CAST(NULL as integer) quantity, ASSOCIATED_PROVIDER_ID AS PROVIDER_ID, 
		VISIT_OCCURRENCE_ID, CONDITION_SOURCE_VALUE AS DEVICE_SOURCE_VALUE, 0 as device_source_concept_id,
		CONDITION_OCCURRENCE_ID as OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	INNER JOIN w3m16jd0concept_map cm1
		 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('device')  
 
	--find devices that were previously classified as observations
	UNION ALL
	SELECT PERSON_ID, 
		cm1.target_concept_id AS DEVICE_CONCEPT_ID, 
		OBSERVATION_DATE AS DEVICE_EXPOSURE_START_DATE, 
		TO_DATE(NULL , 'yyyymmdd') AS DEVICE_EXPOSURE_END_DATE, 0 AS DEVICE_TYPE_CONCEPT_ID,  TO_CHAR(NULL ) unique_device_id, 
		CAST(null as integer) quantity, ASSOCIATED_PROVIDER_ID AS PROVIDER_ID,
		VISIT_OCCURRENCE_ID, OBSERVATION_SOURCE_VALUE AS DEVICE_SOURCE_VALUE, 0 as device_source_concept_id,
		OBSERVATION_ID as OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
	INNER JOIN w3m16jd0concept_map cm1
		 ON observation.observation_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('device')  
) OTHERS
;
 
 
 /****
 
 MEASUREMENT
 
 ****/
 
--find valid measurements from observation table
INSERT INTO [TARGET_CDMV5].[SCHEMA].measurement
SELECT row_number() over (order by occurrence_id) AS measurement_id,  
	person_id, measurement_concept_id, measurement_date, measurement_time, measurement_type_concept_id, operator_concept_id, value_as_number, value_as_concept_id, unit_concept_id, range_low, range_high, 
	provider_id, visit_occurrence_id, measurement_source_value, measurement_source_concept_id, unit_source_value, value_source_value
from
(
	--find mesaurements that were previously classified as observations
	select person_id, 
		cm1.target_concept_id AS measurement_concept_id, 
		OBSERVATION_DATE AS  measurement_date, 
		TO_CHAR(OBSERVATION_TIME ) AS measurement_time, 
		0 AS measurement_type_concept_id, 
		CAST(null as integer) operator_concept_id,
		value_as_number, 
		value_as_concept_id, 
		COALESCE(cm2.target_concept_id,0) AS unit_concept_id,
		range_low, 
		range_high, 
		ASSOCIATED_PROVIDER_ID AS provider_id, 
		visit_occurrence_id, 
		OBSERVATION_SOURCE_VALUE AS measurement_source_value,
		CAST(null as integer) measurement_source_concept_id, 
		unit_source_value AS unit_source_value, 
		TO_CHAR(null ) as value_source_value,
		observation_id as occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
	INNER JOIN w3m16jd0concept_map cm1
			 ON observation.observation_concept_id = cm1.source_concept_id
			 AND LOWER(cm1.domain_id) IN ('measurement')  
	LEFT JOIN w3m16jd0concept_map cm2
			 ON observation.unit_concept_id = cm2.source_concept_id
			 AND LOWER(cm1.domain_id) IN ('unit')  

	UNION ALL

	SELECT person_id, 
		cm1.target_concept_id as measurement_concept_id, 
		procedure_date as measurement_date, 
		TO_CHAR(NULL ) as measurement_time, 
		0 as measurement_type_concept_id, 
		CAST(null as integer) as operator_concept_id, 
		CAST(null as integer) as value_as_number, 
		CAST(null as integer) as value_as_concept_id, 
		CAST(null as integer) as unit_concept_id, 
		CAST(null as integer) as range_low, 
		CAST(null as integer) as range_high, 
		associated_provider_id as provider_id, 
		visit_occurrence_id, 
		procedure_source_value as measurement_source_value, 
		CAST(null as integer) as measurement_source_concept_id, 
		TO_CHAR(null ) as unit_source_value, 
		TO_CHAR(null ) as value_source_value,
		procedure_occurrence_id as occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN w3m16jd0concept_map cm1
		 ON procedure_occurrence.procedure_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('measurement') 
		 
	UNION ALL

	SELECT person_id, 
		cm1.target_concept_id as measurement_concept_id, 
		condition_start_date as measurement_date, 
		TO_CHAR(NULL ) as measurement_time, 
		0 as measurement_type_concept_id, 
		CAST(null as integer) as operator_concept_id, 
		CAST(null as integer) as value_as_number, 
		CAST(null as integer) as value_as_concept_id, 
		CAST(null as integer) as unit_concept_id, 
		CAST(null as integer) as range_low, 
		CAST(null as integer) as range_high, 
		associated_provider_id as provider_id, 
		visit_occurrence_id, 
		condition_source_value as measurement_source_value, 
		CAST(null as integer) as measurement_source_concept_id, 
		TO_CHAR(null ) as unit_source_value, 
		TO_CHAR(null ) as value_source_value,
		condition_occurrence_id as occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	INNER JOIN w3m16jd0concept_map cm1
		 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('measurement') 
		 
	UNION ALL

	SELECT person_id, 
		cm1.target_concept_id as measurement_concept_id, 
		drug_exposure_start_date as measurement_date, 
		TO_CHAR(NULL ) as measurement_time, 
		0 as measurement_type_concept_id, 
		CAST(null as integer) as operator_concept_id, 
		CAST(null as integer) as value_as_number, 
		CAST(null as integer) as value_as_concept_id, 
		CAST(null as integer) as unit_concept_id, 
		CAST(null as integer) as range_low, 
		CAST(null as integer) as range_high, 
		prescribing_provider_id as provider_id, 
		visit_occurrence_id, 
		drug_source_value as measurement_source_value, 
		CAST(null as integer) as measurement_source_concept_id, 
		TO_CHAR(null ) as unit_source_value, 
		TO_CHAR(null ) as value_source_value,
		drug_exposure_id as occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].drug_exposure
	INNER JOIN w3m16jd0concept_map cm1
		 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('measurement') 	 
		 
		 
) OTHERS
;
 
 
 
 /****
 
 OBSERVATION
 
 ****/
 
 
 --find valid observation from observation table
 INSERT INTO [TARGET_CDMV5].[SCHEMA].observation
 SELECT   
	observation_id, 
	person_id, 
	observation_concept_id, 
	observation_date, 
	TO_CHAR(observation_time ) as observation_time, 
	observation_type_concept_id, 
	value_as_number, 
	value_as_string, 
	value_as_concept_id, 
	CAST(null as integer) qualifier_concept_id,
	unit_concept_id, 
	associated_provider_id as provider_id, 
	visit_occurrence_id, 
	observation_source_value, 
	CAST(null as integer) observation_source_concept_id,
	unit_source_value, 
	TO_CHAR(null ) qualifier_source_value
  FROM  [SOURCE_CDMV4].[SCHEMA].OBSERVATION
   WHERE  observation_concept_id NOT IN (SELECT source_concept_id FROM w3m16jd0concept_map_distinct WHERE LOWER(domain_id) IN ('condition','drug','procedure','device','measurement')) 

 
 --find observations that were previously classified as procedure
UNION ALL 
select 
	CASE WHEN MAXROW.MAXROWID IS NULL THEN 0 ELSE MAXROW.MAXROWID END + row_number() over (order by OCCURRENCE_ID) AS observation_id, 
	person_id, 
	observation_concept_id, 
	observation_date, 
	observation_time, 
	observation_type_concept_id, 
	value_as_number, 
	value_as_string, 
	value_as_concept_id, 
	qualifier_concept_id,
	unit_concept_id, 
	provider_id, 
	visit_occurrence_id, 
	observation_source_value, 
	observation_source_concept_id,
	unit_source_value, 
	qualifier_source_value
FROM
(
	select person_id, 
		cm1.target_concept_id as observation_concept_id, 
		procedure_date as observation_date, 
		TO_CHAR(null ) as observation_time,
		0 as observation_type_concept_id, 
		CAST(null as float) as value_as_number, 
		null as value_as_string, 
		CAST(null as integer) as value_as_concept_id, 
		CAST(null as integer) qualifier_concept_id,
		CAST(null as integer) as unit_concept_id, 
		associated_provider_id as provider_id, 
		visit_occurrence_id, 
		procedure_source_value as observation_source_value, 
		CAST(null as integer) observation_source_concept_id,
		null as unit_source_value, 
		TO_CHAR(null ) qualifier_source_value,
		procedure_occurrence_id as occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN w3m16jd0concept_map cm1
		 ON procedure_occurrence.procedure_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('observation') 
 
 --find observations that were previously classified as condition
	UNION ALL 
	SELECT person_id, 
		cm1.target_concept_id as observation_concept_id, 
		condition_start_date as observation_date, 
		TO_CHAR(null ) as observation_time,
		0 as observation_type_concept_id, 
		CAST(null as float) as value_as_number, 
		null as value_as_string, 
		CAST(null as integer) as value_as_concept_id, 
		CAST(null as integer) qualifier_concept_id,
		CAST(null as integer) as unit_concept_id, 
		associated_provider_id as provider_id, 
		visit_occurrence_id, 
		condition_source_value as observation_source_value, 
		CAST(null as integer) observation_source_concept_id,
		null as unit_source_value, 
		TO_CHAR(null ) qualifier_source_value,
		condition_occurrence_id as occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	INNER JOIN w3m16jd0concept_map cm1
		 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('observation') 
 
 --find observations that were previously classified as drug exposure
	UNION ALL
	SELECT person_id, 
		cm1.target_concept_id as observation_concept_id, 
		drug_exposure_start_date as observation_date, 
		TO_CHAR(null ) as observation_time,
		0 as observation_type_concept_id, 
		CAST(null as float) as value_as_number, 
		null as value_as_string, 
		CAST(null as integer) as value_as_concept_id, 
		CAST(null as integer) qualifier_concept_id,
		CAST(null as integer) as unit_concept_id, 
		CAST(null as integer) as provider_id, 
		visit_occurrence_id, 
		drug_source_value as observation_source_value, 
		CAST(null as integer) observation_source_concept_id,
		null as unit_source_value, 
		TO_CHAR(null ) qualifier_source_value,
		drug_exposure_id as occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	INNER JOIN w3m16jd0concept_map cm1
		 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		 AND LOWER(cm1.domain_id) IN ('observation') 
 ) OTHERS,(SELECT MAX(OBSERVATION_ID) AS MAXROWID FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION) MAXROW 
 ;
 
 
 
 /****
 
 PAYER_PLAN_PERIOD
 
 ****/

INSERT INTO [TARGET_CDMV5].[SCHEMA].payer_plan_period
SELECT payer_plan_period_id, person_id, payer_plan_period_start_date, payer_plan_period_end_date, 
	payer_source_value, plan_source_value, family_source_value
FROM [SOURCE_CDMV4].[SCHEMA].PAYER_PLAN_PERIOD;
 
 /****
 
 DRUG_COST
 
 note : if there were invalid drug concepts in DRUG_EXPOSURE, those records may not enter CDMv5 but costs will persist
 
 ****/

INSERT INTO [TARGET_CDMV5].[SCHEMA].drug_cost
SELECT drug_cost_id, dc.drug_exposure_id, cast(null as integer) currency_concept_id, paid_copay, paid_coinsurance, paid_toward_deductible, paid_by_payer, 
	paid_by_coordination_benefits, total_out_of_pocket, total_paid, ingredient_cost, dispensing_fee, 
	average_wholesale_price, payer_plan_period_id
FROM [SOURCE_CDMV4].[SCHEMA].DRUG_COST dc
;

-- insert procedure costs for procedures that were inserted into the drug_exposure table
INSERT INTO [TARGET_CDMV5].[SCHEMA].drug_cost
select 
	CASE WHEN MAXROW.MAXROWID IS NULL THEN 0 ELSE MAXROW.MAXROWID END + row_number() over (order by OCCURRENCE_ID) AS drug_cost_id, 
	drug_exposure_id, 
	cast(null as integer) currency_concept_id, 
	paid_copay, 
	paid_coinsurance, 
	paid_toward_deductible, 
	paid_by_payer, 
	paid_by_coordination_benefits, 
	total_out_of_pocket, 
	total_paid, 
	ingredient_cost, 
	dispensing_fee, 
	average_wholesale_price, 
	payer_plan_period_id
FROM (
		SELECT 
			drug_exposure_id, 
			po.person_id, 
			paid_copay, 
			paid_coinsurance, 
			paid_toward_deductible, 
			paid_by_payer, 
			paid_by_coordination_benefits, 
			total_out_of_pocket, 
			total_paid, 
			CAST(null as float) as ingredient_cost, 
			CAST(null as float) as dispensing_fee, 
			CAST(null as float) as average_wholesale_price, 
			payer_plan_period_id, 
			procedure_cost_id as OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE po
	join [SOURCE_CDMV4].[SCHEMA].PROCEDURE_COST pc on po.procedure_occurrence_id = pc.procedure_occurrence_id
	--JOIN dbo.drug_exposure de on de.person_id = po.person_id and pc.procedure_occurrence_id = de.origional_procedure_id
	JOIN w3m16jd0drgexp_map de on de.person_id = po.person_id and pc.procedure_occurrence_id = de.origional_procedure_id
) OTHERS ,(SELECT MAX(drug_cost_id) AS MAXROWID FROM [SOURCE_CDMV4].[SCHEMA].DRUG_COST) MAXROW 
;
 
 /****
 
 PROCEDURE_COST
 
 note : if there were invalid procedure concepts in PROCEDURE_OCCURRENCE, those records may not enter CDMv5 but costs will persist
 
 
 ****/

INSERT INTO [TARGET_CDMV5].[SCHEMA].procedure_cost
SELECT procedure_cost_id, procedure_occurrence_id, cast(null as integer) currency_concept_id, paid_copay, paid_coinsurance, paid_toward_deductible, 
	paid_by_payer, paid_by_coordination_benefits, total_out_of_pocket, total_paid, 
	payer_plan_period_id, revenue_code_concept_id, revenue_code_source_value
FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_COST;


-- insert drug costs for drugs that were inserted into the procedure_occurrence table
INSERT INTO [TARGET_CDMV5].[SCHEMA].procedure_cost
SELECT 
	CASE WHEN MAXROW.MAXROWID IS NULL THEN 0 ELSE MAXROW.MAXROWID END + row_number() over (order by OCCURRENCE_ID) AS procedure_cost_id, 
	procedure_occurrence_id, 
	cast(null as integer) 
	currency_concept_id, 
	paid_copay, 
	paid_coinsurance, 
	paid_toward_deductible, 
	paid_by_payer, 
	paid_by_coordination_benefits, 
	total_out_of_pocket, 
	total_paid, 
	payer_plan_period_id,
	revenue_code_concept_id, 
	revenue_code_source_value
	FROM (
		SELECT 
			po.procedure_occurrence_id, 
			po.person_id, 
			paid_copay, 
			paid_coinsurance, 
			paid_toward_deductible, 
			paid_by_payer, 
			paid_by_coordination_benefits, 
			total_out_of_pocket, 
			total_paid, 
			CAST(null as float) as ingredient_cost, 
			CAST(null as float) as dispensing_fee, 
			CAST(null as float) as average_wholesale_price, 
			payer_plan_period_id, 
			CAST(null as integer) as revenue_code_concept_id, 
			CAST(null as integer) as revenue_code_source_value, 
			drug_cost_id as OCCURRENCE_ID
		FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE de
		join [SOURCE_CDMV4].[SCHEMA].DRUG_COST dc on de.drug_exposure_id = dc.drug_exposure_id
		--JOIN dbo.procedure_occurrence po on de.person_id = po.person_id and de.drug_exposure_id = po.origional_drug_id
		JOIN w3m16jd0po_map po on de.person_id = po.person_id and de.drug_exposure_id = po.origional_drug_id
	) OTHERS,(SELECT MAX(drug_cost_id) AS MAXROWID FROM [SOURCE_CDMV4].[SCHEMA].DRUG_COST) MAXROW 
;
 
/****

DRUG ERA
Note: Eras derived from DRUG_EXPOSURE table, using 30d gap

 ****/

-- drop table dbo.drug_era
INSERT INTO  [TARGET_CDMV5].[SCHEMA].drug_era
 WITH  cteDrugTarget (DRUG_EXPOSURE_ID, PERSON_ID, DRUG_CONCEPT_ID, DRUG_TYPE_CONCEPT_ID, DRUG_EXPOSURE_START_DATE, DRUG_EXPOSURE_END_DATE, INGREDIENT_CONCEPT_ID)  AS 
(
	-- Normalize DRUG_EXPOSURE_END_DATE to either the existing drug exposure end date, or add days supply, or add 1 day to the start date
	select d.DRUG_EXPOSURE_ID, d. PERSON_ID, c.CONCEPT_ID, d.DRUG_TYPE_CONCEPT_ID, DRUG_EXPOSURE_START_DATE, 
		COALESCE(DRUG_EXPOSURE_END_DATE, (DRUG_EXPOSURE_START_DATE + DAYS_SUPPLY), (DRUG_EXPOSURE_START_DATE + 1)) as DRUG_EXPOSURE_END_DATE,
		c.CONCEPT_ID as INGREDIENT_CONCEPT_ID
	FROM [TARGET_CDMV5].[SCHEMA].DRUG_EXPOSURE d
		join [TARGET_CDMV5].[SCHEMA].CONCEPT_ANCESTOR ca on ca.DESCENDANT_CONCEPT_ID = d.DRUG_CONCEPT_ID
		join [TARGET_CDMV5].[SCHEMA].CONCEPT c on ca.ANCESTOR_CONCEPT_ID = c.CONCEPT_ID
		where c.VOCABULARY_ID = 'RxNorm'
		and c.CONCEPT_CLASS_ID = 'Ingredient'
),
cteEndDates (PERSON_ID, INGREDIENT_CONCEPT_ID, END_DATE) as -- the magic
(
	select PERSON_ID, INGREDIENT_CONCEPT_ID, (EVENT_DATE + -30) as END_DATE -- unpad the end date
	FROM
	(
		select E1.PERSON_ID, E1.INGREDIENT_CONCEPT_ID, E1.EVENT_DATE, COALESCE(E1.START_ORDINAL,MAX(E2.START_ORDINAL)) START_ORDINAL, E1.OVERALL_ORD 
		FROM 
		(
			select PERSON_ID, INGREDIENT_CONCEPT_ID, EVENT_DATE, EVENT_TYPE, START_ORDINAL,
			ROW_NUMBER() OVER (PARTITION BY PERSON_ID, INGREDIENT_CONCEPT_ID ORDER BY EVENT_DATE, EVENT_TYPE) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
			from
			(
				-- select the start dates, assigning a row number to each
				Select PERSON_ID, INGREDIENT_CONCEPT_ID, DRUG_EXPOSURE_START_DATE AS EVENT_DATE, 0 as EVENT_TYPE, ROW_NUMBER() OVER (PARTITION BY PERSON_ID, INGREDIENT_CONCEPT_ID ORDER BY DRUG_EXPOSURE_START_DATE) as START_ORDINAL
				from cteDrugTarget
		
				UNION ALL
		
				-- add the end dates with NULL as the row number, padding the end dates by 30 to allow a grace period for overlapping ranges.
				select PERSON_ID, INGREDIENT_CONCEPT_ID, (DRUG_EXPOSURE_END_DATE + 30), 1 as EVENT_TYPE, NULL
				FROM cteDrugTarget
			) RAWDATA
		) E1
		JOIN (
			Select PERSON_ID, INGREDIENT_CONCEPT_ID, DRUG_EXPOSURE_START_DATE AS EVENT_DATE, ROW_NUMBER() OVER (PARTITION BY PERSON_ID, INGREDIENT_CONCEPT_ID ORDER BY DRUG_EXPOSURE_START_DATE) as START_ORDINAL
			from cteDrugTarget
		) E2 ON E1.PERSON_ID = E2.PERSON_ID AND E1.INGREDIENT_CONCEPT_ID = E2.INGREDIENT_CONCEPT_ID AND E2.EVENT_DATE < E1.EVENT_DATE
		GROUP BY E1.PERSON_ID, E1.INGREDIENT_CONCEPT_ID, E1.EVENT_DATE, E1.START_ORDINAL, E1.OVERALL_ORD
	) E
	WHERE 2 * E.START_ORDINAL - E.OVERALL_ORD = 0
),
cteDrugExposureEnds (PERSON_ID, DRUG_CONCEPT_ID, DRUG_TYPE_CONCEPT_ID, DRUG_EXPOSURE_START_DATE, DRUG_ERA_END_DATE) as
(
select 
	d.PERSON_ID, 
	d.INGREDIENT_CONCEPT_ID,
	d.DRUG_TYPE_CONCEPT_ID,
	d.DRUG_EXPOSURE_START_DATE, 
	MIN(e.END_DATE) as ERA_END_DATE
FROM cteDrugTarget d
JOIN cteEndDates e on d.PERSON_ID = e.PERSON_ID and d.INGREDIENT_CONCEPT_ID = e.INGREDIENT_CONCEPT_ID and e.END_DATE >= d.DRUG_EXPOSURE_START_DATE
GROUP BY d.PERSON_ID, 
	d.INGREDIENT_CONCEPT_ID, 
	d.DRUG_TYPE_CONCEPT_ID, 
	d.DRUG_EXPOSURE_START_DATE
)
 SELECT  row_number() over (order by person_id) as drug_era_id, person_id, drug_concept_id, min(DRUG_EXPOSURE_START_DATE) as drug_era_start_date, drug_era_end_date, COUNT(*) as DRUG_EXPOSURE_COUNT, 30 as gap_days
from cteDrugExposureEnds
GROUP BY person_id, drug_concept_id, drug_type_concept_id, DRUG_ERA_END_DATE
;

/****

CONDITION ERA
Note: Eras derived from CONDITION_OCCURRENCE table, using 30d gap

 ****/

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE  w3m16jd0condition_era_phase_1';
  EXECUTE IMMEDIATE 'DROP TABLE  w3m16jd0condition_era_phase_1';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

CREATE GLOBAL TEMPORARY TABLE w3m16jd0condition_era_phase_1
 ON COMMIT PRESERVE ROWS
AS
WITH  cteConditionTarget (PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE, CONDITION_END_DATE)  AS 
(
	-- create base eras from the concepts found in condition_occurrence
  select co.PERSON_ID, co.condition_concept_id, co.CONDITION_START_DATE,
        COALESCE(co.CONDITION_END_DATE, (CONDITION_START_DATE + 1)) as CONDITION_END_DATE
  FROM [TARGET_CDMV5].[SCHEMA].CONDITION_OCCURRENCE co
),
cteEndDates (PERSON_ID, CONDITION_CONCEPT_ID, END_DATE) as -- the magic
(
	select PERSON_ID, CONDITION_CONCEPT_ID, (EVENT_DATE + -30) as END_DATE -- unpad the end date
	FROM
	(
		select E1.PERSON_ID, E1.CONDITION_CONCEPT_ID, E1.EVENT_DATE, COALESCE(E1.START_ORDINAL,MAX(E2.START_ORDINAL)) START_ORDINAL, E1.OVERALL_ORD 
		FROM 
		(
			select PERSON_ID, CONDITION_CONCEPT_ID, EVENT_DATE, EVENT_TYPE, START_ORDINAL,
			ROW_NUMBER() OVER (PARTITION BY PERSON_ID, CONDITION_CONCEPT_ID ORDER BY EVENT_DATE, EVENT_TYPE) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
			from
			(
				-- select the start dates, assigning a row number to each
				Select PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE AS EVENT_DATE, -1 as EVENT_TYPE, ROW_NUMBER() OVER (PARTITION BY PERSON_ID, CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATE) as START_ORDINAL
				from cteConditionTarget
		
				UNION ALL
		
				-- pad the end dates by 30 to allow a grace period for overlapping ranges.
				select PERSON_ID, CONDITION_CONCEPT_ID, (CONDITION_END_DATE + 30), 1 as EVENT_TYPE, NULL
				FROM cteConditionTarget
			) RAWDATA
		) E1
		JOIN (
			Select PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE AS EVENT_DATE, ROW_NUMBER() OVER (PARTITION BY PERSON_ID, CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATE) as START_ORDINAL
			from cteConditionTarget
		) E2 ON E1.PERSON_ID = E2.PERSON_ID AND E1.CONDITION_CONCEPT_ID = E2.CONDITION_CONCEPT_ID AND E2.EVENT_DATE < E1.EVENT_DATE
		GROUP BY E1.PERSON_ID, E1.CONDITION_CONCEPT_ID, E1.EVENT_DATE, E1.START_ORDINAL, E1.OVERALL_ORD
	) E
	WHERE (2 * E.START_ORDINAL) - E.OVERALL_ORD = 0
),
cteConditionEnds (PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE, ERA_END_DATE) as
(
select 
	c.PERSON_ID, 
	c.CONDITION_CONCEPT_ID,
	c.CONDITION_START_DATE, 
	MIN(e.END_DATE) as ERA_END_DATE
FROM cteConditionTarget c
JOIN cteEndDates e on c.PERSON_ID = e.PERSON_ID and c.CONDITION_CONCEPT_ID = e.CONDITION_CONCEPT_ID and e.END_DATE >= c.CONDITION_START_DATE
GROUP BY 
	c.PERSON_ID, 
	c.CONDITION_CONCEPT_ID,
	c.CONDITION_START_DATE 
)
 SELECT
 row_number() over (order by person_id) as condition_era_id, person_id, CONDITION_CONCEPT_ID, min(CONDITION_START_DATE) as CONDITION_ERA_START_DATE, ERA_END_DATE as CONDITION_ERA_END_DATE, COUNT(*) as CONDITION_OCCURRENCE_COUNT

FROM
 cteConditionEnds
GROUP BY person_id, CONDITION_CONCEPT_ID, ERA_END_DATE
;

INSERT INTO [TARGET_CDMV5].[SCHEMA].condition_era
           (condition_era_id
           ,person_id
           ,condition_concept_id
           ,condition_era_start_date
           ,condition_era_end_date
           ,condition_occurrence_count)
SELECT
	condition_era_id,
	PERSON_ID,
	CONDITION_CONCEPT_ID,
	CONDITION_ERA_START_DATE,
	CONDITION_ERA_END_DATE,
	CONDITIOn_OCCURRENCE_COUNT
FROM w3m16jd0condition_era_phase_1


