options (skip=1)
load data
infile concept_synonym.csv 
into table concept_synonym
replace
fields terminated by '\t'
trailing nullcols
(
  concept_id,
  concept_synonym_name CHAR(1000),
  language_concept_id
)