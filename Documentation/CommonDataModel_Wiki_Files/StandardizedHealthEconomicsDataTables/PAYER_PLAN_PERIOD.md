The PAYER_PLAN_PERIOD table captures details of the period of time that a Person is continuously enrolled under a specific health Plan benefit structure, from a certain sponsor, from a given Payer and within the same family. Each Person receiving healthcare is typically covered by a health benefit plan, which determines what health care services will be paid for (fully or partially). A sponsor (usually an employer group or government or the payer itself) holds the financial responsibility for the reimbursement, and the financial transaction of adjudicating the eligible plan-benefit and reimbursing the service provider is administered by the payer. In each plan the details of the health benefits are defined for the Person or her family, and the health benefit Plan might change over time typically with increasing utilization (reaching certain cost thresholds such as deductibles), plan availability and purchasing choices of the Person. The unique combinations of Payer organizations, health benefit Plans and time periods in which they are valid for a Person are recorded in this table.

Field|Required|Type|Description
:------------------------------|:--------|:------------|:----------------------------------------------
|payer_plan_period_id|Yes|integer|A identifier for each unique combination of payer, sponsor, plan, family code and time span.|
|person_id|Yes|integer|A foreign key identifier to the Person covered by the payer. The demographic details of that Person are stored in the PERSON table.|
|payer_plan_period_start_date|Yes|date|The start date of the payer plan period.|
|payer_plan_period_end_date|Yes|date|The end date of the payer plan period.|
|payer_concept_id |No|integer|A foreign key that refers to a Standard Payer concept identifiers in the Standardized Vocabularies|
|payer_source_value|No|varchar(50)|The source code for the payer as it appears in the source data.|
|payer_source_concept_id |No|integer|A foreign key to a payer concept that refers to the code used in the source.|
|plan_concept_id|No|integer|A foreign key that refers to a Standard plan that represents the health benefit plan in the Standardized Vocabularies|
|plan_source_value|No|varchar(50)|The source code for the Person's health benefit plan as it appears in the source data.|
| plan_source_concept_id |No|integer|A foreign key to a plan concept that refers to the code used in the source.|
| sponsor_concept_id |No|integer|A foreign key that refers to a Standard plan that represents the sponsor in the Standardized Vocabularies|
|sponsor_source_value|No|varchar(50)|The source code for the Person's sponsor of the health plan as it appears in the source data.|
| sponsor_source_concept_id*|No|integer|A foreign key to a sponsor concept that refers to the code used in the source.|
|family_source_value|No|varchar(50)|The source code for the Person's family as it appears in the source data.|
| stop_reason_concept_id |No|integer|A foreign key that refers to a Standard termination reason that represents the reason for the termination in the Standardized Vocabularies.|
| stop_reason_source_value |No|varchar(50)|The reason for stop-coverage of the record.|
| stop_reason_source_concept_id |No|integer|A foreign key to a stop-coverage concept that refers to the code used in the source.|

### Conventions 
  * Different Payers have different designs for their health benefit Plans. The PAYER_PLAN_PERIOD table does not capture all details of the plan design or the relationship between Plans or the cost of healthcare triggering a change from one Plan to another. However, it allows identifying the unique combination of Payer (insurer), Plan (determining healthcare benefits and limits), Sponsor (holds the financial risk), Family and Person. Typically, depending on healthcare utilization, a Person may have one or many subsequent Plans during coverage by a single Payer.
  * **sponsor:** who finances the transaction. 
  * **payer:** who administers the transaction. 
  * **plan:** the actual contract being administered by the payer and agreed by the sponsor. 
  * **stop reason:** reason for termination of the contract
  * Source values of the Payer, Plan, Sponsor, Family are captured as the respective _source_value. Concept_id's are used to support standardized analysis, similar to other OMOP CDM tables that use _source_concept_id and _concept_id.
  * Typically, family members are covered under the same Plan as the Person. In those cases, the payer_source_value, plan_source_value and family_source_value are identical
