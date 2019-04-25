Common-Data-Model / Oracle
=================

This folder contains the SQL scripts for Oracle. These scripts were created by running the Sql Server ddl, constraint, and primary key files through [SqlRender](https://github.com/ohdsi/sqlrender) to translate them to Oracle. They were then tested for syntax errors by running them on an empty Oracle database. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema or identify the schema you would like to use for your OMOP instance.

2. Execute the script `OMOP CDM oracle [cdmVersion] ddl.sql` and `OMOP CDM Results oracle ddl.txt` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM oracle [cdmVersion] pk indexes.sql` to add the minimum set of indices and primary keys we recommend.

5. Execute the script `OMOP CDM oracle [cdmVersion] constraints.sql` to add the foreign key constraints.

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.

