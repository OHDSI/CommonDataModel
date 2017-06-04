Common-Data-Model / SQL Server
=================

This folder contains the SQL scripts for SQL Server. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `CDM V4 ddl.sql` to create the tables and fields.

3. Load your data into the schema using the loading scripts in VocabImport

Note: you could also apply the constraints and the indexes after loading the data, this will speed up the insertion of the data considerably.
