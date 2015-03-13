options (skip=1)
load data
infile concept.csv 
into table concept
replace
fields terminated by '\t'
trailing nullcols
(
  concept_id,
  concept_name,
  domain_id,
  vocabulary_id,
  concept_class_id,
  standard_concept,
  concept_code,
  valid_start_date DATE 'YYYYMMDD',
  valid_end_date DATE 'YYYYMMDD',
  invalid_reason
)