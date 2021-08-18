#This script is meant to create the OMOP Common Data Model DDLs for each dialect as well as the pdf of the documentation.

# Step 1-2 from README: Create new csv files "..._Field_Level.csv" and "..._Table_Level.csv" in inst/csv for the new version and make changes to the files reflecting
# the new CDM versions. Set the below variable to indicate the version of the cdm you are creating. This will be used for the name of the pdf so, for
# example, write v5.3 as v5_3.

  cdmVersion <- "5.3.1"

# Step 3: After creating the csv files for the new version, create the sql server DDL from the file

    s <- CdmDdlBase::createDdlFromFile(cdmVersion)

  # Step 3.1: Create the primary key constraints for the new version

    p <- CdmDdlBase::createPkFromFile(cdmVersionNum = cdmVersion,
                                      cdmFieldCsvLoc = "inst/csv/OMOP_CDMv6.0_Field_Level.csv")

  # Step 3.2: Create the foreign key constraints for the new version

    f <- CdmDdlBase::createFkFromFile(cdmVersionNum = cdmVersion,
                                      cdmFieldCsvLoc = "inst/csv/OMOP_CDMv6.0_Field_Level.csv")
# At this point you should rebuild the package

# Step 4: Run the following code to render the DDLs for each dialect. These will be used for testing on the ohdsi servers which is why the cdmDatabaseSchema is specified.

writeDDL(targetdialect = "oracle",
         cdmVersion = cdmVersion,
         sqlFilename = paste0("OMOP CDM ddl ", cdmVersion, " ", Sys.Date(), ".sql"),
         cdmDatabaseSchema = "OHDSI",
         cleanUpScript = F) #oracle syntax for removing tables is weird, set this to F and make any changes to the raw file

writeDDL(targetdialect = "postgresql",
         cdmVersion = cdmVersion,
         sqlFilename = paste0("OMOP CDM ddl ", cdmVersion, " ", Sys.Date(), ".sql"),
         cdmDatabaseSchema = "ohdsi",
         cleanUpScript = F) #This needs to be updated manually right now

writeDDL(targetdialect = "sql server",
         cdmVersion = cdmVersion,
         sqlFilename = paste0("OMOP CDM ddl ", cdmVersion, " ", Sys.Date(), ".sql"),
         cdmDatabaseSchema = "ohdsi.dbo",
         cleanUpScript = F) #This needs to be updated manually right now

# Step 5: Run the following code to render the primary key constraints for Oracle, Postgres, and Sql Server

