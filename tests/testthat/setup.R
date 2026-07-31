testDatabases <- c("postgresql")

if (Sys.getenv("CDMDDLBASE_POSTGRESQL_SERVER") != "") {
  library(DatabaseConnector)

  if (dir.exists(Sys.getenv("DATABASECONNECTOR_JAR_FOLDER"))) {
    jdbcDriverFolder <- Sys.getenv("DATABASECONNECTOR_JAR_FOLDER")
  } else {
    jdbcDriverFolder <- file.path(tempdir(), "jdbcDrivers")
    dir.create(jdbcDriverFolder, showWarnings = FALSE)
    DatabaseConnector::downloadJdbcDrivers("all", pathToDriver = jdbcDriverFolder)

    Sys.setenv(DATABASECONNECTOR_JAR_FOLDER = jdbcDriverFolder)

    withr::defer({
      unlink(jdbcDriverFolder,
             recursive = TRUE,
             force = TRUE)
    },
    testthat::teardown_env())
  }
} else {
  message("Skipping driver setup because environmental variables not set")
}

# Helper functions used in tests
getConnectionDetails <- function(dbms) {
  switch (
    dbms,
    "postgresql" = createConnectionDetails(
      dbms = "postgresql",
      user = Sys.getenv("CDMDDLBASE_POSTGRESQL_USER"),
      password = Sys.getenv("CDMDDLBASE_POSTGRESQL_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_POSTGRESQL_SERVER"),
      pathToDriver = jdbcDriverFolder
    ),
    "redshift" = createConnectionDetails(
      dbms = "redshift",
      user = Sys.getenv("CDMDDLBASE_REDSHIFT_USER"),
      password = Sys.getenv("CDMDDLBASE_REDSHIFT_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_REDSHIFT_SERVER"),
      pathToDriver = jdbcDriverFolder
    ),
    "sql server" = createConnectionDetails(
      dbms = "sql server",
      user = Sys.getenv("CDMDDLBASE_SQL_SERVER_USER"),
      password = Sys.getenv("CDMDDLBASE_SQL_SERVER_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_SQL_SERVER_SERVER"),
      pathToDriver = jdbcDriverFolder
    ),
    "oracle" = createConnectionDetails(
      dbms = "oracle",
      user = Sys.getenv("CDMDDLBASE_ORACLE_USER"),
      password = Sys.getenv("CDMDDLBASE_ORACLE_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_ORACLE_SERVER"),
      pathToDriver = jdbcDriverFolder
    )
  )
}

getSchema <- function(dbms) {
  switch (
    dbms,
    "postgresql" = Sys.getenv("CDMDDLBASE_POSTGRESQL_SCHEMA"),
    "redshift" = Sys.getenv("CDMDDLBASE_REDSHIFT_SCHEMA"),
    "sql server" = Sys.getenv("CDMDDLBASE_SQL_SERVER_CDM_SCHEMA"),
    "oracle" = Sys.getenv("CDMDDLBASE_ORACLE_CDM_SCHEMA")
  )
}

listTablesInSchema <- function(connectionDetails, schema) {
  stopifnot(
    "ConnectionDetails" %in% class(connectionDetails),
    class(schema) == "character",
    length(schema) == 1
  )
  stopifnot(connectionDetails$dbms %in% c("postgresql", "redshift", "sql server", "oracle"))
  con <- DatabaseConnector::connect(connectionDetails)
  on.exit(DatabaseConnector::disconnect(con))
  dbms <- connectionDetails$dbms
  if (dbms %in% c("postgresql", "redshift", "sql server")) {
    tables <-
      dbGetQuery(
        con,
        paste0(
          "select table_name from information_schema.tables where table_schema = '",
          schema,
          "'"
        )
      )[[1]]
  } else if (dbms == "oracle") {
    query <-
      paste0(
        "select table_name from all_tables where owner = '",
        toupper(schema),
        "' and tablespace_name = 'USERS'"
      )
    tables <- dbGetQuery(con, query)[[1]]
  }
  return(tables)
}

dropAllTablesFromSchema <- function(connectionDetails, schema) {
  stopifnot(
    "ConnectionDetails" %in% class(connectionDetails),
    class(schema) == "character",
    length(schema) == 1
  )
  stopifnot(connectionDetails$dbms %in% c("postgresql", "redshift", "sql server", "oracle"))
  tableNames <- listTablesInSchema(connectionDetails, schema)

  if (length(tableNames) == 0) {
    return(invisible(NULL))  # No tables to drop
  }

  con <- DatabaseConnector::connect(connectionDetails)
  on.exit(DatabaseConnector::disconnect(con))
  dbms <- connectionDetails$dbms
  
  # For all databases, use DROP TABLE IF EXISTS ... CASCADE
  # but quote schema and table names properly
  if (dbms %in% c("postgresql", "redshift")) {
    # PostgreSQL/Redshift: quote identifiers
    for (tableName in tableNames) {
      sql <- paste0('DROP TABLE IF EXISTS "', schema, '"."', tableName, '" CASCADE')
      DBI::dbExecute(con, sql)
    }
  } else if (dbms == "sql server") {
    # SQL Server: use brackets for identifiers
    for (tableName in tableNames) {
      sql <- paste0('DROP TABLE IF EXISTS [', schema, '].[', tableName, ']')
      DBI::dbExecute(con, sql)
    }
  } else if (dbms == "oracle") {
    # Oracle: drop each table individually
    for (tableName in tableNames) {
      sql <- paste0('DROP TABLE "', tableName, '" CASCADE CONSTRAINTS')
      DBI::dbExecute(con, sql)
    }
  }
}
