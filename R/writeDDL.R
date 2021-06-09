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

#' Write DDL script
#'
#' @param targetdialect  The dialect of the target database. Choices are "oracle", "postgresql", "pdw", "redshift", "impala", "netezza", "bigquery", "sql server"
#' @param cdmVersion The version of the CDM for which you are creating the DDL.
#' @param cdmDatabaseSchema The schema of the CDM instance where the DDL will be run. For example, this would be "ohdsi.dbo" when testing on sql server. After testing
#'                          this can be changed to "@cdmDatabaseSchema"
#' @param sqlFilename The name of the sql file with the current ddl specifications to be translated and rendered
#' @param cleanUpScript Set to T if the clean up script should be created. This is for testing purposes and will create a sql script that drops all CDM tables.
#'                      By default set to F. Set to F for Oracle as well as the sql render translation does not work well.
#'
#' @export
writeDDL <- function(targetdialect, cdmVersion, cdmDatabaseSchema, sqlFilename, cleanUpScript = F) {
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
                      targetFile = paste0("output/",targetdialect,"/OMOP CDM ",targetdialect," ", cdmVersion," ddl.sql"))


  if(cleanUpScript){

      sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "testCleanUp.sql",
                                               packageName = "CdmDdlBase",
                                               dbms = targetdialect,
                                               cdmDatabaseSchema = cdmDatabaseSchema)

      SqlRender::writeSql(sql = sql,
                          targetFile = paste0("output/",targetdialect,"/", targetdialect," testCleanUp ", cdmVersion,".sql"))
  }

}
