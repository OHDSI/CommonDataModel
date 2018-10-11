A Dose Era is defined as a span of time when the Person is assumed to be exposed to a constant dose of a specific active ingredient. 

Field|Required|Type|Description
:--------------------|:--------|:------------|:---------------------------
|dose_era_id|Yes|integer|A unique identifier for each Dose Era.|
|person_id|Yes|integer|A foreign key identifier to the Person who is subjected to the drug during the drug era. The demographic details of that Person are stored in the PERSON table.|
|drug_concept_id|Yes|integer|A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies for the active Ingredient Concept.|
|unit_concept_id|Yes|integer|A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies for the unit concept.|
|dose_value|Yes|float|The numeric value of the dose.|
|dose_era_start_datetime|Yes|date|The start date for the drug era constructed from the individual instances of drug exposures. It is the start date of the very first chronologically recorded instance of utilization of a drug.|
|dose_era_end_datetime|Yes|date|The end date for the drug era constructed from the individual instance of drug exposures. It is the end date of the final continuously recorded instance of utilization of a drug.|

### Conventions 

No.|Convention Description
:--------|:------------------------------------
| 1  | Dose Eras will be derived from records in the DRUG_EXPOSURE table and the Dose information from the DRUG_STRENGTH table using a standardized algorithm. |
| 2  | Each Dose Era corresponds to one or many Drug Exposures that form a continuous interval and contain the same Drug Ingredient (active compound) at the same effective daily dose. |
| 3  | Dose Form information is not taken into account. So, if the patient changes between different formulations, or different manufacturers with the same formulation, the Dose Era is still spanning the entire time of exposure to the Ingredient.
| 4  | The daily dose is calculated for each DRUG_EXPOSURE record by calculating the total dose of the record and dividing by the duration. |


The total dose of a DRUG_EXPOSURE record is calculated with the help of the DRUG_STRENGTH table containing the dosage information for each drug as following:  
  
|  5     | Tablets and other fixed amount formulations | 
|:-----------------|:-----------------------------------------|
||*Example: Acetaminophen (Paracetamol) 500 mg, 20 tablets.*|
| DRUG_STRENGTH  | The denominator_unit is empty |
| DRUG_EXPOSURE  | The quantity refers to number of pieces, e.g. tablets    |
||*In the example: 20*|
|`Ingredient dose=`|`quantity x amount_value [amount_unit_concept_id]`|
||*`Acetaminophen dose = 20 x 500mg = 10,000mg`*|

|  6     | Puffs of an inhaler | 
|:-----------------|:-----------------------------------------|
||Note: There is no difference to use case 1 besides that the DRUG_STRENGTH table may put {actuat} in the denominator unit. In this case the strength is provided in the numerator.|
| DRUG_STRENGTH  | The denominator_unit is {actuat}|
| DRUG_EXPOSURE  | The quantity refers to the number of pieces, e.g. puffs |
| `Ingredient dose=`|`quantity x numerator_value [numerator_unit_concept_id]`|

|  7     | Quantified Drugs which are formulated as a concentration | 
|:-----------------|:-----------------------------------------|
||*Example: The Clinical Drug is Acetaminophen 250 mg/mL in a 5mL oral suspension. The Quantified Clinical Drug would have 1250 mg / 5 ml in the DRUG_STRENGTH table. Two suspensions are dispensed.*|
| DRUG_STRENGTH  | The denominator_unit is either mg or mL. The denominator_value might be different from 1. |
| DRUG_EXPOSURE  | The quantity refers to a fraction or, multiple of the pack. |
||*Example: 2* |
| `Ingredient dose=`|`quantity x numerator_value [numerator_unit_concept_id]`|
||*`Acetaminophen dose = 2 x 1250mg = 2500mg`*|

|  8     | Drugs with the total amount provided in quantity, e.g. chemotherapeutics | 
|:-----------------|:-----------------------------------------|
||*Example: 42799258 "Benzyl Alcohol 0.1 ML/ML / Pramoxine hydrochloride 0.01 MG/MG Topical Gel" dispensed in a 1.25oz pack.*|
| DRUG_STRENGTH  | The denominator_unit is either mg or mL.|
||*Example: Benzyl Alcohol in mL and Pramoxine hydrochloride in mg*|
| DRUG_EXPOSURE  | The quantity refers to mL or g.|
||*Example: 1.25 x 30 (conversion factor oz -> mL) = 37*|
| `Ingredient dose=`|`quantity x numerator_value [numerator_unit_concept_id]`|
||*`Benzyl Alcohol dose = 37 x 0.1mL = 3.7mL`*|
||*`Pramoxine hydrochloride dose = 37 x 0.01mg x 1000 = 370mg`*|
||*Note: The analytical side should check the denominator in the DRUG_STRENGTH table. As mg is used for the second ingredient the factor 1000 will be applied to convert between g and mg.*|

|  9     | Compounded drugs |
|:-----------------|:-----------------------------------------|
||*Example: Ibuprofen 20%/Piroxicam 1% Cream, 30ml in 5ml tubes.*|
| DRUG_STRENGTH  | We need entries for the ingredients of Ibuprofen and  Piroxicam, probably with an amount_value of 1 and a unit of mg.|
| DRUG_EXPOSURE  | The quantity refers to the total amount of the compound. Use one record in the DRUG_EXPOSURE table for each compound.|
||*Example: 20% Ibuprofen of 30ml = 6mL, 1% Piroxicam of 30ml = 0.3mL*|
|`Ingredient dose=`|Depends on the drugs involved: One of the use cases above.|
||*`Ibuprofen dose = 6 x 1mg x 1000 = 6000mg`*|
||*`Piroxicam dose = 0.3 x 1mg x 1000 = 300mg`*|
||*Note: The analytical side determines that the denominator for both ingredients in the DRUG_STRENGTH table is mg and applies the factor 1000 to convert between mL/g and mg.*|

|  10     | Drugs with the active ingredient released over time, e.g. patches |
|:-----------------|:-----------------------------------------|
||*Example: Ethinyl Estradiol 0.000833 MG/HR / norelgestromin 0.00625 MG/HR Weekly Transdermal Patch*|
| DRUG_STRENGTH  | The denominator units refer to hour.|
||*Example: Ethinyl Estradiol 0.000833 mg/h / norelgestromin 0.00625 mg/h*|
| DRUG_EXPOSURE  | The quantity refers to the number of pieces.|
||*Example: 1 patch*|
| `Ingredient rate=`|`numerator_value [numerator_unit_concept_id]`|
||*`Ethinyl Estradiol rate = 0.000833 mg/h`*|
||*`norelgestromin rate 0.00625 mg/h`*|
||*Note: This can be converted to a daily dosage by multiplying it with 24. (Assuming 1 patch at a time for at least 24 hours)*|
