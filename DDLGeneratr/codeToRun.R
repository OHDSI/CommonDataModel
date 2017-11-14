#This script is meant to create the OMOP Common Data Model DDLs for each dialect as well as the pdf of the documentation.


# Step 1: Update the file inst/sql/sql_server/OMOP CDM ddl.sql with the changes for the new version

# Step 2: Run the following code to create the DDLs for each dialect:

writeDDL("bigquery")
writeDDL("impala")
writeDDL("netezza")
writeDDL("oracle")
writeDDL("pdw")
writeDDL("postgresql")
writeDDL("redshift")
writeDDL("sql server")

# Step 3: Run the following code to create indices for Oracle, Postgres, PDW and Sql Server

writeIndex("oracle")

# Step 3: Update the .md wiki files with the changes for the new version

# step 4: Run the following code to create the pdf documentation. It will be written to the reports folder.

writePDF(mdFilesLocation = "../../Documentation/CommonDataModel_Wiki_Files", cdmVersion = "v5_3")
