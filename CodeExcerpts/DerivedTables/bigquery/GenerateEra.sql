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

use [cdm];



/****

DRUG ERA
Note: Eras derived from DRUG_EXPOSURE table, using 30d gap

 ****/
DROP TABLE IF EXISTS n7cbw799ctedrugtarget;

/* / */

-- Normalize DRUG_EXPOSURE_END_DATETIME to either the existing drug exposure end date, or add days supply, or add 1 day to the start date
CREATE TABLE n7cbw799ctedrugtarget
 AS
SELECT
d.drug_exposure_id
	,d.person_id
	,c.concept_id
	,d.drug_type_concept_id
	,drug_exposure_start_datetime
	,coalesce(drug_exposure_end_datetime, DATE_ADD(IF(SAFE_CAST(drug_exposure_start_datetime  AS DATE) IS NULL,PARSE_DATE('%Y%m%d', cast(drug_exposure_start_datetime  AS STRING)),SAFE_CAST(drug_exposure_start_datetime  AS DATE)), interval days_supply DAY), DATE_ADD(IF(SAFE_CAST(drug_exposure_start_datetime  AS DATE) IS NULL,PARSE_DATE('%Y%m%d', cast(drug_exposure_start_datetime  AS STRING)),SAFE_CAST(drug_exposure_start_datetime  AS DATE)), interval 1 DAY)) as drug_exposure_end_datetime
	,c.concept_id as ingredient_concept_id

FROM
[cdm].[cdmschema].drug_exposure d
inner join [cdm].[cdmschema].concept_ancestor ca on ca.descendant_concept_id = d.drug_concept_id
inner join [cdm].[cdmschema].concept c on ca.ancestor_concept_id = c.concept_id
where c.vocabulary_id = 'RxNorm'
	and c.concept_class_id = 'Ingredient';

/* / */

DROP TABLE IF EXISTS n7cbw799cteenddates;

/* / */

CREATE TABLE n7cbw799cteenddates
 AS
SELECT
person_id
	,ingredient_concept_id
	,DATE_ADD(IF(SAFE_CAST(event_datetime  AS DATE) IS NULL,PARSE_DATE('%Y%m%d', cast(event_datetime  AS STRING)),SAFE_CAST(event_datetime  AS DATE)), interval - 30 DAY) as end_datetime -- unpad the end date

FROM
(
	 select e1.person_id
		,e1.ingredient_concept_id
		,e1.event_datetime
		,coalesce(e1.start_ordinal, max(e2.start_ordinal)) start_ordinal
		,e1.overall_ord
	 from (
		select person_id
			,ingredient_concept_id
			,event_datetime
			,event_type
			,start_ordinal
			,row_number() over (
				partition by person_id
				,ingredient_concept_id order by event_datetime
					,event_type
				) as overall_ord -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
		from (
			-- select the start dates, assigning a row number to each
			select person_id
				,ingredient_concept_id
				,drug_exposure_start_datetime as event_datetime
				,0 as event_type
				,row_number() over (
					partition by person_id
					,ingredient_concept_id order by drug_exposure_start_datetime
					) as start_ordinal
			from n7cbw799ctedrugtarget

			union all

			-- add the end dates with NULL as the row number, padding the end dates by 30 to allow a grace period for overlapping ranges.
			select person_id
				,ingredient_concept_id
				,DATE_ADD(IF(SAFE_CAST(drug_exposure_end_datetime  AS DATE) IS NULL,PARSE_DATE('%Y%m%d', cast(drug_exposure_end_datetime  AS STRING)),SAFE_CAST(drug_exposure_end_datetime  AS DATE)), interval 30 DAY)
				,1 as event_type
				,null
			from n7cbw799ctedrugtarget
			) rawdata
		) e1
	inner join (
		select person_id
			,ingredient_concept_id
			,drug_exposure_start_datetime as event_datetime
			,row_number() over (
				partition by person_id
				,ingredient_concept_id order by drug_exposure_start_datetime
				) as start_ordinal
		from n7cbw799ctedrugtarget
		) e2 on e1.person_id = e2.person_id
		and e1.ingredient_concept_id = e2.ingredient_concept_id
		and e2.event_datetime <= e1.event_datetime
	 group by  e1.person_id
		, e1.ingredient_concept_id
		, e1.event_datetime
		, e1.start_ordinal
		, e1.overall_ord
	 ) e
where 2 * e.start_ordinal - e.overall_ord = 0;

/* / */

DROP TABLE IF EXISTS n7cbw799ctedrugexpends;

/* / */

 CREATE TABLE n7cbw799ctedrugexpends
  AS
SELECT
d.person_id
	,d.ingredient_concept_id
	,d.drug_type_concept_id
	,d.drug_exposure_start_datetime
	,min(e.end_datetime) as era_end_datetime

FROM
n7cbw799ctedrugtarget d
inner join n7cbw799cteenddates e on d.person_id = e.person_id
	and d.ingredient_concept_id = e.ingredient_concept_id
	and e.end_datetime >= d.drug_exposure_start_datetime
 group by  d.person_id
	, d.ingredient_concept_id
	, d.drug_type_concept_id
	, d.drug_exposure_start_datetime ;

