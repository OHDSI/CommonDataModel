The DRUG_STRENGTH table contains structured content about the amount or concentration and associated units of a specific ingredient contained within a particular drug product. This table is supplemental information to support standardized analysis of drug utilization. 

Field|Required|Type|Description
:----------------------------|:--------|:------------|:----------------------------------------
|drug_concept_id|Yes|integer|A foreign key to the Concept in the CONCEPT table representing the identifier for Branded Drug or Clinical Drug Concept.|
|ingredient_concept_id|Yes|integer|A foreign key to the Concept in the CONCEPT table, representing the identifier for drug Ingredient Concept contained within the drug product.|
|amount_value|No|float|The numeric value associated with the amount of active ingredient contained within the product.|
|amount_unit_concept_id|No|integer|A foreign key to the Concept in the CONCEPT table representing the identifier for the Unit for the absolute amount of active ingredient.|
|numerator_value|No|float|The numeric value associated with the concentration of the active ingredient contained in the product|
|numerator_unit_concept_id|No|integer|A foreign key to the Concept in the CONCEPT table representing the identifier for the numerator Unit for the concentration of active ingredient.|
|denominator_value|No|float|The amount of total liquid (or other divisible product, such as ointment, gel, spray, etc.).|
|denominator_unit_concept_id|No|integer|A foreign key to the Concept in the CONCEPT table representing the identifier for the denominator Unit for the concentration of active ingredient.|
|valid_start_date|Yes|date|The date when the Concept was first recorded. The default value is 1-Jan-1970.|
|valid_end_date|Yes|date|The date when the concept became invalid because it was deleted or superseded (updated) by a new Concept. The default value is 31-Dec-2099.|
|invalid_reason|No|varchar(1)|Reason the concept was invalidated. Possible values are 'D' (deleted), 'U' (replaced with an update) or NULL when valid_end_date has the default value.|

### Conventions

  * The DRUG_STRENGTH table contains information for each active (non-deprecated) standard drug concept.
  * A drug which contains multiple active Ingredients will result in multiple DRUG_STRENGTH records, one for each active ingredient.
  * Ingredient strength information is provided either as absolute amount (usually for solid formulations) or as concentration (usually for liquid formulations).
  * If the absolute amount is provided (for example, 'Acetaminophen 5 MG Tablet') the amount_value and amount_unit_concept_id are used to define this content (in this case 5 and 'MG').
  * If the concentration is provided (for example 'Acetaminophen 48 MG/ML Oral Solution') the numerator_value in combination with the numerator_unit_concept_id and denominator_unit_concept_id are used to define this content (in this case 48, 'MG' and 'ML'). 
  * In case of Quantified Clinical or Branded Drugs the denominator_value contains the total amount of the solution (not the amount of the ingredient). In all other drug concept classes the denominator amount is NULL because the concentration is always normalized to the unit of the denominator. So, a product containing 960 mg in 20 mL is provided as 48 mg/mL in the Clinical Drug and Clinical Drug Component, while as a Quantified Clinical Drug it is written as 960 mg/20 mL.
  * If the strength is provided in % (volume or mass-percent are not distinguished) it is stored in the numerator_value/numerator_unit_concept_id field combination, with both the denominator_value and denominator_unit_concept_id set to NULL. If it is a Quantified Drug the total amount of drug is provided in the denominator_value/denominator_unit_concept_id pair. E.g., the 30 G Isoconazole 2% Topical Cream is provided as 2% / in Clinical Drug and Clinical Drug Component, and as 2% /30 G.
  * Sometimes, one Ingredient is listed with different units within the same drug. This is very rare, and usually this happens if there are more than one Precise Ingredient. For example, 'Penicillin G, Benzathine 150000 UNT/ML / Penicillin G, Procaine 150000 MEQ/ML Injectable Suspension' contains Penicillin G in two different forms.
  * Sometimes, different ingredients in liquid drugs are listed with different units in the denominator_unit_concept_id. This is usually the case if the ingredients are liquids themselves (concentration provided as mL/mL) or solid substances (mg/mg). In these cases, the general assumptions is made that the density of the drug is that of water, and one can assume 1 g = 1 mL.
  * All Drug vocabularies containing Standard Concepts have entries in the DRUG_STRENGTH table. 