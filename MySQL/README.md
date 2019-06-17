Common-Data-Model / MySQL
=================

This folder contains the SQL scripts for MySQL. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema. CREATE DATABASE omop;

2. Execute the script `OMOP CDM mysql ddl.sql` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM MySQL pk indexes.sql` to add the minimum set of indexes and primary keys we recommend.

5. Execute the script `OMOP CDM MySQL constraints.sql` to add the constraints (foreign keys). 

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.

6. Repeat steps 1-3, executing the script `OMOP CDM Results MySQL ddl.sql`