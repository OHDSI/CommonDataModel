# Download the JDBC drivers used in the tests
library(DatabaseConnector)

driverPath <- file.path(Sys.getenv("HOME"), "drivers")
if(!dir.exists(driverPath)) dir.create(driverPath)

if(Sys.getenv("LOCAL_TEST") != "TRUE") {
  cat("downloading drivers")
  downloadJdbcDrivers("all", pathToDriver = driverPath)
}


postgresDetails <- createConnectionDetails(
  dbms = "postgresql",
  user = Sys.getenv("CDMDDLBASE_POSTGRESQL_USER"),
  password = Sys.getenv("CDMDDLBASE_POSTGRESQL_PASSWORD"),
  server = Sys.getenv("CDMDDLBASE_POSTGRESQL_SERVER"),
  pathToDriver = file.path(Sys.getenv("HOME"), "drivers"),
  cdmSchema = Sys.getenv("CDMDDLBASE_POSTGRESQL_SCHEMA")
)

redshiftDetails <- createConnectionDetails(
  dbms = "redshift",
  user = Sys.getenv("CDMDDLBASE_REDSHIFT_USER"),
  password = Sys.getenv("CDMDDLBASE_REDSHIFT_PASSWORD"),
  server = Sys.getenv("CDMDDLBASE_REDSHIFT_SERVER"),
  pathToDriver = file.path(Sys.getenv("HOME"), "drivers"),
  cdmSchema = Sys.getenv("CDMDDLBASE_REDSHIFT_SCHEMA")
)

sqlserverDetails <- createConnectionDetails(
  dbms = "sql server",
  user = Sys.getenv("CDMDDLBASE_SQL_SERVER_USER"),
  password = Sys.getenv("CDMDDLBASE_SQL_SERVER_PASSWORD"),
  server = Sys.getenv("CDMDDLBASE_SQL_SERVER_SERVER"),
  pathToDriver = file.path(Sys.getenv("HOME"), "drivers"),
  cdmSchema = Sys.getenv("CDMDDLBASE_SQL_SERVER_CDM_SCHEMA")
)

oracleDetails <- createConnectionDetails(
  dbms = "oracle",
  user = Sys.getenv("CDMDDLBASE_ORACLE_USER"),
  password = Sys.getenv("CDMDDLBASE_ORACLE_PASSWORD"),
  server = Sys.getenv("CDMDDLBASE_ORACLE_SERVER"),
  pathToDriver = file.path(Sys.getenv("HOME"), "drivers"),
  cdmSchema = Sys.getenv("CDMDDLBASE_ORACLE_CDM_SCHEMA")
)
