# Download the JDBC drivers used in the tests

driverPath <- file.path(Sys.getenv("HOME"), "drivers")
if(!dir.exists(driverPath)) dir.create(driverPath)

if(!Sys.getenv("LOCAL_TEST" == "TRUE")) {
  DatabaseConnector::downloadJdbcDrivers("all", pathToDriver = driverPath)
}
