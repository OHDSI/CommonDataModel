Common-Data-Model / SQL Server
=================

This folder contains the SQL scripts for SQL Server. These scripts were tested for syntax errors by running them on an empty Sql Server database. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema or identify the schema you would like to use for your OMOP instance.

2. Execute the script `OMOP CDM sql server [cdmVersion] ddl.sql` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM sql server [cdmVersion] pk indexes.txt` to add the minimum set of indices and primary keys we recommend.

5. Execute the script `OMOP CDM sql server [cdmVersion] constraints.txt` to add the foreign key constraints.

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.

6. Repeat steps 1-3, executing the script `OMOP CDM Results sql server ddl.txt` to create the results schema
