Common-Data-Model / Parallel Data Warehouse
=================

This folder contains the script for Parallel Data Warehouse. *PLEASE NOTE* this dialect is not fully supported, meaning it has not been tested. This script was created by running the Sql Server ddl through [SqlRender](https://github.com/ohdsi/sqlrender) in order to translate it to PDW and it may not have accounted for all idiosyncrasies.

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema or identify the schema you would like to use for your OMOP instance.

2. Execute the script `OMOP CDM pdw [cdmVersion] ddl.txt` to create the tables and fields.

3. Load your data into the schema.

4. Execute the script `OMOP CDM pdw [cdmVersion] pk indexes.sql` to add the minimum set of indices and primary keys we recommend.

5. Execute the script `OMOP CDM pdw [cdmVersion] constraints.sql` to add the foreign key constraints.

6. Create an empty schema for results.

7. Execute the script `OMOP CDM Results pdw ddl.txt` to create the tables and fields in the results schema.
