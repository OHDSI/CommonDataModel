options (skip=1)
load data
infile concept_class.csv 
into table concept_class
replace
fields terminated by '\t'
trailing nullcols
(
  concept_class_id,
  concept_class_name,
  concept_class_concept_id	
)