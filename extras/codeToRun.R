

# CommonDataModel/extras/codeToRun.R
# 
# For each of a bunch of SQL dialects, this script reads a pair of metadata CSV files 
# and generates  a world of DDL from them. Files are generated for table DDL,
# primary key DDL and foreign key DDL.
# It assumes the current directory is the top of the git repo. 
# The CSV files are in inst/csv and start with OMOP_CDM.
# The resulting dialect-specific files are deposited into the output directory
# with subdirectories for each dialect.
#
# RUNNING:
# From a command shell with the current directory as the top of the git repo, run this as follows:
# shell> Rscript extras/codeToRun.R
#
# ISSUES/TODO:
#   Working in test-mode in a git repository, I wanted to avoid the need for
#   creating a package as part of running this. In this version, I directly 
#   source the R code and read files without concern of package location.
#
#   I haven't gotten the documentation generation to work.
#
#   The CSV files indicate the version with a string like v6.0, and the output SQL/DDL files write it like V6_0.
#
#   Automate the tests from this script. Fail obviously if they don't pass. To that, this code doesn't
#   write the first three (sql server, oracle, postgresql) dialects back into inst/sql/. The tests might
#   expect them there.
#
# MODS
#   I got clever with a little dataframe of metadata and looped over it to reduce
#   the amount of duplicated code.
#
#   I added functions to the writeDDL, writePK and writeConstraints files that directly
#   take the strings that come out of the createXXXFromFile functions. This avoids writing
#   and reading back that data from files, and so avoid the question of where the are, as
#   well as the package build invovled in putting them. This makes the CSV files drive everything
#   as the SQL Server version of the DDL isn't kept in the package, but generated.
#
#   Perhaps the *BIGGEST DEAL* is that this code works from a git mindset, not a package mindset.
#   Practically that means the CSV and DDL files aren't accessed by way of the package location, 
#   and the R files are sourced rather than brought in from a library. This helps two different
#   processes. 
#   The first is modifying the R scripts: you can just re-run without having to build
#   a package. I haven't built packages from within R studio. It's a non-issue if that's a piece
#   of cake to do there.
#   The second is for generating the files and ultimately testing. I want to be able to run a script
#   and go from a freshly pulled git repo and CSV files to generated, tested, documented and loaded
#   DDL from a script. I don't want to depend on RStudio or manual steps, maybe even the complexity
#   of buidling a package to get there.  
#
# MORE TODO
#   Consider eventually removing the SQL Server version of the DDL from the project and 
#   fully promote the CSV files as the single source of truth: It all gets generated from them.
#
#   The formal R package has value as a way of getting from install.packages("CommonDataModel") to 
#   an installed data model in one step, and I haven't fully integrated the two ideas.




if (!require("SqlRender")) { install.packages("SqlRender") }
library(SqlRender)
if (!require("pagedown")) { install.packages("pagedown") }
library(pagedown)
if (!require("kableExtra")) { install.packages("kableExtra") }
library(kableExtra)

if (TRUE) {
    #WikiParser.R
    source("R/createDdlFromFile.R")
    source("R/createFkFromFile.R")
    source("R/createPkFromFile.R")
    source("R/downloadCurrentDdl.R")
    source("R/writeConstraints.R")
    source("R/writeDDL.R")
    source("R/writeIndex.R")
    source("R/writePrimaryKeys.R")
} else {
    if (!require("CdmDdlBase")) { install.packages("CdmDdlBase") }
    library("CdmDdlBase")
}


  cdmVersion <- "v6_0"
  filePrefix <- "OMOP CDM "
  fileVersion <- "v6.0"


# Create the sql server DDL from the file
    ddl <- createDdlFromFile(cdmTableCsvLoc = paste0("inst/csv/OMOP_CDM", fileVersion, "_Table_Level.csv"),
                                   outputFile     = paste0(filePrefix, "ddl ", cdmVersion, ".sql"),
                                   cdmFieldCsvLoc = paste0("inst/csv/OMOP_CDM", fileVersion, "_Field_Level.csv"))
    pk <- createPkFromFile(cdmVersionNum = cdmVersion,
                                  outputFile    = paste0(filePrefix, "pk ", cdmVersion, ".sql"),
                                  cdmFieldCsvLoc = paste0("inst/csv/OMOP_CDM", fileVersion, "_Field_Level.csv"))
    fk <- createFkFromFile(cdmVersionNum = cdmVersion,
                                  outputFile    = paste0(filePrefix, "fk ", cdmVersion, ".sql"),
                                  cdmFieldCsvLoc = paste0("inst/csv/OMOP_CDM", fileVersion, "_Field_Level.csv"))

    # No index files?

