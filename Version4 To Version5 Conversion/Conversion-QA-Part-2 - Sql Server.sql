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

PURPOSE: Use this script is used to help perform Quality Assurance activities 
         after you convert your OMOP V4 common data model to CDM V5.

last revised: 01 July 2015
author:  Anthony Sena

This script was authored against SQL Server and will require conversion to other
dialects. Please keep this in mind if you plan to use this against another RDBMS.

General Notes
---------------

The V4 to V5 conversion script utilizes the standard vocabularies to map data
from the V4 source tables to the V5 target tables. As a result, comparing the
rowcounts for the following tables is not adviseable since we are expecting 
certain entries to move from their source table to a different target:

Condition_Occurrence
Drug_Exposure
Observation
Measurement
Procedure_Occurrence

This script will produce 2 tables:

Table 1: This will contain the source table name (i.e. Condition_Occurrence),
         the target domain_id from the V5 vocabulary and the expected rowcount
		 from the conversion. When there is no target defined in the V5 vocabulary, 
		 the source data is carried over to the same target table in V5 with 
		 a concept_id of 0. For example:

		 TableName	            Domain	    RowCount
		 ---------              ------      --------
         Condition_Occurrence	condition	464849
         Condition_Occurrence	measurement	8416
         Condition_Occurrence	observation	31522
         Condition_Occurrence	procedure	24298

Table 2: This will contain a summary of the V5 Target Domains and Rowcounts. 
         I found this helpful to tie out the expected rowcounts and what actually
		 happened during the conversion.

INSTRUCTIONS
------------

 1. This script has placeholders for your CDM V4 and CDMV5 database/schema. 
    In order to make this file work in your environment, you 
	should plan to do a global "FIND AND REPLACE" on this file to fill in the 
	file with values that pertain to your environment. The following are the 
	tokens you should use when doing your "FIND AND REPLACE" operation:

	a. [SOURCE_CDMV4]
    b. [TARGET_CDMV5]

 2. Run the resulting script on your target RDBDMS.

*********************************************************************************/

USE [TARGET_CDMV5]
GO

/*
 * CONCEPT MAP
 */
IF OBJECT_ID('tempdb..#concept_map', 'U') IS NOT NULL
	DROP TABLE #concept_map;

--standard concepts
SELECT concept_id AS source_concept_id
	,concept_id AS target_concept_id
	,domain_id
	,NULL AS source_concept_mapping_occurrence
INTO #concept_map
FROM dbo.concept
WHERE standard_concept = 'S'
	AND invalid_reason IS NULL

UNION

--concepts with 'map to' standard
SELECT DISTINCT c1.concept_id AS source_concept_id
	,c2.concept_id AS target_concept_id
	,c2.domain_id
	,NULL
FROM (
	SELECT concept_id
	FROM dbo.concept
	WHERE (
			(
				standard_concept <> 'S'
				OR standard_concept IS NULL
				)
			OR invalid_reason IS NOT NULL
			)
	) c1
INNER JOIN dbo.concept_relationship cr1 ON c1.concept_id = cr1.concept_id_1
INNER JOIN dbo.concept c2 ON cr1.concept_id_2 = c2.concept_id
WHERE c2.standard_concept = 'S'
	AND c2.invalid_reason IS NULL
	AND cr1.relationship_id IN ('Maps to')
	AND cr1.invalid_reason IS NULL

UNION

--concepts without 'map to' standard with another non 'is a' relation to standard
SELECT DISTINCT c1.concept_id AS source_concept_id
	,c2.concept_id AS target_concept_id
	,c2.domain_id
	,NULL
FROM (
	SELECT concept_id
	FROM dbo.concept
	WHERE (
			(
				standard_concept <> 'S'
				OR standard_concept IS NULL
				)
			OR invalid_reason IS NOT NULL
			)
		AND concept_id NOT IN (
			SELECT DISTINCT c1.concept_id
			FROM (
				SELECT concept_id
				FROM dbo.concept
				WHERE (
						(
							standard_concept <> 'S'
							OR standard_concept IS NULL
							)
						OR invalid_reason IS NOT NULL
						)
				) c1
			INNER JOIN dbo.concept_relationship cr1 ON c1.concept_id = cr1.concept_id_1
			INNER JOIN dbo.concept c2 ON cr1.concept_id_2 = c2.concept_id
			WHERE c2.standard_concept = 'S'
				AND c2.invalid_reason IS NULL
				AND cr1.relationship_id IN ('Maps to')
				AND cr1.invalid_reason IS NULL
			)
	) c1
