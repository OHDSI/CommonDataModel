# Download the JDBC drivers used in the tests

# oldJarFolder <- Sys.getenv("DATABASECONNECTOR_JAR_FOLDER")

driverPath <- file.path(Sys.getenv("HOME"), "drivers")
if(!dir.exists(driverPath)) dir.create(driverPath)
Sys.setenv("DATABASECONNECTOR_JAR_FOLDER" = driverPath)
DatabaseConnector::downloadJdbcDrivers("postgresql", pathToDriver = driverPath)

print(Sys.getenv("DATABASECONNECTOR_JAR_FOLDER"))
list.files(driverPath)
# if(Sys.getenv("DATABASECONNECTOR_JAR_FOLDER") == "") {
  # driverPath <- file.path(Sys.getenv("HOME"), "drivers")
# }
# downloadJdbcDrivers("sql server")
# downloadJdbcDrivers("oracle")

# withr::defer({
#   unlink(Sys.getenv("DATABASECONNECTOR_JAR_FOLDER"), recursive = TRUE, force = TRUE)
#   Sys.setenv("DATABASECONNECTOR_JAR_FOLDER" = oldJarFolder)
# }, testthat::teardown_env())
