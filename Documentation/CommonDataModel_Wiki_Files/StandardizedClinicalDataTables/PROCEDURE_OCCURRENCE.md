The PROCEDURE_OCCURRENCE table contains records of activities or processes ordered by, or carried out by, a healthcare provider on the patient to have a diagnostic or therapeutic purpose. Procedures are present in various data sources in different forms with varying levels of standardization. For example:

  * Medical Claims include procedure codes that are submitted as part of a claim for health services rendered, including procedures performed.
  * Electronic Health Records that capture procedures as orders.

Field|Required|Type|Description
:--------------------------|:--------|:------------|:----------------------------------------
|procedure_occurrence_id|Yes|integer|A system-generated unique identifier for each Procedure Occurrence.|
|person_id|Yes|integer|A foreign key identifier to the Person who is subjected to the Procedure. The demographic details of that Person are stored in the PERSON table.|
|procedure_concept_id|Yes|integer|A foreign key that refers to a standard procedure Concept identifier in the Standardized Vocabularies.|
|procedure_date|Yes|date|The date on which the Procedure was performed.|
|procedure_datetime|No|datetime|The date and time on which the Procedure was performed.|
|procedure_type_concept_id|Yes|integer|A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of source data from which the procedure record is derived.|
|modifier_concept_id|No|integer|A foreign key to a Standard Concept identifier for a modifier to the Procedure (e.g. bilateral)|
|quantity|No|integer|The quantity of procedures ordered or administered.|
|provider_id|No|integer|A foreign key to the provider in the provider table who was responsible for carrying out the procedure.|
|visit_occurrence_id|No|integer|A foreign key to the visit in the visit table during which the Procedure was carried out.|
|procedure_source_value|No|varchar(50)|The source code for the Procedure as it appears in the source data. This code is mapped to a standard procedure Concept in the Standardized Vocabularies and the original code is, stored here for reference. Procedure source codes are typically ICD-9-Proc, CPT-4, HCPCS or OPCS-4 codes.|
|procedure_source_concept_id|No|integer|A foreign key to a Procedure Concept that refers to the code used in the source.|
|qualifier_source_value|No|varchar(50)|The source code for the qualifier as it appears in the source data.|

### Conventions 

  * Valid Procedure Concepts belong to the "Procedure" domain. Procedure Concepts are based on a variety of vocabularies: SNOMED-CT, ICD-9-Proc, CPT-4, HCPCS and OPCS-4, but also atypical Vocabularies such as ICD-9-CM or MedDRA.
  * Procedures are expected to be carried out within one day and therefore have no end date.
  * Procedures could involve the application of a drug, in which case the procedural component is recorded in the procedure table and simultaneously the administered drug in the drug exposure table when both the procedural component and drug are identifiable. 
  * If the quantity value is omitted, a single procedure is assumed.
  * The Procedure Type defines from where the Procedure Occurrence is drawn or inferred. For administrative claims records the type indicates whether a Procedure was primary or secondary and their relative positioning within a claim. 
  * The Visit during which the procedure was performed is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
  * The Provider carrying out the procedure is recorded through a reference to the PROVIDER table. This information is not always available.