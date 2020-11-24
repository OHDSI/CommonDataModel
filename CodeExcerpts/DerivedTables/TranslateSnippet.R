

library(SqlRender);library(RCurl)

#specify URL of sql code written in parametized SQL        (see some examples below)
# url<-'https://raw.githubusercontent.com/OHDSI/CommonDataModel/master/Version4%20To%20Version5%20Conversion/OMOP%20CDMv4%20to%20CDMv5%20-%20OHDSI-SQL.sql'
url<-'https://raw.githubusercontent.com/OHDSI/Achilles/master/inst/sql/sql_server/export/drugera/sqlPrevalenceByGenderAgeYear.sql'

#get the code
sql<-getURL(url)


#inspect what parameters are needed by searching for @

#decide your parameters
results='ccae'
vocab='public'


#fill in parameters
tta<-SqlRender::renderSql(sql,results_database_schema=results,vocab_database_schema=vocab)


#translate into target dialect

ttb<-SqlRender::translateSql(tta$sql,targetDialect = 'postgresql')


#write final SQL to a local file
cat(ttb$sql,file='c:/temp/drug_era_2017.sql')
sql<-ttb$sql



#loop for making flavors

fname<-'GenerateEra.sql'
flavors<-c(
'oracle'
,'postgresql'
,'pdw'
,'redshift'
,'impala'
,'netezza'
,'bigquery'
,'sql server')



for (flavor in flavors){
  print(flavor)
  sql<-readChar(fname, file.info(fname)$size)
  tta<-SqlRender::renderSql(sql,results_database_schema='results',vocab_database_schema='vocab')
  ttb<-SqlRender::translateSql(tta$sql,targetDialect = flavor)
  dir.create(flavor)
  cat(ttb$sql,file=file.path(flavor,paste0(fname)))
  # sql<-ttb$sql
  
}
  
  

