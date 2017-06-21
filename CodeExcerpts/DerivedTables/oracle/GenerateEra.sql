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

PURPOSE: Use this script to convert your OMOP V4 common data model to CDM V5.

last revised: Jun 2017
authors:  Patrick Ryan, Chris Knoll, Anthony Sena, Vojtech Huser

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

ALTER SESSION SET current_schema = [TARGET_CDMV5];



/****

DRUG ERA
Note: Eras derived from DRUG_EXPOSURE table, using 30d gap

 ****/
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE iob2wlgwcteDrugTarget';
  EXECUTE IMMEDIATE 'DROP TABLE iob2wlgwcteDrugTarget';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

/* / */

-- Normalize DRUG_EXPOSURE_END_DATE to either the existing drug exposure end date, or add days supply, or add 1 day to the start date
CREATE TABLE iob2wlgwcteDrugTarget
 AS
SELECT
d.DRUG_EXPOSURE_ID
	,d.PERSON_ID
	,c.CONCEPT_ID
	,d.DRUG_TYPE_CONCEPT_ID
	,DRUG_EXPOSURE_START_DATE
	,COALESCE(DRUG_EXPOSURE_END_DATE, (DRUG_EXPOSURE_START_DATE + NUMTODSINTERVAL(DAYS_SUPPLY, 'day')), (DRUG_EXPOSURE_START_DATE + NUMTODSINTERVAL(1, 'day'))) AS DRUG_EXPOSURE_END_DATE
	,c.CONCEPT_ID AS INGREDIENT_CONCEPT_ID

FROM
[TARGET_CDMV5].[SCHEMA].DRUG_EXPOSURE d
INNER JOIN [TARGET_CDMV5].[SCHEMA].CONCEPT_ANCESTOR ca ON ca.DESCENDANT_CONCEPT_ID = d.DRUG_CONCEPT_ID
INNER JOIN [TARGET_CDMV5].[SCHEMA].CONCEPT c ON ca.ANCESTOR_CONCEPT_ID = c.CONCEPT_ID
  WHERE c.VOCABULARY_ID = 'RxNorm'
	AND c.CONCEPT_CLASS_ID = 'Ingredient' ;

/* / */

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE iob2wlgwcteEndDates';
  EXECUTE IMMEDIATE 'DROP TABLE iob2wlgwcteEndDates';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

/* / */

CREATE TABLE iob2wlgwcteEndDates
 AS
SELECT
PERSON_ID
	,INGREDIENT_CONCEPT_ID
	,(EVENT_DATE + NUMTODSINTERVAL(- 30, 'day')) AS END_DATE -- unpad the end date

FROM
(SELECT E1.PERSON_ID
		,E1.INGREDIENT_CONCEPT_ID
		,E1.EVENT_DATE
		,COALESCE(E1.START_ORDINAL, MAX(E2.START_ORDINAL)) START_ORDINAL
		,E1.OVERALL_ORD
	FROM (SELECT PERSON_ID
			,INGREDIENT_CONCEPT_ID
			,EVENT_DATE
			,EVENT_TYPE
			,START_ORDINAL
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,INGREDIENT_CONCEPT_ID ORDER BY EVENT_DATE
					,EVENT_TYPE
				) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
		FROM (SELECT PERSON_ID
				,INGREDIENT_CONCEPT_ID
				,DRUG_EXPOSURE_START_DATE AS EVENT_DATE
				,0 AS EVENT_TYPE
				,ROW_NUMBER() OVER (
					PARTITION BY PERSON_ID
					,INGREDIENT_CONCEPT_ID ORDER BY DRUG_EXPOSURE_START_DATE
					) AS START_ORDINAL
			FROM iob2wlgwcteDrugTarget

			  UNION ALL

			-- add the end dates with NULL as the row number, padding the end dates by 30 to allow a grace period for overlapping ranges.
			SELECT PERSON_ID
				,INGREDIENT_CONCEPT_ID
				,(DRUG_EXPOSURE_END_DATE + NUMTODSINTERVAL(30, 'day'))
				,1 AS EVENT_TYPE
				,NULL
			FROM iob2wlgwcteDrugTarget
			 ) RAWDATA
		 ) E1
	INNER JOIN (SELECT PERSON_ID
			,INGREDIENT_CONCEPT_ID
			,DRUG_EXPOSURE_START_DATE AS EVENT_DATE
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,INGREDIENT_CONCEPT_ID ORDER BY DRUG_EXPOSURE_START_DATE
				) AS START_ORDINAL
		FROM iob2wlgwcteDrugTarget
		 ) E2 ON E1.PERSON_ID = E2.PERSON_ID
		AND E1.INGREDIENT_CONCEPT_ID = E2.INGREDIENT_CONCEPT_ID
		AND E2.EVENT_DATE <= E1.EVENT_DATE
	GROUP BY E1.PERSON_ID
		,E1.INGREDIENT_CONCEPT_ID
		,E1.EVENT_DATE
		,E1.START_ORDINAL
		,E1.OVERALL_ORD
	 ) E
  WHERE 2 * E.START_ORDINAL - E.OVERALL_ORD = 0 ;

/* / */

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE iob2wlgwcteDrugExpEnds';
  EXECUTE IMMEDIATE 'DROP TABLE iob2wlgwcteDrugExpEnds';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

/* / */

CREATE TABLE iob2wlgwcteDrugExpEnds
  AS
SELECT
d.PERSON_ID
	,d.INGREDIENT_CONCEPT_ID
	,d.DRUG_TYPE_CONCEPT_ID
	,d.DRUG_EXPOSURE_START_DATE
	,MIN(e.END_DATE) AS ERA_END_DATE

