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

last revised: 04 August 2015
authors:  Patrick Ryan, Chris Knoll, Anthony Sena

!!!!!!!!!!!!!!!!!!!!! PLEASE READ THESE INSTRUCTIONS !!!!!!!!!!!!!!!!!!!!!!!!!!!

This script was authored using OHDSI-SQL which will require you to run this
script through SqlRender to creat a version that is compatible with your target
RDBMS. We have pre-generated these scripts using SQL Render and have placed
them in folders for each RDBMS. Depending on which script you are viewing, your
instructions will be slightly different.

General Assumptions
-------------------

This script assumes that your V4 and V5 database are located on the same
RDBMS server. It also assumes that the V4 and V5 databases were created
using the standard data definition scripts for these databases. If you 
altered your V4 database in any way, this script will likely require
some mo

Getting Started
---------------

Before you can use this script, there are some prerequisites:

 1. Create a target CDMv5 database on your database server using the 
    appropriate script from https://github.com/OHDSI/CommonDataModel
 2. Load VocabV5 into the target database/schema that will contain CDMv5 using
    Athena: http://ohdsi.org/web/ATHENA

OHDSI-SQL File Instructions
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

USE [TARGET_CDMV5];

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
IF OBJECT_ID('tempdb..#concept_map', 'U') IS NOT NULL
	DROP TABLE #concept_map;

/* / */

SELECT concept_id AS source_concept_id
	,concept_id AS target_concept_id
	,domain_id AS domain_id
INTO #concept_map
FROM [TARGET_CDMV5].[SCHEMA].concept
WHERE 1 = 0;

/* / */

INSERT INTO #concept_map
--standard concepts
SELECT concept_id AS source_concept_id
	,concept_id AS target_concept_id
	,domain_id
FROM [TARGET_CDMV5].[SCHEMA].concept
WHERE standard_concept = 'S'
	AND invalid_reason IS NULL

UNION

--concepts with 'map to' standard
SELECT DISTINCT c1.concept_id AS source_concept_id
	,c2.concept_id AS target_concept_id
	,c2.domain_id
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

UNION

--concepts without 'map to' standard with another non 'is a' relation to standard
SELECT DISTINCT c1.concept_id AS source_concept_id
	,c2.concept_id AS target_concept_id
	,c2.domain_id
