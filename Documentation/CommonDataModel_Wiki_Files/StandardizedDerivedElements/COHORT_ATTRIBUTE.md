The COHORT_ATTRIBUTE table contains attributes associated with each subject within a cohort, as defined by a given set of criteria for a duration of time. The definition of the Cohort Attribute is contained in the ATTRIBUTE_DEFINITION table.

Field|Required|Type|Description
:---------------------|:--------|:------------|:------------------------------
|cohort_definition_id|Yes|integer|A foreign key to a record in the [COHORT_DEFINITION](https://github.com/OHDSI/CommonDataModel/wiki/COHORT_DEFINITION) table containing relevant Cohort Definition information.|
|subject_id|Yes|integer|A foreign key to the subject in the Cohort. These could be referring to records in the PERSON, PROVIDER, VISIT_OCCURRENCE table.|
|cohort_start_date|Yes|date|The date when the Cohort Definition criteria for the Person, Provider or Visit first match.|
|cohort_end_date|Yes|date|The date when the Cohort Definition criteria for the Person, Provider or Visit no longer match or the Cohort membership was terminated.|
|attribute_definition_id|Yes|integer|A foreign key to a record in the [ATTRIBUTE_DEFINITION](https://github.com/OHDSI/CommonDataModel/wiki/ATTRIBUTE_DEFINITION) table containing relevant Attribute Definition information.|
|value_as_number|No|float|The attribute result stored as a number. This is applicable to attributes where the result is expressed as a numeric value.|
|value_as_concept_id|No|integer|The attribute result stored as a Concept ID. This is applicable to attributes where the result is expressed as a categorical value.|

### Conventions 
  * Each record in the COHORT_ATTRIBUTE table is linked to a specific record in the COHORT table, identified by matching cohort_definition_id, subject_id, cohort_start_date and cohort_end_date fields.
  * It adds to the Cohort records calculated co-variates (for example age, BMI) or composite scales (for example Charleson index).
  * The unifying definition or feature of the Cohort Attribute is captured in the attribute_definition_id referring to a record in the ATTRIBUTE_DEFINITION table.
  * The actual result or value of the Cohort Attribute (co-variate, index value) is captured in the value_as_number	(if the value is numeric) or the value_as_concept_id (if the value is a concept) fields.