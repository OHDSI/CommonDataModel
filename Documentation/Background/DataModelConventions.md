*OMOP Common Data Model v5.1 Specifications*
<br>*Authors: Christian Reich, Patrick Ryan, Rimma Belenkaya, Karthik Natarajan, Clair Blacketer*
<br>***Release date needed***

[Back to Table of Contents](Documentation/TableofContents.md)
<br>[Back to Background](Background.md)

---

# 1.3 Data Model Conventions 

There are a number of implicit and explicit conventions that have been adopted in the CDM. Developers of methods that run methods against the CDM need to understand these conventions.

## General conventions of data tables

The CDM is platform-independent. Data types are defined generically using ANSI SQL data types (VARCHAR, INTEGER, FLOAT, DATE, TIME, CLOB). Precision is provided only for VARCHAR. It reflects the minimal required string length and can be expanded within a CDM instantiation. The CDM does not prescribe the date and time format. Standard queries against CDM may vary for local instantiations and date/time configurations. 

In most cases, the first field in each table ends in "_id", containing a record identifier that can be used as a foreign key in another table.

## General conventions of fields 

Variable names across all tables follow one convention:

^Notation^Description^
|<entity>_SOURCE_VALUE|Verbatim information from the source data, typically used in ETL to map to CONCEPT_ID, and not to be used by any standard analytics. For example, condition_source_value = ‘787.02’ was the ICD-9 code captured as a diagnosis from the administrative claim|
|<entity>_ID|Unique identifiers for key entities, which can serve as foreign keys to establish relationships across entities For example, person_id uniquely identifies each individual. visit_occurrence_id uniquely identifies a PERSON encounter at a point of care.|
|<entity>_CONCEPT_ID|Foreign key into the Standardized Vocabularies (i.e. the standard_concept attribute for the corresponding term is true), which serves as the primary basis for all standardized analytics For example, condition_concept_id = 31967 contains reference value for SNOMED concept of ‘Nausea’|
|<entity>_SOURCE_CONCEPT_ID|Foreign key into the Standardized Vocabularies representing the concept and terminology used in the source data, when applicable For example, condition_source_concept_id = 35708202 denotes the concept of ‘Nausea’ in the MedDRA terminology; the analogous condition_concept_id might be 31967, since SNOMED-CT is the Standardized Vocabularies for most clinical diagnoses and findings.|
|<entity>_TYPE_CONCEPT_ID|Delineates the origin of the source information, standardized within the Standardized Vocabularies For example, drug_type_concept_id can allow analysts to discriminate between ‘Pharmacy dispensing’ and ‘Prescription written’|

## Representation of content through Concepts 

In CDM data tables the meaning of the content of each record is represented using Concepts. Concepts are stored with their concept_id as foreign keys to the CONCEPT table in the Standardized Vocabularies, which contains Concepts necessary to describe the healthcare experience of a patient. If a Standard Concept does not exist or cannot be identified, the Concept with the concept_id 0 is used, representing a non-existing or unmappable concept.

Records in the CONCEPT table contain all the detailed information about it (name, relationships, types etc.). Concepts, Concept Relationships and other information relating to Concepts contained in the tables of the Standardized Vocabularies..

## Difference between Concept IDs and Source Values 

Many tables contain equivalent information multiple times: As a Source Value, a Source Concept and as a Standard Concept.
  * Source Values contains the codes from public code systems such as ICD-9-CM, NDC, CPT-4 etc. or local controlled vocabularies (such as F for female and M for male) copied from the source data. Source Values are stored in the _source_value field in the data tables. 
  * Concepts are CDM-specific entities that represent the meaning of a clinical fact. Most concepts are based on code systems used in healthcare (called Source Concepts), while others were created de-novo (concept_code = "OMOP generated"). Concepts have unique IDs across all domains. 
  * Source Concepts are the concepts that represent the code used in the source. Source Concepts are only used for common healthcare code systems, but not for OMOP-generated Concepts. Source Concepts are stored in the source_concept_id field in the data tables.
  * Standard Concepts are those concepts that are used to define the unique meaning of a clinical entity. For each entity there is one Standard Concept. Standard Concepts are typically drawn from existing public vocabulary sources. Concepts that have the equivalent meaning to a Standard Concept are mapped to the Standard Concept. Standard Concepts are referred to in the concept_id field of the data tables. 

Source Values are only provided for convenience and quality assurance (QA) purposes. Source Values and Source Concepts are optional, while Standard Concepts are mandatory. Source Values may contain information that is only meaningful in the context of a specific data source. 

## Difference between general Concepts and Type Concepts 

Type Concepts (ending in _type_concept_id) and general Concepts (ending in _concept_id) are part of many tables. The former are special Concepts with the purpose of indicating where the data are derived from in the source. For example, the Type Concept field can be used to distinguish a DRUG_EXPOSURE record that is derived from a pharmacy-dispensing claim from one indicative of a prescription written in an electronic health record (EHR).

## Time span of available data 