INNER JOIN dbo.concept_relationship cr1 ON c1.concept_id = cr1.concept_id_1
INNER JOIN dbo.concept c2 ON cr1.concept_id_2 = c2.concept_id
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
	,NULL
FROM (
	SELECT concept_id
	FROM dbo.concept
	WHERE (
			(
				standard_concept <> 'S'
				OR standard_concept IS NULL
				)
			OR invalid_reason IS NOT NULL
			)
		AND concept_id NOT IN (
			SELECT DISTINCT c1.concept_id
			FROM (
				SELECT concept_id
				FROM dbo.concept
				WHERE (
						(
							standard_concept <> 'S'
							OR standard_concept IS NULL
							)
						OR invalid_reason IS NOT NULL
						)
				) c1
			INNER JOIN dbo.concept_relationship cr1 ON c1.concept_id = cr1.concept_id_1
			INNER JOIN dbo.concept c2 ON cr1.concept_id_2 = c2.concept_id
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
			)
	) c1
INNER JOIN dbo.concept_relationship cr1 ON c1.concept_id = cr1.concept_id_1
INNER JOIN dbo.concept c2 ON cr1.concept_id_2 = c2.concept_id
WHERE c2.standard_concept = 'S'
	AND c2.invalid_reason IS NULL
	AND cr1.relationship_id IN ('Is a')
	AND cr1.invalid_reason IS NULL;
GO

-- Update the source_concept_mapping_occurrence column
-- to contain a count to indicate the number of target_concept_ids
-- map to that source_concept_id. This will be used elsewhere in 
-- the script to ensure that we generate new primary keys
-- for the target tables when applicable 
UPDATE #concept_map
SET #concept_map.source_concept_mapping_occurrence = A.[Rowcount]
FROM #concept_map
	,(
		SELECT source_concept_id
			,domain_id
			,count(*) AS "rowcount"
		FROM #concept_map
		GROUP BY source_concept_id
			,domain_id
		) AS A
WHERE #concept_map.source_concept_id = A.source_concept_id
	AND #concept_map.domain_id = A.domain_id

IF OBJECT_ID('tempdb..#concept_map_distinct', 'U') IS NOT NULL
	DROP TABLE #concept_map_distinct;

SELECT DISTINCT source_concept_id
	,domain_id
	,COUNT(*) AS "rowcount"
INTO #concept_map_distinct
FROM #concept_map
GROUP BY source_concept_id
	,domain_id


/*
 * V4 - Condition_Occurrence summary and mapping to #concept_map
 */
IF OBJECT_ID('tempdb..#classification_map', 'U') IS NOT NULL
	DROP TABLE #classification_map;

SELECT *
INTO #classification_map
FROM
(
	SELECT 'Condition_Occurrence' as TableName, ISNULL(LOWER(cm.domain_id), 'condition') AS "Domain", COUNT(*) AS "RowCount"
	FROM [SOURCE_CDMV4].[dbo].[Condition_Occurrence] as CO
	LEFT JOIN #concept_map as CM ON co.condition_concept_id = cm.source_concept_id
	GROUP BY ISNULL(LOWER(cm.domain_id), 'condition')
	UNION
	SELECT 'Drug_Exposure' as TableName, ISNULL(LOWER(cm.domain_id), 'drug') AS "Domain", COUNT(*) AS "RowCount"
	FROM [SOURCE_CDMV4].[dbo].[Drug_Exposure] as de
	LEFT JOIN #concept_map as CM ON de.drug_concept_id = cm.source_concept_id
	GROUP BY ISNULL(LOWER(cm.domain_id), 'drug')
	UNION
	SELECT 'Observation' as TableName, ISNULL(LOWER(cm.domain_id), 'observation') AS "Domain", COUNT(*) AS "RowCount"
	FROM [SOURCE_CDMV4].[dbo].[Observation] as o
	LEFT JOIN #concept_map as CM ON o.observation_concept_id = cm.source_concept_id
	GROUP BY ISNULL(LOWER(cm.domain_id), 'observation')
	UNION
	SELECT 'Procedure_Occurrence' as TableName, ISNULL(LOWER(cm.domain_id), 'procedure') AS "Domain", COUNT(*) AS "RowCount"
	FROM [SOURCE_CDMV4].[dbo].[Procedure_Occurrence] as po
	LEFT JOIN #concept_map as CM ON po.PROCEDURE_CONCEPT_ID = cm.source_concept_id
	GROUP BY ISNULL(LOWER(cm.domain_id), 'procedure')
) AS A
ORDER by A.[TableName], A.[Domain]

select *
from #classification_map
order by [TableName], [Domain]

select domain, SUM([RowCount]) 
from #classification_map
group by domain
order by domain