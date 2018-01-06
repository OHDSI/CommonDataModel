Common-Data-Model / PostgreSQL
=================

This folder contains the SQL scripts for PostgreSQL. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `OMOP CDM postgresql ddl.txt` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM postgresql constraints.txt` to add the constraints (primary keys). 

5. Execute the script `OMOP CDM postgresql indexes required.txt` to add the minimum set of indexes and foreign keys we recommend.

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.
