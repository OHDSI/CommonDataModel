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

#' Create OMOP CDM SQL files
#'
#' Writes DDL, ForeignKey, PrimaryKey and index SQL files for given cdmVersion
#' and targetDialect to the 'ddl' folder in current working directory.
#'
#' @param cdmVersions The versions of the CDM you are creating, e.g. 5.3, 5.4.
#'                   Defaults to all supported CDM versions.
#' @param targetDialects A character vector of target dialects.
#'                      Defaults to all supported dialects.
#' @param outputfolder The base folder where the SQL files will be written.
#'                     Subfolders will be created for each cdmVersion and targetDialect.
#' @export
buildRelease <- function(cdmVersions = listSupportedVersions(),
                         targetDialects = listSupportedDialects(),
                         outputfolder = file.path(getwd(), "inst", "ddl")){
  basefolder <- outputfolder
  for (cdmVersion in cdmVersions) {
    for (targetDialect in targetDialects) {
      outputfolder <- file.path(basefolder, cdmVersion, gsub(" ", "_", targetDialect))

      writeDdl(targetDialect = targetDialect,
               cdmVersion = cdmVersion,
               outputfolder = outputfolder)

      writePrimaryKeys(targetDialect = targetDialect,
                       cdmVersion = cdmVersion,
                       outputfolder = outputfolder)

      writeForeignKeys(targetDialect = targetDialect,
                       cdmVersion = cdmVersion,
                       outputfolder = outputfolder)

      writeIndex(targetDialect = targetDialect,
                 cdmVersion = cdmVersion,
                 outputfolder = outputfolder)
    }
  }
}

#' Create OMOP CDM release zip
#'
#' First calls \code{buildReleaseZips} for given cdmVersions and targetDialects.
#' This writes the ddl sql files to the ddl folder.
#' Then zips all written ddl files into a release zip to given output folder.
#'
#' If no (or multiple) targetDialect is given,
#' then one zip is written with the files of all supported dialects.
#'
#' @param cdmVersion The version of the CDM you are creating, e.g. 5.3, 5.4.
#'                   Defaults to all supported CDM versions.
#' @param targetDialect The target dialect. Defaults to all supported dialects.
#' @param outputfolder The output folder. Defaults to "output"
#' @return A character string containing the OHDSQL DDL
#' @export
#' @examples
#' buildReleaseZip(cdmVersion='5.3', targetDialect='sql server', outputfolder='.')
#'
buildReleaseZip <- function(cdmVersion,
                            targetDialect = listSupportedDialects(),
                            outputfolder = file.path(getwd(), "output")){
  # argument checks
  stopifnot(is.character(cdmVersion), length(cdmVersion) == 1, cdmVersion %in% listSupportedVersions())

  if (!dir.exists(outputfolder)) {
    dir.create(outputfolder)
  }

  files <- c()
  for (dialect in targetDialect) {
    buildRelease(cdmVersion, dialect, outputfolder = outputfolder)
    files <- c(files, list.files(file.path(outputfolder, cdmVersion, gsub(" ", "_", dialect)),
                                 pattern = ".*\\.sql$",
                                 full.names = TRUE))
  }

  if (length(targetDialect) == 1) {
    zipName <- file.path(outputfolder, paste0("OMOPCDM", "_", gsub(" ", "_", targetDialect), "_", cdmVersion, '.zip'))
  } else {
    zipName <- file.path(outputfolder, paste0("OMOPCDM", "_", cdmVersion, '.zip'))
  }

  DatabaseConnector::createZipFile(zipFile = zipName, files = files)
}
