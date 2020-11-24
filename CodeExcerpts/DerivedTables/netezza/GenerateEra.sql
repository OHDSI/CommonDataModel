/*********************************************************************************
# Copyright 2017 Observational Health Data Sciences and Informatics
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

PURPOSE: Generate Era table (based on conversion script from V4, V5).

last revised: November 2020
authors:  Patrick Ryan, Chris Knoll, Anthony Sena, Vojtech Huser, Sam Debruyn


OHDSI-SQL File Instructions
-----------------------------

 1. Set parameter name of schema that contains CDMv6 instance
    ([CDM], [CDM].[CDMSCHEMA])
 3. Run this script through SqlRender to produce a script that will work in your
    source dialect. SqlRender can be found here: https://github.com/OHDSI/SqlRender
 4. Run the script produced by SQL Render on your target RDBDMS.

<RDBMS> File Instructions
-------------------------

 1. This script will hold a number of placeholders for your CDMV6
    database/schema. In order to make this file work in your environment, you
	should plan to do a global "FIND AND REPLACE" on this file to fill in the
	file with values that pertain to your environment. The following are the
	tokens you should use when doing your "FIND AND REPLACE" operation:

	
     [CMD]
	 [CDM].[CDMSCHEMA]
	

*********************************************************************************/
/* SCRIPT PARAMETERS */

	
	-- The target CDMV6 database name
	-- the target CDMV6 database plus schema

SET search_path TO [CDM];



/****

DRUG ERA
Note: Eras derived from DRUG_EXPOSURE table, using 30d gap

 ****/
DROP TABLE cteDrugTarget IF EXISTS;

/* / */

-- Normalize DRUG_EXPOSURE_END_DATETIME to either the existing drug exposure end date, or add days supply, or add 1 day to the start date
CREATE TEMP TABLE cteDrugTarget

AS
SELECT
d.DRUG_EXPOSURE_ID
	,d.PERSON_ID
	,c.CONCEPT_ID
	,d.DRUG_TYPE_CONCEPT_ID
	,DRUG_EXPOSURE_START_DATETIME
	,COALESCE(DRUG_EXPOSURE_END_DATETIME, (DRUG_EXPOSURE_START_DATETIME + DAYS_SUPPLY), (DRUG_EXPOSURE_START_DATETIME + 1)) AS DRUG_EXPOSURE_END_DATETIME
	,c.CONCEPT_ID AS INGREDIENT_CONCEPT_ID

FROM
[CDM].[CDMSCHEMA].DRUG_EXPOSURE d
INNER JOIN [CDM].[CDMSCHEMA].CONCEPT_ANCESTOR ca ON ca.DESCENDANT_CONCEPT_ID = d.DRUG_CONCEPT_ID
INNER JOIN [CDM].[CDMSCHEMA].CONCEPT c ON ca.ANCESTOR_CONCEPT_ID = c.CONCEPT_ID
WHERE c.VOCABULARY_ID = 'RxNorm'
	AND c.CONCEPT_CLASS_ID = 'Ingredient';

/* / */

DROP TABLE cteEndDates IF EXISTS;

/* / */

CREATE TEMP TABLE cteEndDates

AS
SELECT
PERSON_ID
	,INGREDIENT_CONCEPT_ID
	,(EVENT_DATETIME + - 30) AS END_DATETIME -- unpad the end date

