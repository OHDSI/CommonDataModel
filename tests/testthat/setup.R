# Specify desired test platforms
cdmVersion <- "5.4"
testDatabases <- c("postgresql")

# Download the JDBC drivers used in the tests
library(DatabaseConnector)

missingJarFolderEnvironmentVariable <- FALSE
emptyJarFolderEnivornmentVariable <- FALSE
jarFolderDoesNotExist <- FALSE

missingJarFolderEnvironmentVariable <- is.na(Sys.getenv("DATABASECONNECTOR_JAR_FOLDER"))
if (missingJarFolderEnvironmentVariable) {
  cat("DATABASECONNECTOR_JAR_FOLDER environment variable not set.")
} else {
  emptyJarFolderEnivornmentVariable <- Sys.getenv("DATABASECONNECTOR_JAR_FOLDER")==""
  if (emptyJarFolderEnivornmentVariable) {
    cat("DATABASECONNECTOR_JAR_FOLDER environment variable is empty string")
  } else {
    jarFolderDoesNotExist <- !dir.exists(Sys.getenv("DATABASECONNECTOR_JAR_FOLDER"))
    if (jarFolderDoesNotExist) {
      cat(paste("specified DATABASECONNECTOR_JAR_FOLDER", Sys.getenv("DATABASECONNECTOR_JAR_FOLDER"), "does not exist."))
    }
  }
}

if ( missingJarFolderEnvironmentVariable| emptyJarFolderEnivornmentVariable | jarFolderDoesNotExist) {
  driverPath <- tempdir()
  cat("\ndownloading drivers\n")
  downloadJdbcDrivers("redshift", pathToDriver = driverPath)
  downloadJdbcDrivers("postgresql", pathToDriver = driverPath)
  downloadJdbcDrivers("oracle", pathToDriver = driverPath)
  downloadJdbcDrivers("sql server", pathToDriver = driverPath)
} else {
  driverPath <- Sys.getenv("DATABASECONNECTOR_JAR_FOLDER")
}

# Helper functions used in tests
getConnectionDetails <- function(dbms) {
  switch (dbms,
    "postgresql" = createConnectionDetails(
      dbms = "postgresql",
      user = Sys.getenv("CDMDDLBASE_POSTGRESQL_USER"),
      password = Sys.getenv("CDMDDLBASE_POSTGRESQL_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_POSTGRESQL_SERVER"),
      pathToDriver = driverPath
    ),
    "redshift" = createConnectionDetails(
      dbms = "redshift",
      user = Sys.getenv("CDMDDLBASE_REDSHIFT_USER"),
      password = Sys.getenv("CDMDDLBASE_REDSHIFT_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_REDSHIFT_SERVER"),
      pathToDriver = driverPath
    ),
    "sql server" = createConnectionDetails(
      dbms = "sql server",
      user = Sys.getenv("CDMDDLBASE_SQL_SERVER_USER"),
      password = Sys.getenv("CDMDDLBASE_SQL_SERVER_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_SQL_SERVER_SERVER"),
      pathToDriver = driverPath
    ),
    "oracle" = createConnectionDetails(
      dbms = "oracle",
      user = Sys.getenv("CDMDDLBASE_ORACLE_USER"),
      password = Sys.getenv("CDMDDLBASE_ORACLE_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_ORACLE_SERVER"),
      pathToDriver = driverPath
    )
  )
}

getSchema <- function(dbms) {
  switch (dbms,
    "postgresql" = Sys.getenv("CDMDDLBASE_POSTGRESQL_SCHEMA"),
    "redshift" = Sys.getenv("CDMDDLBASE_REDSHIFT_SCHEMA"),
    "sql server" = Sys.getenv("CDMDDLBASE_SQL_SERVER_CDM_SCHEMA"),
    "oracle" = Sys.getenv("CDMDDLBASE_ORACLE_CDM_SCHEMA")
  )
}

listTablesInSchema <- function(connectionDetails, schema) {
  stopifnot("ConnectionDetails" %in% class(connectionDetails), class(schema) == "character", length(schema) == 1)
  stopifnot(connectionDetails$dbms %in% c("postgresql", "redshift", "sql server", "oracle"))
  con <- DatabaseConnector::connect(connectionDetails)
  on.exit(DatabaseConnector::disconnect(con))
  dbms <- connectionDetails$dbms
  if(dbms %in% c("postgresql", "redshift", "sql server")) {
    tables <- dbGetQuery(con, paste0("select table_name from information_schema.tables where table_schema = '", schema, "'"))[[1]]
  } else if(dbms == "oracle") {
    query <- paste0("select table_name from all_tables where owner = '", toupper(schema), "' and tablespace_name = 'USERS'")
    tables <- dbGetQuery(con, query)[[1]]
  }
  return(tables)
}

dropAllTablesFromSchema <- function(connectionDetails, schema) {
  stopifnot("ConnectionDetails" %in% class(connectionDetails), class(schema) == "character", length(schema) == 1)
  stopifnot(connectionDetails$dbms %in% c("postgresql", "redshift", "sql server", "oracle"))
  tableNames <- listTablesInSchema(connectionDetails, schema)

  con <- DatabaseConnector::connect(connectionDetails)
  on.exit(DatabaseConnector::disconnect(con))
  dbms <- connectionDetails$dbms
  if(dbms %in% c("redshift", "postgresql", "sql server")) {
    for(tableName in tableNames) {
      DBI::dbExecute(con, paste("DROP TABLE IF EXISTS",paste(schema, tableName, sep = "."),"CASCADE"))
    }
  } else if(dbms == "oracle") {
    for(tableName in tableNames) {
      DBI::dbExecute(con, paste("DROP TABLE IF EXISTS",tableName,"CASCADE"))
    }
  }
}