# NO package rebuild required.

# Render the DDLs for the first three dialects with specific schema names for testing.
    id <- 1:8
    dialect <- c("oracle", "postgresql", "sql server", "bigquery", "impala", "netezza", "pdw", "redshift" )
    schema  <- c("OHDSI",  "ohdsi",      "ohdsi.dbo", "@cdmDtabaseSchema", 
                 "@cdmDatabaseSchema", "@cdmDatabaseSchema", "@cdmDatabaseSchema", "@cdmDatabaseSchema")
    schema2 <- c("@cdmDatabaseSchema", "@cdmDatabaseSchema", "@cdmDtabaseSchema" , "@cdmDatabaseSchema", 
                 "@cdmDatabaseSchema", "@cdmDatabaseSchema", "@cdmDatabaseSchema", "@cdmDatabaseSchema")
    metadf <- data.frame(id, dialect, schema, schema2)
    for (i in 1:3) {
        writeDdlFromString(
            targetdialect = metadf[id==i, 'dialect'],
            cdmVersion = cdmVersion,
            cdmDatabaseSchema = metadf[id==i, 'schema'],
            sql = (paste0(ddl, collapse='')),
            cleanUpScript = FALSE) #oracle syntax for removing tables is weird, set this to F and make any changes to the raw file

        writePrimaryKeysFromString(
            targetdialect = metadf[id==i, 'dialect'],
            cdmVersion = cdmVersion,
            cdmDatabaseSchema = metadf[id==i, 'schema'],
            sql = (paste0(pk, collapse='')))

        writeConstraintsFromString(
            metadf[id==i, 'dialect'],
            cdmVersion,
            cdmDatabaseSchema = metadf[id==i, 'schema'],
            sql = (paste0(fk, collapse='')))

# Q: where do the index files get created?
#        writeIndex(
#           metadf[id==i, 'dialect'],
#           cdmVersion,
#           sqlFilename = paste0(filePrefix, "indices ", cdmVersion, ".sql"),
#           cdmDatabaseSchema = metadf[id==i, 'schema'] )
    }

##############################
# RUN THE TESTTHAT.R TO TEST ORACLE, POSTGRES, AND SQLSERVER


# Create the files for all dialects. 
# Oracle,  Postgres and Sql Server are rewritten to overwrite the cdmDatabaseSchema with a token.
    for (i in 1:8) {
        writeDdlFromString(
            targetdialect = metadf[id==i, 'dialect'],
            cdmVersion = cdmVersion,
            cdmDatabaseSchema = metadf[id==i, 'schema2'],
            sql = (paste0(ddl, collapse='')),
            cleanUpScript = F) #oracle syntax for removing tables is weird, set this to F and make any changes to the raw file

        writePrimaryKeysFromString(
            targetdialect = metadf[id==i, 'dialect'],
            cdmVersion = cdmVersion,
            cdmDatabaseSchema = metadf[id==i, 'schema2'],
            sql = (paste0(pk, collapse='')))

        writeConstraintsFromString(
            metadf[id==i, 'dialect'],
            cdmVersion,
            cdmDatabaseSchema = metadf[id==i, 'schema2'],
            sql = (paste0(fk, collapse='')))

#        writeIndex(
#           metadf[id==i, 'dialect'],
#           cdmVersion,
#           sqlFilename = paste0(filePrefix, "indices ", cdmVersion, ".sql"),
#           cdmDatabaseSchema = metadf[id==i, 'schema2'] )
    }


#setwd("C:/Git/Github/CdmDdlBase/rmd")
#setwd("rmd")
#rmarkdown::render_site()
#setwd("..")

# Create the PDF documentation.
##########pagedown::chrome_print("rmd/cdm531.Rmd") # https://stackoverflow.com/questions/25824795/how-to-combine-two-rmarkdown-rmd-files-into-a-single-output

# Move the files to the CommonDataModel directory
#newdir <- "C:/Git/Github/CommonDataModel/docs"
#newdir <- "docs"
#currentdir <- paste0(getwd(),"/docs/")
#file.copy(currentdir, newdir, recursive = TRUE, overwrite = TRUE)



