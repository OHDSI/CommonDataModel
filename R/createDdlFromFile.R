
# Copyright 2019 Observational Health Data Sciences and Informatics
#
# This file is part of CdmDdlBase
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Create a DDL script from a two csv files that detail the OMOP CDM Specifications. These files also form the basis of the CDM documentation and the Data Quality
#' Dashboard.
#'
#' @param cdmVersionNum The version of the CDM you are creating
#'
#' @param cdmTableCsvLoc  The location of the csv file with the high-level CDM table information. This is defaulted to "inst/csv/OMOP_CDMv5.3.1_Table_Level.csv".
#'                        If a new version of this file was committed to the CDM repository the package automatically will grab it and place it in "inst/csv/".
#' @param cdmFieldCsvLoc The location of the csv file with the CDM field information. This is defaulted to "inst/csv/OMOP_CDMv5.3.1_Field_Level.csv".
#'                        If a new version of this file was committed to the CDM repository the package automatically will grab it and place it in "inst/csv/".
#' @param outputFile  The name of the output ddl sql file. This is defaulted to a location in the inst/sql/sql server folder and named with today's date and the CDM version.
#' @export

createDdlFromFile <- function(cdmVersionNum = cdmVersion,
                              cdmTableCsvLoc = "inst/csv/OMOP_CDMv5.3.1_Table_Level.csv",
                              cdmFieldCsvLoc = "inst/csv/OMOP_CDMv5.3.1_Field_Level.csv",
                              outputFile = paste0("inst/sql/sql_server/OMOP CDM ddl ", cdmVersion, " ", Sys.Date(), ".sql")){

  tableSpecs <- read.csv(cdmTableCsvLoc, stringsAsFactors = FALSE)
  cdmSpecs <- read.csv(cdmFieldCsvLoc, stringsAsFactors = FALSE)

  tableList <- tableSpecs$cdmTableName

  s <- c()
  s <- c(paste0("--@targetdialect CDM DDL Specification for OMOP Common Data Model ",cdmVersionNum))
  for (t in tableList){
    table <- subset(cdmSpecs, cdmTableName == t)
    fields <- table$cdmFieldName

    if ('person_id' %in% fields){
      q <- "\n\n--HINT DISTRIBUTE ON KEY (person_id)\n"
    } else {
      q <- "\n\n--HINT DISTRIBUTE ON RANDOM\n"
    }

    s <- c(s, q, paste0("CREATE TABLE @cdmDatabaseSchema.", t, " (\n"))

    end <- length(fields)
    a <- c()

    for(f in fields) {

      if (subset(table, cdmFieldName == f, isRequired) == "Yes") {
        r <- (" NOT NULL")
      } else {
        r <- (" NULL")
      }

      if (f == fields[[end]]) {
        e <- (" );")
      } else {
        e <- (",")
      }

      if (f=="offset") {
        field <- paste0('"',f,'"')
      } else {
        field <- f
      }

      a <- c(a, paste0("\n\t\t\t",field," ",subset(table, cdmFieldName == f, cdmDatatype),r,e))
    }
    s <- c(s, a, "")
  }
  SqlRender::writeSql(s, targetFile = outputFile)
  return(s)
}
