# Copyright 2017 Observational Health Data Sciences and Informatics
#
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

#' Write constraint script
#'
#' @param targetdialect  The dialect of the target database. Choices are "oracle", "postgresql", "pdw", "redshift", "impala", "netezza", "bigquery", "sql server"
#' @param cdmVersion The version of the CDM that you are creating the primary keys for
#' @param cdmDatabaseSchema The name of the schema where the cdm sits. Defaults to "@cdmDatabaseSchema"
#'
#' @export

writeForeignKeys <- function(targetdialect, cdmVersion, cdmDatabaseSchema = "@cdmDatabaseSchema") {
  outputpath <- file.path("ddl", cdmVersion, targetdialect)
  dir.create(outputpath, showWarnings = FALSE, recursive = TRUE)

  sql <- createForeignKeys(cdmVersion)
  sql <- SqlRender::render(sql = sql, cdmDatabaseSchema = cdmDatabaseSchema, targetdialect = targetdialect)
  sql <- SqlRender::translate(sql, targetDialect = targetdialect)

  filename <- paste("OMOPCDM", targetdialect, cdmVersion, "constraints.sql", sep = "_")
  SqlRender::writeSql(sql = sql,
                      targetFile = file.path(outputpath, filename)
  )
}
