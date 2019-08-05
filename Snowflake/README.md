Common-Data-Model / Snowflake
=================

This folder contains the SQL scripts for Snowflake. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create a database for all OHDSI assets, if one does not already exist within your Snowflake account.

2. Within the OHDSI database, create a schema for the Common Data Model.

3. Open a Snowflake session and set the session context to use the database and schema referenced in Steps 1 and 2.

4. Set the session context to use an available Warehouse.

5. Execute the scripts `OMOP CDM snowflake ddl.txt`  and `OMOP CDM Results snowflake ddl.txt` to create the tables and fields.

6. Execute the script `OMOP CDM snowflake primary keys.txt` to add the minimum set of primary keys we recommend.

7. Execute the script `OMOP CDM snowflake constraints.txt` to add the foreign key constraints.

8. Load your data into the schema.

Optionally, before loading your data into the schema, execute the `OMOP CDM snowflake cluster keys.txt` in full or for individual tables to add cluster keys where indexes are used in other technologies.

Note: adding cluster keys will result in additional compute costs in Snowflake and should be considered carefully with respect to performance SLAs vs. compute costs.