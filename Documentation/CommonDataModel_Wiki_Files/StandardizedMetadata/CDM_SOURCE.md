The CDM_SOURCE table contains detail about the source database and the process used to transform the data into the OMOP Common Data Model. 

Field|Required|Type|Description
:------------------------------|:--------|:------------|:-----------------------------------------
|cdm_source_name|Yes|varchar(255)|The full name of the source|
|cdm_source_abbreviation|No|varchar(25)|An abbreviation of the name|
|cdm_holder|No|varchar(255)|The name of the organization responsible for the development of the CDM instance|
|source_description|No|CLOB|A description of the source data origin and purpose for collection. The description may contain a summary of the period of time that is expected to be covered by this dataset.|
|source_documentation_reference|No|varchar(255)|URL or other external reference to location of source documentation|
|cdm_etl_reference|No|varchar(255)|URL or other external reference to location of ETL specification documentation and ETL source code|
|source_release_date|No|date|The date for which the source data are most current, such as the last day of data capture|
|cdm_release_date|No|date|The date when the CDM was instantiated|
|cdm_version|No|varchar(10)|The version of CDM used|
|vocabulary_version|No|varchar(20)|The version of the vocabulary used|

### Conventions 

  * If a source database is derived from multiple data feeds, the integration of those disparate sources is expected to be documented in the ETL specifications. The source information on each of the databases can be represented as separate records in the CDM_SOURCE table. 
  * Currently, there is no mechanism to link individual records in the CDM tables to their source record in the CDM_SOURCE table.
  * The version of the vocabulary can be obtained from the vocabulary_name field in the VOCABULARY table for the record where vocabulary_id='None'.
