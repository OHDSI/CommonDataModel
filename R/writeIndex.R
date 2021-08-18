# Copyright 2017 Observational Health Data Sciences and Informatics
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

#' Write Index script
#'
#' @param targetdialect  The dialect of the target database. Choices are "oracle", "postgresql", "pdw", "redshift", "impala", "netezza", "bigquery", "sql server"
#' @param cdmVersion The version of the CDM that you are creating the indices for. e.g. 5.3.1
#' @param cdmDatabaseSchema The name of the schema where the cdm sits. Defaults to "@cdmDatabaseSchema"
#'
#' @export
writeIndex <- function(targetdialect, cdmVersion, cdmDatabaseSchema  = "@cdmDatabaseSchema") {
  outputpath <- file.path("ddl", cdmVersion, targetdialect)
  dir.create(outputpath, showWarnings = FALSE, recursive = TRUE)

  sqlFilename <- paste0("OMOP CDM indices v", cdmVersion, ".sql")
  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = sqlFilename,
                                           packageName = "CdmDdlBase",
                                           dbms = targetdialect,
                                           targetdialect = targetdialect,
                                           cdmDatabaseSchema = cdmDatabaseSchema)

  filename <- paste("OMOPCDM", targetdialect, cdmVersion, "indices.sql", sep = " ")
  SqlRender::writeSql(sql = sql,
                      targetFile = file.path(outputpath, filename))
}
