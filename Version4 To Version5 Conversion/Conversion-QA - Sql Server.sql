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

This script will use the metadata tables from the V4 and V5 tables to get a list
of all of the tables from each database and the rowcounts for each table in an 
effort to help you see how your data has changed through the conversion process.

In the results, we include a column to identify the tables that were part of 
the migration process in an effort to hone in on the key tables.

There is a Part 2 of this QA script which will also show you how data moved 
amongst some specific tables. 


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
--USE [TARGET_CDMV5]
USE [CDMV5_Conversion_Target]
GO

IF OBJECT_ID('tempdb..#v5_stats', 'U') IS NOT NULL
	DROP TABLE #v5_stats;

SELECT 
	DB_NAME() as DBName,
    t.NAME AS TableName,
    p.[Rows]
INTO #v5_stats
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.NAME NOT LIKE 'dt%' AND
    i.OBJECT_ID > 255 AND   
    i.index_id <= 1
GROUP BY 
    t.NAME, i.object_id, i.index_id, i.name, p.[Rows]
ORDER BY 
    object_name(i.object_id) 

--USE [SOURCE_CDMV4]
USE [CDM_TRUVEN_CCAE_6k]
GO

IF OBJECT_ID('tempdb..#v4_stats', 'U') IS NOT NULL
	DROP TABLE #v4_stats;

SELECT 
	DB_NAME() as DBName,
    t.NAME AS TableName,
    p.[Rows]
INTO #v4_stats
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.NAME NOT LIKE 'dt%' AND
    i.OBJECT_ID > 255 AND   
    i.index_id <= 1
GROUP BY 
    t.NAME, i.object_id, i.index_id, i.name, p.[Rows]
ORDER BY 
    object_name(i.object_id) 

DECLARE @MigrationTarget TABLE (TableName varchar(100))

INSERT INTO @MigrationTarget SELECT 'care_site'
INSERT INTO @MigrationTarget SELECT 'condition_era'
INSERT INTO @MigrationTarget SELECT 'condition_occurrence'
INSERT INTO @MigrationTarget SELECT 'death'
INSERT INTO @MigrationTarget SELECT 'device_exposure'
INSERT INTO @MigrationTarget SELECT 'drug_cost'
INSERT INTO @MigrationTarget SELECT 'drug_era'
INSERT INTO @MigrationTarget SELECT 'drug_exposure'
INSERT INTO @MigrationTarget SELECT 'location'
INSERT INTO @MigrationTarget SELECT 'measurement'
INSERT INTO @MigrationTarget SELECT 'observation'
INSERT INTO @MigrationTarget SELECT 'observation_period'
INSERT INTO @MigrationTarget SELECT 'payer_plan_period'
INSERT INTO @MigrationTarget SELECT 'person'
INSERT INTO @MigrationTarget SELECT 'procedure_cost'
INSERT INTO @MigrationTarget SELECT 'procedure_occurrence'
INSERT INTO @MigrationTarget SELECT 'provider'
INSERT INTO @MigrationTarget SELECT 'visit_occurrence'

select
	ISNULL(V4.DBName, 'No V4 Table Equivalent') as "Database Name",
	v4.TableName,
	v4.rows,
	ISNULL(V5.DBName, 'No V5 Table Equivalent') as "Database Name",
	v5.TableName,
	v5.rows,
	CASE WHEN mt.TableName IS NULL THEN 'N' ELSE 'Y' END AS "Migration Target",
	ISNULL(v5.Rows, 0) - ISNULL(v4.Rows, 0) AS "Row Count Change"
from #v4_stats as v4
full outer join #v5_stats as v5 ON v4.TableName = v5.TableName
left join @MigrationTarget mt on v5.TableName = mt.TableName
order by v5.TableName



