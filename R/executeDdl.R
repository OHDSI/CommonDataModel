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

#' Generate and execute the DDL on a database
#'
#' This function will generate the DDL for a specific dbms and CDM version and
#' then execute the DDL on a database.
#'
#' @param connectionDetails An object of class connectionDetails as created by the DatabaseConnector::createConnectionDetails function.
#' @param cdmVersion The version of the CDM you are creating, e.g. 5.3, 5.4
#' @param cdmDatabaseSchema The schema of the CDM instance where the DDL will be run. For example, this would be "ohdsi.dbo" when testing on sql server.
#' @param executeDdl Should the DDL be executed? TRUE or FALSE
#' @param executePrimaryKey Should the primary keys be added? TRUE or FALSE
#' @param executeForeignKey Should the foreign keys be added? TRUE or FALSE
#' @param ... Other arguments passed on to DatabaseConnector::executeSql. (This allows the user to set the path to errorReportFile.)
#' @export
#'
#' @examples
#' \dontrun{
#' executeDdl(connectionDetails = connectionDetails,
#'            cdmVersion = "5.4",
#'            cdmDatabaseSchema = "myCdm")
#'}
executeDdl <- function(connectionDetails,
                       cdmVersion,
                       cdmDatabaseSchema,
                       executeDdl = TRUE,
                       executePrimaryKey = TRUE,
                       executeForeignKey = TRUE,
                       ...) {

  outputfolder <- tempdir(check = TRUE)


  if(executeDdl) {
    filename <- writeDdl(targetDialect = connectionDetails$dbms,
                         cdmVersion = cdmVersion,
                         cdmDatabaseSchema = cdmDatabaseSchema,
                         outputfolder = outputfolder)

    sql <- readr::read_file(file.path(outputfolder, filename))
  } else {
    sql <- ""
  }

  if(executePrimaryKey) {
    filename <- writePrimaryKeys(targetDialect = connectionDetails$dbms,
                                 cdmVersion = cdmVersion,
                                 cdmDatabaseSchema = cdmDatabaseSchema,
                                 outputfolder = outputfolder)

    sql <- paste(sql, readr::read_file(file.path(outputfolder, filename)), sep = "\n")
  }

  if(executeForeignKey) {
    filename <- writeForeignKeys(targetDialect = connectionDetails$dbms,
                                 cdmVersion = cdmVersion,
                                 cdmDatabaseSchema = cdmDatabaseSchema,
                                 outputfolder = outputfolder)

    sql <- paste(sql, readr::read_file(file.path(outputfolder, filename)), sep = "\n")
  }

  con <- DatabaseConnector::connect(connectionDetails = connectionDetails)

  DatabaseConnector::executeSql(con, sql = sql, ...)

  DatabaseConnector::disconnect(con)
}




