options (skip=1)
load data
infile relationship.csv 
into table relationship
replace
fields terminated by '\t'
trailing nullcols
(
  relationship_id,
  relationship_name,
  is_hierarchical,
  defines_ancestry,
  reverse_relationship_id,
  relationship_concept_id
)