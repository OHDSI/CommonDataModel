A Drug Era is defined as a span of time when the Person is assumed to be exposed to a particular active ingredient. A Drug Era is not the same as a Drug Exposure: Exposures are individual records corresponding to the source when Drug was delivered to the Person, while successive periods of Drug Exposures are combined under certain rules to produce continuous Drug Eras. 

Field|Required|Type|Description
:---------------------|:--------|:------------|:----------------------------
|drug_era_id|Yes|integer|A unique identifier for each Drug Era.|
|person_id|Yes|integer|A foreign key identifier to the Person who is subjected to the Drug during the fDrug Era. The demographic details of that Person are stored in the PERSON table.|
|drug_concept_id|Yes|integer|A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies for the Ingredient Concept.|
|drug_era_start_date|Yes|date|The start date for the Drug Era constructed from the individual instances of Drug Exposures. It is the start date of the very first chronologically recorded instance of conutilization of a Drug.|
|drug_era_end_date|Yes|date|The end date for the drug era constructed from the individual instance of drug exposures. It is the end date of the final continuously recorded instance of utilization of a drug.|
|drug_exposure_count|No|integer|The number of individual Drug Exposure occurrences used to construct the Drug Era.|
|gap_days|No|integer|The number of days that are not covered by DRUG_EXPOSURE records that were used to make up the era record.|

### Conventions 
  * Drug Eras are derived from records in the DRUG_EXPOSURE table using a standardized algorithm.
  * Each Drug Era corresponds to one or many Drug Exposures that form a continuous interval and contain the same Drug Ingredient (active compound).
  * The drug_concept_id field only contains Concepts that have the concept_class 'Ingredient'. The Ingredient is derived from the Drug Concepts in the DRUG_EXPOSURE table that are aggregated into the Drug Era record.
  * The Drug Era Start Date is the start date of the first Drug Exposure.
  * The Drug Era End Date is the end date of the last Drug Exposure. The End Date of each Drug Exposure is either taken from the field drug_exposure_end_date or, as it is typically not available, inferred using the following rules:
    * For pharmacy prescription data, the date when the drug was dispensed plus the number of days of supply are used to extrapolate the End Date for the Drug Exposure. Depending on the country-specific healthcare system, this supply information is either explicitly provided in the day_supply field or inferred from package size or similar information.
    * For Procedure Drugs, usually the drug is administered on a single date (i.e., the administration date). 
    * A standard Persistence Window of 30 days (gap, slack) is permitted between two subsequent such extrapolated DRUG_EXPOSURE records to be considered to be merged into a single Drug Era.
  * The Gap Days determine how many total drug-free days are observed between all Drug Exposure events that contribute to a DRUG_ERA record. It is assumed that the drugs are "not stockpiled" by the patient, i.e. that if a new drug prescription or refill is observed (a new DRUG_EXPOSURE record is written), the remaining supply from the previous events is abandoned.
  * The difference between Persistence Window and Gap Days is that the former is the maximum drug-free time allowed between two subsequent DRUG_EXPOSURE records, while the latter is the sum of actual drug-free days for the given Drug Era under the above assumption of non-stockpiling.
  * The choice of a standard Persistence Window of 30 and the non-stockpiling assumption is arbitrary, but has been shown to deliver good results in drug-outcome estimation. Other problems, such as estimation of drug compliance, my require a different or drug-dependent Persistence Window/stockpiling assumption. Researchers are encouraged to consider creating their own Drug Eras with different parameters as Cohorts and store them in the COHORT table.

![](http://www.ohdsi.org/web/wiki/lib/exe/fetch.php?w=800&tok=5ebf4b&media=documentation:cdm:drugera.jpg)\
  