FROM (
	SELECT A.concept_id
	FROM [TARGET_CDMV5].[SCHEMA].concept A
	LEFT JOIN (
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
INNER JOIN [TARGET_CDMV5].[SCHEMA].concept_relationship cr1 ON c1.concept_id = cr1.concept_id_1
INNER JOIN [TARGET_CDMV5].[SCHEMA].concept c2 ON cr1.concept_id_2 = c2.concept_id
WHERE c2.standard_concept = 'S'
	AND c2.invalid_reason IS NULL
	AND cr1.relationship_id IN (
		'RxNorm replaced by'
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

UNION

--concepts without 'map to' standard with 'is a' relation to standard
SELECT DISTINCT c1.concept_id AS source_concept_id
	,c2.concept_id AS target_concept_id
	,c2.domain_id
FROM (
	SELECT A.concept_id
	FROM [TARGET_CDMV5].[SCHEMA].concept A
	LEFT JOIN (
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
WHERE c2.standard_concept = 'S'
	AND c2.invalid_reason IS NULL
	AND cr1.relationship_id IN ('Is a')
	AND cr1.invalid_reason IS NULL;

IF OBJECT_ID('tempdb..#concept_map_distinct', 'U') IS NOT NULL
	DROP TABLE #concept_map_distinct;

/* / */

SELECT source_concept_id
	,domain_id
	,COUNT(*) AS targetConceptCount
INTO #concept_map_distinct
FROM #concept_map
WHERE 1 = 0
GROUP BY source_concept_id
	,domain_id;

/* / */

INSERT INTO #concept_map_distinct
SELECT source_concept_id
	,domain_id
	,COUNT(*)
FROM #concept_map
GROUP BY source_concept_id
	,domain_id;

IF OBJECT_ID('[TARGET_CDMV5].[SCHEMA].ETL_WARNINGS', 'U') IS NOT NULL
	DROP TABLE [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS;

/* / */

CREATE TABLE [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE VARCHAR(4000));
/* / */

/****
 
CDM_SOURCE
 
 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].cdm_source (
	cdm_source_name
	,cdm_version
	,vocabulary_version
	,cdm_release_date
	)
SELECT '[TARGET_CDMV5]'
	,'V5'
	,v.vocabulary_version
	,getDate()
FROM [TARGET_CDMV5].[SCHEMA].vocabulary v
WHERE vocabulary_id = 'Vocabulary';

/****

LOCATION

 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].location
SELECT location_id
	,address_1
	,address_2
	,city
	,STATE
	,zip
	,county
	,location_source_value
FROM [SOURCE_CDMV4].[SCHEMA].LOCATION;

/****

CARE_SITE

 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].care_site
SELECT care_site_id
	,cast(NULL AS VARCHAR(255)) AS care_site_name
	,place_of_service_concept_id
	,location_id
	,care_site_source_value
	,place_of_service_source_value
FROM [SOURCE_CDMV4].[SCHEMA].CARE_SITE;

/****

Provider

****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].provider
SELECT provider_id
	,cast(NULL AS VARCHAR(255)) AS provider_name
	,NPI
	,DEA
	,specialty_concept_id
	,care_site_id
	,cast(NULL AS INT) AS year_of_birth
	,cast(NULL AS INT) AS gender_concept_id
	,provider_source_value
	,specialty_source_value
	,0 AS specialty_source_concept_id
	,cast(NULL AS VARCHAR(50)) AS gender_source_value
	,cast(NULL AS INT) AS gender_source_concept_id
FROM [SOURCE_CDMV4].[SCHEMA].provider;

/****
 
 PERSON
 
 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].person
SELECT person_id
	,coalesce(gender.target_concept_id, 0) AS gender_concept_id
	,year_of_birth
	,month_of_birth
	,day_of_birth
	,CAST(NULL AS VARCHAR(10)) time_of_birth
	,coalesce(race.target_concept_id, 0) AS race_concept_id
	,coalesce(ethnicity.target_concept_id, 0) AS ethnicity_concept_id
	,location_id
	,provider_id
	,care_site_id
	,person_source_value
	,gender_source_value
	,CAST(NULL AS INT) gender_source_concept_id
	,CAST(NULL AS INT) race_source_value
	,CAST(NULL AS INT) race_source_concept_id
	,ethnicity_source_value
	,CAST(NULL AS INT) ethnicity_source_concept_id
FROM [SOURCE_CDMV4].[SCHEMA].PERSON p
LEFT JOIN #concept_map gender ON LOWER(gender.DOMAIN_ID) IN ('gender')
	AND p.gender_concept_id = gender.source_concept_id
LEFT JOIN #concept_map race ON LOWER(race.DOMAIN_ID) IN ('race')
	AND p.race_concept_id = race.source_concept_id
LEFT JOIN #concept_map ethnicity ON LOWER(ethnicity.DOMAIN_ID) IN ('ethnicity')
	AND p.ETHNICITY_CONCEPT_ID = ethnicity.source_concept_id;

INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'PERSON: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid GENDER_CONCEPT_ID'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].PERSON
	WHERE GENDER_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR (
					STANDARD_CONCEPT = 'S'
					AND LOWER(DOMAIN_ID) IN ('gender')
					)
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'PERSON: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid RACE_CONCEPT_ID'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].PERSON
	WHERE RACE_CONCEPT_ID IS NOT NULL
		AND RACE_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR (
					STANDARD_CONCEPT = 'S'
					AND LOWER(DOMAIN_ID) IN ('race')
					)
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'PERSON: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid ETHNICITY_CONCEPT_ID'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].PERSON
	WHERE ETHNICITY_CONCEPT_ID IS NOT NULL
		AND ETHNICITY_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR (
					STANDARD_CONCEPT = 'S'
					AND LOWER(DOMAIN_ID) IN ('ethnicity')
					)
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

/****
 
 OBSERVATION_PERIOD
 
 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].observation_period
SELECT observation_period_id
	,person_id
	,observation_period_start_date
	,observation_period_end_date
	,44814722 AS period_type_concept_id
FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION_PERIOD;

/****
 
 DEATH
 
 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].death
SELECT person_id
	,death_date
	,COALESCE(death_type_concept_id, 0) AS death_type_concept_id
	,cause_of_death_concept_id AS cause_concept_id
	,cause_of_death_source_value AS cause_source_value
	,CAST(NULL AS INT) AS cause_source_concept_id
FROM [SOURCE_CDMV4].[SCHEMA].DEATH
LEFT JOIN #concept_map_distinct cm1 ON DEATH.DEATH_TYPE_CONCEPT_ID = CM1.SOURCE_CONCEPT_ID
	AND LOWER(DOMAIN_ID) IN ('death type');

INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'DEATH: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid DEATH_TYPE_CONCEPT_ID'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].DEATH
	WHERE DEATH_TYPE_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR (
					STANDARD_CONCEPT = 'S'
					AND LOWER(DOMAIN_ID) IN ('death type')
					)
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

/****
 
 VISIT_OCCURRENCE
 
 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].visit_occurrence
SELECT visit_occurrence_id
	,person_id
	,COALESCE(cm1.target_concept_id, 0) AS visit_concept_id
	,visit_start_date
	,CAST(NULL AS VARCHAR(10)) visit_start_time
	,visit_end_date
	,CAST(NULL AS VARCHAR(10)) visit_end_time
	,44818517 AS visit_type_concept_id
	,CAST(NULL AS INT) provider_id
	,care_site_id
	,place_of_service_source_value AS visit_source_value
	,CAST(NULL AS INT) visit_source_concept_id
FROM [SOURCE_CDMV4].[SCHEMA].VISIT_OCCURRENCE
LEFT JOIN #concept_map cm1 ON VISIT_OCCURRENCE.PLACE_OF_SERVICE_CONCEPT_ID = cm1.source_concept_id
	AND LOWER(cm1.domain_id) IN ('visit');

INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'VISIT_OCCURRENCE: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid VISIT_CONCEPT_ID (from the CDMv4 PLACE_OF_SERVICE_CONCEPT_ID field)'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].VISIT_OCCURRENCE
	WHERE PLACE_OF_SERVICE_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR (
					STANDARD_CONCEPT = 'S'
					AND LOWER(DOMAIN_ID) IN ('visit')
					)
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

/****
 
 PROCEDURE_OCCURRENCE
 
 ****/
IF OBJECT_ID('tempdb..#po_map', 'U') IS NOT NULL
	DROP TABLE #po_map;

/* / */

SELECT po.procedure_occurrence_id
	,po.person_id
	,po.procedure_concept_id
	,po.procedure_date
	,po.procedure_type_concept_id
	,po.modifier_concept_id
	,po.quantity
	,po.provider_id
	,po.visit_occurrence_id
	,po.procedure_source_value
	,po.procedure_source_concept_id
	,po.qualifier_source_value
	,de.drug_exposure_id AS origional_drug_id
INTO #po_map
FROM [TARGET_CDMV5].[SCHEMA].procedure_occurrence po
LEFT JOIN [TARGET_CDMV5].[SCHEMA].drug_exposure de ON 1 = 0
WHERE 0 = 1;

/* / */

--find valid procedures from procedure table
INSERT INTO #po_map
SELECT procedure_occurrence_id
	,person_id
	,COALESCE(cm1.target_concept_id, 0) AS procedure_concept_id
	,procedure_date
	,COALESCE(cm2.target_concept_id, 0) AS procedure_type_concept_id
	,CAST(NULL AS INT) AS modifier_concept_id
	,CAST(NULL AS INT) AS quantity
	,associated_provider_id AS provider_id
	,visit_occurrence_id
	,procedure_source_value
	,CAST(NULL AS INT) AS procedure_source_concept_id
	,NULL AS qualifier_source_value
	,CAST(NULL AS INT) AS origional_drug_id
FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
INNER JOIN #concept_map cm1 ON PROCEDURE_OCCURRENCE.PROCEDURE_CONCEPT_ID = cm1.source_concept_id
	AND LOWER(cm1.domain_id) IN ('procedure')
INNER JOIN #concept_map_distinct cmdis ON cm1.source_concept_id = cmdis.source_concept_id
	AND cm1.domain_id = cmdis.domain_id
	AND cmdis.targetConceptCount = 1
LEFT JOIN #concept_map cm2 ON PROCEDURE_OCCURRENCE.PROCEDURE_TYPE_CONCEPT_ID = cm2.source_concept_id
	AND LOWER(cm2.domain_id) IN ('procedure type')
LEFT JOIN #concept_map_distinct cmdis2 ON cm2.source_concept_id = cmdis2.source_concept_id
	AND cm2.domain_id = cmdis2.domain_id
	AND cmdis2.targetConceptCount = 1

UNION ALL

-- All procedures that did not map to a standard concept in V4 should also carry over to V5
SELECT procedure_occurrence_id
	,person_id
	,procedure_concept_id
	,procedure_date
	,procedure_type_concept_id
	,CAST(NULL AS INT) AS modifier_concept_id
	,CAST(NULL AS INT) AS quantity
	,associated_provider_id AS provider_id
	,visit_occurrence_id
	,procedure_source_value
	,CAST(NULL AS INT) procedure_source_concept_id
	,NULL qualifier_source_value
	,CAST(NULL AS INT) AS origional_drug_id
FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
WHERE procedure_concept_id = 0

UNION ALL

-- All PROCEDURE_OCCURRENCE that do not map to a standard concept in V5 should also carry over with procedure_concept_id = 0
SELECT procedure_occurrence_id
	,person_id
	,0 AS procedure_concept_id
	,procedure_date
	,COALESCE(cm2.target_concept_id, 0) AS procedure_type_concept_id
	,CAST(NULL AS INT) AS modifier_concept_id
	,CAST(NULL AS INT) AS quantity
	,associated_provider_id AS provider_id
	,visit_occurrence_id
	,procedure_source_value
	,CAST(NULL AS INT) procedure_source_concept_id
	,NULL qualifier_source_value
	,CAST(NULL AS INT) AS origional_drug_id
FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
LEFT JOIN #concept_map cm1 ON procedure_concept_id = cm1.source_concept_id
LEFT JOIN #concept_map cm2 ON procedure_concept_id = cm2.source_concept_id
	AND LOWER(cm2.domain_id) IN ('procedure type')
WHERE procedure_concept_id <> 0
	AND cm1.domain_id IS NULL

UNION ALL

SELECT CASE 
		WHEN MAXROW.MAXROWID IS NULL
			THEN 0
		ELSE MAXROW.MAXROWID
		END + row_number() OVER (
		ORDER BY OCCURRENCE_ID
		) AS procedure_occurrence_id
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
	,origional_drug_id
FROM (
	--find valid procedures from procedure table that map to more than 1
	--target concept in V5
	SELECT person_id
		,COALESCE(cm1.target_concept_id, 0) AS procedure_concept_id
		,procedure_date
		,COALESCE(cm2.target_concept_id, 0) AS procedure_type_concept_id
		,CAST(NULL AS INT) AS modifier_concept_id
		,CAST(NULL AS INT) AS quantity
		,associated_provider_id AS provider_id
		,visit_occurrence_id
		,procedure_source_value
		,CAST(NULL AS INT) procedure_source_concept_id
		,NULL qualifier_source_value
		,CAST(NULL AS INT) AS origional_drug_id
		,CAST(NULL AS INT) AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN #concept_map cm1 ON PROCEDURE_OCCURRENCE.PROCEDURE_CONCEPT_ID = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('procedure')
	INNER JOIN #concept_map_distinct cmdis ON cm1.source_concept_id = cmdis.source_concept_id
		AND cm1.domain_id = cmdis.domain_id
		AND cmdis.targetConceptCount > 1
	LEFT JOIN #concept_map cm2 ON PROCEDURE_OCCURRENCE.PROCEDURE_TYPE_CONCEPT_ID = cm2.source_concept_id
		AND LOWER(cm2.domain_id) IN ('procedure type')
	
	UNION ALL
	
	--find procedures that were previously classified as condition
	SELECT person_id
		,cm1.target_concept_id AS procedure_concept_id
		,condition_start_date AS procedure_date
		,0 AS procedure_type_concept_id
		,CAST(NULL AS INT) AS modifier_concept_id
		,CAST(NULL AS INT) AS quantity
		,associated_provider_id AS provider_id
		,visit_occurrence_id
		,condition_source_value AS procedure_source_value
		,CAST(NULL AS INT) AS procedure_source_concept_id
		,NULL AS qualifier_source_value
		,CAST(NULL AS INT) AS origional_drug_id
		,condition_occurrence_id AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	INNER JOIN #concept_map cm1 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('procedure')
	
	UNION ALL
	
	--find procedures that were previously classified as drug
	SELECT person_id
		,cm1.target_concept_id AS procedure_concept_id
		,drug_exposure_start_date AS procedure_date
		,0 AS procedure_type_concept_id
		,CAST(NULL AS INT) AS modifier_concept_id
		,CAST(NULL AS INT) AS quantity
		,prescribing_provider_id AS provider_id
		,visit_occurrence_id
		,drug_source_value AS procedure_source_value
		,CAST(NULL AS INT) AS procedure_source_concept_id
		,NULL AS qualifier_source_value
		,drug_exposure_id AS origional_drug_id
		,drug_exposure_id AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	INNER JOIN #concept_map cm1 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('procedure')
	--find procedures that were previously classified as observation
	
	UNION ALL
	
	SELECT person_id
		,cm1.target_concept_id AS procedure_concept_id
		,observation_date AS procedure_date
		,0 AS procedure_type_concept_id
		,CAST(NULL AS INT) AS modifier_concept_id
		,CAST(NULL AS INT) AS quantity
		,associated_provider_id AS provider_id
		,visit_occurrence_id
		,observation_source_value AS procedure_source_value
		,CAST(NULL AS INT) AS procedure_source_concept_id
		,NULL AS qualifier_source_value
		,CAST(NULL AS INT) AS origional_drug_id
		,OBSERVATION_ID AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
	INNER JOIN #concept_map cm1 ON observation.observation_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('procedure')
	) OTHERS
	,(
		SELECT MAX(PROCEDURE_OCCURRENCE_ID) AS MAXROWID
		FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
		) MAXROW;

INSERT INTO [TARGET_CDMV5].[SCHEMA].procedure_occurrence (
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
	)
SELECT procedure_occurrence_id
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
FROM #po_map;

--warnings of invalid records
INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'PROCEDURE_OCCURRENCE: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid PROCOEDURE_CONCEPT_ID'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	WHERE PROCEDURE_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR STANDARD_CONCEPT = 'S'
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'PROCEDURE_OCCURRENCE: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid PROCOEDURE_TYPE_CONCEPT_ID'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	WHERE PROCEDURE_TYPE_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR (
					STANDARD_CONCEPT = 'S'
					AND LOWER(DOMAIN_ID) IN ('procedure type')
					)
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

/****
 
 DRUG_EXPOSURE
 
 ****/
--find valid drugs from drug_exposure table
IF OBJECT_ID('tempdb..#drgexp_map', 'U') IS NOT NULL
	DROP TABLE #drgexp_map;

/* / */

SELECT de.drug_exposure_id
	,de.person_id
	,de.drug_concept_id
	,de.drug_exposure_start_date
	,de.drug_exposure_end_date
	,de.drug_type_concept_id
	,de.stop_reason
	,de.refills
	,de.quantity
	,de.days_supply
	,de.sig
	,de.route_concept_id
	,de.effective_drug_dose
	,de.dose_unit_concept_id
	,de.lot_number
	,de.provider_id
	,de.visit_occurrence_id
	,de.drug_source_value
	,de.drug_source_concept_id
	,de.route_source_value
	,de.dose_unit_source_value
	,po.procedure_occurrence_id AS origional_procedure_id
INTO #drgexp_map
FROM [TARGET_CDMV5].[SCHEMA].drug_exposure de
LEFT JOIN [TARGET_CDMV5].[SCHEMA].procedure_occurrence po ON 1 = 0
WHERE 0 = 1;

/* / */

INSERT INTO #drgexp_map
SELECT drug_exposure_id
	,person_id
	,COALESCE(cm1.target_concept_id, 0) AS drug_concept_id
	,drug_exposure_start_date
	,drug_exposure_end_date
	,COALESCE(cm2.target_concept_id, 0) drug_type_concept_id
	,stop_reason
	,refills
	,quantity
	,days_supply
	,sig
	,CAST(NULL AS INT) AS route_concept_id
	,CAST(NULL AS FLOAT) AS effective_drug_dose
	,CAST(NULL AS INT) AS dose_unit_concept_id
	,NULL AS lot_number
	,prescribing_provider_id AS provider_id
	,visit_occurrence_id
	,drug_source_value
	,CAST(NULL AS INT) AS drug_source_concept_id
	,NULL AS route_source_value
	,NULL AS dose_unit_source_value
	,CAST(NULL AS INT) AS origional_procedure_id
FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
INNER JOIN #concept_map cm1 ON drug_exposure.drug_concept_id = cm1.source_concept_id
	AND LOWER(cm1.domain_id) IN ('drug')
INNER JOIN #concept_map_distinct cmdis ON cm1.source_concept_id = cmdis.source_concept_id
	AND cm1.domain_id = cmdis.domain_id
	AND cmdis.targetConceptCount = 1
LEFT JOIN #concept_map cm2 ON drug_exposure.drug_type_concept_id = cm2.source_concept_id
	AND LOWER(cm2.domain_id) IN ('drug type')
INNER JOIN #concept_map_distinct cmdis2 ON cm2.source_concept_id = cmdis2.source_concept_id
	AND cm2.domain_id = cmdis2.domain_id
	AND cmdis2.targetConceptCount = 1
WHERE drug_concept_id > 0 -- This condition will map those concepts that were mapped to valid concepts in V4

UNION ALL

-- All drug exposures that did not map to a standard concept in V4 should also carry over to V5
SELECT drug_exposure_id
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
	,CAST(NULL AS INT) AS route_concept_id
	,CAST(NULL AS FLOAT) AS effective_drug_dose
	,CAST(NULL AS INT) AS dose_unit_concept_id
	,NULL AS lot_number
	,prescribing_provider_id AS provider_id
	,visit_occurrence_id
	,drug_source_value
	,CAST(NULL AS INT) AS drug_source_concept_id
	,NULL AS route_source_value
	,NULL AS dose_unit_source_value
	,CAST(NULL AS INT) AS origional_procedure_id
FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
WHERE drug_concept_id = 0

UNION ALL

-- All drug exposures that do not map to a standard concept in V5 should also carry over with condition_concept_id = 0
SELECT drug_exposure_id
	,person_id
	,0
	,drug_exposure_start_date
	,drug_exposure_end_date
	,COALESCE(cm2.target_concept_id, 0) drug_type_concept_id
	,stop_reason
	,refills
	,quantity
	,days_supply
	,sig
	,CAST(NULL AS INT) AS route_concept_id
	,CAST(NULL AS FLOAT) AS effective_drug_dose
	,CAST(NULL AS INT) AS dose_unit_concept_id
	,NULL AS lot_number
	,prescribing_provider_id AS provider_id
	,visit_occurrence_id
	,drug_source_value
	,CAST(NULL AS INT) AS drug_source_concept_id
	,NULL AS route_source_value
	,NULL AS dose_unit_source_value
	,CAST(NULL AS INT) AS origional_procedure_id
FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
LEFT JOIN #concept_map cm1 ON drug_concept_id = cm1.source_concept_id
LEFT JOIN #concept_map cm2 ON drug_exposure.drug_type_concept_id = cm2.source_concept_id
	AND LOWER(cm2.domain_id) IN ('drug type')
WHERE drug_concept_id <> 0
	AND cm1.domain_id IS NULL

UNION ALL

SELECT CASE 
		WHEN MAXROW.MAXROWID IS NULL
			THEN 0
		ELSE MAXROW.MAXROWID
		END + row_number() OVER (
		ORDER BY OCCURRENCE_ID
		) AS drug_exposure_id
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
	,origional_procedure_id
FROM (
	--find valid drugs from drug_exposure table that map to > 1 target concept
	SELECT person_id
		,COALESCE(cm1.target_concept_id, 0) AS drug_concept_id
		,drug_exposure_start_date
		,drug_exposure_end_date
		,COALESCE(cm2.target_concept_id, 0) drug_type_concept_id
		,stop_reason
		,refills
		,quantity
		,days_supply
		,sig
		,CAST(NULL AS INT) AS route_concept_id
		,CAST(NULL AS FLOAT) AS effective_drug_dose
		,CAST(NULL AS INT) AS dose_unit_concept_id
		,NULL AS lot_number
		,prescribing_provider_id AS provider_id
		,visit_occurrence_id
		,drug_source_value
		,CAST(NULL AS INT) AS drug_source_concept_id
		,NULL AS route_source_value
		,NULL AS dose_unit_source_value
		,CAST(NULL AS INT) AS origional_procedure_id
		,CAST(NULL AS INT) AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	INNER JOIN #concept_map cm1 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('drug')
	INNER JOIN #concept_map_distinct cmdis ON cm1.source_concept_id = cmdis.source_concept_id
		AND cm1.domain_id = cmdis.domain_id
		AND cmdis.targetConceptCount > 1
	LEFT JOIN #concept_map cm2 ON drug_exposure.drug_type_concept_id = cm2.source_concept_id
		AND LOWER(cm2.domain_id) IN ('drug type')
	
	UNION ALL
	
	--find drugs that were previously classified as condition
	SELECT person_id
		,cm1.target_concept_id AS drug_concept_id
		,condition_start_date AS drug_exposure_start_date
		,NULL AS drug_exposure_end_date
		,0 AS drug_type_concept_id
		,NULL AS stop_reason
		,CAST(NULL AS INT) AS refills
		,CAST(NULL AS FLOAT) AS quantity
		,CAST(NULL AS INT) AS days_supply
		,NULL AS sig
		,CAST(NULL AS INT) AS route_concept_id
		,CAST(NULL AS FLOAT) AS effective_drug_dose
		,CAST(NULL AS INT) AS dose_unit_concept_id
		,NULL AS lot_number
		,CAST(NULL AS INT) AS provider_id
		,visit_occurrence_id
		,condition_source_value AS drug_source_value
		,CAST(NULL AS INT) AS drug_source_concept_id
		,NULL AS route_source_value
		,NULL AS dose_unit_source_value
		,CAST(NULL AS INT) AS origional_procedure_id
		,condition_occurrence_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	INNER JOIN #concept_map cm1 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('drug')
	--find drugs that were previously classified as procedure
	
	UNION ALL
	
	SELECT person_id
		,cm1.target_concept_id AS drug_concept_id
		,procedure_date AS drug_exposure_start_date
		,CAST(NULL AS DATE) AS drug_exposure_end_date
		,0 AS drug_type_concept_id
		,NULL AS stop_reason
		,CAST(NULL AS INT) AS refills
		,CAST(NULL AS FLOAT) AS quantity
		,CAST(NULL AS INT) AS days_supply
		,NULL AS sig
		,CAST(NULL AS INT) AS route_concept_id
		,CAST(NULL AS FLOAT) AS effective_drug_dose
		,CAST(NULL AS INT) AS dose_unit_concept_id
		,NULL AS lot_number
		,CAST(NULL AS INT) AS provider_id
		,visit_occurrence_id
		,procedure_source_value AS drug_source_value
		,CAST(NULL AS INT) AS drug_source_concept_id
		,NULL AS route_source_value
		,NULL AS dose_unit_source_value
		,procedure_occurrence_id AS origional_procedure_id
		,procedure_occurrence_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN #concept_map cm1 ON procedure_occurrence.procedure_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('drug')
	--find drugs that were previously classified as observation
	
	UNION ALL
	
	SELECT person_id
		,cm1.target_concept_id AS drug_concept_id
		,observation_date AS drug_exposure_start_date
		,CAST(NULL AS DATE) AS drug_exposure_end_date
		,0 AS drug_type_concept_id
		,NULL AS stop_reason
		,CAST(NULL AS INT) AS refills
		,CAST(NULL AS FLOAT) AS quantity
		,CAST(NULL AS INT) AS days_supply
		,NULL AS sig
		,CAST(NULL AS INT) AS route_concept_id
		,CAST(NULL AS FLOAT) AS effective_drug_dose
		,CAST(NULL AS INT) AS dose_unit_concept_id
		,NULL AS lot_number
		,CAST(NULL AS INT) AS provider_id
		,visit_occurrence_id
		,observation_source_value AS drug_source_value
		,CAST(NULL AS INT) AS drug_source_concept_id
		,NULL AS route_source_value
		,NULL AS dose_unit_source_value
		,CAST(NULL AS INT) AS origional_procedure_id
		,observation_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
	INNER JOIN #concept_map cm1 ON observation.observation_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('drug')
	) OTHERS
	,(
		SELECT MAX(DRUG_EXPOSURE_ID) AS MAXROWID
		FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
		) MAXROW;

INSERT INTO [TARGET_CDMV5].[SCHEMA].drug_exposure (
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
	)
SELECT drug_exposure_id
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
FROM #drgexp_map;

--warnings of invalid records
INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'DRUG_EXPOSURE: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid DRUG_CONCEPT_ID'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	WHERE DRUG_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR STANDARD_CONCEPT = 'S'
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'DRUG_EXPOSURE: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid DRUG_TYPE_CONCEPT_ID'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	WHERE DRUG_TYPE_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR (
					STANDARD_CONCEPT = 'S'
					AND LOWER(DOMAIN_ID) IN ('drug type')
					)
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

/****
 
 CONDITION_OCCURRENCE
 
 ****/
--find valid conditions from condition_occurrence table
INSERT INTO [TARGET_CDMV5].[SCHEMA].condition_occurrence
SELECT condition_occurrence_id
	,person_id
	,COALESCE(cm1.target_concept_id, 0) AS condition_concept_id
	,condition_start_date
	,condition_end_date
	,COALESCE(cm2.target_concept_id, 0) AS condition_type_concept_id
	,stop_reason
	,associated_provider_id AS provider_id
	,visit_occurrence_id
	,condition_source_value
	,CAST(NULL AS INT) condition_source_concept_id
FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
INNER JOIN #concept_map cm1 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
	AND LOWER(cm1.domain_id) IN ('condition')
INNER JOIN #concept_map_distinct cmdis ON cm1.source_concept_id = cmdis.source_concept_id
	AND cm1.domain_id = cmdis.domain_id
	AND cmdis.targetConceptCount = 1
LEFT JOIN #concept_map cm2 ON condition_occurrence.condition_type_concept_id = cm2.source_concept_id
	AND LOWER(cm2.domain_id) IN ('condition type')
WHERE condition_concept_id > 0 -- This condition will map those concepts that were mapped to valid concepts in V4

UNION ALL

-- All conditions that did not map to a standard concept in V4 should also carry over to V5
SELECT condition_occurrence_id
	,person_id
	,condition_concept_id
	,condition_start_date
	,condition_end_date
	,COALESCE(condition_type_concept_id, 0) AS condition_type_concept_id
	,stop_reason
	,associated_provider_id AS provider_id
	,visit_occurrence_id
	,condition_source_value
	,CAST(NULL AS INT) condition_source_concept_id
FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
WHERE condition_concept_id = 0

UNION ALL

-- All conditions that do not map to a standard concept in V5 should also carry over with condition_concept_id = 0
SELECT condition_occurrence_id
	,person_id
	,0 AS condition_concept_id
	,condition_start_date
	,condition_end_date
	,COALESCE(cm2.target_concept_id, 0) AS condition_type_concept_id
	,stop_reason
	,associated_provider_id AS provider_id
	,visit_occurrence_id
	,condition_source_value
	,CAST(NULL AS INT) condition_source_concept_id
FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
LEFT JOIN #concept_map cm1 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
LEFT JOIN #concept_map cm2 ON condition_occurrence.condition_type_concept_id = cm2.source_concept_id
	AND LOWER(cm2.domain_id) IN ('condition type')
WHERE condition_concept_id <> 0
	AND cm1.domain_id IS NULL

UNION ALL

SELECT CASE 
		WHEN MAXROW.MAXROWID IS NULL
			THEN 0
		ELSE MAXROW.MAXROWID
		END + row_number() OVER (
		ORDER BY OCCURRENCE_ID
		) AS drug_exposure_id
	,person_id
	,condition_concept_id
	,condition_start_date
	,condition_end_date
	,condition_type_concept_id
	,stop_reason
	,provider_id
	,visit_occurrence_id
	,condition_source_value
	,condition_source_concept_id
FROM (
	--find valid conditions from condition_occurrence table that map to > 1 target concept
	SELECT person_id
		,COALESCE(cm1.target_concept_id, 0) AS condition_concept_id
		,condition_start_date
		,condition_end_date
		,COALESCE(cm2.target_concept_id, 0) AS condition_type_concept_id
		,stop_reason
		,associated_provider_id AS provider_id
		,visit_occurrence_id
		,condition_source_value
		,CAST(NULL AS INT) condition_source_concept_id
		,NULL AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	INNER JOIN #concept_map cm1 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('condition')
	INNER JOIN #concept_map_distinct cmdis ON cm1.source_concept_id = cmdis.source_concept_id
		AND cm1.domain_id = cmdis.domain_id
		AND cmdis.targetConceptCount > 1
	LEFT JOIN #concept_map cm2 ON condition_occurrence.condition_type_concept_id = cm2.source_concept_id
		AND LOWER(cm2.domain_id) IN ('condition type')
	WHERE condition_concept_id > 0 -- This condition will map those concepts that were mapped to valid concepts in V4
	
	UNION ALL
	
	--find conditions that were previously classified as procedure
	SELECT person_id
		,cm1.target_concept_id AS condition_concept_id
		,procedure_date AS condition_start_date
		,NULL AS condition_end_date
		,0 AS condition_type_concept_id
		,NULL AS stop_reason
		,associated_provider_id AS provider_id
		,visit_occurrence_id
		,procedure_source_value AS condition_source_value
		,CAST(NULL AS INT) condition_source_concept_id
		,procedure_occurrence_id AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN #concept_map cm1 ON procedure_occurrence.procedure_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('condition')
	--find conditions that were previously classified as drug
	
	UNION ALL
	
	SELECT person_id
		,cm1.target_concept_id AS condition_concept_id
		,drug_exposure_start_date AS condition_start_date
		,NULL AS condition_end_date
		,0 AS condition_type_concept_id
		,NULL AS stop_reason
		,prescribing_provider_id AS provider_id
		,visit_occurrence_id
		,drug_source_value AS condition_source_value
		,CAST(NULL AS INT) condition_source_concept_id
		,drug_exposure_id AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	INNER JOIN #concept_map cm1 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('condition')
	--find conditions that were previously classified as observation
	
	UNION ALL
	
	SELECT person_id
		,cm1.target_concept_id AS condition_concept_id
		,observation_date AS condition_start_date
		,NULL AS condition_end_date
		,0 AS condition_type_concept_id
		,NULL AS stop_reason
		,associated_provider_id AS provider_id
		,visit_occurrence_id
		,observation_source_value AS condition_source_value
		,CAST(NULL AS INT) condition_source_concept_id
		,observation_id AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
	INNER JOIN #concept_map cm1 ON observation.observation_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('condition')
	) OTHERS
	,(
		SELECT MAX(condition_occurrence_id) AS MAXROWID
		FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
		) MAXROW;

--warnings of invalid records
INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'CONDITION_OCCURRENCE: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid CONDITION_CONCEPT_ID'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	WHERE CONDITION_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR STANDARD_CONCEPT = 'S'
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

INSERT INTO [TARGET_CDMV5].[SCHEMA].ETL_WARNINGS (WARNING_MESSAGE)
SELECT 'CONDIITON_OCCURRENCE: ' + CAST(NUM_INVALID_RECORDS AS VARCHAR) + ' records in the source CDMv4 database have invalid CONDITION_TYPE_CONCEPT_ID'
FROM (
	SELECT COUNT(PERSON_ID) AS NUM_INVALID_RECORDS
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	WHERE CONDITION_TYPE_CONCEPT_ID NOT IN (
			SELECT CONCEPT_ID
			FROM [TARGET_CDMV5].[SCHEMA].CONCEPT
			WHERE CONCEPT_ID = 0
				OR (
					STANDARD_CONCEPT = 'S'
					AND LOWER(DOMAIN_ID) IN ('condition type')
					)
			)
	HAVING COUNT(PERSON_ID) > 0
	) warn;

/****
 
 DEVICE_EXPOSURE
 
 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].device_exposure
SELECT row_number() OVER (
		ORDER BY OCCURRENCE_ID
		) AS device_exposure_id
	,person_id
	,device_concept_id
	,device_exposure_start_date
	,device_exposure_end_date
	,device_type_concept_id
	,unique_device_id
	,quantity
	,provider_id
	,visit_occurrence_id
	,device_source_value
	,device_source_concept_id
FROM (
	--find devices that were previously classified as procedures
	SELECT PERSON_ID
		,cm1.target_concept_id AS DEVICE_CONCEPT_ID
		,PROCEDURE_DATE AS DEVICE_EXPOSURE_START_DATE
		,CAST(NULL AS DATE) AS DEVICE_EXPOSURE_END_DATE
		,0 AS DEVICE_TYPE_CONCEPT_ID
		,CAST(NULL AS VARCHAR(50)) unique_device_id
		,CAST(NULL AS INT) quantity
		,ASSOCIATED_PROVIDER_ID AS PROVIDER_ID
		,VISIT_OCCURRENCE_ID
		,PROCEDURE_SOURCE_VALUE AS DEVICE_SOURCE_VALUE
		,0 AS device_source_concept_id
		,PROCEDURE_OCCURRENCE_ID AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN #concept_map cm1 ON procedure_occurrence.procedure_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('device')
	--find devices that were previously classified as drug exposure
	
	UNION ALL
	
	SELECT PERSON_ID
		,cm1.target_concept_id AS DEVICE_CONCEPT_ID
		,DRUG_EXPOSURE_START_DATE AS DEVICE_EXPOSURE_START_DATE
		,CAST(NULL AS DATE) AS DEVICE_EXPOSURE_END_DATE
		,0 AS DEVICE_TYPE_CONCEPT_ID
		,CAST(NULL AS VARCHAR(50)) unique_device_id
		,quantity
		,PRESCRIBING_PROVIDER_ID AS PROVIDER_ID
		,VISIT_OCCURRENCE_ID
		,DRUG_SOURCE_VALUE AS DEVICE_SOURCE_VALUE
		,0 AS device_source_concept_id
		,DRUG_EXPOSURE_ID AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	INNER JOIN #concept_map cm1 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('device')
	--find devices that were previously classified as conditions
	
	UNION ALL
	
	SELECT PERSON_ID
		,cm1.target_concept_id AS DEVICE_CONCEPT_ID
		,CONDITION_START_DATE AS DEVICE_EXPOSURE_START_DATE
		,CAST(NULL AS DATE) AS DEVICE_EXPOSURE_END_DATE
		,0 AS DEVICE_TYPE_CONCEPT_ID
		,CAST(NULL AS VARCHAR(50)) unique_device_id
		,CAST(NULL AS INT) quantity
		,ASSOCIATED_PROVIDER_ID AS PROVIDER_ID
		,VISIT_OCCURRENCE_ID
		,CONDITION_SOURCE_VALUE AS DEVICE_SOURCE_VALUE
		,0 AS device_source_concept_id
		,CONDITION_OCCURRENCE_ID AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	INNER JOIN #concept_map cm1 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('device')
	--find devices that were previously classified as observations
	
	UNION ALL
	
	SELECT PERSON_ID
		,cm1.target_concept_id AS DEVICE_CONCEPT_ID
		,OBSERVATION_DATE AS DEVICE_EXPOSURE_START_DATE
		,CAST(NULL AS DATE) AS DEVICE_EXPOSURE_END_DATE
		,0 AS DEVICE_TYPE_CONCEPT_ID
		,CAST(NULL AS VARCHAR(50)) unique_device_id
		,CAST(NULL AS INT) quantity
		,ASSOCIATED_PROVIDER_ID AS PROVIDER_ID
		,VISIT_OCCURRENCE_ID
		,OBSERVATION_SOURCE_VALUE AS DEVICE_SOURCE_VALUE
		,0 AS device_source_concept_id
		,OBSERVATION_ID AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
	INNER JOIN #concept_map cm1 ON observation.observation_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('device')
	) OTHERS;

/****
 
 MEASUREMENT
 
 ****/
--find valid measurements from observation table
INSERT INTO [TARGET_CDMV5].[SCHEMA].measurement
SELECT row_number() OVER (
		ORDER BY occurrence_id
		) AS measurement_id
	,person_id
	,measurement_concept_id
	,measurement_date
	,measurement_time
	,measurement_type_concept_id
	,operator_concept_id
	,value_as_number
	,value_as_concept_id
	,unit_concept_id
	,range_low
	,range_high
	,provider_id
	,visit_occurrence_id
	,measurement_source_value
	,measurement_source_concept_id
	,unit_source_value
	,value_source_value
FROM (
	--find mesaurements that were previously classified as observations
	SELECT person_id
		,cm1.target_concept_id AS measurement_concept_id
		,OBSERVATION_DATE AS measurement_date
		,CAST(OBSERVATION_TIME AS VARCHAR(50)) AS measurement_time
		,0 AS measurement_type_concept_id
		,CAST(NULL AS INT) operator_concept_id
		,value_as_number
		,value_as_concept_id
		,COALESCE(cm2.target_concept_id, 0) AS unit_concept_id
		,range_low
		,range_high
		,ASSOCIATED_PROVIDER_ID AS provider_id
		,visit_occurrence_id
		,OBSERVATION_SOURCE_VALUE AS measurement_source_value
		,CAST(NULL AS INT) measurement_source_concept_id
		,unit_source_value AS unit_source_value
		,cast(NULL AS VARCHAR(50)) AS value_source_value
		,observation_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
	INNER JOIN #concept_map cm1 ON observation.observation_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('measurement')
	LEFT JOIN #concept_map cm2 ON observation.unit_concept_id = cm2.source_concept_id
		AND LOWER(cm2.domain_id) IN ('unit')
	
	UNION ALL
	
	SELECT person_id
		,cm1.target_concept_id AS measurement_concept_id
		,procedure_date AS measurement_date
		,CAST(NULL AS VARCHAR(50)) AS measurement_time
		,0 AS measurement_type_concept_id
		,CAST(NULL AS INT) AS operator_concept_id
		,CAST(NULL AS INT) AS value_as_number
		,CAST(NULL AS INT) AS value_as_concept_id
		,CAST(NULL AS INT) AS unit_concept_id
		,CAST(NULL AS INT) AS range_low
		,CAST(NULL AS INT) AS range_high
		,associated_provider_id AS provider_id
		,visit_occurrence_id
		,procedure_source_value AS measurement_source_value
		,CAST(NULL AS INT) AS measurement_source_concept_id
		,CAST(NULL AS VARCHAR(50)) AS unit_source_value
		,CAST(NULL AS VARCHAR(50)) AS value_source_value
		,procedure_occurrence_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN #concept_map cm1 ON procedure_occurrence.procedure_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('measurement')
	
	UNION ALL
	
	SELECT person_id
		,cm1.target_concept_id AS measurement_concept_id
		,condition_start_date AS measurement_date
		,CAST(NULL AS VARCHAR(50)) AS measurement_time
		,0 AS measurement_type_concept_id
		,CAST(NULL AS INT) AS operator_concept_id
		,CAST(NULL AS INT) AS value_as_number
		,CAST(NULL AS INT) AS value_as_concept_id
		,CAST(NULL AS INT) AS unit_concept_id
		,CAST(NULL AS INT) AS range_low
		,CAST(NULL AS INT) AS range_high
		,associated_provider_id AS provider_id
		,visit_occurrence_id
		,condition_source_value AS measurement_source_value
		,CAST(NULL AS INT) AS measurement_source_concept_id
		,CAST(NULL AS VARCHAR(50)) AS unit_source_value
		,CAST(NULL AS VARCHAR(50)) AS value_source_value
		,condition_occurrence_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	INNER JOIN #concept_map cm1 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('measurement')
	
	UNION ALL
	
	SELECT person_id
		,cm1.target_concept_id AS measurement_concept_id
		,drug_exposure_start_date AS measurement_date
		,CAST(NULL AS VARCHAR(50)) AS measurement_time
		,0 AS measurement_type_concept_id
		,CAST(NULL AS INT) AS operator_concept_id
		,CAST(NULL AS INT) AS value_as_number
		,CAST(NULL AS INT) AS value_as_concept_id
		,CAST(NULL AS INT) AS unit_concept_id
		,CAST(NULL AS INT) AS range_low
		,CAST(NULL AS INT) AS range_high
		,prescribing_provider_id AS provider_id
		,visit_occurrence_id
		,drug_source_value AS measurement_source_value
		,CAST(NULL AS INT) AS measurement_source_concept_id
		,CAST(NULL AS VARCHAR(50)) AS unit_source_value
		,CAST(NULL AS VARCHAR(50)) AS value_source_value
		,drug_exposure_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].drug_exposure
	INNER JOIN #concept_map cm1 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('measurement')
	) OTHERS;

/****
 
 OBSERVATION
 
 ****/
--find valid observation from observation table
INSERT INTO [TARGET_CDMV5].[SCHEMA].observation
SELECT observation_id
	,person_id
	,observation_concept_id
	,observation_date
	,CAST(observation_time AS VARCHAR(50)) AS observation_time
	,observation_type_concept_id
	,value_as_number
	,value_as_string
	,value_as_concept_id
	,CAST(NULL AS INT) qualifier_concept_id
	,unit_concept_id
	,associated_provider_id AS provider_id
	,visit_occurrence_id
	,observation_source_value
	,CAST(NULL AS INT) observation_source_concept_id
	,unit_source_value
	,cast(NULL AS VARCHAR(50)) qualifier_source_value
FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
WHERE observation_concept_id NOT IN (
		SELECT source_concept_id
		FROM #concept_map_distinct
		WHERE LOWER(domain_id) IN (
				'condition'
				,'drug'
				,'procedure'
				,'device'
				,'measurement'
				)
		)
--find observations that were previously classified as procedure

UNION ALL

SELECT CASE 
		WHEN MAXROW.MAXROWID IS NULL
			THEN 0
		ELSE MAXROW.MAXROWID
		END + row_number() OVER (
		ORDER BY OCCURRENCE_ID
		) AS observation_id
	,person_id
	,observation_concept_id
	,observation_date
	,observation_time
	,observation_type_concept_id
	,value_as_number
	,value_as_string
	,value_as_concept_id
	,qualifier_concept_id
	,unit_concept_id
	,provider_id
	,visit_occurrence_id
	,observation_source_value
	,observation_source_concept_id
	,unit_source_value
	,qualifier_source_value
FROM (
	SELECT person_id
		,cm1.target_concept_id AS observation_concept_id
		,procedure_date AS observation_date
		,CAST(NULL AS VARCHAR(50)) AS observation_time
		,0 AS observation_type_concept_id
		,CAST(NULL AS FLOAT) AS value_as_number
		,NULL AS value_as_string
		,CAST(NULL AS INT) AS value_as_concept_id
		,CAST(NULL AS INT) qualifier_concept_id
		,CAST(NULL AS INT) AS unit_concept_id
		,associated_provider_id AS provider_id
		,visit_occurrence_id
		,procedure_source_value AS observation_source_value
		,CAST(NULL AS INT) observation_source_concept_id
		,NULL AS unit_source_value
		,cast(NULL AS VARCHAR(50)) qualifier_source_value
		,procedure_occurrence_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE
	INNER JOIN #concept_map cm1 ON procedure_occurrence.procedure_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('observation')
	--find observations that were previously classified as condition
	
	UNION ALL
	
	SELECT person_id
		,cm1.target_concept_id AS observation_concept_id
		,condition_start_date AS observation_date
		,CAST(NULL AS VARCHAR(50)) AS observation_time
		,0 AS observation_type_concept_id
		,CAST(NULL AS FLOAT) AS value_as_number
		,NULL AS value_as_string
		,CAST(NULL AS INT) AS value_as_concept_id
		,CAST(NULL AS INT) qualifier_concept_id
		,CAST(NULL AS INT) AS unit_concept_id
		,associated_provider_id AS provider_id
		,visit_occurrence_id
		,condition_source_value AS observation_source_value
		,CAST(NULL AS INT) observation_source_concept_id
		,NULL AS unit_source_value
		,cast(NULL AS VARCHAR(50)) qualifier_source_value
		,condition_occurrence_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].CONDITION_OCCURRENCE
	INNER JOIN #concept_map cm1 ON condition_occurrence.condition_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('observation')

	UNION ALL

	--find DRG observations that were previously classified as procedure_cost
	SELECT po.person_id
		,cm1.target_concept_id AS observation_concept_id
		,po.procedure_date AS observation_date
		,CAST(NULL AS VARCHAR(50)) AS observation_time
		,0 AS observation_type_concept_id
		,CAST(NULL AS FLOAT) AS value_as_number
		,NULL AS value_as_string
		,CAST(NULL AS INT) AS value_as_concept_id
		,CAST(NULL AS INT) qualifier_concept_id
		,CAST(NULL AS INT) AS unit_concept_id
		,po.associated_provider_id AS provider_id
		,po.visit_occurrence_id
		,pc.DISEASE_CLASS_SOURCE_VALUE AS observation_source_value
		,cm1.source_concept_id as observation_source_concept_id
		,NULL AS unit_source_value
		,cast(NULL AS VARCHAR(50)) qualifier_source_value
		,po.procedure_occurrence_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_COST pc
	INNER JOIN [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE po ON pc.PROCEDURE_OCCURRENCE_ID = po.PROCEDURE_OCCURRENCE_ID
	INNER JOIN #concept_map cm1 ON pc.disease_class_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('observation')
	
	UNION ALL
	
	--find observations that were previously classified as drug exposure
	SELECT person_id
		,cm1.target_concept_id AS observation_concept_id
		,drug_exposure_start_date AS observation_date
		,CAST(NULL AS VARCHAR(10)) AS observation_time
		,0 AS observation_type_concept_id
		,CAST(NULL AS FLOAT) AS value_as_number
		,NULL AS value_as_string
		,CAST(NULL AS INT) AS value_as_concept_id
		,CAST(NULL AS INT) qualifier_concept_id
		,CAST(NULL AS INT) AS unit_concept_id
		,CAST(NULL AS INT) AS provider_id
		,visit_occurrence_id
		,drug_source_value AS observation_source_value
		,CAST(NULL AS INT) observation_source_concept_id
		,NULL AS unit_source_value
		,cast(NULL AS VARCHAR(50)) qualifier_source_value
		,drug_exposure_id AS occurrence_id
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE
	INNER JOIN #concept_map cm1 ON drug_exposure.drug_concept_id = cm1.source_concept_id
		AND LOWER(cm1.domain_id) IN ('observation')
	) OTHERS
	,(
		SELECT MAX(OBSERVATION_ID) AS MAXROWID
		FROM [SOURCE_CDMV4].[SCHEMA].OBSERVATION
		) MAXROW;

/****
 
 PAYER_PLAN_PERIOD
 
 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].payer_plan_period
SELECT payer_plan_period_id
	,person_id
	,payer_plan_period_start_date
	,payer_plan_period_end_date
	,payer_source_value
	,plan_source_value
	,family_source_value
FROM [SOURCE_CDMV4].[SCHEMA].PAYER_PLAN_PERIOD;

/****
 
 DRUG_COST
 
 note : if there were invalid drug concepts in DRUG_EXPOSURE, those records may not enter CDMv5 but costs will persist
 
 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].drug_cost
SELECT drug_cost_id
	,dc.drug_exposure_id
	,cast(NULL AS INT) currency_concept_id
	,paid_copay
	,paid_coinsurance
	,paid_toward_deductible
	,paid_by_payer
	,paid_by_coordination_benefits
	,total_out_of_pocket
	,total_paid
	,ingredient_cost
	,dispensing_fee
	,average_wholesale_price
	,payer_plan_period_id
FROM [SOURCE_CDMV4].[SCHEMA].DRUG_COST dc;

-- insert procedure costs for procedures that were inserted into the drug_exposure table
INSERT INTO [TARGET_CDMV5].[SCHEMA].drug_cost
SELECT CASE 
		WHEN MAXROW.MAXROWID IS NULL
			THEN 0
		ELSE MAXROW.MAXROWID
		END + row_number() OVER (
		ORDER BY OCCURRENCE_ID
		) AS drug_cost_id
	,drug_exposure_id
	,cast(NULL AS INT) currency_concept_id
	,paid_copay
	,paid_coinsurance
	,paid_toward_deductible
	,paid_by_payer
	,paid_by_coordination_benefits
	,total_out_of_pocket
	,total_paid
	,ingredient_cost
	,dispensing_fee
	,average_wholesale_price
	,payer_plan_period_id
FROM (
	SELECT drug_exposure_id
		,po.person_id
		,paid_copay
		,paid_coinsurance
		,paid_toward_deductible
		,paid_by_payer
		,paid_by_coordination_benefits
		,total_out_of_pocket
		,total_paid
		,CAST(NULL AS FLOAT) AS ingredient_cost
		,CAST(NULL AS FLOAT) AS dispensing_fee
		,CAST(NULL AS FLOAT) AS average_wholesale_price
		,payer_plan_period_id
		,procedure_cost_id AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_OCCURRENCE po
	INNER JOIN [SOURCE_CDMV4].[SCHEMA].PROCEDURE_COST pc ON po.procedure_occurrence_id = pc.procedure_occurrence_id
	--JOIN dbo.drug_exposure de on de.person_id = po.person_id and pc.procedure_occurrence_id = de.origional_procedure_id
	INNER JOIN #drgexp_map de ON de.person_id = po.person_id
		AND pc.procedure_occurrence_id = de.origional_procedure_id
	) OTHERS
	,(
		SELECT MAX(drug_cost_id) AS MAXROWID
		FROM [SOURCE_CDMV4].[SCHEMA].DRUG_COST
		) MAXROW;

/****
 
 PROCEDURE_COST
 
 note : if there were invalid procedure concepts in PROCEDURE_OCCURRENCE, those records may not enter CDMv5 but costs will persist
 
 
 ****/
INSERT INTO [TARGET_CDMV5].[SCHEMA].procedure_cost
SELECT procedure_cost_id
	,procedure_occurrence_id
	,cast(NULL AS INT) currency_concept_id
	,paid_copay
	,paid_coinsurance
	,paid_toward_deductible
	,paid_by_payer
	,paid_by_coordination_benefits
	,total_out_of_pocket
	,total_paid
	,payer_plan_period_id
	,revenue_code_concept_id
	,revenue_code_source_value
FROM [SOURCE_CDMV4].[SCHEMA].PROCEDURE_COST;

-- insert drug costs for drugs that were inserted into the procedure_occurrence table
INSERT INTO [TARGET_CDMV5].[SCHEMA].procedure_cost
SELECT CASE 
		WHEN MAXROW.MAXROWID IS NULL
			THEN 0
		ELSE MAXROW.MAXROWID
		END + row_number() OVER (
		ORDER BY OCCURRENCE_ID
		) AS procedure_cost_id
	,procedure_occurrence_id
	,cast(NULL AS INT) currency_concept_id
	,paid_copay
	,paid_coinsurance
	,paid_toward_deductible
	,paid_by_payer
	,paid_by_coordination_benefits
	,total_out_of_pocket
	,total_paid
	,payer_plan_period_id
	,revenue_code_concept_id
	,revenue_code_source_value
FROM (
	SELECT po.procedure_occurrence_id
		,po.person_id
		,paid_copay
		,paid_coinsurance
		,paid_toward_deductible
		,paid_by_payer
		,paid_by_coordination_benefits
		,total_out_of_pocket
		,total_paid
		,CAST(NULL AS FLOAT) AS ingredient_cost
		,CAST(NULL AS FLOAT) AS dispensing_fee
		,CAST(NULL AS FLOAT) AS average_wholesale_price
		,payer_plan_period_id
		,CAST(NULL AS INT) AS revenue_code_concept_id
		,CAST(NULL AS INT) AS revenue_code_source_value
		,drug_cost_id AS OCCURRENCE_ID
	FROM [SOURCE_CDMV4].[SCHEMA].DRUG_EXPOSURE de
	INNER JOIN [SOURCE_CDMV4].[SCHEMA].DRUG_COST dc ON de.drug_exposure_id = dc.drug_exposure_id
	--JOIN dbo.procedure_occurrence po on de.person_id = po.person_id and de.drug_exposure_id = po.origional_drug_id
	INNER JOIN #po_map po ON de.person_id = po.person_id
		AND de.drug_exposure_id = po.origional_drug_id
	) OTHERS
	,(
		SELECT MAX(drug_cost_id) AS MAXROWID
		FROM [SOURCE_CDMV4].[SCHEMA].DRUG_COST
		) MAXROW;

/****

DRUG ERA
Note: Eras derived from DRUG_EXPOSURE table, using 30d gap

 ****/
IF OBJECT_ID('tempdb..#cteDrugTarget', 'U') IS NOT NULL
	DROP TABLE #cteDrugTarget;

/* / */

-- Normalize DRUG_EXPOSURE_END_DATE to either the existing drug exposure end date, or add days supply, or add 1 day to the start date
SELECT d.DRUG_EXPOSURE_ID
	,d.PERSON_ID
	,c.CONCEPT_ID
	,d.DRUG_TYPE_CONCEPT_ID
	,DRUG_EXPOSURE_START_DATE
	,COALESCE(DRUG_EXPOSURE_END_DATE, DATEADD(day, DAYS_SUPPLY, DRUG_EXPOSURE_START_DATE), DATEADD(day, 1, DRUG_EXPOSURE_START_DATE)) AS DRUG_EXPOSURE_END_DATE
	,c.CONCEPT_ID AS INGREDIENT_CONCEPT_ID
INTO #cteDrugTarget
FROM [TARGET_CDMV5].[SCHEMA].DRUG_EXPOSURE d
INNER JOIN [TARGET_CDMV5].[SCHEMA].CONCEPT_ANCESTOR ca ON ca.DESCENDANT_CONCEPT_ID = d.DRUG_CONCEPT_ID
INNER JOIN [TARGET_CDMV5].[SCHEMA].CONCEPT c ON ca.ANCESTOR_CONCEPT_ID = c.CONCEPT_ID
WHERE c.VOCABULARY_ID = 'RxNorm'
	AND c.CONCEPT_CLASS_ID = 'Ingredient';

/* / */

IF OBJECT_ID('tempdb..#cteEndDates', 'U') IS NOT NULL
	DROP TABLE #cteEndDates;

/* / */

SELECT PERSON_ID
	,INGREDIENT_CONCEPT_ID
	,DATEADD(day, - 30, EVENT_DATE) AS END_DATE -- unpad the end date
INTO #cteEndDates
FROM (
	SELECT E1.PERSON_ID
		,E1.INGREDIENT_CONCEPT_ID
		,E1.EVENT_DATE
		,COALESCE(E1.START_ORDINAL, MAX(E2.START_ORDINAL)) START_ORDINAL
		,E1.OVERALL_ORD
	FROM (
		SELECT PERSON_ID
			,INGREDIENT_CONCEPT_ID
			,EVENT_DATE
			,EVENT_TYPE
			,START_ORDINAL
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,INGREDIENT_CONCEPT_ID ORDER BY EVENT_DATE
					,EVENT_TYPE
				) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
		FROM (
			-- select the start dates, assigning a row number to each
			SELECT PERSON_ID
				,INGREDIENT_CONCEPT_ID
				,DRUG_EXPOSURE_START_DATE AS EVENT_DATE
				,0 AS EVENT_TYPE
				,ROW_NUMBER() OVER (
					PARTITION BY PERSON_ID
					,INGREDIENT_CONCEPT_ID ORDER BY DRUG_EXPOSURE_START_DATE
					) AS START_ORDINAL
			FROM #cteDrugTarget
			
			UNION ALL
			
			-- add the end dates with NULL as the row number, padding the end dates by 30 to allow a grace period for overlapping ranges.
			SELECT PERSON_ID
				,INGREDIENT_CONCEPT_ID
				,DATEADD(day, 30, DRUG_EXPOSURE_END_DATE)
				,1 AS EVENT_TYPE
				,NULL
			FROM #cteDrugTarget
			) RAWDATA
		) E1
	INNER JOIN (
		SELECT PERSON_ID
			,INGREDIENT_CONCEPT_ID
			,DRUG_EXPOSURE_START_DATE AS EVENT_DATE
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,INGREDIENT_CONCEPT_ID ORDER BY DRUG_EXPOSURE_START_DATE
				) AS START_ORDINAL
		FROM #cteDrugTarget
		) E2 ON E1.PERSON_ID = E2.PERSON_ID
		AND E1.INGREDIENT_CONCEPT_ID = E2.INGREDIENT_CONCEPT_ID
		AND E2.EVENT_DATE <= E1.EVENT_DATE
	GROUP BY E1.PERSON_ID
		,E1.INGREDIENT_CONCEPT_ID
		,E1.EVENT_DATE
		,E1.START_ORDINAL
		,E1.OVERALL_ORD
	) E
WHERE 2 * E.START_ORDINAL - E.OVERALL_ORD = 0;

/* / */

IF OBJECT_ID('tempdb..#cteDrugExpEnds', 'U') IS NOT NULL
	DROP TABLE #cteDrugExpEnds;

/* / */

SELECT d.PERSON_ID
	,d.INGREDIENT_CONCEPT_ID
	,d.DRUG_TYPE_CONCEPT_ID
	,d.DRUG_EXPOSURE_START_DATE
	,MIN(e.END_DATE) AS ERA_END_DATE
INTO #cteDrugExpEnds
FROM #cteDrugTarget d
INNER JOIN #cteEndDates e ON d.PERSON_ID = e.PERSON_ID
	AND d.INGREDIENT_CONCEPT_ID = e.INGREDIENT_CONCEPT_ID
	AND e.END_DATE >= d.DRUG_EXPOSURE_START_DATE
GROUP BY d.PERSON_ID
	,d.INGREDIENT_CONCEPT_ID
	,d.DRUG_TYPE_CONCEPT_ID
	,d.DRUG_EXPOSURE_START_DATE;

/* / */

INSERT INTO [TARGET_CDMV5].[SCHEMA].drug_era
SELECT row_number() OVER (
		ORDER BY person_id
		) AS drug_era_id
	,person_id
	,INGREDIENT_CONCEPT_ID
	,min(DRUG_EXPOSURE_START_DATE) AS drug_era_start_date
	,ERA_END_DATE
	,COUNT(*) AS DRUG_EXPOSURE_COUNT
	,30 AS gap_days
FROM #cteDrugExpEnds
GROUP BY person_id
	,INGREDIENT_CONCEPT_ID
	,drug_type_concept_id
	,ERA_END_DATE;

/****

CONDITION ERA
Note: Eras derived from CONDITION_OCCURRENCE table, using 30d gap

 ****/
IF OBJECT_ID('tempdb..#condition_era_phase_1', 'U') IS NOT NULL
	DROP TABLE #condition_era_phase_1;

/* / */

IF OBJECT_ID('tempdb..#cteConditionTarget', 'U') IS NOT NULL
	DROP TABLE #cteConditionTarget;

/* / */

-- create base eras from the concepts found in condition_occurrence
SELECT co.PERSON_ID
	,co.condition_concept_id
	,co.CONDITION_START_DATE
	,COALESCE(co.CONDITION_END_DATE, DATEADD(day, 1, CONDITION_START_DATE)) AS CONDITION_END_DATE
INTO #cteConditionTarget
FROM [TARGET_CDMV5].[SCHEMA].CONDITION_OCCURRENCE co;

/* / */

IF OBJECT_ID('tempdb..#cteCondEndDates', 'U') IS NOT NULL
	DROP TABLE #cteCondEndDates;

/* / */

SELECT PERSON_ID
	,CONDITION_CONCEPT_ID
	,DATEADD(day, - 30, EVENT_DATE) AS END_DATE -- unpad the end date
INTO #cteCondEndDates
FROM (
	SELECT E1.PERSON_ID
		,E1.CONDITION_CONCEPT_ID
		,E1.EVENT_DATE
		,COALESCE(E1.START_ORDINAL, MAX(E2.START_ORDINAL)) START_ORDINAL
		,E1.OVERALL_ORD
	FROM (
		SELECT PERSON_ID
			,CONDITION_CONCEPT_ID
			,EVENT_DATE
			,EVENT_TYPE
			,START_ORDINAL
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,CONDITION_CONCEPT_ID ORDER BY EVENT_DATE
					,EVENT_TYPE
				) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
		FROM (
			-- select the start dates, assigning a row number to each
			SELECT PERSON_ID
				,CONDITION_CONCEPT_ID
				,CONDITION_START_DATE AS EVENT_DATE
				,- 1 AS EVENT_TYPE
				,ROW_NUMBER() OVER (
					PARTITION BY PERSON_ID
					,CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATE
					) AS START_ORDINAL
			FROM #cteConditionTarget
			
			UNION ALL
			
			-- pad the end dates by 30 to allow a grace period for overlapping ranges.
			SELECT PERSON_ID
				,CONDITION_CONCEPT_ID
				,DATEADD(day, 30, CONDITION_END_DATE)
				,1 AS EVENT_TYPE
				,NULL
			FROM #cteConditionTarget
			) RAWDATA
		) E1
	INNER JOIN (
		SELECT PERSON_ID
			,CONDITION_CONCEPT_ID
			,CONDITION_START_DATE AS EVENT_DATE
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATE
				) AS START_ORDINAL
		FROM #cteConditionTarget
		) E2 ON E1.PERSON_ID = E2.PERSON_ID
		AND E1.CONDITION_CONCEPT_ID = E2.CONDITION_CONCEPT_ID
		AND E2.EVENT_DATE <= E1.EVENT_DATE
	GROUP BY E1.PERSON_ID
		,E1.CONDITION_CONCEPT_ID
		,E1.EVENT_DATE
		,E1.START_ORDINAL
		,E1.OVERALL_ORD
	) E
WHERE (2 * E.START_ORDINAL) - E.OVERALL_ORD = 0;

/* / */

IF OBJECT_ID('tempdb..#cteConditionEnds', 'U') IS NOT NULL
	DROP TABLE #cteConditionEnds;

/* / */

SELECT c.PERSON_ID
	,c.CONDITION_CONCEPT_ID
	,c.CONDITION_START_DATE
	,MIN(e.END_DATE) AS ERA_END_DATE
INTO #cteConditionEnds
FROM #cteConditionTarget c
INNER JOIN #cteCondEndDates e ON c.PERSON_ID = e.PERSON_ID
	AND c.CONDITION_CONCEPT_ID = e.CONDITION_CONCEPT_ID
	AND e.END_DATE >= c.CONDITION_START_DATE
GROUP BY c.PERSON_ID
	,c.CONDITION_CONCEPT_ID
	,c.CONDITION_START_DATE;

/* / */

INSERT INTO [TARGET_CDMV5].[SCHEMA].condition_era (
	condition_era_id
	,person_id
	,condition_concept_id
	,condition_era_start_date
	,condition_era_end_date
	,condition_occurrence_count
	)
SELECT row_number() OVER (
		ORDER BY person_id
		) AS condition_era_id
	,person_id
	,CONDITION_CONCEPT_ID
	,min(CONDITION_START_DATE) AS CONDITION_ERA_START_DATE
	,ERA_END_DATE AS CONDITION_ERA_END_DATE
	,COUNT(*) AS CONDITION_OCCURRENCE_COUNT
FROM #cteConditionEnds
GROUP BY person_id
	,CONDITION_CONCEPT_ID
	,ERA_END_DATE;

/****

QUALITY ASSURANCE OUTPUT

Note: These queries are used to provide some basic stats around row counts between your V4 and V5 database
      to ensure that all of the data has migrated as expected.

 ****/
 
IF OBJECT_ID('tempdb..#v5_stats', 'U') IS NOT NULL
	DROP TABLE #v5_stats;

/* / */

IF OBJECT_ID('tempdb..#v4_stats', 'U') IS NOT NULL
	DROP TABLE #v4_stats;

/* / */

-- Get the row counts for each table that is in scope for the migration
SELECT *
INTO #v4_stats
FROM
(
	SELECT '[SOURCE_CDMV4]' AS DBName, 'care_site' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].care_site
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'condition_era' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].condition_era
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'condition_occurrence' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].condition_occurrence
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'death' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].death
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'drug_cost' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].drug_cost
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'drug_era' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].drug_era
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'drug_exposure' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].drug_exposure
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'location' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].location
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'observation' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].observation
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'observation_period' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].observation_period
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'payer_plan_period' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].payer_plan_period
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'person' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].person
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'procedure_cost' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].procedure_cost
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'procedure_occurrence' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].procedure_occurrence
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'provider' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].provider
	UNION
	SELECT '[SOURCE_CDMV4]' AS DBName, 'visit_occurrence' AS TableName, COUNT(*) as row_count FROM [SOURCE_CDMV4].[SCHEMA].visit_occurrence
) v4_stats;

