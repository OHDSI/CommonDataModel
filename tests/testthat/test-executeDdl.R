library(DatabaseConnector)

connectionDetails <- createConnectionDetails(
    dbms = "postgresql",
    user = Sys.getenv("CDMDDLBASE_POSTGRESQL_USER"),
    password = Sys.getenv("CDMDDLBASE_POSTGRESQL_PASSWORD"),
    server = Sys.getenv("CDMDDLBASE_POSTGRESQL_SERVER"),
    pathToDriver = file.path(Sys.getenv("HOME"), "drivers")
)

# Helper functions used in tests
.listTablesInSchema <- function(connectionDetails, schema) {
  con <- DatabaseConnector::connect(connectionDetails)
  tables <- DBI::dbListObjects(con, prefix = "cdmddlbase")
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

.removeConstraintsPostgresql <- function(connectionDetails, schema) {
  # the order of removal of constraints matters!
  con <- DatabaseConnector::connect(connectionDetails)
  constraints <- DBI::dbGetQuery(con,
  "SELECT con.conname, rel.relname as relname
    FROM pg_catalog.pg_constraint con
  INNER JOIN pg_catalog.pg_class rel
  ON rel.oid = con.conrelid
  INNER JOIN pg_catalog.pg_namespace nsp
  ON nsp.oid = connamespace
  WHERE nsp.nspname = 'cdmddlbase';")


  constraints <- dplyr::mutate(constraints, sql = paste0("alter table ", schema, ".", relname, " drop constraint if exists ", conname, ";\n" ))

  sql <- paste(rev(constraints$sql), collapse = "")
  executeSql(con, sql)

  disconnect(con)

}

test_that("Database can be connected to", {
  expect_error(con <- connect(connectionDetails), NA)
  disconnect(con)
})

test_that("Execute DDL on Postgres", {
  # make sure the schema is cleared out
  cdmDatabaseSchema <- Sys.getenv("CDMDDLBASE_POSTGRESQL_SCHEMA")
  cdmVersion <- "5.4"
  # .removeConstraintsPostgresql(connectionDetails, cdmDatabaseSchema)
  .dropAllTablesFromSchema(connectionDetails, cdmDatabaseSchema)

  executeDdl(connectionDetails,
             cdmVersion = cdmVersion,
             cdmDatabaseSchema = cdmDatabaseSchema,
             executeDdl = TRUE,
             executePrimaryKey = FALSE,
             executeForeignKey = FALSE)

  tables <- .listTablesInSchema(connectionDetails, schema = cdmDatabaseSchema)

  cdmTableCsvLoc <- system.file(file.path("csv", paste0("OMOP_CDMv", cdmVersion, "_Table_Level.csv")), package = "CommonDataModel", mustWork = TRUE)
  tableSpecs <- read.csv(cdmTableCsvLoc, stringsAsFactors = FALSE)$cdmTableName

  # check that the tables in the database match the tables in the specification
  expect_equal(sort(tables), sort(tableSpecs))

  # clear schema
  # .removeConstraintsPostgresql(connectionDetails, cdmDatabaseSchema)
  .dropAllTablesFromSchema(connectionDetails, cdmDatabaseSchema)
})