FROM
iob2wlgwcteDrugTarget d
INNER JOIN iob2wlgwcteEndDates e ON d.PERSON_ID = e.PERSON_ID
	AND d.INGREDIENT_CONCEPT_ID = e.INGREDIENT_CONCEPT_ID
	AND e.END_DATE >= d.DRUG_EXPOSURE_START_DATE
GROUP BY d.PERSON_ID
	,d.INGREDIENT_CONCEPT_ID
	,d.DRUG_TYPE_CONCEPT_ID
	,d.DRUG_EXPOSURE_START_DATE ;

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
 FROM iob2wlgwcteDrugExpEnds
GROUP BY person_id
	,INGREDIENT_CONCEPT_ID
	,drug_type_concept_id
	,ERA_END_DATE ;





























/****

CONDITION ERA
Note: Eras derived from CONDITION_OCCURRENCE table, using 30d gap

 ****/
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE iob2wlgwcondition_era_phase_1';
  EXECUTE IMMEDIATE 'DROP TABLE iob2wlgwcondition_era_phase_1';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

/* / */

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE iob2wlgwcteConditionTarget';
  EXECUTE IMMEDIATE 'DROP TABLE iob2wlgwcteConditionTarget';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

/* / */

-- create base eras from the concepts found in condition_occurrence
CREATE TABLE iob2wlgwcteConditionTarget
  AS
SELECT
co.PERSON_ID
	,co.condition_concept_id
	,co.CONDITION_START_DATE
	,COALESCE(co.CONDITION_END_DATE, (CONDITION_START_DATE + NUMTODSINTERVAL(1, 'day'))) AS CONDITION_END_DATE

FROM
[TARGET_CDMV5].[SCHEMA].CONDITION_OCCURRENCE co ;

/* / */

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE iob2wlgwcteCondEndDates';
  EXECUTE IMMEDIATE 'DROP TABLE iob2wlgwcteCondEndDates';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

/* / */

CREATE TABLE iob2wlgwcteCondEndDates
 AS
SELECT
PERSON_ID
	,CONDITION_CONCEPT_ID
	,(EVENT_DATE + NUMTODSINTERVAL(- 30, 'day')) AS END_DATE -- unpad the end date

FROM
(SELECT E1.PERSON_ID
		,E1.CONDITION_CONCEPT_ID
		,E1.EVENT_DATE
		,COALESCE(E1.START_ORDINAL, MAX(E2.START_ORDINAL)) START_ORDINAL
		,E1.OVERALL_ORD
	FROM (SELECT PERSON_ID
			,CONDITION_CONCEPT_ID
			,EVENT_DATE
			,EVENT_TYPE
			,START_ORDINAL
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,CONDITION_CONCEPT_ID ORDER BY EVENT_DATE
					,EVENT_TYPE
				) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
		FROM (SELECT PERSON_ID
				,CONDITION_CONCEPT_ID
				,CONDITION_START_DATE AS EVENT_DATE
				,- 1 AS EVENT_TYPE
				,ROW_NUMBER() OVER (
					PARTITION BY PERSON_ID
					,CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATE
					) AS START_ORDINAL
			FROM iob2wlgwcteConditionTarget

			  UNION ALL

			-- pad the end dates by 30 to allow a grace period for overlapping ranges.
			SELECT PERSON_ID
				,CONDITION_CONCEPT_ID
				,(CONDITION_END_DATE + NUMTODSINTERVAL(30, 'day'))
				,1 AS EVENT_TYPE
				,NULL
			FROM iob2wlgwcteConditionTarget
			 ) RAWDATA
		 ) E1
	INNER JOIN (SELECT PERSON_ID
			,CONDITION_CONCEPT_ID
			,CONDITION_START_DATE AS EVENT_DATE
			,ROW_NUMBER() OVER (
				PARTITION BY PERSON_ID
				,CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATE
				) AS START_ORDINAL
		FROM iob2wlgwcteConditionTarget
		 ) E2 ON E1.PERSON_ID = E2.PERSON_ID
		AND E1.CONDITION_CONCEPT_ID = E2.CONDITION_CONCEPT_ID
		AND E2.EVENT_DATE <= E1.EVENT_DATE
	GROUP BY E1.PERSON_ID
		,E1.CONDITION_CONCEPT_ID
		,E1.EVENT_DATE
		,E1.START_ORDINAL
		,E1.OVERALL_ORD
	 ) E
  WHERE (2 * E.START_ORDINAL) - E.OVERALL_ORD = 0 ;

/* / */

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE iob2wlgwcteConditionEnds';
  EXECUTE IMMEDIATE 'DROP TABLE iob2wlgwcteConditionEnds';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

/* / */

CREATE TABLE iob2wlgwcteConditionEnds
  AS
SELECT
c.PERSON_ID
	,c.CONDITION_CONCEPT_ID
	,c.CONDITION_START_DATE
	,MIN(e.END_DATE) AS ERA_END_DATE

FROM
iob2wlgwcteConditionTarget c
INNER JOIN iob2wlgwcteCondEndDates e ON c.PERSON_ID = e.PERSON_ID
	AND c.CONDITION_CONCEPT_ID = e.CONDITION_CONCEPT_ID
	AND e.END_DATE >= c.CONDITION_START_DATE
GROUP BY c.PERSON_ID
	,c.CONDITION_CONCEPT_ID
	,c.CONDITION_START_DATE ;

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
 FROM iob2wlgwcteConditionEnds
GROUP BY person_id
	,CONDITION_CONCEPT_ID
	,ERA_END_DATE ;

