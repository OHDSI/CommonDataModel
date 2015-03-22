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
  amount_unit,
  concentration_value,
  concentration_enum_unit,
  concentration_denom_unit,
  valid_start_date DATE 'YYYYMMDD',
  valid_end_date DATE 'YYYYMMDD',
  invalid_reason
)