/* / */

SELECT *
INTO #v5_stats
FROM
(
	SELECT '[TARGET_CDMV5]' AS DBName, 'care_site' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].care_site
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'condition_era' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].condition_era
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'condition_occurrence' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].condition_occurrence
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'death' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].death
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'device_exposure' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].device_exposure
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'drug_cost' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].drug_cost
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'drug_era' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].drug_era
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'drug_exposure' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].drug_exposure
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'location' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].location
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'measurement' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].measurement
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'observation' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].observation
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'observation_period' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].observation_period
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'payer_plan_period' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].payer_plan_period
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'person' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].person
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'procedure_cost' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].procedure_cost
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'procedure_occurrence' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].procedure_occurrence
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'provider' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].provider
	UNION
	SELECT '[TARGET_CDMV5]' AS DBName, 'visit_occurrence' AS TableName, COUNT(*) as row_count FROM [TARGET_CDMV5].[SCHEMA].visit_occurrence
) v5_stats;

/* / */

-- Show the results
select
	'Rowcounts for each database and table',
	ISNULL(V4.DBName, 'None') v4_database_name,
	v4.TableName v4_table_name,
	v4.row_count v4_row_count,
	ISNULL(v5.DBName, 'None') v5_database_name,
	v5.TableName v5_table_name,
	v5.row_count v5_row_count,
	ISNULL(v5.row_count, 0) - ISNULL(v4.row_count, 0) row_count_change
