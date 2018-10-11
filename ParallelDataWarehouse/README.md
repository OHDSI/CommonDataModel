Common-Data-Model / Parallel Data Warehouse
=================

This folder contains the script for Parallel Data Warehouse. 

n order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `OMOP CDM pdw ddl.txt` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM pdw indexes.txt` to add the minimum set of indices and primary keys we recommend.

5. Execute the script `OMOP CDM pdw constraints.txt` to add the foreign key constraints.

6. Create an empty schema for results.

7. Execute the script `OMOP CDM Results pdw ddl.txt` to create the tables and fields in the results schema.
