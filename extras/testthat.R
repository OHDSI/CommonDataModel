library(DatabaseConnector)

##### Oracle Testing
oracleConnect <- DatabaseConnector::createConnectionDetails(dbms = "oracle",
                                                            user = Sys.getenv("CDM5_ORACLE_USER"),
                                                            password = Sys.getenv("CDM5_ORACLE_PASSWORD"),
                                                            server = Sys.getenv("CDM5_ORACLE_SERVER"),
                                                            schema = Sys.getenv("CDM5_ORACLE_CDM_SCHEMA"))

conn <- DatabaseConnector::connect(connectionDetails = oracleConnect)

## Run oracle ddl
sql <- SqlRender::readSql(paste0("output/oracle/OMOP CDM oracle ", cdmVersion," ddl.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
                              )

## Run oracle primary keys
sql <- SqlRender::readSql(paste0("output/oracle/OMOP CDM oracle ", cdmVersion," primary keys.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Run oracle constraints
sql <- SqlRender::readSql(paste0("output/oracle/OMOP CDM oracle ", cdmVersion," constraints.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Run oracle indices
sql <- SqlRender::readSql(paste0("output/oracle/OMOP CDM oracle ", cdmVersion," indices.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Remove oracle tables
sql <- SqlRender::readSql(paste0("output/oracle/oracle testCleanUp ", "v5_3_1",".sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)


DatabaseConnector::disconnect(conn)

##########################################################################
##### Postgres Testing
postgresConnect <- DatabaseConnector::createConnectionDetails(dbms = "postgresql",
                                                            user = Sys.getenv("CDM5_POSTGRESQL_USER"),
                                                            password = Sys.getenv("CDM5_POSTGRESQL_PASSWORD"),
                                                            server = Sys.getenv("CDM5_POSTGRESQL_SERVER"),
                                                            schema = Sys.getenv("CDM5_POSTGRESQL_OHDSI_SCHEMA"))

conn <- DatabaseConnector::connect(connectionDetails = postgresConnect)

## Run postgres ddl
sql <- SqlRender::readSql(paste0("output/postgresql/OMOP CDM postgresql ", cdmVersion," ddl.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Run postgres primary keys
sql <- SqlRender::readSql(paste0("output/postgresql/OMOP CDM postgresql", cdmVersion," primary keys.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Run postgres constraints
sql <- SqlRender::readSql(paste0("output/postgresql/OMOP CDM postgresql ", cdmVersion," constraints.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Run postgres indices
sql <- SqlRender::readSql(paste0("output/postgresql/OMOP CDM postgresql ", cdmVersion," indices.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Remove postgres tables
sql <- SqlRender::readSql(paste0("output/postgresql/postgresql testCleanUp ", "v5_3_1",".sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)


DatabaseConnector::disconnect(conn)

##### Sql Server Testing
sqlServerConnect <- DatabaseConnector::createConnectionDetails(dbms = "sql server",
                                                              user = Sys.getenv("CDM5_SQL_SERVER_USER"),
                                                              password = Sys.getenv("CDM5_SQL_SERVER_PASSWORD"),
                                                              server = Sys.getenv("CDM5_SQL_SERVER_SERVER"),
                                                              schema = Sys.getenv("CDM5_SQL_SERVER_OHDSI_SCHEMA"))

conn <- DatabaseConnector::connect(connectionDetails = sqlServerConnect)

## Create sql server tables
sql <- SqlRender::readSql(paste0("output/sql server/OMOP CDM sql server ", cdmVersion," ddl.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Run sql server primary keys and indices
sql <- SqlRender::readSql(paste0("output/sql server/OMOP CDM sql server ", cdmVersion," primary keys.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Run sql server constraints
sql <- SqlRender::readSql(paste0("output/sql server/OMOP CDM sql server ", cdmVersion," constraints.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Run sql server indices
sql <- SqlRender::readSql(paste0("output/sql server/OMOP CDM sql server ", cdmVersion," indices.sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)

## Remove sql server tables
sql <- SqlRender::readSql(paste0("output/sql server/sql server testCleanUp ", "v6_0",".sql"))

DatabaseConnector::executeSql(connection = conn,
                              sql = sql,
                              progressBar = TRUE
)


DatabaseConnector::disconnect(conn)

