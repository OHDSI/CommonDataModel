Common-Data-Model / Exasol
=================

This folder contains the SQL scripts for Exasol. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `OMOP CDM exasol ddl.txt` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM exasol pk.txt` to add the minimum set of primary keys

5. Execute the script `OMOP CDM exasol constraints.txt` to add the constraints (foreign keys).

6. Repeat steps 1-3, executing the script `OMOP CDM Results exasol ddl.txt`
