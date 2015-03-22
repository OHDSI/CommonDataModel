options (skip=1)
load data
infile source_to_concept_map.csv 
into table source_to_concept_map
replace
fields terminated by '\t'
trailing nullcols
(
  source_code,
  source_vocabulary_id,
  source_code_description CHAR(256),
  target_concept_id,
  target_vocabulary_id,
  mapping_type,
  primary_map,
  valid_start_date DATE 'YYYYMMDD',
  valid_end_date DATE 'YYYYMMDD',
  invalid_reason
)