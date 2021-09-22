# To run tests for one dbms and one cdmVersion use the variables below
# dbms <- "postgresql"; cdmVersion <- "5.4"

testDatabases <- c("oracle", "postgresql", "sql server", "redshift")
# testDatabases <- c("redshift")

test_that("getConnectionDetails works", {
  for(dbms in testDatabases) {
    expect_s3_class(getConnectionDetails(dbms), "connectionDetails")
  }
})

test_that("getSchema works", {
  for(dbms in testDatabases) {
    expect_type(getSchema(dbms), "character")
  }
})

for(dbms in testDatabases) {
  connectionDetails <- getConnectionDetails(dbms)
  cdmDatabaseSchema <- getSchema(dbms)

  test_that(paste("Can connect to", dbms), {
    expect_error(con <- connect(connectionDetails), NA)
    expect_error(disconnect(con), NA)
  })


  for(cdmVersion in listSupportedVersions()) {
    test_that(paste("DDL", cdmVersion, "runs on", dbms), {
      dropAllTablesFromSchema(connectionDetails, cdmDatabaseSchema)
      tables <- listTablesInSchema(connectionDetails, cdmDatabaseSchema)
      expect_equal(tables, character(0))

      executeDdl(connectionDetails,
                 cdmVersion = cdmVersion,
                 cdmDatabaseSchema = cdmDatabaseSchema,
                 executeDdl = TRUE,
                 executePrimaryKey = TRUE,
                 executeForeignKey = FALSE)

      tables <- listTablesInSchema(connectionDetails, cdmDatabaseSchema)
      cdmTableCsvLoc <- system.file(file.path("csv", paste0("OMOP_CDMv", cdmVersion, "_Table_Level.csv")), package = "CommonDataModel", mustWork = TRUE)
      tableSpecs <- read.csv(cdmTableCsvLoc, stringsAsFactors = FALSE)$cdmTableName

      # check that the tables in the database match the tables in the specification
      expect_equal(sort(tolower(tables)), sort(tolower(tableSpecs)))
      dropAllTablesFromSchema(connectionDetails, cdmDatabaseSchema)
    })
  }
}
