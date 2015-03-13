options (skip=1)
load data
infile drug_strength.csv 
into table drug_strength
replace
fields terminated by '\t'
trailing nullcols
(
  drug_concept_id,
  ingredient_concept_id,
  amount_value,
  amount_unit_concept_id,
  numerator_value,
  numerator_unit_concept_id,
  denominator_unit_concept_id,
  valid_start_date DATE 'YYYYMMDD',
  valid_end_date DATE 'YYYYMMDD',
  invalid_reason
)