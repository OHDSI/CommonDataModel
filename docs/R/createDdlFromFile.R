
# Copyright 2019 Observational Health Data Sciences and Informatics
#
# This file is part of DDLGeneratr
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
#' @param cdmTableCsvLoc  The location of the csv file with the high-level CDM table information. This is defaulted to "inst/csv/OMOP_CDMv5.3.1_Table_Level.csv".
#'                        If a new version of this file was committed to the CDM repository the package automatically will grab it and place it in "inst/csv/".
#' @param cdmVersion The location of the csv file with the CDM field information. This is defaulted to "inst/csv/OMOP_CDMv5.3.1_Field_Level.csv".
#'                        If a new version of this file was committed to the CDM repository the package automatically will grab it and place it in "inst/csv/".
#' @export

createDdlFromFile <- function(cdmTableCsvLoc = "inst/csv/OMOP_CDMv5.3.1_Table_Level.csv",
                              cdmFieldCsvLoc = "inst/csv/OMOP_CDMv5.3.1_Field_Level.csv"){

  tableSpecs <- read.csv(cdmTableCsvLoc, stringsAsFactors = FALSE)
  cdmSpecs <- read.csv(cdmFieldCsvLoc, stringsAsFactors = FALSE)

  tableList <- tableSpecs$cdmTableName

  s <- c()
  for (t in tableList){
    table <- subset(cdmSpecs, cdmTableName == t)
    fields <- table$cdmFieldName

    if ('person_id' %in% fields){
      q <- "--HINT DISTRIBUTE ON KEY (person_id)"
    } else {
      q <- "--HINT DISTRIBUTE ON RANDOM"
    }

    s <- c(s, q, paste0("CREATE TABLE ", t, " ("))

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

      a <- c(a, paste0(f," ",subset(table, cdmFieldName == f, cdmDatatype),r,e))
    }
    s <- c(s, a, "")
  }
  return(s)
}