writePrimaryKeys(targetdialect = "oracle",
                 cdmVersion = cdmVersion,
                 sqlFilename = paste0("OMOP CDM pk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 cdmDatabaseSchema = "OHDSI")


writePrimaryKeys(targetdialect = "postgresql",
                 cdmVersion = cdmVersion,
                 sqlFilename = paste0("OMOP CDM pk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 cdmDatabaseSchema = "ohdsi")


writePrimaryKeys(targetdialect = "sql server",
                 cdmVersion = cdmVersion,
                 sqlFilename = paste0("OMOP CDM pk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 cdmDatabaseSchema = "ohdsi.dbo")

# Step 6: Run the following code to render the foreign key constraints for Oracle, Postgres, and Sql Server

writeConstraints("oracle",
                 cdmVersion,
                 sqlFileName = paste0("OMOP CDM fk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 "OHDSI")

writeConstraints("postgresql",
                 cdmVersion,
                 sqlFileName = paste0("OMOP CDM fk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 "ohdsi")

writeConstraints("sql server",
                 cdmVersion,
                 sqlFileName = paste0("OMOP CDM fk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 "ohdsi.dbo")

# Step 7: Run the following code to render the indices for Oracle, Postgres, and Sql Server

writeIndex("oracle", ### NOTE: ORACLE CREATES AUTO INDEXING AND NEED TO UPDATE INST/INDEX FILE TO REPRESENT IT
           cdmVersion,
           sqlFilename = "OMOP CDM indices v6_0.sql",
           "OHDSI")

writeIndex("postgresql",
           cdmVersion,
           sqlFilename = "OMOP CDM indices v6_0.sql",
           "ohdsi")

writeIndex("sql server",
           cdmVersion,
           sqlFilename = "OMOP CDM indices v6_0.sql",
           "ohdsi.dbo")


##############################
# RUN THE TESTTHAT.R TO TEST ORACLE, POSTGRES, AND SQLSERVER


# Step 8: After testing the files for Oracle, Postgres, and Sql Server run the following to create the files for all dialects. Oracle
# Postgres and Sql Server are rewritten to overwrite the cdmDatabaseSchema with a token.


for (targetdialect in c("oracle", "postgresql", "pdw", "redshift", "impala", "netezza", "bigquery", "sql server")) {
  writeDDL(targetdialect = targetdialect,
           cdmVersion = cdmVersion)
}


## Write all primary keys

writePrimaryKeys(targetdialect = "oracle",
                 cdmVersion = cdmVersion,
                 sqlFilename = paste0("OMOP CDM pk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 cdmDatabaseSchema = "@cdmDatabaseSchema")


writePrimaryKeys(targetdialect = "postgresql",
                 cdmVersion = cdmVersion,
                 sqlFilename = paste0("OMOP CDM pk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 cdmDatabaseSchema = "@cdmDatabaseSchema")


writePrimaryKeys(targetdialect = "sql server",
                 cdmVersion = cdmVersion,
                 sqlFilename = paste0("OMOP CDM pk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 cdmDatabaseSchema = "@cdmDatabaseSchema")

writePrimaryKeys(targetdialect = "netezza",
                 cdmVersion = cdmVersion,
                 sqlFilename = paste0("OMOP CDM pk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 cdmDatabaseSchema = "@cdmDatabaseSchema")

## write all foreign key constraints

writeConstraints("oracle",
                 cdmVersion,
                 sqlFileName = paste0("OMOP CDM fk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 "@cdmDatabaseSchema")

writeConstraints("postgresql",
                 cdmVersion,
                 sqlFileName = paste0("OMOP CDM fk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 "@cdmDatabaseSchema")

writeConstraints("sql server",
                 cdmVersion,
                 sqlFileName = paste0("OMOP CDM fk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 "@cdmDatabaseSchema")

writeConstraints("pdw",
                 cdmVersion,
                 sqlFileName = paste0("OMOP CDM fk ", cdmVersion, " ", Sys.Date(), ".sql"),
                 "@cdmDatabaseSchema")

## write all indices

writeIndex("oracle", ### NOTE: ORACLE CREATES AUTO INDEXING AND NEED TO UPDATE INST/INDEX FILE TO REPRESENT IT
           cdmVersion,
           sqlFilename = "OMOP CDM indices v5_3_1.sql",
           "@cdmDatabaseSchema")

writeIndex("postgresql",
           cdmVersion,
           sqlFilename = "OMOP CDM indices v5_3_1.sql",
           "@cdmDatabaseSchema")

writeIndex("sql server",
           cdmVersion,
           sqlFilename = "OMOP CDM indices v5_3_1.sql",
           "@cdmDatabaseSchema")

writeIndex("pdw",
           cdmVersion,
           sqlFilename = "OMOP CDM indices v5_3_1.sql",
           "@cdmDatabaseSchema")


#############
# BE SURE TO RUN THE EXTRAS/SITEMAINTENANCE.R BEFORE CREATING THE PDF

# step 9: Run the following code to create the pdf documentation. It will be written to the reports folder. Use knit with pagedown
pagedown::chrome_print("rmd/cdm531.Rmd") # create a comprehensive rmd with background, conventions, etc like https://stackoverflow.com/questions/25824795/how-to-combine-two-rmarkdown-rmd-files-into-a-single-output

# Step 10: After updating any of the .Rmd files, rendering the site following directions in SiteMaintenance.R, then move the files to the CommonDataModel directory

newdir <- "C:/Git/Github/CommonDataModel/docs"
currentdir <- paste0(getwd(),"/docs/")


file.copy(currentdir, newdir, recursive = TRUE, overwrite = TRUE)



