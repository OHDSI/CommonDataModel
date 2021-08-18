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

#' Create a foreign key sql script from two csv files that detail the OMOP CDM Specifications.

#' @param cdmVersionNum The version of the CDM you are creating, e.g. 5.3.1
#' @export

createForeignKeys <- function(cdmVersion = cdmVersion){
  cdmFieldCsvLoc <- paste0("inst/csv/OMOP_CDMv", cdmVersion, "_Field_Level.csv")
  cdmSpecs <- read.csv(cdmFieldCsvLoc, stringsAsFactors = FALSE)

  foreignKeys <- subset(cdmSpecs, isForeignKey == "Yes")
  foreignKeys$key <- paste0(foreignKeys$cdmTableName, "_", foreignKeys$cdmFieldName)

  sql_result <- c(paste0("--@targetdialect CDM Foreign Key Constraints for OMOP Common Data Model ", cdmVersion, "\n"))
  for (foreignKey in foreignKeys$key){

      subquery <- subset(foreignKeys, foreignKeys$key==foreignKey)

      sql_result <- c(sql_result, paste0("\nALTER TABLE @cdmDatabaseSchema.", subquery$cdmTableName, " ADD CONSTRAINT fpk_", subquery$cdmTableName, "_", subquery$cdmFieldName, " FOREIGN KEY (", subquery$cdmFieldName , ") REFERENCES @cdmDatabaseSchema.", subquery$fkTableName, " (", subquery$fkFieldName, ");\n"))

  }
  return(paste0(sql_result, collapse = ""))
}
