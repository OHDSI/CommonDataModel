The COST table captures records containing the cost of any medical entity recorded in one of the DRUG_EXPOSURE, PROCEDURE_OCCURRENCE, VISIT_OCCURRENCE or DEVICE_OCCURRENCE tables. It replaces the corresponding DRUG_COST, PROCEDURE_COST, VISIT_COST or DEVICE_COST tables that were initially defined for the OMOP CDM V5. However, it also allows to capture cost information for records of the OBSERVATION and MEASUREMENT tables.

The information about the cost is defined by the amount of money paid by the Person and Payer, or as the charged cost by the healthcare provider. So, the COST table can be used to represent both cost and revenue perspectives. The cost_type_concept_id field will use concepts in the Standardized Vocabularies to designate the source of the cost data. A reference to the health plan information in the PAYER_PLAN_PERIOD table is stored in the record that is responsible for the determination of the cost as well as some of the payments. 

Field|Required|Type|Description
:-----------------------------|:--------|:------------|:----------------------------------------------------
|cost_id						|Yes|integer|A unique identifier for each COST record.|
|cost_event_id					|Yes|integer|A foreign key identifier to the event (e.g. Measurement, Procedure, Visit, Drug Exposure, etc) record for which cost data are recorded.|
|cost_domain_id					|Yes|varchar(20)|The concept representing the domain of the cost event, from which the corresponding table can be inferred that contains the entity for which cost information is recorded.|
|cost_type_concept_id			|Yes|integer|A foreign key identifier to a concept in the CONCEPT table for the provenance or the source of the COST data: Calculated from insurance claim information, provider revenue, calculated from cost-to-charge ratio, reported from accounting database, etc.|
|currency_concept_id			|No|integer|A foreign key identifier to the concept representing the 3-letter code used to delineate international currencies, such as USD for US Dollar.|
|total_charge					|No|float|The total amount charged by some provider of goods or services (e.g. hospital, physician pharmacy, dme provider) to payers (insurance companies, the patient).|
|total_cost						|No|float|The cost incurred by the provider of goods or services.|
|total_paid						|No|float|The total amount actually paid from all payers for goods or services of the provider.|
|paid_by_payer					|No|float|The amount paid by the Payer for the goods or services.|
|paid_by_patient				|No|float|The total amount paid by the Person as a share of the expenses.|
|paid_patient_copay				|No|float|The amount paid by the Person as a fixed contribution to the expenses.|
|paid_patient_coinsurance		|No|float|The amount paid by the Person as a joint assumption of risk. Typically, this is a percentage of the expenses defined by the Payer Plan after the Person's deductible is exceeded.|
|paid_patient_deductible		|No|float|The amount paid by the Person that is counted toward the deductible defined by the Payer Plan. paid_patient_deductible does contribute to the paid_by_patient variable.|
|paid_by_primary				|No|float|The amount paid by a primary Payer through the coordination of benefits.|
|paid_ingredient_cost			|No|float|The amount paid by the Payer to a pharmacy for the drug, excluding the amount paid for dispensing the drug.  paid_ingredient_cost contributes to the paid_by_payer field if this field is populated with a nonzero value.|
|paid_dispensing_fee			|No|float|The amount paid by the Payer to a pharmacy for dispensing a drug, excluding the amount paid for the drug ingredient. paid_dispensing_fee contributes to the paid_by_payer field if this field is populated with a nonzero value.|
|payer_plan_period_id			|No|integer|A foreign key to the PAYER_PLAN_PERIOD table, where the details of the Payer, Plan and Family are stored.  Record the payer_plan_id that relates to the payer who contributed to the paid_by_payer field.|
|amount_allowed					|No|float|The contracted amount agreed between the payer and provider.|
|revenue_code_concept_id		|No|integer|A foreign key referring to a Standard Concept ID in the Standardized Vocabularies for Revenue codes.|
|revenue_code_source_value		|No|varchar(50)|The source code for the Revenue code as it appears in the source data, stored here for reference.|
|drg_concept_id					|No|integer|A foreign key to the predefined concept in the DRG Vocabulary reflecting the DRG for a visit.|
|drg_source_value				|No|varchar(3)|	The 3-digit DRG source code as it appears in the source data.|

### Conventions 
The COST table will store information reporting money or currency amounts. There are three types of cost data, defined in the cost_type_concept_id: 1) paid or reimbursed amounts, 2) charges or list prices (such as Average Wholesale Prices), and 3) costs or expenses incurred by the provider. The defined fields are variables found in almost all U.S.-based claims data sources, which is the most common data source for researchers. Non-U.S.-based data holders are encouraged to engage with OHDSI to adjust these tables to their needs.

