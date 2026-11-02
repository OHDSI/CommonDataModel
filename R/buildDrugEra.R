#' Build the DRUG_ERA table from the DRUG_EXPOSURE table
#'
#' Runs the drug era script that is shown on the "SQL Scripts" page of the CDM website
#' (\code{inst/sql/sql_server/OMOP_CDM_drug_era.sql}) on a database. The script strings together the
#' periods of time that a person is exposed to an active drug ingredient, allowing for gaps of up to 30
#' days, and inserts the resulting eras into the DRUG_ERA table.
#'
#' @details
#' The script reads DRUG_EXPOSURE, CONCEPT and CONCEPT_ANCESTOR (RxNorm ingredients) from the CDM schema and
#' inserts into DRUG_ERA without deleting existing rows, so DRUG_ERA is expected to be empty. It uses a
#' temp table, so on dialects that emulate temp tables (for example Oracle, BigQuery, Spark and Snowflake)
#' \code{tempEmulationSchema} has to be set.
#'
#' @param connectionDetails An object of class connectionDetails as created by the DatabaseConnector::createConnectionDetails function.
#' @param cdmDatabaseSchema The schema of the CDM instance that holds the DRUG_EXPOSURE, CONCEPT, CONCEPT_ANCESTOR and DRUG_ERA tables. For example, this would be "ohdsi.dbo" when testing on sql server.
#' @param tempEmulationSchema The schema used to emulate temp tables on dialects that do not support them, see SqlRender::translate.
#' @param ... Other arguments passed on to DatabaseConnector::executeSql. (This allows the user to set the path to errorReportFile.)
#' @return Called for its side effect of populating the DRUG_ERA table; returns NULL invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' buildDrugEra(connectionDetails = connectionDetails,
#'              cdmDatabaseSchema = "myCdm")
#'}
buildDrugEra <- function(connectionDetails,
                         cdmDatabaseSchema,
                         tempEmulationSchema = getOption("sqlRenderTempEmulationSchema"),
                         ...) {

  sqlFile <- system.file("sql", "sql_server", "OMOP_CDM_drug_era.sql",
                         package = "CommonDataModel", mustWork = TRUE)

  sql <- SqlRender::render(SqlRender::readSql(sqlFile), cdm_schema = cdmDatabaseSchema)
  sql <- SqlRender::translate(sql,
                              targetDialect = connectionDetails$dbms,
                              tempEmulationSchema = tempEmulationSchema)

  con <- DatabaseConnector::connect(connectionDetails = connectionDetails)
  on.exit(DatabaseConnector::disconnect(con))

  DatabaseConnector::executeSql(con, sql = sql, reportOverallTime = FALSE, progressBar = FALSE, ...)

  invisible(NULL)
}
