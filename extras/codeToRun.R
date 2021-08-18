# This script is meant to create the OMOP Common Data Model DDLs for each dialect as well as the pdf of the documentation.

# For a given cdmVersion, create all ddl sql files for every sql dialect
# Results are written to ddl/cdm_version/dialect.
cdmVersion <- "5.3.1"

for (targetdialect in c("oracle", "postgresql", "pdw", "redshift", "impala", "netezza", "bigquery", "sql server")) {
  writeDDL(targetdialect = targetdialect,
           cdmVersion = cdmVersion)

  writePrimaryKeys(targetdialect = targetdialect,
                   cdmVersion = cdmVersion)

  writeConstraints(targetdialect = targetdialect,
                   cdmVersion = cdmVersion)

  writeIndex(targetdialect = targetdialect,
             cdmVersion = cdmVersion)
}


#############
# BE SURE TO RUN THE EXTRAS/SITEMAINTENANCE.R BEFORE CREATING THE PDF

# step 9: Run the following code to create the pdf documentation. It will be written to the reports folder. Use knit with pagedown
pagedown::chrome_print("rmd/cdm531.Rmd") # create a comprehensive rmd with background, conventions, etc like https://stackoverflow.com/questions/25824795/how-to-combine-two-rmarkdown-rmd-files-into-a-single-output

# Step 10: After updating any of the .Rmd files, rendering the site following directions in SiteMaintenance.R, then move the files to the CommonDataModel directory

newdir <- "C:/Git/Github/CommonDataModel/docs"
currentdir <- paste0(getwd(),"/docs/")


file.copy(currentdir, newdir, recursive = TRUE, overwrite = TRUE)



