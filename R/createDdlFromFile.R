
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
#' @param cdmVersionNum The version of the CDM you are creating, e.g. 5.3.1
#'
#' @param cdmTableCsvLoc  The location of the csv file with the high-level CDM table information. This is defaulted to "inst/csv/OMOP_CDMv5.3.1_Table_Level.csv".
#'                        If a new version of this file was committed to the CDM repository the package automatically will grab it and place it in "inst/csv/".
#' @param cdmFieldCsvLoc The location of the csv file with the CDM field information. This is defaulted to "inst/csv/OMOP_CDMv5.3.1_Field_Level.csv".
#'                        If a new version of this file was committed to the CDM repository the package automatically will grab it and place it in "inst/csv/".
#' @param outputFile  The name of the output ddl sql file. This is defaulted to a location in the inst/sql/sql server folder and named with today's date and the CDM version.
#' @export

createDdlFromFile <- function(cdmVersion = cdmVersion){
  cdmTableCsvLoc = paste0("inst/csv/OMOP_CDMv", cdmVersion, "_Table_Level.csv")
  cdmFieldCsvLoc = paste0("inst/csv/OMOP_CDMv", cdmVersion, "_Field_Level.csv")

  tableSpecs <- read.csv(cdmTableCsvLoc, stringsAsFactors = FALSE)
  cdmSpecs <- read.csv(cdmFieldCsvLoc, stringsAsFactors = FALSE)

  tableList <- tableSpecs$cdmTableName

  sql_result <- c()
  sql_result <- c(paste0("--@targetdialect CDM DDL Specification for OMOP Common Data Model ", cdmVersion))
  for (tableName in tableList){
    fields <- subset(cdmSpecs, cdmTableName == tableName)
    fieldNames <- fields$cdmFieldName

    if ('person_id' %in% fieldNames){
      query <- "\n\n--HINT DISTRIBUTE ON KEY (person_id)\n"
    } else {
      query <- "\n\n--HINT DISTRIBUTE ON RANDOM\n"
    }

    sql_result <- c(sql_result, query, paste0("CREATE TABLE @cdmDatabaseSchema.", tableName, " ("))

    n_fields <- length(fieldNames)
    for(fieldName in fieldNames) {

      if (subset(fields, cdmFieldName == fieldName, isRequired) == "Yes") {
        nullable_sql <- (" NOT NULL")
      } else {
        nullable_sql <- (" NULL")
      }

      if (fieldName == fieldNames[[n_fields]]) {
        closing_sql <- (" );")
      } else {
        closing_sql <- (",")
      }

      if (fieldName=="offset") {
        field <- paste0('"',fieldName,'"')
      } else {
        field <- fieldName
      }
      fieldSql <- paste0("\n\t\t\t",
                         field," ",
                         subset(fields, cdmFieldName == fieldName, cdmDatatype),
                         nullable_sql,
                         closing_sql)
      sql_result <- c(sql_result, fieldSql)
    }
    sql_result <- c(sql_result, "")
  }
  return(paste0(sql_result, collapse = ""))
}
