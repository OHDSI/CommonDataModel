--
-- RETRIEVE TABLE AND COLUMN NAMES FOR V5.4 AND V6.0 CDMS.
-- SUPPLY THE NAME OF EACH SCHEMA WHERE INDICATED.
-- THE "STATUS" COLUMN:
-- "IN BOTH": INDICATES COLUMN IS IN BOTH 5.4 AND 6.0 
-- "MISSING FROM v6.0.1": INDICATES COLUMN IS IN BOTH 5.4 BUT NOT 6.0 AND NEEDS TO BE ADDED OR RENAMED
-- "MISSING FROM v5.4.0": INDICATES COLUMN IS IN BOTH 6.0 BUT NOT 5.4 AND NEED TO BE DROPPED OR RENAMED

with cdm_v540 as (
select * 
  from information_schema.columns
 where table_schema = 'cdm_v540' --> YOUR V5.4 CDM SCHEMA NAME HERE
   and table_name not in ('_version','cohort','cohort_attribute','cohort_definition')
), cdm_v601 as (
select * 
  from information_schema.columns
 where table_schema = 'cdm_v601' --> YOUR V6.0 CDM SCHEMA NAME HERE
   and table_name not in ('_version','cohort','cohort_attribute','cohort_definition')
)
select a.table_name,
       a.column_name,
       'IN BOTH' status 
  from cdm_v540 a
  join cdm_v601 b
    on a.table_name  = b.table_name 
   and a.column_name = b.column_name
union all
select a.table_name,
       a.column_name,
       'MISSING FROM v6.0.1' status 
  from cdm_v540 a
  left join cdm_v601 b
    on a.table_name  = b.table_name 
   and a.column_name = b.column_name
 where b.column_name is null
union all
select b.table_name,
       b.column_name,
       'MISSING FROM v5.4.0' status 
  from cdm_v540 a
  right join cdm_v601 b
    on a.table_name  = b.table_name 
   and a.column_name = b.column_name
 where a.column_name is null
order by 1,3;