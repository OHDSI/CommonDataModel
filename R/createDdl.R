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

#' Create the OHDSI-SQL Common Data Model DDL code
#'
#' The createDdl, createForeignKeys, and createPrimaryKeys functions each return a character string
#' containing their respective DDL SQL code in OHDSQL dialect for a specific CDM version.
#' The SQL they generate needs to be rendered and translated before it can be executed.
#'
#' The DDL SQL code is created from a two csv files that detail the OMOP CDM Specifications.
#' These files also form the basis of the CDM documentation and the Data Quality
#' Dashboard.
#'
#' @param cdmVersion The version of the CDM you are creating, e.g. 5.3, 5.4
#' @return A character string containing the OHDSQL DDL
#' @importFrom utils read.csv
#' @export
#' @examples
#' ddl <- createDdl("5.4")
#' pk <- createPrimaryKeys("5.4")
#' fk <- createForeignKeys("5.4")
createDdl <- function(cdmVersion){

  # argument checks
  stopifnot(is.character(cdmVersion), length(cdmVersion) == 1, cdmVersion %in% listSupportedVersions())

  cdmTableCsvLoc <- system.file(file.path("csv", paste0("OMOP_CDMv", cdmVersion, "_Table_Level.csv")), package = "CommonDataModel", mustWork = TRUE)
  cdmFieldCsvLoc <- system.file(file.path("csv", paste0("OMOP_CDMv", cdmVersion, "_Field_Level.csv")), package = "CommonDataModel", mustWork = TRUE)

  tableSpecs <- read.csv(cdmTableCsvLoc, stringsAsFactors = FALSE)
  cdmSpecs <- read.csv(cdmFieldCsvLoc, stringsAsFactors = FALSE)

  tableList <- tableSpecs$cdmTableName

  sql_result <- c()
  sql_result <- c(paste0("--@targetDialect CDM DDL Specification for OMOP Common Data Model ", cdmVersion))
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


#' @describeIn createDdl createPrimaryKeys Returns a string containing the OHDSQL for creation of primary keys in the OMOP CDM.
#' @export
createPrimaryKeys <- function(cdmVersion){

  # argument checks
  stopifnot(is.character(cdmVersion), length(cdmVersion) == 1, cdmVersion %in% listSupportedVersions())

  cdmFieldCsvLoc <- system.file(file.path("csv", paste0("OMOP_CDMv", cdmVersion, "_Field_Level.csv")), package = "CommonDataModel", mustWork = TRUE)
  cdmSpecs <- read.csv(cdmFieldCsvLoc, stringsAsFactors = FALSE)

  primaryKeys <- subset(cdmSpecs, isPrimaryKey == "Yes")
  pkFields <- primaryKeys$cdmFieldName

  sql_result <- c(paste0("--@targetDialect CDM Primary Key Constraints for OMOP Common Data Model ", cdmVersion, "\n"))
  for (pkField in pkFields){

    subquery <- subset(primaryKeys, cdmFieldName==pkField)

    sql_result <- c(sql_result, paste0("\nALTER TABLE @cdmDatabaseSchema.", subquery$cdmTableName, " ADD CONSTRAINT xpk_", subquery$cdmTableName, " PRIMARY KEY NONCLUSTERED (", subquery$cdmFieldName , ");\n"))

  }
  return(paste0(sql_result, collapse = ""))
}

#' @describeIn createDdl createForeignKeys Returns a string containing the OHDSQL for creation of foreign keys in the OMOP CDM.
#' @export
createForeignKeys <- function(cdmVersion){

  # argument checks
  stopifnot(is.character(cdmVersion), length(cdmVersion) == 1, cdmVersion %in% listSupportedVersions())

  cdmFieldCsvLoc <- system.file(file.path("csv", paste0("OMOP_CDMv", cdmVersion, "_Field_Level.csv")), package = "CommonDataModel", mustWork = TRUE)
  cdmSpecs <- read.csv(cdmFieldCsvLoc, stringsAsFactors = FALSE)

  foreignKeys <- subset(cdmSpecs, isForeignKey == "Yes")
  foreignKeys$key <- paste0(foreignKeys$cdmTableName, "_", foreignKeys$cdmFieldName)

  sql_result <- c(paste0("--@targetDialect CDM Foreign Key Constraints for OMOP Common Data Model ", cdmVersion, "\n"))
  for (foreignKey in foreignKeys$key){

    subquery <- subset(foreignKeys, foreignKeys$key==foreignKey)

    sql_result <- c(sql_result, paste0("\nALTER TABLE @cdmDatabaseSchema.", subquery$cdmTableName, " ADD CONSTRAINT fpk_", subquery$cdmTableName, "_", subquery$cdmFieldName, " FOREIGN KEY (", subquery$cdmFieldName , ") REFERENCES @cdmDatabaseSchema.", subquery$fkTableName, " (", subquery$fkFieldName, ");\n"))

  }
  return(paste0(sql_result, collapse = ""))
}



# A helper function that will return a character string with the omop ascii art given a major and minor cdm version
# example: cat(createAsciiHeader(5, 3))
createAsciiHeader <- function(major, minor) {

  stopifnot(is.numeric(major), is.numeric(minor), length(major) == 1, length(minor) == 1)
  stopifnot(major %in% 0:99, minor %in% 0:99)

  # An inner function that returns an ascii art matrix for any number between 0 and 99
  numberMatrix <- function(num){
    stopifnot(is.numeric(num), num %in% 0:99)

    # An inner function that returns a 7x7 matrix of number ascii art for the number 0 through 9
    # for the number 1 a 7x5 matrix is returned because 1 is narrower than other numbers.
    singleDigit <- function(num) {
      nums <- c('  ###     #    #####  ##### #      ####### ##### ####### #####  #####  #   #   ##   #     ##     ##    # #      #     ##    # #     ##     ##     # # #         #      ##    # #      #          #  #     ##     ##     #   #    #####  ##### #    # ###### ######    #    #####  #######     #   #   #            ########      ##     #  #    #     #      # #   #    #   #      #     #     # #     ##     #  #    #     ##     #  ###   ##### ####### #####      #  #####  #####   #     #####  ##### ')
      numsMatrix <- matrix(data = strsplit(nums, character(0))[[1]], nrow = 7, byrow = T)
      cols <- seq(num*7+1, num*7+7, by = 1)
      out <- numsMatrix[1:7, cols]
      # the number 1 is narrower than the other numbers
      if(num == 1) out<- out[1:7, 2:6]
      out
    }

    if(num < 10){
      return(singleDigit(num))
    } else {
      space <- matrix(rep(" ", 7), nrow = 7)
      return(cbind(singleDigit(floor(num/10)), space, singleDigit(num %% 10)))
    }
  }

  omop <- c('.
  ####### #     # ####### ######      #####  ######  #     #          .
  #     # ##   ## #     # #     #    #     # #     # ##   ##    #    #.
  #     # # # # # #     # #     #    #       #     # # # # #    #    #.
  #     # #  #  # #     # ######     #       #     # #  #  #    #    #.
  #     # #     # #     # #          #       #     # #     #    #    #.
  #     # #     # #     # #          #     # #     # #     #     #  # .
  ####### #     # ####### #           #####  ######  #     #      ##  ')

  # convert to matrix and remove first column
  omop <- matrix(strsplit(omop, character(0))[[1]], nrow = 7, byrow = TRUE)
  omop <- omop[,c(-1, -2)]

  dot <- matrix(c(rep(" ", 3*4), rep("#", 3*3)), nrow = 7, byrow = TRUE)
  space <- matrix(rep(" ", 7), nrow = 7)
  newline <- matrix(rep("\n", 7, nrow = 7))


  header <- character(0)
  headerMatrix <- cbind(omop, space, numberMatrix(major), space, dot, space, numberMatrix(minor), newline)
  for(i in 1:7) {
    header <- c(header, as.character(headerMatrix[i,]))
  }
  header <- paste(header, collapse = "")
  return(header)
}