from #v4_stats v4
full outer join #v5_stats v5 ON v4.TableName = v5.TableName
order by v5.TableName;

/*
 * Determine how the vocabulary/domains helped to map from the V4 source
 * tables to the V5 destinations
 */
IF OBJECT_ID('tempdb..#classification_map', 'U') IS NOT NULL
	DROP TABLE #classification_map;

/* / */

SELECT *
INTO #classification_map
FROM
(
	SELECT 'Condition_Occurrence' TableName, ISNULL(LOWER(cm.domain_id), 'condition') domain_id, COUNT(*) row_count
	FROM [SOURCE_CDMV4].[SCHEMA].Condition_Occurrence CO
	LEFT JOIN #concept_map CM ON co.condition_concept_id = cm.source_concept_id
	GROUP BY ISNULL(LOWER(cm.domain_id), 'condition')
	UNION
	SELECT 'Drug_Exposure' TableName, ISNULL(LOWER(cm.domain_id), 'drug') domain_id, COUNT(*) row_count
	FROM [SOURCE_CDMV4].[SCHEMA].Drug_Exposure de
	LEFT JOIN #concept_map CM ON de.drug_concept_id = cm.source_concept_id
	GROUP BY ISNULL(LOWER(cm.domain_id), 'drug')
	UNION
	SELECT 'Observation' TableName, ISNULL(LOWER(cm.domain_id), 'observation') domain_id, COUNT(*) row_count
	FROM [SOURCE_CDMV4].[SCHEMA].Observation o
	LEFT JOIN #concept_map CM ON o.observation_concept_id = cm.source_concept_id
	GROUP BY ISNULL(LOWER(cm.domain_id), 'observation')
	UNION
	SELECT 'Procedure_Occurrence' TableName, ISNULL(LOWER(cm.domain_id), 'procedure') domain_id, COUNT(*) row_count
	FROM [SOURCE_CDMV4].[SCHEMA].Procedure_Occurrence po
	LEFT JOIN #concept_map CM ON po.PROCEDURE_CONCEPT_ID = cm.source_concept_id
	GROUP BY ISNULL(LOWER(cm.domain_id), 'procedure')
) A
ORDER by A.TableName, A.domain_id;

/* / */

select *
from #classification_map
order by tablename, domain_id;

select domain_id, SUM(row_count) 
from #classification_map
group by domain_id
order by domain_id;