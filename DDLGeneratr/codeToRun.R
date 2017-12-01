#This script is meant to create the OMOP Common Data Model DDLs for each dialect as well as the pdf of the documentation.


# Step 1: Update the file inst/sql/sql_server/OMOP CDM ddl.sql with the changes for the new version and set the below variables

  # Step 1.1: The version of the CDM you are writing. This will be used for the name of the pdf so, for example, write v5.3 as v5_3
  cdmVersion <- "v5_3"

  # Step 1.2: The location of the wiki markdown files. The default is "../../Documentation/CommonDataModel_Wiki_Files"
  mdFilesLocation <- "../../Documentation/CommonDataModel_Wiki_Files"

# Step 2: Run the following code to create the DDLs for each dialect:

writeDDL("bigquery")
writeDDL("impala")
writeDDL("netezza")
writeDDL("oracle")
writeDDL("pdw")
writeDDL("postgresql")
writeDDL("redshift")
writeDDL("sql server")

# Step 3: Run the following code to create the primary key constraints and index files for Oracle, Postgres, PDW and Sql Server

writeIndex("oracle")
writeIndex("postgresql")
writeIndex("pdw")
writeIndex("sql server")

# Step 4: Run the following code to create primary key constraints for Netezza

writePrimaryKeys("netezza")

# Step 5: Run the following code to create foreign key constraints for Oracle, Postgres, PDW and Sql Server

writeConstraints("oracle")
writeConstraints("postgresql")
writeConstraints("pdw")
writeConstraints("sql server")

# step 6: Run the following code to create the pdf documentation. It will be written to the reports folder.

rmarkdown::render("reports/OMOP_CDM_PDF.Rmd",
                  output_format = "pdf_document",
                  output_file = paste0("OMOP_CDM_",cdmVersion,".pdf"),
                  params = list(mdFilesLocation = mdFilesLocation))
