Common-Data-Model / Oracle
=================

This folder contains the SQL scripts for Oracle. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `OMOP CDM ddl - Oracle.sql` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM constraints - Oracle.sql` to add the constraints (primary and foreign keys). 

5. Execute the script `OMOP CDM indexes required - Oracle - With constraints.sql` to add the minimum set of indexes we recommend.

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.

Also note: you can apply the indexes without first applying the constraints, but then we recommend you use the script `OMOP CDM indexes required - Oracle - Without constraints.sql`. (This script will also create the indexes that would normally be automatically created by the primary key constraints.)
