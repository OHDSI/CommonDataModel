#!/bin/bash

echo "-- VISIT_OCCURENCE" > "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/VISIT_OCCURRENCE.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.visit_occurence.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- CONDITION_OCCURENCE" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/CONDITION_OCCURRENCE.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.condition_occurence.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- DEATH" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/DEATH.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.death.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- DEVICE_EXPOSURE" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/DEVICE_EXPOSURE.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.device_exposure.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- DRUG_EXPOSURE" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/DRUG_EXPOSURE.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.drug_exposure.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- FACT_RELATIONSHIP" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/FACT_RELATIONSHIP.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.FACT_RELATIONSHIP.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- MEASUREMENT" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/MEASUREMENT.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.MEASUREMENT.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- NOTE" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/NOTE.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.NOTE.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- VISIT_DETAIL" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/VISIT_DETAIL.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.VISIT_DETAIL.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- SPECIMEN" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/SPECIMEN.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.SPECIMEN.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- PROCEDURE_OCCURRENCE" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.PROCEDURE_OCCURRENCE.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- PERSON" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/PERSON.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.PERSON.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- OBSERVATION_PERIOD" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/OBSERVATION_PERIOD.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.OBSERVATION_PERIOD.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- OBSERVATION" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/OBSERVATION.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.OBSERVATION.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"

echo "-- NOTE_NLP" >> "PostgreSQL/pg_comments.sql"
grep "|" Documentation/CommonDataModel_Wiki_Files/StandardizedClinicalDataTables/NOTE_NLP.md |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/'';/g" |sed "s/|\(.*\)|.*|.*|\(.*\)|/COMMENT ON COLUMN omop.NOTE_NLP.\1 IS '\2';/g" >> "PostgreSQL/pg_comments.sql"
