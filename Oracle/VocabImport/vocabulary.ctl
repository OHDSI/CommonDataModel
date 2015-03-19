options (skip=1)
load data
infile vocabulary.csv 
into table vocabulary
replace
fields terminated by '\t'
trailing nullcols
(
  vocabulary_id,
  vocabulary_name,
  vocabulary_reference,
  vocabulary_version,
  vocabulary_concept_id
)