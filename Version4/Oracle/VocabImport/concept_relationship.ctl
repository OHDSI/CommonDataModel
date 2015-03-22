options (skip=1)
load data
infile concept_relationship.csv 
into table concept_relationship
replace
fields terminated by '\t'
trailing nullcols
(
  concept_id_1,
  concept_id_2,
  relationship_id,
  valid_start_date DATE 'YYYYMMDD',
  valid_end_date DATE 'YYYYMMDD',
  invalid_reason
)