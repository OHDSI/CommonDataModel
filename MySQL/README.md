Common-Data-Model / MySQL
=================

This folder contains the SQL scripts for MySQL. This was tested with MySQL v5.6. 

Note: This was derived from the Postgres migration. Performance has not been tested.

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `OMOP CDM ddl - MySQL.sql` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM indexes required - MySQL.sql` to add the minimum set of indexes we recommend (required before fk creation in MySQL).

5. Execute the script `OMOP CDM constraints - MySQL.sql` to add the constraints (primary and foreign keys). 

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.

Note: There is a possibility depending on configuration / foreign_key_check setting that one would need to load the data after schema creation.
