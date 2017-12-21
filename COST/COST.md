# COST

The COST table captures records containing the cost of any medical entity recorded in one of the DRUG_EXPOSURE, PROCEDURE_OCCURRENCE, VISIT_OCCURRENCE, DEVICE_OCCURRENCE, OBSERVATION, MEASUREMENT of SPECIMEN tables.

The information about the cost is defined by the amount of money paid by the Person and Payer, or as the charged cost by the healthcare provider. So, the COST table can be used to represent both cost and revenue perspectives. The cost_type_concept_id field will use concepts in the Standardized Vocabularies to designate the source of the cost data. A reference to the health plan information in the PAYER_PLAN_PERIOD table is stored in the record that is responsible for the determination of the cost as well as some of the payments. 

Field                        | Required  | Type        | Description     
:----------------|:-----------------|:------------|:-----------------------------------|
| cost_id                      | Yes       | integer     | A unique identifier for each COST record.                                                                                                                                                                                                                   |
| person_id                    | Yes       | integer     | A unique identifier for each person.                                                                                                                                                                                                                        |
| cost_event_id                | Yes | integer     | A foreign key identifier to the event (e.g. Measurement, Procedure, Visit, Drug Exposure, etc) record for which cost data are recorded.                                                                                                                     |
| cost_domain_id               | Yes       | varchar(50)     | The concept id representing the domain of the cost event, from which the corresponding table can be inferred that contains the entity for which cost information is recorded.                                                                               |
| cost_event_table_concept_id |Yes| integer| A foreign key identifier to a concept in the CONCEPT table representing the identity of the table whose primary key is equal to cost_event_id **This field is still under discussion and subject to change**|
| cost_concept_id         | Yes       | integer     | A foreign key that refers to a Standard Cost Concept identifier in the Standardized Vocabularies.  |
| cost_type_concept_id         | Yes       | integer     | A foreign key identifier to a concept in the CONCEPT table for the provenance or the source of the COST data: Co-ordination of benefits, Calculated from insurance claim information, provider revenue, calculated from cost-to-charge ratio, reported from accounting database, etc.  |
| cost_source_concept_id         | No       | integer     | A foreign key to a Cost Concept that refers to the code used in the source. |
| cost_source_value | No | varchar(50) | The source value for the cost as it appears in the source data|
| currency_concept_id          | Yes       | integer     | A foreign key identifier to the concept representing the 3-letter code used to delineate international currencies, such as USD for US Dollar.  |
| cost                  | Yes       | float       | The actual financial cost amount |
| incurred_date                 | Yes       | date        | The first date of service of the clinical event corresponding to the cost as in table capturing the information (e.g. date of visit, date of procedure, date of condition, date of drug etc).   |
| billed_date              | No        | date    | The date a bill was generated for a service or encounter              |
| paid_date               | No        | date    | The date payment was received for a service or encounter                                                                                                                                                                                          |
| revenue_code_concept_id      | No        | integer     | A foreign key referring to a Standard Concept ID in the Standardized Vocabularies for Revenue codes.                                                                                                                                                        |
| drg_concept_id               | No        | integer     | A foreign key referring to a Standard Concept ID in the Standardized Vocabularies for DRG codes.                                                                                                                                                            |
| revenue_code_source_value    | No        | string(50)  | The source value for the Revenue code as it appears in the source data, stored here for reference.                                                                                                                                                           |
| drg_source_value             | No        | string(50)  | The source value for the 3-digit DRG source code as it appears in the source data, stored here for reference.    
| payer_plan_period_id    | No        | integer  | A foreign key to the PAYER_PLAN_PERIOD table, where the details of the Payer, Plan and Family are stored. Record the payer_plan_id that relates to the payer who contributed to the paid_by_payer field.    | 
                                          
### Conventions 
The COST table will store information reporting money or currency amounts. There are three types of cost data, defined in the cost_type_concept_id: 1) paid or reimbursed amounts, 2) charges or list prices (such as Average Wholesale Prices), and 3) costs or expenses incurred by the provider. The defined fields are variables found in almost all U.S.-based claims data sources, which is the most common data source for researchers. Non-U.S.-based data holders are encouraged to engage with OHDSI to adjust these tables to their needs.

One cost record is generated for each money or currency amount associated with a record in one of the event tables. For example, a raw record that looks like this:

|patient_id	|cob	|coins|	copay|	deduct|	net|	total_pay|	pddate	|proc_cd|	procmod|	revcode|	svcdate|
:-------|:----------|:-------|:-----------|:----------|:-------|:-----------|:----------|:-------|:-----------|:----------|:----------|
|175127601|	0|	0	|22	|3|	88|	113|	2/28/2000	|82378	|	|	|1/1/2000|

Will create four lines in the COST table:


