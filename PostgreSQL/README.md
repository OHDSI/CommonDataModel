Common-Data-Model / PostgreSQL
=================

This folder contains the SQL scripts for PostgreSQL. These scripts were created by running the Sql Server ddl, constraint, and primary key files through [SqlRender](https://github.com/ohdsi/sqlrender) to translate them to PostgreSQL. They were then tested for syntax errors by running them on an empty PostgreSQL database. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema or identify the schema you would like to use for your OMOP instance.

2. Execute the script `OMOP CDM postgresql [cdmVersion] ddl.sql` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM postgresql [cdmVersion] pk indexes.sql` to add the minimum set of indexes and primary keys we recommend.

5. Execute the script `OMOP CDM postgresql [cdmVersion] constraints.txt` to add the constraints (foreign keys). 

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.

6. Repeat steps 1-3, executing the script `OMOP CDM Results postgresql ddl.txt`