/* / */

insert into [cdm].[cdmschema].drug_era
 select row_number() over (
		order by person_id
		) as drug_era_id
	,person_id
	,ingredient_concept_id
	,min(drug_exposure_start_datetime) as drug_era_start_datetime
	,era_end_datetime
	,count(*) as drug_exposure_count
	,30 as gap_days
 from n7cbw799ctedrugexpends
 group by  1, 3, drug_type_concept_id
	, 5 ;



/****

CONDITION ERA
Note: Eras derived from CONDITION_OCCURRENCE table, using 30d gap

 ****/
DROP TABLE IF EXISTS n7cbw799condition_era_phase_1;

/* / */

DROP TABLE IF EXISTS n7cbw799cteconditiontarget;

/* / */

-- create base eras from the concepts found in condition_occurrence
CREATE TABLE n7cbw799cteconditiontarget
 AS
SELECT
co.person_id
	,co.condition_concept_id
	,co.condition_start_datetime
	,coalesce(co.condition_end_datetime, DATE_ADD(IF(SAFE_CAST(condition_start_datetime  AS DATE) IS NULL,PARSE_DATE('%Y%m%d', cast(condition_start_datetime  AS STRING)),SAFE_CAST(condition_start_datetime  AS DATE)), interval 1 DAY)) as condition_end_datetime

FROM
[cdm].[cdmschema].condition_occurrence co;

/* / */

DROP TABLE IF EXISTS n7cbw799ctecondenddates;

/* / */

CREATE TABLE n7cbw799ctecondenddates
 AS
SELECT
person_id
	,condition_concept_id
	,DATE_ADD(IF(SAFE_CAST(event_datetime  AS DATE) IS NULL,PARSE_DATE('%Y%m%d', cast(event_datetime  AS STRING)),SAFE_CAST(event_datetime  AS DATE)), interval - 30 DAY) as end_datetime -- unpad the end date

FROM
(
	 select e1.person_id
		,e1.condition_concept_id
		,e1.event_datetime
		,coalesce(e1.start_ordinal, max(e2.start_ordinal)) start_ordinal
		,e1.overall_ord
	 from (
		select person_id
			,condition_concept_id
			,event_datetime
			,event_type
			,start_ordinal
			,row_number() over (
				partition by person_id
				,condition_concept_id order by event_datetime
					,event_type
				) as overall_ord -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
		from (
			-- select the start dates, assigning a row number to each
			select person_id
				,condition_concept_id
				,condition_start_datetime as event_datetime
				,- 1 as event_type
				,row_number() over (
					partition by person_id
					,condition_concept_id order by condition_start_datetime
					) as start_ordinal
			from n7cbw799cteconditiontarget

			union all

			-- pad the end dates by 30 to allow a grace period for overlapping ranges.
			select person_id
				,condition_concept_id
				,DATE_ADD(IF(SAFE_CAST(condition_end_datetime  AS DATE) IS NULL,PARSE_DATE('%Y%m%d', cast(condition_end_datetime  AS STRING)),SAFE_CAST(condition_end_datetime  AS DATE)), interval 30 DAY)
				,1 as event_type
				,null
			from n7cbw799cteconditiontarget
			) rawdata
		) e1
	inner join (
		select person_id
			,condition_concept_id
			,condition_start_datetime as event_datetime
			,row_number() over (
				partition by person_id
				,condition_concept_id order by condition_start_datetime
				) as start_ordinal
		from n7cbw799cteconditiontarget
		) e2 on e1.person_id = e2.person_id
		and e1.condition_concept_id = e2.condition_concept_id
		and e2.event_datetime <= e1.event_datetime
	 group by  e1.person_id
		, e1.condition_concept_id
		, e1.event_datetime
		, e1.start_ordinal
		, e1.overall_ord
	 ) e
where (2 * e.start_ordinal) - e.overall_ord = 0;

/* / */

DROP TABLE IF EXISTS n7cbw799cteconditionends;

/* / */

 CREATE TABLE n7cbw799cteconditionends
  AS
SELECT
c.person_id
	,c.condition_concept_id
	,c.condition_start_datetime
	,min(e.end_date) as era_end_datetime

FROM
n7cbw799cteconditiontarget c
inner join n7cbw799ctecondenddates e on c.person_id = e.person_id
	and c.condition_concept_id = e.condition_concept_id
	and e.end_datetime >= c.condition_start_datetime
 group by  c.person_id
	, c.condition_concept_id
	, c.condition_start_datetime ;

/* / */

insert into [cdm].[cdmschema].condition_era (
	condition_era_id
	,person_id
	,condition_concept_id
	,condition_era_start_datetime
	,condition_era_end_datetime
	,condition_occurrence_count
	)
 select row_number() over (
		order by person_id
		) as condition_era_id
	,person_id
	,condition_concept_id
	,min(condition_start_datetime) as condition_era_start_datetime
	,era_end_datetime as condition_era_end_datetime
	,count(*) as condition_occurrence_count
 from n7cbw799cteconditionends
 group by  1, 3, 5 ;

