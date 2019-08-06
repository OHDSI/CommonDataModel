Common-Data-Model / Vocabularies / Snowflake
=================

This folder contains the SQL scripts for loading the vocabularies into the CDM data model v6 via Snowflake. 

In order to load the vocabularies into the Common Data Model Version 6 in your Snowflake account, you will need to complete the following prerequisites:

1. Complete the steps to instantiate the Common Data Model version 6 in a dedicated schema and database within your Snowflake account.

2. Download the CDM Vocabulary files you require from http://athena.ohdsi.org/ and unzip to a directory on your machine.

After you have completed the prerequisites, we recommend following these steps:

1. Open a Snowflake session and set the session context to use the OHDSI database and Common Data Model schema you created in your Snowflake account.

2. Set the session context to use an available Warehouse.

3. Execute the script `create vocabularies file format.sql` to create the file format to parse the vocabulary files.

4. Execute the script `OMOP CDM vocabulary load - Snowflake.sql` in full or for individual tables to stage the vocabulary files and load them into the CDM vocabulary tables.

Note: the script `OMOP CDM vocabulary load - Snowflake.sql` makes several assumptions that you will need to mimic or modify so that the script will execute in your environment:
  - The SnowSQL CLI client is being utilized to complete the loads; the SnowSQL CLI client can be downloaded from the Snowflake User/Web Interface for your account.
  - The dedicated schema and database for the Common Data Model have already been created in your Snowflake account.
  - The file format "OHDSI_VOCABULARIES_FF" has been created in the dedicated schema and database for the Common Data Model in your Snowflake account.
  - The CDM version 5 vocabulary zip file has been unzipped into the "<<User Home>>/Desktop" directory on a Mac; modify as required for your OS and file directory. 
  - The script is executed manually via SnowSQL CLI using the above assumptions and settings; the script can instead be used as a template for the steps you must script in an automated code base and/or for translation into your selected data integration tool.