Data tables for clinical data contain a date stamp (ending in _date, _start_date or _end_date), indicating when that clinical event occurred. As a rule, no record can be outside of a valid OBSERVATION_PERIOD time period. Clinical information that relates to events happened prior the first OBSERVATION_PERIOD, it will be captured as a record in the OBSERVATION table of 'Medical history' (concept_id = 43054928), with the observation_date set to the first observation_period_start_date of that patient, and the value_as_concept_id set to the corresponding concept_id for the condition/drug/procedure that occurred in the past. No data occurring after the last observation_period_end_date can be valid records in the CDM.

## Content of each table 

For the tables of the main domains of the CDM it is imperative that used concepts are strictly limited to the domain. For example, the CONDITION_OCCURRENCE table contains only information about conditions (diagnoses, signs, symptoms), but no information about procedures. Not all source coding schemes adhere to such rules. For example, ICD-9-CM codes, which contain mostly diagnoses of human disease, also contain information about the status of patients having received a procedure: V25.5 "Encounter for insertion of implantable subdermal contraceptive" defines a procedure and is therefore stored in the PROCEDURE_OCCURRENCE table.

## Differentiating between source values, source concept ids, and standard concept ids 

Each table contains fields for source values, source concept ids, and standard concept ids. 

  * Source values are fields to maintain the verbatim information from the source database, are stored as unstructured text, and are generally not to be used by any standardized analytics.
  * Source concept ids provide a repeatable representation of the source concept, when the source data are drawn from a commonly-used internationally-recognized vocabulary that has been distributed with the OMOP Common Data Model. Specific use cases where source vocabulary-specific analytics are required can be accommodated by the use of the source concept id fields, but these are generally not applicable across disparate data sources. The standard concept id fields are **strongly suggested** to be used in all standardized analytics, as specific vocabularies have been established within each data domain to facilitate standardization of both structure and content within the OMOP Common Data Model.

The following provide conventions for processing source data using these three fields in each domain:

When processing data where the source value is either free text or a reference to a coding scheme that is not contained within the Standardized Vocabularies:

  - Map all source values directly to standard concept_ids. Store these mappings in the SOURCE_TO_CONCEPT_MAP table. 
    - If the source code is not mappable to a vocabulary term, the source_concept_id field is set to 0
When processing your data where source value is a reference to a coding scheme contained within the Standardized Vocabularies:
  - Map all your source values to the corresponding concept_ids in the source vocabulary. Store the result in the source_concept_id field. 
    - If the source code follows the same formatting as the distributed vocabulary, the mapping can be directly obtained from the CONCEPT table using the CONCEPT_CODE field. 
    - If the source code uses alternative formatting (ex. format has removed decimal point from ICD-9 codes), you will need to perform the formatting transformation within the ETL. In this case, you may wish to store the mappings from original codes to source concept ids in the SOURCE_TO_CONCEPT_MAP table.
    - If the source code is not mappable to a vocabulary term, the source_concept_id field is set to 0
  - Use the CONCEPT_RELATIONSHIP table to identify the standard concept_id that corresponds to the source_concept_id in the domain.
    - Each source_concept_id can have 1 or more Standard concept_id mapped to it. Each Standard concept_id belongs to only one primary domain, but when a source concept_id maps to multiple standard concept_ids, it is possible for that source_concept_id to result in records being produced across multiple domains. For example, HCPCS code for infusion of a drug will map to a concept in the procedure domain of the infusion and a different concept in the drug domain for the product infused. It is also possible for one source_concept_id to map to multiple standard concept_ids within the same domain. For example, ICD-9 for ‘viral hepatitis with hepatic coma’ maps to SNOMED ‘viral hepatitis’ and a different concept for ‘hepatic coma’ in which case multiple condition_occurrence records will be generated for the one source value record.
    - If the source_concept_id is not mappable to any standard concept_id, the concept_id field is set to 0.
  - Write the data record into table(s) corresponding to the domain of the standard concept_id(s). 
    - If the source value is mapped to source_concept_id, but the source_concept_id is not mapped to a standard concept_id, then the domain for the data record, and hence it's table location, is determined by the domain_id field of the CONCEPT record the source_concept_id refers to. The standard concept_id is set to 0. 
    - If the source value cannot be mapped to a source_concept_id or standard concept_id, then direct the data record to the most appropriate CDM domain based on your local knowledge of the intent of the source data and associated value. For example, if the unmappable source_value came from a ‘diagnosis’ table, then in the absence of other information, you may choose to record that fact in the CONDITION_OCCURRENCE table.

Each standard concept_id field has a set of allowable concept_id values. The allowable values are defined by the domain of the concepts. For example, there is a domain concept of ‘Gender’, for which there are only two allowable standard concepts of practical use (8507- ‘Male’, 8532- ‘Female’) and one allowable generic concept to represent a standard notion of ‘no information’ (concept_id = 0).

There is no constraint on allowed concept_ids within the source_concept_id fields. 

## Custom source_to_concept_maps 

When the source data uses coding systems that are not currently in the Standardized Vocabularies (e.g. ICPC codes for diagnoses), the convention is to store the mapping of such source codes to Standard Concepts in the SOURCE_TO_CONCEPT_MAP table. The codes used in the data source can be recorded in the source_value fields, but no source_concept_id will be available.

Custom source codes are not allowed to map to Standard Concepts that are marked as invalid.
