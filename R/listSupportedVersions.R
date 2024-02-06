#' List CDM versions supported by this package
#'
#' @return A character vector containing the supported Common Data Model (CDM) versions in major.minor format.
#' @export
listSupportedVersions <- function() {
  supportedVersions <- c("5.3", "5.4")
  return(supportedVersions)
}

#' List RDBMS dialects supported by this package
#'
#' @return A list containing the supported Structured Query Language (SQL) dialects.
#' @export

listSupportedDialects <- function() {
  sqlRenderSupportedDialects <- SqlRender::listSupportedDialects()
  supportedDialects <- sqlRenderSupportedDialects$dialect
  return(supportedDialects)
}
