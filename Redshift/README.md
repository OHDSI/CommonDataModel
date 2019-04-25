Common-Data-Model / Redshift
=================

This folder contains the SQL scripts for Amazon Redshift. *PLEASE NOTE* this dialect is not fully supported, meaning it has not been tested. This script was created by running the Sql Server ddl through [SqlRender](https://github.com/ohdsi/sqlrender) in order to translate it to Redshift and it may not have accounted for all idiosyncrasies.

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema or identify the schema you would like to use for your OMOP instance.

2. Set the search_path to that schema.

3. Execute the script `OMOP CDM redshift [cdmVersion] ddl.sql` to create the tables and fields.

4. Load your data into the schema using COPY commands from Amazon S3.

5. Repeat to create the results schema, executing the script `OMOP CDM Results redshift ddl.txt`