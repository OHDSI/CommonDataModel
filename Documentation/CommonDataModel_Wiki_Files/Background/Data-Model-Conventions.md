There are a number of implicit and explicit conventions that have been adopted in the CDM. Developers of methods that run against the CDM need to understand these conventions.

### General conventions of data tables

The CDM is platform-independent. Data types are defined generically using ANSI SQL data types (VARCHAR, INTEGER, FLOAT, DATE, DATETIME, CLOB). Precision is provided only for VARCHAR. It reflects the minimal required string length and can be expanded within a CDM instantiation. The CDM does not prescribe the date and datetime format. Standard queries against CDM may vary for local instantiations and date/datetime configurations. 

In most cases, the first field in each table ends in '_ID', containing a record identifier that can be used as a foreign key in another table.

### General conventions of fields 

Variable names across all tables follow one convention:

Notation|Description
---------------------|--------------------------------------------------
|<entity>_SOURCE_VALUE|Verbatim information from the source data, typically used in ETL to map to CONCEPT_ID, and not to be used by any standard analytics. For example, CONDITION_SOURCE_VALUE = '787.02' was the ICD-9 code captured as a diagnosis from the administrative claim.|
|<entity>_ID|Unique identifiers for key entities, which can serve as foreign keys to establish relationships across entities. For example, PERSON_ID uniquely identifies each individual. VISIT_OCCURRENCE_ID uniquely identifies a PERSON encounter at a point of care.|
|<entity>_CONCEPT_ID|Foreign key into the Standardized Vocabularies (i.e. the standard_concept attribute for the corresponding term is true), which serves as the primary basis for all standardized analytics. For example, CONDITION_CONCEPT_ID = [31967](http://athena.ohdsi.org/search-terms/terms/31967) contains the reference value for the SNOMED concept of 'Nausea'|
|<entity>_SOURCE_CONCEPT_ID|Foreign key into the Standardized Vocabularies representing the concept and terminology used in the source data, when applicable. For example, CONDITION_SOURCE_CONCEPT_ID = [45431665](http://athena.ohdsi.org/search-terms/terms/45431665) denotes the concept of 'Nausea' in the Read terminology; the analogous CONDITION_CONCEPT_ID might be 31967, since SNOMED-CT is the Standardized Vocabulary for most clinical diagnoses and findings.|
|<entity>_TYPE_CONCEPT_ID|Delineates the origin of the source information, standardized within the Standardized Vocabularies. For example, DRUG_TYPE_CONCEPT_ID can allow analysts to discriminate between 'Pharmacy dispensing' and 'Prescription written'|

### Representation of content through Concepts 

In CDM data tables the meaning of the content of each record is represented using Concepts. Concepts are stored with their CONCEPT_ID as foreign keys to the CONCEPT table in the Standardized Vocabularies, which contains Concepts necessary to describe the healthcare experience of a patient. If a Standard Concept does not exist or cannot be identified, the Concept with the CONCEPT_ID 0 is used, representing a non-existing or unmappable concept.

Records in the CONCEPT table contain all the detailed information about it (name, domain, class etc.). Concepts, Concept Relationships and other information relating to Concepts is contained in the tables of the Standardized Vocabularies.

### Difference between Concept IDs and Source Values 

Many tables contain equivalent information multiple times: As a Source Value, a Source Concept and as a Standard Concept.  

  * Source Values contain the codes from public code systems such as ICD-9-CM, NDC, CPT-4 etc. or locally controlled vocabularies (such as F for female and M for male) copied from the source data. Source Values are stored in the *_SOURCE_VALUE fields in the data tables. 
  * Concepts are CDM-specific entities that represent the meaning of a clinical fact. Most concepts are based on code systems used in healthcare (called Source Concepts), while others were created de-novo (CONCEPT_CODE = 'OMOP generated'). Concepts have unique IDs across all domains. 
  * Source Concepts are the concepts that represent the code used in the source. Source Concepts are only used for common healthcare code systems, not for OMOP-generated Concepts. Source Concepts are stored in the *_SOURCE_CONCEPT_ID field in the data tables.
  * Standard Concepts are those concepts that are used to define the unique meaning of a clinical entity. For each entity there is one Standard Concept. Standard Concepts are typically drawn from existing public vocabulary sources. Concepts that have the equivalent meaning to a Standard Concept are mapped to the Standard Concept. Standard Concepts are referred to in the <entity>_CONCEPT_ID field of the data tables. 

Source Values are only provided for convenience and quality assurance (QA) purposes. Source Values and Source Concepts are optional, while Standard Concepts are mandatory. Source Values may contain information that is only meaningful in the context of a specific data source. 

### Difference between general Concepts and Type Concepts 

Type Concepts (ending in _TYPE_CONCEPT_ID) and general Concepts (ending in _CONCEPT_ID) are part of many tables. The former are special Concepts with the purpose of indicating where the data are derived from in the source. For example, the Type Concept field can be used to distinguish a DRUG_EXPOSURE record that is derived from a pharmacy-dispensing claim from one indicative of a prescription written in an electronic health record (EHR).

### Time span of available data 

Data tables for clinical data contain a datetime stamp (ending in _DATETIME, _START_DATETIME or _END_DATETIME), indicating when that clinical event occurred. As a rule, no record can be outside of a valid OBSERVATION_PERIOD time period. Clinical information that relates to events that happened prior to the first OBSERVATION_PERIOD will be captured as a record in the OBSERVATION table as 'Medical history' (CONCEPT_ID = 43054928), with the OBSERVATION_DATETIME set to the first OBSERVATION_PERIOD_START_DATE of that patient, and the VALUE_AS_CONCEPT_ID set to the corresponding CONCEPT_ID for the condition/drug/procedure that occurred in the past. No data occurring after the last OBSERVATION_PERIOD_END_DATE can be valid records in the CDM.
  * When mapping source data to the CDM, if time is unknown the default time of 00:00:00 should be chosen. If a time of 00:00:00 is given in the source data it should be shifted to 00:00:01.

### Content of each table 

For the tables of the main domains of the CDM it is imperative that concepts used are strictly limited to the domain. For example, the CONDITION_OCCURRENCE table contains only information about conditions (diagnoses, signs, symptoms), but no information about procedures. Not all source coding schemes adhere to such rules. For example, ICD-9-CM codes, which contain mostly diagnoses of human disease, also contain information about the status of patients having received a procedure. The ICD-9-CM code V20.3 'Newborn health supervision' defines a continuous procedure and is therefore stored in the PROCEDURE_OCCURRENCE table.

### Differentiating between Source Values, Source Concept Ids, and Standard Concept Ids 

Each table contains fields for Source Values, Source Concept Ids, and Standard Concept Ids. 

  * Source Values are fields to maintain the verbatim information from the source database, stored as unstructured text, and are generally not to be used by any standardized analytics. There is no standardization for these fields and these columns can be used as the local CDM builders see fit. A typical example would be an ICD-9 code without the decimal from an administrative claim as condition_source_value = '78702' which is how it appeared in the source.
  * Source Concept Ids provide a repeatable representation of the source concept, when the source data are drawn from a commonly-used, internationally-recognized vocabulary that has been distributed with the OMOP Common Data Model. Specific use cases where source vocabulary-specific analytics are required can be accommodated by the use of the *_SOURCE_CONCEPT_ID fields, but these are generally not applicable across disparate data sources. The standard *_CONCEPT_ID fields are **strongly suggested** to be used in all standardized analytics, as specific vocabularies have been established within each data domain to facilitate standardization of both structure and content within the OMOP Common Data Model.

The following provide conventions for processing source data using these three fields in each domain:

When processing data where the source value is either free text or a reference to a coding scheme that is not contained within the Standardized Vocabularies:

  - Map all Source Values directly to Standard CONCEPT_IDs. Store these mappings in the SOURCE_TO_CONCEPT_MAP table. 
    - If the source code is not mappable to a vocabulary term, the SOURCE_CONCEPT_ID field is set to 0

When processing your data where Source Value is a reference to a coding scheme contained within the Standardized Vocabularies:
  
  - Map all your Source Values to the corresponding CONCEPT_IDs in the Source Vocabulary. Store the result in the SOURCE_CONCEPT_ID field. 
    - If the source code follows the same formatting as the distributed vocabulary, the mapping can be directly obtained from the CONCEPT table using the CONCEPT_CODE field. 
    - If the source code uses alternative formatting (ex. format has removed decimal point from ICD-9 codes), you will need to perform the formatting transformation within the ETL. In this case, you may wish to store the mappings from original codes to SOURCE_CONCEPT_IDs in the SOURCE_TO_CONCEPT_MAP table.
    - If the source code is not mappable to a vocabulary term, the SOURCE_CONCEPT_ID field is set to 0
  - Use the CONCEPT_RELATIONSHIP table to identify the Standard CONCEPT_ID that corresponds to the SOURCE_CONCEPT_ID in the domain.
    - Each SOURCE_CONCEPT_ID can have 1 or more Standard CONCEPT_IDs mapped to it. Each Standard CONCEPT_ID belongs to only one primary domain but when a source CONCEPT_ID maps to multiple Standard CONCEPT_IDs, it is possible for that SOURCE_CONCEPT_ID to result in records being produced across multiple domains. For example, ICD-10-CM code Z34.00 'Encounter for supervision of normal first pregnancy, unspecified trimester' will be mapped to the SNOMED concept 'Routine antenatal care' in the procedure domain and the concept in the condition domain 'Primagravida'. It is also possible for one SOURCE_CONCEPT_ID to map to multiple Standard CONCEPT_IDs within the same domain. For example, ICD-9-CM code 070.43 'Hepatitis E with hepatic coma' maps to the SNOMED concept for 'Acute hepatitis E' and a second SNOMED concept for 'Hepatic coma', in which case multiple CONDITION_OCCURRENCE records will be generated for the one source value record.
    - If the SOURCE_CONCEPT_ID is not mappable to any Standard CONCEPT_ID, the CONCEPT_ID field is set to 0.
  - Write the data record into the table(s) corresponding to the domain of the Standard CONCEPT_ID(s). 
    - If the Source Value is mapped to a SOURCE_CONCEPT_ID but the SOURCE_CONCEPT_ID is not mapped to a Standard CONCEPT_ID, then the domain for the data record, and hence it's table location, is determined by the DOMAIN_ID field of the CONCEPT record the SOURCE_CONCEPT_ID refers to. The Standard CONCEPT_ID is set to 0. 
    - If the Source Value cannot be mapped to a SOURCE_CONCEPT_ID or Standard CONCEPT_ID, then direct the data record to the most appropriate CDM domain based on your local knowledge of the intent of the source data and associated value. For example, if the unmappable Source Value came from a 'diagnosis' table then, in the absence of other information, you may choose to record that fact in the CONDITION_OCCURRENCE table.

Each Standard CONCEPT_ID field has a set of allowable CONCEPT_ID values. The allowable values are defined by the domain of the concepts. For example, there is a domain concept of 'Gender', for which there are only two allowable standard concepts of practical use (8507 - 'Male', 8532- 'Female') and one allowable generic concept to represent a standard notion of 'no information' (concept_id = 0). This 'no information' concept should be used when there is no mapping to a standard concept available or if there is no information available for that field. The exceptions are MEASUREMENT.VALUE_AS_CONCEPT_ID, OBSERVATION.VALUE_AS_CONCEPT_ID, MEASUREMENT.UNIT_CONCEPT_ID, OBSERVATION.UNIT_CONCEPT_ID, MEASUREMENT.OPERATOR_CONCEPT_ID, and OBSERVATION.MODIFIER_CONCEPT_ID, which can be NULL if the data do not contain the information ([THEMIS issue #11](https://github.com/OHDSI/Themis/issues/11)).  

There is no constraint on allowed CONCEPT_IDs within the SOURCE_CONCEPT_ID fields. 

### Custom SOURCE_TO_CONCEPT_MAPs 

When the source data uses coding systems that are not currently in the Standardized Vocabularies (e.g. ICPC codes for diagnoses), the convention is to store the mapping of such source codes to Standard Concepts in the SOURCE_TO_CONCEPT_MAP table. The codes used in the data source can be recorded in the SOURCE_VALUE fields, but no SOURCE_CONCEPT_ID will be available.

Custom source codes are not allowed to map to Standard Concepts that are marked as invalid.
