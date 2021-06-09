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

#' Create a primary key sql script from two csv files that detail the OMOP CDM Specifications.

#' @param cdmVersionNum The version of the CDM you are creating
#'
#' @param cdmFieldCsvLoc The location of the csv file with the CDM field information. This is defaulted to "inst/csv/OMOP_CDMv5.3.1_Field_Level.csv".
#'                        If a new version of this file was committed to the CDM repository the package automatically will grab it and place it in "inst/csv/".
#' @param outputFile  The name of the output primary key sql file. This is defaulted to a location in the inst/sql/sql server folder and named with today's date and CDM Version.
#' @export

createPkFromFile <- function(cdmVersionNum = cdmVersion,
                              cdmFieldCsvLoc = "inst/csv/OMOP_CDMv5.3.1_Field_Level.csv",
                              outputFile = paste0("inst/sql/sql_server/OMOP CDM pk ", cdmVersion, " ", Sys.Date(), ".sql")){

  cdmSpecs <- read.csv(cdmFieldCsvLoc, stringsAsFactors = FALSE)

  pks <- subset(cdmSpecs, isPrimaryKey == "Yes")

  pkFields <- pks$cdmFieldName

  s <- c()
  s <- c(paste0("--@targetdialect CDM Primary Key Constraints for OMOP Common Data Model ",cdmVersionNum, "\n"))
  for (f in pkFields){

    q <- subset(pks, cdmFieldName==f)

    s <- c(s, paste0("\nALTER TABLE @cdmDatabaseSchema.", q$cdmTableName, " ADD CONSTRAINT xpk_", q$cdmTableName, " PRIMARY KEY NONCLUSTERED (", q$cdmFieldName ,");\n"))

  }
  SqlRender::writeSql(s, targetFile = outputFile)
  return(s)
}
