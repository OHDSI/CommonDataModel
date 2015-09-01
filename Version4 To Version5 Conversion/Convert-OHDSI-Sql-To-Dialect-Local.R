# Load Libraries
install.packages(devtools)
library(devtools)
install_github("OHDSI/SqlRender")
library(SqlRender)
# Variables
ohdsiSqlFile <- "C:/Git/CommonDataModel/Version4 To Version5 Conversion/OMOP CDMv4 to CDMv5 - OHDSI-SQL.sql"
targetSqlServerFile <- "C:/Git/CommonDataModel/Version4 To Version5 Conversion/Sql Server/OMOP CDMv4 to CDMv5 - SQL Server.sql"
targetPostgreSqlFile <- "C:/Git/CommonDataModel/Version4 To Version5 Conversion/PostgreSQL/OMOP CDMv4 to CDMv5 - PostgreSQL.sql"
targetOracleFile <- "C:/Git/CommonDataModel/Version4 To Version5 Conversion/Oracle/OMOP CDMv4 to CDMv5 - Oracle.sql"
targetSqlServerPDWFile <- "C:/Git/CommonDataModel/Version4 To Version5 Conversion/Sql Server PDW/OMOP CDMv4 to CDMv5 - Sql Server PDW.dsql"
targetRedshiftFile <- "C:/Git/CommonDataModel/Version4 To Version5 Conversion/Redshift/OMOP CDMv4 to CDMv5 - Redshift.sql"

##### LOCAL - SQL Server Testing
#renderSqlFile(ohdsiSqlFile, targetSqlServerFile, SOURCE_CDMV4 = "[CDMV4]", SOURCE_CDMV4_SCHEMA = "[CDMV4].[dbo]", TARGET_CDMV5 = "[CDMV5]", TARGET_CDMV5_SCHEMA = "[CDMV5].[dbo]")

##### SQL Server Testing
#renderSqlFile(ohdsiSqlFile, targetSqlServerFile, SOURCE_CDMV4 = "[CDM_TRUVEN_CCAE_6k]", SOURCE_CDMV4_SCHEMA = "[CDM_TRUVEN_CCAE_6k].[dbo]", TARGET_CDMV5 = "[CDMV5_Conversion_Target]", TARGET_CDMV5_SCHEMA = "[CDMV5_Conversion_Target].[dbo]")

##### PostgreSql Testing
#renderSqlFile(ohdsiSqlFile, targetSqlServerFile, SOURCE_CDMV4 = "sandbox", SOURCE_CDMV4_SCHEMA = "sandbox.cdmv4", TARGET_CDMV5 = "sandbox", TARGET_CDMV5_SCHEMA = "sandbox.cdmv5")
#translateSqlFile(sourceFile = targetSqlServerFile, targetFile = targetPostgreSqlFile, targetDialect = "postgresql")

##### Oracle Testing
#renderSqlFile(ohdsiSqlFile, targetSqlServerFile, SOURCE_CDMV4 = "CDMV4", SOURCE_CDMV4_SCHEMA = "CDMV4", TARGET_CDMV5 = "CDMV5", TARGET_CDMV5_SCHEMA = "CDMV5")
#translateSqlFile(sourceFile = targetSqlServerFile, targetFile = targetOracleFile, targetDialect = "oracle")

##### APS Testing
#renderSqlFile(ohdsiSqlFile, targetSqlServerFile, SOURCE_CDMV4 = "[CDM_THIN]", SOURCE_CDMV4_SCHEMA = "[CDM_THIN].[dbo]", TARGET_CDMV5 = "[CDM_THIN_V5_asena5]", TARGET_CDMV5_SCHEMA = "[CDM_THIN_V5_asena5].[dbo]")
#translateSqlFile(sourceFile = targetSqlServerFile, targetFile = targetSqlServerPDWFile, targetDialect = "pdw")

##### Push to GitHub
renderSqlFile(ohdsiSqlFile, targetSqlServerFile)
translateSqlFile(sourceFile = targetSqlServerFile, targetFile = targetPostgreSqlFile, targetDialect = "postgresql")
translateSqlFile(sourceFile = targetSqlServerFile, targetFile = targetOracleFile, targetDialect = "oracle")
translateSqlFile(sourceFile = targetSqlServerFile, targetFile = targetSqlServerPDWFile, targetDialect = "pdw")
translateSqlFile(sourceFile = targetSqlServerFile, targetFile = targetRedshiftFile, targetDialect = "redshift")

