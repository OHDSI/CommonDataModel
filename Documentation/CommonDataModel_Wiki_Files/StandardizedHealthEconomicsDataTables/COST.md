The COST table captures records containing the cost of any medical event recorded in one of the OMOP clinical event tables such as DRUG_EXPOSURE, PROCEDURE_OCCURRENCE, VISIT_OCCURRENCE, VISIT_DETAIL, DEVICE_OCCURRENCE, OBSERVATION or MEASUREMENT.

Each record in the cost table account for the amount of money transacted for the clinical event. So, the COST table may be used to represent both receivables (charges) and payments (paid), each transaction type represented by its COST_CONCEPT_ID. The COST_TYPE_CONCEPT_ID field will use concepts in the Standardized Vocabularies to designate the source (provenance) of the cost data. A reference to the health plan information in the PAYER_PLAN_PERIOD table is stored in the record for information used for the adjudication system to determine the persons benefit for the clinical event. 

Field|Required|Type|Description
:-----------------------------|:--------|:------------|:----------------------------------------------------
|cost_id						|Yes|integer|A unique identifier for each COST record.|
|person_id						|Yes|integer|A unique identifier for each PERSON.|
|cost_event_id					|Yes|integer|A foreign key identifier to the event (e.g. Measurement, Procedure, Visit, Drug Exposure, etc) record for which cost data are recorded.|
|cost_event_field_concept_id    |Yes| integer| A foreign key identifier to a concept in the CONCEPT table representing the identity of the field represented by COST_EVENT_ID |
|cost_concept_id         		| Yes| integer| A foreign key that refers to a Standard Cost Concept identifier in the Standardized Vocabularies belonging to the 'Cost' vocabulary.  |
| cost_type_concept_id         | Yes       | integer     | A foreign key identifier to a concept in the CONCEPT table for the provenance or the source of the COST data and belonging to the 'Cost Type' vocabulary  |
| cost_source_concept_id         | Yes       | integer     | A foreign key to a Cost Concept that refers to the code used in the source. |
| cost_source_value | No | varchar(50) | The source value for the cost as it appears in the source data|
| currency_concept_id          | Yes       | integer     | A foreign key identifier to the concept representing the 3-letter code used to delineate international currencies, such as USD for US Dollar. These belong to the 'Currency' vocabulary  |
| cost                  | Yes       | float       | The actual financial cost amount |
| incurred_date                 | Yes       | date        | The first date of service of the clinical event corresponding to the cost as in table capturing the information (e.g. date of visit, date of procedure, date of condition, date of drug etc).   |
| billed_date              | No        | date    | The date a bill was generated for a service or encounter              |
| paid_date               | No        | date    | The date payment was received for a service or encounter                                                                                                                                                                                          |
| revenue_code_concept_id      | Yes        | integer     | A foreign key referring to a Standard Concept ID in the Standardized Vocabularies for Revenue codes belonging to the 'Revenue Code' vocabulary.                                               |
| drg_concept_id               | Yes        | integer     | A foreign key referring to a Standard Concept ID in the Standardized Vocabularies for DRG codes belonging to the 'DRG' vocabulary.                                                                                                   |
| revenue_code_source_value    | No        | varchar(50)  | The source value for the Revenue code as it appears in the source data, stored here for reference.                                                                                                                                                           |
| drg_source_value             | No        | varchar(50)  | The source value for the 3-digit DRG source code as it appears in the source data, stored here for reference.    
| payer_plan_period_id    | No        | integer  | A foreign key to the PAYER_PLAN_PERIOD table, where the details of the Payer, Plan and Family are stored. Record the payer_plan_id that relates to the payer who contributed to the paid_by_payer field.    | 


### Conventions 