cost_id	|person_id|	cost_event_id|	cost_domain_id|	cost_event_table_concept_id*|	cost_concept_id**|	cost_type_concept_id|	cost_source_concept_id	|currency_concept_id|	cost|	incurred_date|	billed_date|	paid_date	|revenue_code_concept_id|	drg_concept_id	|revenue_code_source_value|	drg_source_value	|payer_plan_period_id
:-------|:-------|:-------|:-----|:----------|:-------|:------|:--------|:-------|:-----|:-------|:----|:-----|:-------|:----|:-----|:-------|:----
|1|	175127601|	1002|	Procedure|	*TBD*|	1234|	5032|	0|	44818668|	22	|1/1/2000|		|2/28/2000|	0	|0	|	||	3045|
|2	|175127601|	1002|	Procedure|	*TBD*|	2345|	5032|	0|	44818668|	3	|1/1/2000|		|2/28/2000|	0	|0|		||	3045|
|3	|175127601|	1002|	Procedure|	*TBD*|	3456|	5032|	0|	44818668|	88	|1/1/2000|	|	2/28/2000|	0	|0|		||	3045|
|4	|175127601|	1002|	Procedure|	*TBD*|	4567|	5032|	0|	44818668|	113	|1/1/2000|	|	2/28/2000|	0	|0|		||	3045|

*The Cost_event_table_concept_id field is still in discussion as to whether it is needed or if the cost_domain_id is sufficient
**The Cost_concept_ids are still in production and will be released with a future vocabulary version so the ones used here are placeholders. 

The cost information is linked through the cost_event_id field to its entity, which denotes a record in a table referenced by the cost_domain_id field:

cost_domain_id|corresponding CDM table
:-------------|:-------------------------
|Drug|DRUG_EXPOSURE|
|Visit|VISIT_OCCURRENCE|
|Procedure|PROCEDURE_OCCURRENCE|
|Device|DEVICE_EXPOSURE|
|Measurement|MEASUREMENT|
|Observation|OBSERVATION|
|Specimen|SPECIMEN|

How to calculate costs:
  * cost_type_concept_id: The concept referenced in this field defines the source of the cost information, and therefore the perspective. It could be from the perspective of the payer, or the perspective of the provider. Therefore, "cost" really means either cost or revenue, and the direction of funds (incoming and outgoing) as well as the modus of its calculation is defined by this field.
  * total charged and total cost: The cost of the goods or services the provider provides is often not known directly, but derived from the hospital charges multiplied by an average cost-to-charge ratio. This data is currently available for [NIS](https://www.hcup-us.ahrq.gov/db/nation/nis/nisdbdocumentation.jsp) datasets, or any other [HCUP](https://www.hcup-us.ahrq.gov/databases.jsp) datasets. See also cost calculation explanation from AHRQ [here](https://www.hcup-us.ahrq.gov/db/state/costtocharge.jsp).
  * total paid: This field is calculated using the following formula: (amount paid by payer) + (amount paid by patient) + (amount paid by primary). In claims data, this field is considered the calculated field the payer expects the provider to get reimbursed for goods and services, based on the payer's contractual obligations.
  * Drug costs are composed of ingredient cost(the amount charged by the wholesale distributor or manufacturer), the dispensing fee(the amount charged by the pharmacy and the sales tax). The latter is usually very small and typically not provided by most source data, and therefore not included in the CDM.
  * amount paid by payer: In claims data, generally there is one field representing the total payment from the payer for the service/device/drug. However, this could be calculated if the source data provides separate payment information for the ingredient cost and the dispensing fee in case of prescription benefits. If there is more than one Payer in the source data, several cost records indicate that fact. The Payer reporting this reimbursement should be indicated under the payer_plan_id field.
  * amount paid by patient:  This field is most often used in claims data to report the contracted amount the patient is responsible for reimbursing the provider for the goods and services he/she received. This is a calculated field using the following formula: copayment + coinsurance + deductible.  If the source data has actual patient payments then the patient payment should have its own cost record with a payer_plan_id set to 0 to indicate the the payer is actually the patient, and the actual patient payment should be noted under the total_paid field. The paid_by_patient field is only used for reporting a patient's responsibility reported on an insurance claim.
  * copayment is only used for reporting a patient's copay amount reported on an insurance claim.
  * coinsurance is only used for reporting a patient's coinsurance amount reported on an insurance claim.
  * deductible is only used for reporting a patient's deductible amount reported on an insurance claim.
  * allowed amount: This information is generally available in claims data.  This is similar to the total_paid amount in that it shows what the payer expects the provider to be reimbursed after the payer and patient pay.  This differs from the total_paid amount in that it is not a calculated field, but a field available directly in claims data. The field is payer-specific and the payer should be indicated by the payer_plan_id field.
  * The amount paid by the primary insurer is only used for reporting a patient's primary insurance payment amount reported on the secondary payer insurance claim. 
  * revenue_code_concept_id: Revenue codes are a method to charge for a class of procedures and conditions in the U.S. hospital system.
  * drg_concept_id: Diagnosis Related Groups are US codes used to classify hospital cases into one of approximately 500 groups. Only the MS-DRG system should be used (mapped to vocabulary_id 'DRG) and all other DRG values should be mapped to 0.
