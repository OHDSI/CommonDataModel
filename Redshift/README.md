Common-Data-Model / Redshift
=================

This folder contains the SQL scripts for Amazon Redshift. 

In order to create your instantiation of the Common Data Model, we recommend following these steps:

1. Create an empty schema.

2. Set the search_path to that schema.

3. Execute the script `OMOP CDM redshift ddl.txt` to create the tables and fields.

4. Load your data into the schema using COPY commands from Amazon S3.