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
  concept_level,
  concept_class,
  vocabulary_id,
  concept_code,
  valid_start_date DATE 'YYYYMMDD',
  valid_end_date DATE 'YYYYMMDD',
  invalid_reason
)