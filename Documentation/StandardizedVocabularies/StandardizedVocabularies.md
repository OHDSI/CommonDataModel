*OMOP Common Data Model v5.1 Specifications*
<br>*Authors: Christian Reich, Patrick Ryan, Rimma Belenkaya, Karthik Natarajan, Clair Blacketer*
<br>***Release date needed***

[Back to Table of Contents](https://github.com/OHDSI/CommonDataModel/blob/master/Documentation/TableofContents.md)

---

# 3 Standardized Vocabularies

<br>[3.1 CONCEPT](CONCEPT.md)
<br>3.2 VOCABULARY
<br>3.3 DOMAIN
<br>3.4 CONCEPT_CLASS
<br>3.5 CONCEPT_RELATIONSHIP
<br>3.6 RELATIONSHIP
<br>3.7 CONCEPT_SYNONYM
<br>3.8 CONCEPT_ANCESTOR
<br>3.9 SOURCE_TO_CONCEPT_MAP
<br>3.10 DRUG_STRENGTH
<br>3.11 COHORT_DEFINITION
<br>3.12 ATTRIBUTE_DEFINITION

These tables contain detailed information about the Concepts used in all of the CDM fact tables. The content of the Standardized Vocabularies tables is not generated anew by each CDM implementation. Instead, it is maintained centrally as a service to the community.

A number of assumptions were made for the design of the Standardized Vocabularies tables: 

  * There is one design which will accommodate all different source terminologies and classifications.
  * All terminologies are loaded into the CONCEPT table. 
  * The key is a newly created concept_id, not the original code of the terminology, because source codes are not unique identifiers across terminologies. 
  * Some Concepts are declared Standard Concepts, i.e. they are used to represent a certain clinical entity in the data. All Concepts may be Source Concepts; they represent how the entity was coded in the source. Standard Concepts are identified through the standard_concept field in the CONCEPT table.
  * Records in the CONCEPT_RELATIONSHIP table define semantic relationships between Concepts. Such relationships can be hierarchical or lateral. 
  * Records in the CONCEPT_RELATIONSHIP table are used to map Source codes to Standard Concepts, replacing the mechanism of the SOURCE_TO_CONCEPT_MAP table used in prior Standardized Vocabularies versions. The SOURCE_TO_CONCEPT_MAP table is retained as an optional aid to bookkeeping codes not found in the Standardized Vocabularies.
  * Chains of hierarchical relationships are recorded in the CONCEPT_ANCESTOR table. Ancestry relationships are only recorded between Standard Concepts that are valid (not deprecated) and are connected through valid and hierarchical relationships in the RELATIONSHIP table (flag defines_ancestry).
  
The advantage of this approach lies in the preservation of codes and relationships between them without adherence to the multiple different source data structures, a simple design for standardized access, and the optimization of performance for analysis. Navigation among Standard Concepts does not require knowledge of the source vocabulary. Finally, the approach is scalable and future vocabularies can be integrated easily. On the other hand, extensive transformation of source data to the Vocabulary is required and not every source data structure and original source hierarchy can be retained.

Below is an entity-relationship diagram highlighting the tables within the Vocabulary portion of the OMOP Common Data Model:

![](images/vocabulary_tables.png)  