# Download the JDBC drivers used in the tests
library(DatabaseConnector)

driverPath <- file.path(Sys.getenv("HOME"), "drivers")
if(!dir.exists(driverPath)) dir.create(driverPath)

if(Sys.getenv("LOCAL_TEST") != "TRUE") {
  cat("\ndownloading drivers\n")
  downloadJdbcDrivers("redshift", pathToDriver = driverPath)
  downloadJdbcDrivers("postgresql", pathToDriver = driverPath)
  downloadJdbcDrivers("oracle", pathToDriver = driverPath)
  downloadJdbcDrivers("sql server", pathToDriver = driverPath)
}

# Helper functions used in tests -----------------------------------------------
getConnectionDetails <- function(dbms) {
  switch (dbms,
    "postgresql" = createConnectionDetails(
      dbms = "postgresql",
      user = Sys.getenv("CDMDDLBASE_POSTGRESQL_USER"),
      password = Sys.getenv("CDMDDLBASE_POSTGRESQL_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_POSTGRESQL_SERVER"),
      pathToDriver = file.path(Sys.getenv("HOME"), "drivers")
    ),
    "redshift" = createConnectionDetails(
      dbms = "redshift",
      user = Sys.getenv("CDMDDLBASE_REDSHIFT_USER"),
      password = Sys.getenv("CDMDDLBASE_REDSHIFT_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_REDSHIFT_SERVER"),
      pathToDriver = file.path(Sys.getenv("HOME"), "drivers")
    ),
    "sql server" = createConnectionDetails(
      dbms = "sql server",
      user = Sys.getenv("CDMDDLBASE_SQL_SERVER_USER"),
      password = Sys.getenv("CDMDDLBASE_SQL_SERVER_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_SQL_SERVER_SERVER"),
      pathToDriver = file.path(Sys.getenv("HOME"), "drivers")
    ),
    "oracle" = createConnectionDetails(
      dbms = "oracle",
      user = Sys.getenv("CDMDDLBASE_ORACLE_USER"),
      password = Sys.getenv("CDMDDLBASE_ORACLE_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_ORACLE_SERVER"),
      pathToDriver = file.path(Sys.getenv("HOME"), "drivers")
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
  stopifnot(class(connectionDetails) == "connectionDetails", class(schema) == "character", length(schema) == 1)
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
  stopifnot(class(connectionDetails) == "connectionDetails", class(schema) == "character", length(schema) == 1)
  stopifnot(connectionDetails$dbms %in% c("postgresql", "redshift", "sql server", "oracle"))
  tables <- listTablesInSchema(connectionDetails, schema)

  con <- DatabaseConnector::connect(connectionDetails)
  on.exit(DatabaseConnector::disconnect(con))
  dbms <- connectionDetails$dbms
  if(dbms %in% c("redshift", "postgresql", "sql server")) {
    for(table in tables) {
      DBI::dbRemoveTable(con, name = DBI::SQL(paste(schema, table, sep = ".")))
    }
  } else if(dbms == "oracle") {
    for(table in tables) {
      DBI::dbRemoveTable(con, name = table)
    }
  }
}


# .removeConstraintsPostgresql <- function(connectionDetails, schema) {
#   # the order of removal of constraints matters!
#   con <- DatabaseConnector::connect(connectionDetails)
#   constraints <- DBI::dbGetQuery(con,
#   "SELECT con.conname, rel.relname as relname
#     FROM pg_catalog.pg_constraint con
#   INNER JOIN pg_catalog.pg_class rel
#   ON rel.oid = con.conrelid
#   INNER JOIN pg_catalog.pg_namespace nsp
#   ON nsp.oid = connamespace
#   WHERE nsp.nspname = 'cdmddlbase';")
#
#
#   constraints <- dplyr::mutate(constraints, sql = paste0("alter table ", schema, ".", relname, " drop constraint if exists ", conname, ";\n" ))
#
#   sql <- paste(rev(constraints$sql), collapse = "")
#   executeSql(con, sql)
#
#   disconnect(con)
#
# }
