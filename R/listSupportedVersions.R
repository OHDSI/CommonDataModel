#' List CDM versions supported by this package
#'
#' @return A character vector containing the support CDM versions in {major}.{minor} format.
#' @export
listSupportedVersions <- function() {
  supportedVersions <- c("5.3", "5.4")
  return(supportedVersions)
}

#' List RDBMS dialects supported by this package
#'
#' @export

listSupportedDialects <- function() {
  supportedDialects <- c("oracle", "postgresql", "pdw", "redshift", "impala", "netezza", "bigquery", "sql server")
  return(supportedDialects)
}
