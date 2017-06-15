*OMOP Common Data Model v5.1 Specifications*
<br>*Authors: Christian Reich, Patrick Ryan, Rimma Belenkaya, Karthik Natarajan, Clair Blacketer*
<br>***Release date needed***

[Back to Table of Contents](https://github.com/OHDSI/CommonDataModel/blob/master/Documentation/TableofContents.md)
<br>[Back to Standardized Vocabularies](StandardizedVocabularies.md)

---

# 3.12 ATTRIBUTE_DEFINITION

The ATTRIBUTE_DEFINITION table contains records defining Attributes, or covariates, to members of a Cohort through an associated description and syntax and upon instantiation (execution of the algorithm) placed into the COHORT_ATTRIBUTE table. Attributes are derived elements that can be selected or calculated for a subject in a Cohort. The ATTRIBUTE_DEFINITION table provides a standardized structure for maintaining the rules governing the calculation of covariates for a subject in a Cohort, and can store operational programming code to instantiate the Attributes for a given Cohort within the OMOP Common Data Model.

Field|Required|Type|Description
:----|:-------|:---|:----------
|attribute_definition_id|Yes|integer|A unique identifier for each Attribute.|
|attribute_name|Yes|varchar(255)|A short description of the Attribute.|
|attribute_description|No|CLOB|A complete description of the Attribute definition|
|attribute_type_concept_id|Yes|integer|Type defining what kind of Attribute Definition the record represents and how the syntax may be executed|
|attribute_syntax|No|CLOB|Syntax or code to operationalize the Attribute definition|


## Conventions
  * Like the definition syntax field for the COHORT_DEFINITION table, the attribute_syntax does not prescribe any specific syntax or programming language. Typically, it would be any flavor SQL, or a cohort definition language, or a free-text description of the algorithm. 
  * The Attribute Definition is generic and not necessarily related to a specific Cohort Definition, however the instantiated Attribute is linked to the Cohort records (see below the [COHORT](https://github.com/OHDSI/CommonDataModel/blob/master/Documentation/StandardizedDerivedElements/COHORT.md) table). For example, the Attribute "Age" can be defined as the amount of time between the cohort_start_date of the COHORT table and the year_of_birth, month_of_birth and day_of_birth of the PERSON table. Thus, such a Attribute Definition can be applied and instantiated with any Cohort, as long as it is applied to a Cohort of the same Domain (Person in this case), as it is defined in the subject_concept_id in the COHORT_DEFINITION table.
