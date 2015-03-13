options (skip=1)
load data
infile domain.csv 
into table domain
replace
fields terminated by '\t'
trailing nullcols
(
  domain_id,
  domain_name,
  domain_concept_id
)