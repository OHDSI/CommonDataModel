A Condition Era is defined as a span of time when the Person is assumed to have a given condition. 
Similar to Drug Eras, Condition Eras are chronological periods of Condition Occurrence. Combining individual Condition Occurrences into a single Condition Era serves two purposes:
  * It allows aggregation of chronic conditions that require frequent ongoing care, instead of treating each Condition Occurrence as an independent event.
  * It allows aggregation of multiple, closely timed doctor visits for the same Condition to avoid double-counting the Condition Occurrences.
For example, consider a Person who visits her Primary Care Physician (PCP) and who is referred to a specialist. At a later time, the Person visits the specialist, who confirms the PCP’s original diagnosis and provides the appropriate treatment to resolve the condition. These two independent doctor visits should be aggregated into one Condition Era.

Field|Required|Type|Description
:----------------------------|:--------|:------------|:----------------------------------
|condition_era_id|Yes|integer|A unique identifier for each Condition Era.|
|person_id|Yes|integer|A foreign key identifier to the Person who is experiencing the Condition during the Condition Era. The demographic details of that Person are stored in the PERSON table.|
|condition_concept_id|Yes|integer|A foreign key that refers to a standard Condition Concept identifier in the Standardized Vocabularies.|
|condition_era_start_date|Yes|date|The start date for the Condition Era constructed from the individual instances of Condition Occurrences. It is the start date of the very first chronologically recorded instance of the condition.|
|condition_era_end_date|Yes|date|The end date for the Condition Era constructed from the individual instances of Condition Occurrences. It is the end date of the final continuously recorded instance of the Condition.|
|condition_occurrence_count|No|integer|The number of individual Condition Occurrences used to construct the condition era.|

### Conventions 
  * Condition Era records will be derived from the records in the CONDITION_OCCURRENCE table using a standardized algorithm.
  * Each Condition Era corresponds to one or many Condition Occurrence records that form a continuous interval.
The condition_concept_id field contains Concepts that are identical to those of the CONDITION_OCCURRENCE table records that make up the Condition Era. In contrast to Drug Eras, Condition Eras are not aggregated to contain Conditions of different hierarchical layers.
The Condition Era Start Date is the start date of the first Condition Occurrence.
The Condition Era End Date is the end date of the last Condition Occurrence.
  * Condition Eras are built with a Persistence Window of 30 days, meaning, if no occurence of the same condition_concept_id happens within 30 days of any one occurrence, it will be considered the condition_era_end_date.
