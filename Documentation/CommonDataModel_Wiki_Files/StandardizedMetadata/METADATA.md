The METADATA table contains metadata information about a dataset that has been transformed to the OMOP Common Data Model. 

Field					|Required	|Type	|Description
:------------------------------|:--------|:------------|:-----------------------------------------
|metadata_concept_id		|Yes		|integer		|A foreign key that refers to a Standard Metadata Concept identifier in the Standardized Vocabularies.|
|metadata_type_concept_id	|Yes		|integer		|A foreign key that refers to a Standard Type Concept identifier in the Standardized Vocabularies.|
|name						|Yes		|varchar(250)	|The name of the Concept stored in metadata_concept_id or a description of the data being stored.|
|value_as_string			|No			|nvarchar		|The metadata value stored as a string.|
|value_as_concept_id		|No			|integer		|A foreign key to a metadata value stored as a Concept ID.|
|metadata date				|No			|date			|The date associated with the metadata|
|metadata_datetime			|No			|datetime		|The date and time associated with the metadata|

### Conventions 

No.|Convention Description
:--------|:------------------------------------
| 1  | One record in the Metadata table is pre-populated in the DDL indicating the CDM version of the database. |