The COHORT_DEFINITION table contains records defining a Cohort derived from the data through the associated description and syntax and upon instantiation (execution of the algorithm) placed into the COHORT table. Cohorts are a set of subjects that satisfy a given combination of inclusion criteria for a duration of time. The COHORT_DEFINITION table provides a standardized structure for maintaining the rules governing the inclusion of a subject into a cohort, and can store operational programming code to instantiate the cohort within the OMOP Common Data Model.

Field|Required|Type|Description
:------------------------------|:--------|:-----|:-----------------------------------------------
|cohort_definition_id|Yes|integer|A unique identifier for each Cohort.|
|cohort_definition_name|Yes|varchar(255)|A short description of the Cohort.|
|cohort_definition_description|No|varchar(MAX)|A complete description of the Cohort definition|
|definition_type_concept_id|Yes|integer|Type defining what kind of Cohort Definition the record represents and how the syntax may be executed|
|cohort_definition_syntax|No|varchar(MAX)|Syntax or code to operationalize the Cohort definition|
|subject_concept_id|Yes|integer|A foreign key to the Concept to which defines the domain of subjects that are members of the cohort (e.g., Person, Provider, Visit).|
|cohort_initiation_date|No|Date|A date to indicate when the Cohort was instantiated in the COHORT table|

### Conventions
  * The cohort_definition_syntax does not prescribe any specific syntax or programming language. Typically, it would be any flavor SQL, a cohort definition language, or a free-text description of the algorithm. 
  * The subject_concept_id determines what the individual subjects or entities of the Cohort consists of. In most cases, that would be a Person (patient). But cohorts could also be constructed for Providers, Visits or any other Domain. Note that the Domain is not codified using the alphanumerical domain_id like in the CONCEPT table. Instead, the corresponding Concept is used. The Concepts for each domain can be obtained from the DOMAIN table in the domain_concept_id.
