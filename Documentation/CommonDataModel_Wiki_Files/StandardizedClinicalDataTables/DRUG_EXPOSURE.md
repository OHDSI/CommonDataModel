The drug exposure domain captures records about the utilization of a Drug when ingested or otherwise introduced into the body. A Drug is a biochemical substance formulated in such a way that when administered to a Person it will exert a certain physiological effect. Drugs include prescription and over-the-counter medicines, vaccines, and large-molecule biologic therapies. Radiological devices ingested or applied locally do not count as Drugs.

Drug Exposure is inferred from clinical events associated with orders, prescriptions written, pharmacy dispensings, procedural administrations, and other patient-reported information, for example:

  * The "Prescription" section of an EHR captures prescriptions written by physicians or from electronic ordering systems
  * The "Medication list" section of an EHR for both non-prescription products and medications prescribed by other providers
  * Prescriptions filled at dispensing providers such as pharmacies, and then captured in reimbursement claim systems
  * Drugs administered as part of a Procedure, such as chemotherapy or vaccines.

Field|Required|Type|Description
:------------------------------|:--------|:------------|:------------------------------------------------
|drug_exposure_id|Yes|integer|A system-generated unique identifier for each Drug utilization event.|
|person_id|Yes|integer|A foreign key identifier to the person who is subjected to the Drug. The demographic details of that person are stored in the person table.|
|drug_concept_id|Yes|integer|A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies for the Drug concept.|
|drug_exposure_start_date|Yes|date|The start date for the current instance of Drug utilization. Valid entries include a start date of a prescription, the date a prescription was filled, or the date on which a Drug administration procedure was recorded.|
|drug_exposure_start_datetime|No|datetime|The start date and time for the current instance of Drug utilization. Valid entries include a start date of a prescription, the date a prescription was filled, or the date on which a Drug administration procedure was recorded.|
|drug_exposure_end_date|Yes|date|The end date for the current instance of Drug utilization. It is not available from all sources.|
|drug_exposure_end_datetime|No|datetime|The end date and time for the current instance of Drug utilization. It is not available from all sources.|
|verbatim_end_date|No|date|The known end date of a drug_exposure as provided by the source|
|drug_type_concept_id|Yes|integer| A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of Drug Exposure recorded. It indicates how the Drug Exposure was represented in the source data.|
|stop_reason|No|varchar(20)|The reason the Drug was stopped. Reasons include regimen completed, changed, removed, etc.|
|refills|No|integer|The number of refills after the initial prescription. The initial prescription is not counted, values start with 0.|
|quantity |No|float|The quantity of drug as recorded in the original prescription or dispensing record.|
|days_supply|No|integer|The number of days of supply of the medication as recorded in the original prescription or dispensing record.|
|sig|No|clob|The directions ("signetur") on the Drug prescription as recorded in the original prescription (and printed on the container) or dispensing record.|
|route_concept_id|No|integer|A foreign key to a predefined concept in the Standardized Vocabularies reflecting the route of administration.|
|lot_number|No|varchar(50)|An identifier assigned to a particular quantity or lot of Drug product from the manufacturer.|
|provider_id|No|integer|A foreign key to the provider in the provider table who initiated (prescribed or administered) the Drug Exposure.|
|visit_occurrence_id|No|integer|A foreign key to the visit in the visit table during which the Drug Exposure was initiated.|
|drug_source_value|No|varchar(50)|The source code for the Drug as it appears in the source data. This code is mapped to a Standard Drug concept in the Standardized Vocabularies and the original code is, stored here for reference.|
|drug_source_concept_id|No|integer|A foreign key to a Drug Concept that refers to the code used in the source.|
|route_source_value|No|varchar(50)|The information about the route of administration as detailed in the source.|
|dose_unit_source_value|No|varchar(50)|The information about the dose unit as detailed in the source.|

### Conventions 

  * Valid Concepts for the drug_concept_id field belong to the "Drug" domain. Most Concepts in the Drug domain are based on RxNorm, but some may come from other sources. Concepts are members of the Clinical Drug or Pack, Branded Drug or Pack, Drug Component or Ingredient classes.
  * Source drug identifiers, including NDC codes, Generic Product Identifiers, etc. are mapped to Standard Drug Concepts in the Standardized Vocabularies (e.g., based on RxNorm). When the Drug Source Value of the code cannot be translated into standard Drug Concept IDs, a Drug exposure entry is stored with only the corresponding source_concept_id and drug_source_value and a drug_concept_id of 0.
  * The Drug Concept with the most detailed content of information is preferred during the mapping process. These are indicated in the concept_class_id field of the Concept and are recorded in the following order of precedence: "Branded Pack", "Clinical Pack", "Branded Drug", "Clinical Drug", "Branded Drug Component", "Clinical Drug Component", "Branded Drug Form", "Clinical Drug Form", and only if no other information is available "Ingredient". Note: If only the drug class is known, the drug_concept_id should contain 0.
  * A Drug Type is assigned to each Drug Exposure to track from what source the information was drawn or inferred from. The valid domain_id for these Concepts is "Drug Type".
  * The content of the refills field determines the current number of refills, not the number of remaining refills. For example, for a drug prescription with 2 refills, the content of this field for the 3 Drug Exposure events are null, 1 and 2.
  * The route_concept_id refers to a Standard Concepts of the "Route" domain. Note: Route information can also be inferred from the Drug product itself by determining the Drug Form of the Concept, creating some partial overlap of the same type of information. However, the route_concept_id could resolve ambiguities of how a certain Drug Form is actually applied. For example, a "Solution" could be used orally or parentherally, and this field will make this determination. 
  * The lot_number field contains an identifier assigned from the manufacturer of the Drug product. 
  * If possible, the visit in which the drug was prescribed or delivered is recorded in the visit_occurrence_id field through a reference to the visit table.
  * If possible, the prescribing or administering provider (physician or nurse) is recorded in the provider_id field through a reference to the provider table.
  * The drug_exposure_end_date denotes the day the drug exposure ended for the patient. This could be that the duration of drug_supply was reached (in which case drug_exposure_end_date = drug_exposure_start_date + days_supply -1), or because the exposure was stopped (medication changed, medication discontinued, etc.)