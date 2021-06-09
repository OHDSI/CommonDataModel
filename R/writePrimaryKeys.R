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

#' Write primary key script
#'
#' @param targetdialect  The dialect of the target database. Choices are "oracle", "postgresql", "pdw", "redshift", "impala", "netezza", "bigquery", "sql server"
#' @param cdmVersion The version of the CDM that you are creating the primary keys for
#' @param cdmDatabaseSchema The name of the schema where the cdm sits.
#' @param sqlFilename The name of the file that should be rendered and translated to a different dbms.
#'
#' @export

writePrimaryKeys <- function(targetdialect, cdmVersion, cdmDatabaseSchema, sqlFilename) {
  if(!dir.exists("output")){
    dir.create("output")
  }

  if(!dir.exists(paste0("output/",targetdialect))){
    dir.create(paste0("output/",targetdialect))
  }

  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = sqlFilename,
                                           packageName = "CdmDdlBase",
                                           dbms = targetdialect,
                                           targetdialect = targetdialect,
                                           cdmDatabaseSchema = cdmDatabaseSchema)

  SqlRender::writeSql(sql = sql,
                      targetFile = paste0("output/",targetdialect,"/OMOP CDM ",targetdialect, " ", cdmVersion, " primary keys.sql" ))

}