FROM
(
	SELECT E1.PERSON_ID
		,E1.INGREDIENT_CONCEPT_ID
		,E1.EVENT_DATETIME
		,COALESCE(E1.START_ORDINAL, MAX(E2.START_ORDINAL)) START_ORDINAL
		,E1.OVERALL_ORD
	FROM (
		SELECT PERSON_ID
			,INGREDIENT_CONCEPT_ID
			,EVENT_DATETIME
			,EVENT_TYPE
			,START_ORDINAL
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,INGREDIENT_CONCEPT_ID ORDER BY EVENT_DATETIME
					,EVENT_TYPE
				) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
		FROM (
			-- select the start dates, assigning a row number to each
			SELECT PERSON_ID
				,INGREDIENT_CONCEPT_ID
				,DRUG_EXPOSURE_START_DATETIME AS EVENT_DATETIME
				,0 AS EVENT_TYPE
				,ROW_NUMBER() OVER (
					PARTITION BY PERSON_ID
					,INGREDIENT_CONCEPT_ID ORDER BY DRUG_EXPOSURE_START_DATETIME
					) AS START_ORDINAL
			FROM cteDrugTarget

			UNION ALL

			-- add the end dates with NULL as the row number, padding the end dates by 30 to allow a grace period for overlapping ranges.
			SELECT PERSON_ID
				,INGREDIENT_CONCEPT_ID
				,(DRUG_EXPOSURE_END_DATETIME + 30)
				,1 AS EVENT_TYPE
				,NULL
			FROM cteDrugTarget
			) RAWDATA
		) E1
	INNER JOIN (
		SELECT PERSON_ID
			,INGREDIENT_CONCEPT_ID
			,DRUG_EXPOSURE_START_DATETIME AS EVENT_DATETIME
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,INGREDIENT_CONCEPT_ID ORDER BY DRUG_EXPOSURE_START_DATETIME
				) AS START_ORDINAL
		FROM cteDrugTarget
		) E2 ON E1.PERSON_ID = E2.PERSON_ID
		AND E1.INGREDIENT_CONCEPT_ID = E2.INGREDIENT_CONCEPT_ID
		AND E2.EVENT_DATETIME <= E1.EVENT_DATETIME
	GROUP BY E1.PERSON_ID
		,E1.INGREDIENT_CONCEPT_ID
		,E1.EVENT_DATETIME
		,E1.START_ORDINAL
		,E1.OVERALL_ORD
	) E
WHERE 2 * E.START_ORDINAL - E.OVERALL_ORD = 0;

/* / */

DROP TABLE cteDrugExpEnds IF EXISTS;

/* / */

CREATE TEMP TABLE cteDrugExpEnds

AS
SELECT
d.PERSON_ID
	,d.INGREDIENT_CONCEPT_ID
	,d.DRUG_TYPE_CONCEPT_ID
	,d.DRUG_EXPOSURE_START_DATETIME
	,MIN(e.END_DATETIME) AS ERA_END_DATETIME

FROM
cteDrugTarget d
INNER JOIN cteEndDates e ON d.PERSON_ID = e.PERSON_ID
	AND d.INGREDIENT_CONCEPT_ID = e.INGREDIENT_CONCEPT_ID
	AND e.END_DATETIME >= d.DRUG_EXPOSURE_START_DATETIME
GROUP BY d.PERSON_ID
	,d.INGREDIENT_CONCEPT_ID
	,d.DRUG_TYPE_CONCEPT_ID
	,d.DRUG_EXPOSURE_START_DATETIME;

/* / */

INSERT INTO [CDM].[CDMSCHEMA].drug_era
SELECT row_number() OVER (
		ORDER BY person_id
		) AS drug_era_id
	,person_id
	,INGREDIENT_CONCEPT_ID
	,min(DRUG_EXPOSURE_START_DATETIME) AS drug_era_start_datetime
	,ERA_END_DATETIME
	,COUNT(*) AS DRUG_EXPOSURE_COUNT
	,30 AS gap_days
FROM cteDrugExpEnds
GROUP BY person_id
	,INGREDIENT_CONCEPT_ID
	,drug_type_concept_id
	,ERA_END_DATETIME;



/****

CONDITION ERA
Note: Eras derived from CONDITION_OCCURRENCE table, using 30d gap

 ****/
DROP TABLE condition_era_phase_1 IF EXISTS;

/* / */

DROP TABLE cteConditionTarget IF EXISTS;

/* / */

-- create base eras from the concepts found in condition_occurrence
CREATE TEMP TABLE cteConditionTarget

AS
SELECT
co.PERSON_ID
	,co.condition_concept_id
	,co.CONDITION_START_DATETIME
	,COALESCE(co.CONDITION_END_DATETIME, (CONDITION_START_DATETIME + 1)) AS CONDITION_END_DATETIME

FROM
[CDM].[CDMSCHEMA].CONDITION_OCCURRENCE co;

