Common-Data-Model / IBM DB2
=================

This folder contains the SQL scripts for IBM DB2. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `OMOP CDM IBM DB2 ddl.sql` to create the tables and fields.

3. Execute the script `OMOP CDM IBM DB2 pk indexes.sql` to add the minimum set of indexes and primary keys we recommend.

4. Execute the script `OMOP CDM IBM DB2 constraints.sql` to add the constraints (foreign keys). 

5. Load your data into the schema (`VocabImport/OMOP CDM vocabulary load - IBM DB2.md` can be used as a guide)

6. Repeat steps 1-3, executing the script `OMOP CDM Results IBM DB2 ddl.sql`
