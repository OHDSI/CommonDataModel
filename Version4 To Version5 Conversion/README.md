Conversion from CDM v4 to CDM v5
==============================================================

The scripts in this directory will aid you in moving your data from the Common Data Model (CDM) version 4 to version 5. 

Overview
==============================================================

The resources in this folder provide you with a means for converting your CDM V4 database to CDM V5. The goal of these scripts is to provide a path for converting your data to the CDM V5 to take advantage of the other tools that are being built to support research on CDM V5. These scripts are **NOT** designed to replace a proper ETL from your source data to CDM V5.

One of the most important aspects to this conversion script is the use of the **[Standarized Vocabularies](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:introduction "Standarized Vocabularies")** to map from tables in the V4 database to their cooresponding V5 table using the vocabulary **[domains](http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:domains "domains")**. At the beginning of the conversion script, we create a #concept\_map temporary table which holds a mapping from source_concept_id's to standard target_concept_ids for each of the domains. This table is then used throughout the remainder of the script to map rows from each of the source V4 tables (i.e. condition\_occurrence) to the proper table in the V5 data model. As a result, the number of rows in the V4 condition\_occurrence will not be the same as in V5 since some rows may be converted to a different table based on the standard concept mapping. 

Assumptions
==============================================================

We have created a directory per Relational Database Management System (RDBMS) that contains the conversion script for that database platform. All of the scripts have the same assumptions:

1. Your source CDM V4 database is on the same sever as your target CDM v5 database.
2. You have read rights to the CDM V4 database and database owner privileges on the target V5 database as this script will create an "ETL_WARNINGS" table in the process.
3. You have enough storage on your database server to perform the conversion. 

Usage
=====

1. **Create your V5 Target Database:** Create a CDM V5 database on the same server as your CDM V4 database by using the **[Common Data Model Scripts](https://github.com/OHDSI/CommonDataModel "Common Data Model Scripts")** for your RDBMS. **NOTE: Please review the data types that exist on your V4 database and ensure you carry forward any data type changes from V4 to V5. For example, if you converted columns from an INT to a BIGINT to accommodate tables with > 2.1 Billion Rows, you will need to make the corresponding changes in your V5 Database and potentially to this conversion script** 
 
2. **Load the V5 Vocabulary**: Download the V5 vocabulary from **[Athena](http://www.ohdsi.org/web/athena/ "Athena")** and load them into the V5 database created in step 1 above.

2. **Download the conversion script:** The **[CDM V4 to V5 Conversion](https://github.com/OHDSI/CommonDataModel/tree/master/Version4%20To%20Version5%20Conversion "CDM V4 to V5 Conversion Directory")** folder has subfolders with scripts that will work on each RDBMS.  In order to make this file work in your environment, you will need to perform a global "FIND AND REPLACE" on the conversion script to fill in the file with values that pertain to your environment. The following are the tokens you should use when doing your "FIND AND REPLACE" operation:
 
	 * [SOURCE_CDMV4] - Your V4 database name
	 * [SOURCE_CDMV4].[SCHEMA] - Your V4 database name + schema
     * [TARGET_CDMV5] - Your V5 database name
	 * [TARGET_CDMV5].[SCHEMA] - Your V5 database name + schema

3. Run the resulting script on your target RDBDMS. ** **NOTE** ** If you are running the Oracle script via Sql Developer or similar, you may need to alter the script to include the appropriate "/" symbols to mark the end of the anonymous code blocks. This has been done in the Oracle script that has been provided in this repository.
4. At the end of the conversion process, several tables will be produced that will help you to understand how your data has changed as a result of the conversion process. This is described in the Quality Assurance section below.


Quality Assurance
===================

At the end of the conversion script, there are 3 queries which will provide information on the conversion process. For reference, this section of the conversion script has a header comment:

/**** QUALITY ASSURANCE OUTPUT ****/

The first query provides a means for comparing the table row counts between the V4 and V5 databases.  As mentioned in the overview section above, table row counts will differ between V4 and V5 based on the way that the standard vocabulary maps the data. The next set of queries will help to tie out the row count changes in these tables. 

The second query shows the source V4 table (i.e condition\_occurrence) and how the row counts maps to the V5 domain. This table is useful to understand how the data from the V4 source was distributed into the V5 tables. As a note, 1 record in the V4 table could map to multiple records in V5 as some concepts will map to multiple standard domains.

The third query uses the information from the second query and provides a summary for each V5 domain. This is useful for tying out the rowcounts we'd expect from the script with the actual results observed in the first query. 

We have included a spreadsheet called "QA-Results.xlsx" which provides an example of how to utilize these 3 result queries to understand the results of the conversion process. The results of the first query go into the "Rowcounts" worksheet. The results of the second and third queries go into the "Classification Map Results" worksheet. If the conversion process worked as expected, all of the "Difference" columns should equal 0 in the "Classification Map Results" worksheet.

Getting Involved
==============================================================
Each script found in the RDBMS directory was generated from the OHDSI-SQL file: *OMOP CDMv4 to CDMv5 - OHDSI-SQL.sql* found in the root of this directory. If you would like to contribute to this script, we'd suggest you modify this script and use **[SqlRender](https://github.com/OHDSI/SqlRender "SqlRender")** to re-generate the specific RDBMS scripts. We have also supplied a basic R script in this directory to help re-generate the scripts using SqlRender.

Developer questions/comments/feedback: OHDSI Forum
We use the GitHub issue tracker for all bugs/issues/enhancements