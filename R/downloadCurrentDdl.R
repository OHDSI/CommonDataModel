#' Get current DDL sitting on the master branch
#'
#' @details
#' This function gets the current ddl on the CDM master branch. It will be taken from the Sql Server folder.
#' The default location is
#' \code{inst/settings/currentOmopDdl.sql}.
#'
#' @param githubPath            The path for the GitHub repo containing the package (e.g. 'OHDSI/CommonDataModel').
#' @param pathToCsv             The path for the snapshot inside the package.
#' @param outputFile            The path where the file should be saved.
#'
#' @examples
#' \dontrun{
#' downloadCurrentDdl("OHDSI/CommonDataModel",
#'  pathToCsv="Sql%20Server/OMOP%20CDM%20sql%20server%20ddl.txt")
#' }
#' @importFrom utils download.file
#' @export

downloadCurrentDdl <- function(githubPath="OHDSI/CommonDataModel",
                               pathToCsv="Sql%20Server/OMOP%20CDM%20sql%20server%20ddl.txt",
                               outputFile = paste0("inst/sql/sql_server/OMOP CDM ddl ",Sys.Date(),".sql")){

  parts <- strsplit(githubPath, "/")[[1]]
  if (length(parts) > 2) {
    githubPath <- paste(c(parts[1:2], "master", parts[3:length(parts)]), collapse = "/")
  } else {
    githubPath <- paste(c(parts[1:2], "master"), collapse = "/")
  }
  url <- paste(c("https://raw.githubusercontent.com", githubPath, pathToCsv), collapse = "/")
  download.file(url, destfile = outputFile)
}
