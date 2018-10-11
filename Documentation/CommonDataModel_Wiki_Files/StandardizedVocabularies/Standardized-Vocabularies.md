[CONCEPT](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT)  
[VOCABULARY](https://github.com/OHDSI/CommonDataModel/wiki/VOCABULARY)  
[DOMAIN](https://github.com/OHDSI/CommonDataModel/wiki/DOMAIN)  
[CONCEPT_CLASS](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT_CLASS)  
[CONCEPT_RELATIONSHIP](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT_RELATIONSHIP)  
[RELATIONSHIP](https://github.com/OHDSI/CommonDataModel/wiki/RELATIONSHIP)  
[CONCEPT_SYNONYM](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT_SYNONYM)  
[CONCEPT_ANCESTOR](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT_ANCESTOR)  
[SOURCE_TO_CONCEPT_MAP](https://github.com/OHDSI/CommonDataModel/wiki/SOURCE_TO_CONCEPT_MAP)  
[DRUG_STRENGTH](https://github.com/OHDSI/CommonDataModel/wiki/DRUG_STRENGTH)  

These tables contain detailed information about the Concepts used in all of the CDM fact tables. The content of the Standardized Vocabularies tables is not generated anew by each CDM implementation. Instead, it is maintained centrally as a service to the community.

A number of assumptions were made for the design of the Standardized Vocabularies tables: 

  * There is one design which will accommodate all different source terminologies and classifications.
  * All terminologies are loaded into the CONCEPT table. 
  * The key is a newly created concept_id, not the original code of the terminology, because source codes are not unique identifiers across terminologies. 
  * Some Concepts are declared Standard Concepts, i.e. they are used to represent a certain clinical entity in the data. All Concepts may be Source Concepts; they represent how the entity was coded in the source. Standard Concepts are identified through the standard_concept field in the CONCEPT table.
  * Records in the CONCEPT_RELATIONSHIP table define semantic relationships between Concepts. Such relationships can be hierarchical or lateral. 
  * Records in the CONCEPT_RELATIONSHIP table are used to map Source codes to Standard Concepts, replacing the mechanism of the SOURCE_TO_CONCEPT_MAP table used in prior Standardized Vocabularies versions. The SOURCE_TO_CONCEPT_MAP table is retained as an optional aid to bookkeeping codes not found in the Standardized Vocabularies.
  * Chains of hierarchical relationships are recorded in the CONCEPT_ANCESTOR table. Ancestry relationships are only recorded between Standard Concepts that are valid (not deprecated) and are connected through valid and hierarchical relationships in the RELATIONSHIP table (flag DEFINES_ANCESTRY).
  
The advantage of this approach lies in the preservation of codes and relationships between them without adherence to the multiple different source data structures, a simple design for standardized access, and the optimization of performance for analysis. Navigation among Standard Concepts does not require knowledge of the source vocabulary. Finally, the approach is scalable and future vocabularies can be integrated easily. On the other hand, extensive transformation of source data to the Vocabulary is required and not every source data structure and original source hierarchy can be retained.

Below is an entity-relationship diagram highlighting the tables within the Vocabulary portion of the OMOP Common Data Model:

![Vocabulary entity-relationship diagram](http://www.ohdsi.org/web/wiki/lib/exe/fetch.php?cache=&w=900&h=714&tok=3c9ce1&media=documentation:cdm:vocabulary_tables.png)
  