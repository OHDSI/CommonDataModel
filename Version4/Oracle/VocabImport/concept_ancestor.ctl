options (skip=1)
load data
infile concept_ancestor.csv 
into table concept_ancestor
replace
fields terminated by '\t'
trailing nullcols
(
  ancestor_concept_id,
  descendant_concept_id,
  min_levels_of_separation,
  max_levels_of_separation	
)