One cost record is generated for each response by a payer. In a claims databases, the payment and payment terms reported by the payer for the goods or services billed will generate one cost record. If the source data has payment information for more than one payer (i.e. primary insurance and secondary insurance payment for one entity), then a cost record is created for each reporting payer. Therefore, it is possible for one procedure to have multiple cost records for each payer, but typically it contains one or no record per entity. Payer reimbursement cost records will be identified by using the payer_plan_id field. Goods or services services not covered by a payer are indicated by 0 values in the amount_allowed and patient responsibility fields (copay, coinsurance, deductible) as well as a missing payer_plan_period_id. This means the patient is responsible for the total_charged value. 

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

  * cost_type_concept_id: The concept referenced in this field defines the source of the cost information, and therefore the perspective. It could be from the perspective of the payer, or the perspective of the provider. Therefore, "cost" really means either cost or revenue, and the direction of funds (incoming and outgoing) as well as the modus of its calculation is defined by this field.
  * total_charged and total_cost: The cost of the goods or services the provider provides is often not known directly, but derived from the hospital charges multiplied by an average cost-to-charge ratio. This data is currently available for [NIS](https://www.hcup-us.ahrq.gov/db/nation/nis/nisdbdocumentation.jsp) datasets, or any other [HCUP](https://www.hcup-us.ahrq.gov/databases.jsp) datasets. See also cost calculation explanation from AHRQ [here](https://www.hcup-us.ahrq.gov/db/state/costtocharge.jsp).
  * total_paid: This field is calculated using the following formula: paid_by_payer + paid_by_patient + paid_by_primary. In claims data, this field is considered the calculated field the payer expects the provider to get reimbursed for goods and services, based on the payer's contractual obligations.
  * Drug costs are composed of ingredient cost(the amount charged by the wholesale distributor or manufacturer), the dispensing fee(the amount charged by the pharmacy and the sales tax). The latter is usually very small and typically not provided by most source data, and therefore not included in the CDM.
  * paid_by_payer: In claims data, generally there is one field representing the total payment from the payer for the service/device/drug. However, this field could be a calculated field if the source data provides separate payment information for the ingredient cost and the dispensing fee in case of prescription benefits. If there is more than one Payer in the source data, several cost records indicate that fact. The Payer reporting this reimbursement should be indicated under the payer_plan_id field.
  * paid_by_patient:  This field is most often used in claims data to report the contracted amount the patient is responsible for reimbursing the provider for the goods and services she received. This is a calculated field using the following formula: paid_patient_copay + paid_patient_coinsurance + paid_patient_deductible.  If the source data has actual patient payments then the patient payment should have its own cost record with a payer_plan_id set to 0 to indicate the the payer is actually the patient, and the actual patient payment should be noted under the total_paid field. The paid_by_patient field is only used for reporting a patient's responsibility reported on an insurance claim.
  * paid_patient_copay does contribute to the paid_by_patient variable. The paid_patient_copay field is only used for reporting a patient's copay amount reported on an insurance claim.
  * paid_patient_coinsurance does contribute to the paid_by_patient variable.  The paid_patient_coinsurance field is only used for reporting a patient's coinsurance amount reported on an insurance claim.
  * paid_patient_deductible does contribute to the paid_by_patient variable.  The paid_patient_deductible field is only used for reporting a patient's deductible amount reported on an insurance claim.
  * amount_allowed: This information is generally available in claims data.  This is similar to the total_paid amount in that it shows what the payer expects the provider to be reimbursed after the payer and patient pay.  This differs from the total_paid amount in that it is not a calculated field, but a field available directly in claims data. The field is payer-specific and the payer should be indicated by the payer_plan_id field.
  * paid_by_primary does contribute to the total_paid variable. The paid_by_primary field is only used for reporting a patient's primary insurance payment amount reported on the secondary payer insurance claim. If the source data has actual primary insurance payments (e.g. the primary insurance payment is not a derivative of the payer claim and there is verification another insurance company paid an amount to the provider), then the primary insurance payment should have its own cost record with a payer_plan_id set to the applicable payer, and the actual primary insurance payment should be noted under the paid_by_payer field.
  * revenue_code_concept_id: Revenue codes are a method to charge for a class of procedures and conditions in the U.S. hospital system.
  * drg_concept_id: Diagnosis Related Groups are US codes used to classify hospital cases into one of approximately 500 groups. Only the MS-DRG system should be used (mapped to vocabulary_id 'DRG) and all other DRG values should be mapped to 0.