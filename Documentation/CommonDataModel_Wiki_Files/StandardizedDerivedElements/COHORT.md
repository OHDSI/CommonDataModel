The COHORT table contains records of subjects that satisfy a given set of criteria for a duration of time. The definition of the cohort is contained within the COHORT_DEFINITION table. Cohorts can be constructed of patients (Persons), Providers or Visits.  

Field|Required|Type|Description
:--------------------|:--------|:------------|:----------------------------
|cohort_definition_id|Yes|integer|A foreign key to a record in the COHORT_DEFINITION table containing relevant Cohort Definition information.|
|subject_id|Yes|integer|A foreign key to the subject in the cohort. These could be referring to records in the PERSON, PROVIDER, VISIT_OCCURRENCE table.|
|cohort_start_date|Yes|date|The date when the Cohort Definition criteria for the Person, Provider or Visit first match.|
|cohort_end_date|Yes|date|The date when the Cohort Definition criteria for the Person, Provider or Visit no longer match or the Cohort membership was terminated.|

### Conventions 
  * The core of a Cohort is the unifying definition or feature of the Cohort. This is captured in the cohort_definition_id. For example, Cohorts can include patients diagnosed with a specific condition, patients exposed to a particular drug, or Providers who have performed a specific Procedure.
  * Cohort records must have a Start Date
  * Cohort records must have an End Date, but may be set to Start Date or could have applied a censored date using the Observation Period Start Date.
  * Cohort records must contain a Subject Id, which can refer to the Person, Provider, Visit record or Care Site. The Cohort Definition will define the type of subject through the subject concept id.
  * A subject can belong (or not belong) to a cohort at any moment in time
  * A subject can only have one record in the cohort table for any moment of time, i.e. it is not possible for a person to contain multiple records indicating cohort membership that are overlapping in time
