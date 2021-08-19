library(DatabaseConnector)

# Helper functions used in tests
.listTablesInSchema <- function(connectionDetails, schema) {
  con <- DatabaseConnector::connect(connectionDetails)
  tables <- DBI::dbListObjects(con, prefix = schema)
  DatabaseConnector::disconnect(con)
  tables <- subset(tables, is_prefix == FALSE)
  tables <- subset(tables, grepl("table", table))$table
  tables <- vapply(tables, function(.) .@name, FUN.VALUE = character(1))
  return(tables)
}

.dropAllTablesFromSchema <- function(connectionDetails, schema) {
  tables <- .listTablesInSchema(connectionDetails, schema)

  con <- DatabaseConnector::connect(connectionDetails)
   for(table in tables) {
     DBI::dbRemoveTable(con, name = DBI::SQL(paste(schema, table, sep = ".")))
  }
  DatabaseConnector::disconnect(con)
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



test_that("Execute DDL on Postgres", {

  connectionDetails <- createConnectionDetails(
      dbms = "postgresql",
      user = Sys.getenv("CDMDDLBASE_POSTGRESQL_USER"),
      password = Sys.getenv("CDMDDLBASE_POSTGRESQL_PASSWORD"),
      server = Sys.getenv("CDMDDLBASE_POSTGRESQL_SERVER"),
      pathToDriver = file.path(Sys.getenv("HOME"), "drivers")
  )

  cdmDatabaseSchema <- Sys.getenv("CDMDDLBASE_POSTGRESQL_SCHEMA")

  expect_error(con <- connect(connectionDetails), NA)
  disconnect(con)

  for(cdmVersion in listSupportedVersions()) {
    # make sure the schema is cleared out
    .dropAllTablesFromSchema(connectionDetails, cdmDatabaseSchema)
    cat(paste("Connecting to schema", cdmDatabaseSchema, "\n"))
    executeDdl(connectionDetails,
               cdmVersion = cdmVersion,
               cdmDatabaseSchema = cdmDatabaseSchema,
               executeDdl = TRUE,
               executePrimaryKey = TRUE,
               executeForeignKey = FALSE)

    tables <- .listTablesInSchema(connectionDetails, schema = cdmDatabaseSchema)

    cdmTableCsvLoc <- system.file(file.path("csv", paste0("OMOP_CDMv", cdmVersion, "_Table_Level.csv")), package = "CommonDataModel", mustWork = TRUE)
    tableSpecs <- read.csv(cdmTableCsvLoc, stringsAsFactors = FALSE)$cdmTableName

    # check that the tables in the database match the tables in the specification
    expect_equal(sort(tables), sort(tableSpecs))

    # clear schema
    .dropAllTablesFromSchema(connectionDetails, cdmDatabaseSchema)
  }
})

test_that("Execute DDL on Redshift", {

  connectionDetails <- createConnectionDetails(
    dbms = "redshift",
    user = Sys.getenv("CDMDDLBASE_REDSHIFT_USER"),
    password = Sys.getenv("CDMDDLBASE_REDSHIFT_PASSWORD"),
    server = Sys.getenv("CDMDDLBASE_REDSHIFT_SERVER"),
    pathToDriver = file.path(Sys.getenv("HOME"), "drivers")
  )

  expect_error(con <- connect(connectionDetails), NA)
  disconnect(con)

  cdmDatabaseSchema <- Sys.getenv("CDMDDLBASE_REDSHIFT_SCHEMA")

  for(cdmVersion in listSupportedVersions()) {
    # make sure the schema is cleared out
    .dropAllTablesFromSchema(connectionDetails, cdmDatabaseSchema)
    executeDdl(connectionDetails,
               cdmVersion = cdmVersion,
               cdmDatabaseSchema = cdmDatabaseSchema,
               executeDdl = TRUE,
               executePrimaryKey = TRUE,
               executeForeignKey = FALSE)

    tables <- .listTablesInSchema(connectionDetails, schema = cdmDatabaseSchema)

    cdmTableCsvLoc <- system.file(file.path("csv", paste0("OMOP_CDMv", cdmVersion, "_Table_Level.csv")), package = "CommonDataModel", mustWork = TRUE)
    tableSpecs <- read.csv(cdmTableCsvLoc, stringsAsFactors = FALSE)$cdmTableName

    # check that the tables in the database match the tables in the specification
    expect_equal(sort(tables), sort(tableSpecs))

    # clear schema
    .dropAllTablesFromSchema(connectionDetails, cdmDatabaseSchema)
  }
})
