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


#' Parse Wiki files
#'
#' @description
#' Parses all .md files in the specified location (or any subfolders), extracting definitions
#' of the Common Data Model.
#'
#' @param mdFilesLocation Path to the root folder of the Wiki repository.
#' @param output_file     Path to where the output CSV file should be written.
#' @importFrom utils write.csv
#' @export
parseWiki <- function(mdFilesLocation, output_file) {
  # mdFilesLocation <- "../CommonDataModel.wiki"
  files <- list.files(mdFilesLocation, pattern = ".*\\.md", recursive = TRUE, full.names = TRUE)
  file <- files[18]
  parseTableRow <- function(row) {
    cells <- stringr::str_trim(stringr::str_split(row, "\\|")[[1]])
    if (substr(row, 1, 1) == "|") {
      cells <- cells[2:5]
    }
    return(data.frame(field = tolower(cells[1]),
                      required = cells[2],
                      type = toupper(cells[3]),
                      description = cells[4]))
  }

  parseMdFile <- function(file) {
    text <- readChar(file, file.info(file)$size)
    lines <- stringr::str_split(text, "\n")[[1]]
    lines <- stringr::str_trim(lines)
    tableStart <- grep("\\s*field\\s*\\|\\s*required\\s*\\|\\s*type\\s*\\|\\s*description\\s*", tolower(lines))
    if (length(tableStart) > 1)
      stop("More than one table definition found in ", file)

    if (length(tableStart) == 1) {
      tableName <- basename(file)
      tableName <- tolower(stringr::str_sub(tableName, 1, -4))
      writeLines(paste("Parsing table", tableName))
      tableStart <- tableStart + 2
      tableEnd <- c(which(lines == ""), length(lines) + 1)
      tableEnd <- min(tableEnd[tableEnd > tableStart]) - 1
      tableDefinition <- lapply(lines[tableStart:tableEnd], parseTableRow)
      tableDefinition <- do.call(rbind, tableDefinition)
      tableDefinition$table <- tableName
      return(tableDefinition)
    } else {
      return(NULL)
    }
  }
  tableDefinitions <- lapply(files, parseMdFile)
  tableDefinitions <- do.call(rbind, tableDefinitions)
  write.csv(tableDefinitions, output_file, row.names = FALSE)
}
