Common-Data-Model / SQL Server
=================

This folder contains the SQL scripts for SQL Server. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `OMOP CDM ddl - SQL Server.sql` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM constraints - SQL Server.sql` to add the constraints (primary and foreign keys). 

5. Execute the script `OMOP CDM indexes required - SQL Server.sql` to add the minimum set of indexes we recommend.

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.