/* / */

DROP TABLE cteCondEndDates IF EXISTS;

/* / */

CREATE TEMP TABLE cteCondEndDates

AS
SELECT
PERSON_ID
	,CONDITION_CONCEPT_ID
	,(EVENT_DATETIME + - 30) AS END_DATETIME -- unpad the end date

FROM
(
	SELECT E1.PERSON_ID
		,E1.CONDITION_CONCEPT_ID
		,E1.EVENT_DATETIME
		,COALESCE(E1.START_ORDINAL, MAX(E2.START_ORDINAL)) START_ORDINAL
		,E1.OVERALL_ORD
	FROM (
		SELECT PERSON_ID
			,CONDITION_CONCEPT_ID
			,EVENT_DATETIME
			,EVENT_TYPE
			,START_ORDINAL
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,CONDITION_CONCEPT_ID ORDER BY EVENT_DATETIME
					,EVENT_TYPE
				) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
		FROM (
			-- select the start dates, assigning a row number to each
			SELECT PERSON_ID
				,CONDITION_CONCEPT_ID
				,CONDITION_START_DATETIME AS EVENT_DATETIME
				,- 1 AS EVENT_TYPE
				,ROW_NUMBER() OVER (
					PARTITION BY PERSON_ID
					,CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATETIME
					) AS START_ORDINAL
			FROM cteConditionTarget

			UNION ALL

			-- pad the end dates by 30 to allow a grace period for overlapping ranges.
			SELECT PERSON_ID
				,CONDITION_CONCEPT_ID
				,(CONDITION_END_DATETIME + 30)
				,1 AS EVENT_TYPE
				,NULL
			FROM cteConditionTarget
			) RAWDATA
		) E1
	INNER JOIN (
		SELECT PERSON_ID
			,CONDITION_CONCEPT_ID
			,CONDITION_START_DATETIME AS EVENT_DATETIME
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATETIME
				) AS START_ORDINAL
		FROM cteConditionTarget
		) E2 ON E1.PERSON_ID = E2.PERSON_ID
		AND E1.CONDITION_CONCEPT_ID = E2.CONDITION_CONCEPT_ID
		AND E2.EVENT_DATETIME <= E1.EVENT_DATETIME
	GROUP BY E1.PERSON_ID
		,E1.CONDITION_CONCEPT_ID
		,E1.EVENT_DATETIME
		,E1.START_ORDINAL
		,E1.OVERALL_ORD
	) E
WHERE (2 * E.START_ORDINAL) - E.OVERALL_ORD = 0;

/* / */

DROP TABLE cteConditionEnds IF EXISTS;

/* / */

CREATE TEMP TABLE cteConditionEnds

AS
SELECT
c.PERSON_ID
	,c.CONDITION_CONCEPT_ID
	,c.CONDITION_START_DATETIME
	,MIN(e.END_DATE) AS ERA_END_DATETIME

FROM
cteConditionTarget c
INNER JOIN cteCondEndDates e ON c.PERSON_ID = e.PERSON_ID
	AND c.CONDITION_CONCEPT_ID = e.CONDITION_CONCEPT_ID
	AND e.END_DATETIME >= c.CONDITION_START_DATETIME
GROUP BY c.PERSON_ID
	,c.CONDITION_CONCEPT_ID
	,c.CONDITION_START_DATETIME;

/* / */

INSERT INTO [CDM].[CDMSCHEMA].condition_era (
	condition_era_id
	,person_id
	,condition_concept_id
	,condition_era_start_datetime
	,condition_era_end_datetime
	,condition_occurrence_count
	)
SELECT row_number() OVER (
		ORDER BY person_id
		) AS condition_era_id
	,person_id
	,CONDITION_CONCEPT_ID
	,min(CONDITION_START_DATETIME) AS CONDITION_ERA_START_DATETIME
	,ERA_END_DATETIME AS CONDITION_ERA_END_DATETIME
	,COUNT(*) AS CONDITION_OCCURRENCE_COUNT
FROM cteConditionEnds
GROUP BY person_id
	,CONDITION_CONCEPT_ID
	,ERA_END_DATETIME;