No.|Convention Description
:--------|:------------------------------------
| 1  | The cost information is linked through the COST_EVENT_ID field to its entity, which denotes a record in a table referenced by the COST_EVENT_FIELD_CONCEPT_ID field. 
| 2  | One cost record is generated for each response by a payer. In a claims databases, the payment and payment terms reported by the payer for the goods or services billed will generate one cost record. If the source data has payment information for more than one payer (i.e. primary insurance and secondary insurance payment for one entity), then a cost record is created for each reporting payer. Therefore, it is possible for one procedure to have multiple cost records for each payer, but typically it contains one or no record per entity. Payer reimbursement cost records will be identified by using the PAYER_PLAN_ID field. |
| 3  | One cost record is generated for each money or currency amount associated with a record in one of the event tables. |
| 4  | The COST field represents the dollar amount, either incoming or outgoing |
| 5  | When dealing with summary costs, the cost of the goods or services the provider provides is often not known directly, but derived from the hospital charges multiplied by an average cost-to-charge ratio. This data is currently available for [NIS](https://www.hcup-us.ahrq.gov/db/nation/nis/nisdbdocumentation.jsp) datasets, or any other [HCUP](https://www.hcup-us.ahrq.gov/databases.jsp) datasets. See also cost calculation explanation from AHRQ | 6  | In claims data, total paid is considered the calculated field the payer expects the provider to get reimbursed for goods and services, based on the payer's contractual obligations. |
| 7  | Drug costs are composed of ingredient cost (the amount charged by the wholesale distributor or manufacturer), the dispensing fee (the amount charged by the pharmacy and the sales tax). |
| 8  | In claims data, generally there is one field representing the total payment from the payer for the service/device/drug. However, this field could be a calculated field if the source data provides separate payment information for the ingredient cost and the dispensing fee in case of prescription benefits. If there is more than one Payer in the source data, several cost records indicate that fact. The Payer reporting this reimbursement should be indicated under the PAYER_PLAN_ID field. |
| 10 | REVENUE_CODE_CONCEPT_ID: Revenue codes are a method to charge for a class of procedures and conditions in the U.S. hospital system.
| 11 | DRG_CONCEPT_ID: Diagnosis Related Groups are US codes used to classify hospital cases into one of approximately 500 groups. APR-DRG codes were recently added to the vocabulary and are now supported along with MS-DRGs ([THEMIS issue #19](https://github.com/OHDSI/Themis/issues/19)). |


The COST table will store information reporting money or currency amounts. There are three types of cost data, defined in the COST_TYPE_CONCEPT_ID: 
1) Payer is primary (coordination of benefit) 
2) Payer is secondary (coordination of benefit) 
3) Premium

One cost record is generated for each money or currency amount associated with a record in one of the event tables. For example, a raw record that looks like this:

|patient_id	|cob	|coins|	copay|	deduct|	net|	total_pay|	pddate	|proc_cd|	procmod|	revcode|	svcdate|
:-------|:----------|:-------|:-----------|:----------|:-------|:-----------|:----------|:-------|:-----------|:----------|:----------|
|175127601|	0|	0	|22	|3|	88|	113|	2/28/2000	|82378	|	|	|1/1/2000|

Will create four lines in the COST table:

cost_id	|person_id|	cost_event_id|	cost_event_field_concept_id|	cost_concept_id|	cost_type_concept_id|	cost_source_concept_id	|currency_concept_id|	cost|	incurred_date|	billed_date|	paid_date	|revenue_code_concept_id|	drg_concept_id	|revenue_code_source_value|	drg_source_value	|payer_plan_period_id
:------|:------|:------|:--------|:-------|:------|:--------|:-------|:-----|:-------|:----|:-----|:-------|:----|:-----|:-------|:----|
|1|	175127601|	1002|		*TBD*|	1234|	5032|	0|	44818668|	22	|1/1/2000|		|2/28/2000|	0	|0	|	||	3045|
|2	|175127601|	1002|		*TBD*|	2345|	5032|	0|	44818668|	3	|1/1/2000|		|2/28/2000|	0	|0|		||	3045|
|3	|175127601|	1002|		*TBD*|	3456|	5032|	0|	44818668|	88	|1/1/2000|	|	2/28/2000|	0	|0|		||	3045|
|4	|175127601|	1002|		*TBD*|	4567|	5032|	0|	44818668|	113	|1/1/2000|	|	2/28/2000|	0	|0|		||	3045|
