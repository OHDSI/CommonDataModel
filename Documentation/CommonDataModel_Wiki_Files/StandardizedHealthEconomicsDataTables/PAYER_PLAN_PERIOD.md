The PAYER_PLAN_PERIOD table captures details of the period of time that a Person is continuously enrolled under a specific health Plan benefit structure from a given Payer. Each Person receiving healthcare is typically covered by a health benefit plan, which pays for (fully or partially), or directly provides, the care. These benefit plans are provided by payers, such as health insurances or state or government agencies. In each plan the details of the health benefits are defined for the Person or her family, and the health benefit Plan might change over time typically with increasing utilization (reaching certain cost thresholds such as deductibles), plan availability and purchasing choices of the Person. The unique combinations of Payer organizations, health benefit Plans and time periods in which they are valid for a Person are recorded in this table.

Field|Required|Type|Description
:------------------------------|:--------|:------------|:----------------------------------------------
|payer_plan_period_id			|Yes|integer|A identifier for each unique combination of payer, plan, family code and time span.|
|person_id						|Yes|integer|A foreign key identifier to the Person covered by the payer. The demographic details of that Person are stored in the PERSON table.|
|contract_person_id				|No|integer|A foreign key identifier to the person_id in person table, for the person who is the primary subscriber/contract owner for the record in the payer_plan_period table. Maybe the same person or different person, depending on who is the primary subscriber/contract owner.|
|payer_plan_period_start_date	|Yes|date|The start date of the payer plan period.|
|payer_plan_period_end_date		|Yes|date|The end date of the payer plan period.|
|payer_concept_id				|No|integer|A foreign key that refers to a standard Payer concept identifier in the Standarized Vocabularies|
|payer_source_value				|No|varchar(50)|The source code for the payer as it appears in the source data.|
|payer_source_concept_id		|No|integer|A foreign key to a payer concept that refers to the code used in the source.|
|plan_concept_id				|No|integer|A foreign key that refers to a standard plan concept identifier that represents the health benefit plan in the Standardized Vocabularies.|
|plan_source_value				|No|varchar(50)|The source code for the Person's health benefit plan as it appears in the source data.|
|plan_source_concept_id			|No|integer|A foreign key to a plan concept that refers to the plan code used in the source data.|
|contract_concept_id			|No|integer|A foreign key to a standard concept representing the reason justifying the contract between person_id and contract_person_id.|
|contract_source_value			|No|integer|The source code representing the reason justifying the contract. Usually it is family relationship like a spouse, domestic partner, child etc.|
|contract_source_concept_id		|No|integer|A foreign key to a concept that refers to the code used in the source as the reason justifying the contract.|
|sponsor_concept_id				|No|integer|A foreign key that refers to a concept identifier that represents the sponsor in the Standardized Vocabularies.|
|sponsor_source_value			|No|varchar(50)|The source code for the Person's sponsor of the health plan as it appears in the source data.|
|sponsor_source_concept_id		|No|integer|A foreign key to a sponsor concept that refers to the sponsor code used in the source data.|
|family_source_value			|No|varchar(50)|The source code for the Person's family as it appears in the source data.|
|stop_reason_concept_id			|No|integer|A foreign key that refers to a standard termination reason that represents the reason for the termination in the Standardized Vocabularies.|
|stop_reason_source_value		|No|varchar(50)|The reason for stop-coverage as it appears in the source data.|
|stop_reason_source_concept_id	|No|integer|A foreign key to a stop-coverage concept that refers to the code used in the source.|

### Conventions 

No.|Convention Description
:--------|:------------------------------------
| 1  | Different Payers have different designs for their health benefit Plans. The PAYER_PLAN_PERIOD table does not capture all details of the plan design or the relationship between Plans or the cost of healthcare triggering a change from one Plan to another. However, it allows identifying the unique combination of Payer (insurer), Plan (determining healthcare benefits and limits) and Person. Typically, depending on healthcare utilization, a Person may have one or many subsequent Plans during coverage by a single Payer. |
| 2  | Typically, family members are covered under the same Plan as the Person. In those cases, the payer_source_value, plan_source_value and family_source_value are identical. |
| 3  | The contract_person_id is meant to refer to the owner of the plan, for instance, a parent who owns the plan under which the child is covered. Contract_person_id many times will be equal to person_id. |
| 4  | The fields contract_source_value and contract_concept_id justify the contract relationship.<br><ul><li>It is represented as the relationship from the person_id to contract_person_id. We will use SNOMED vocabulary of the Relationship Domain and Social Context concept class id (see [here](http://athena.ohdsi.org/search-terms/terms?vocabulary=SNOMED&domain=Relationship&conceptClass=Social+Context&page=1&pageSize=15&query=). For example:<br><ul><li>Person_id is the spouse ([4132413](http://athena.ohdsi.org/search-terms/terms/4132413)) of contract_person_id</li><li>person_id is the child ([4285883](http://athena.ohdsi.org/search-terms/terms/4285883)) of the contract_person_id</li></ul>
| 5  | A patient can have multiple overlapping payer plan periods ([THEMIS issue #18](https://github.com/OHDSI/Themis/issues/18)).
