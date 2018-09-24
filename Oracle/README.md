Common-Data-Model / Oracle
=================

This folder contains the SQL scripts for Oracle. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `OMOP CDM oracle ddl.txt`  and `OMOP CDM Results oracle ddl.txt` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM oracle indexes.txt` to add the minimum set of indices and primary keys we recommend.

5. Execute the script `OMOP CDM oracle constraints.txt` to add the foreign key constraints.

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.

