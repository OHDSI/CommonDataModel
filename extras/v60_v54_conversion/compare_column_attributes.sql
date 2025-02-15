with cdm_v540 as (
select * 
  from information_schema.columns
 where table_schema = 'cdm_v540'  --> ENTER YOUR V5.4 CDM HERE
   and table_name not in ('cohort','cohort_attribute','cohort_definition')
), cdm_v601 as (
select * 
  from information_schema.columns
 where table_schema = 'cdm_v601' --> ENTER YOUR V6.0 CDM HERE
   and table_name not in ('cohort','cohort_attribute','cohort_definition')
)
select a.table_name,
       a.column_name,
       a.is_nullable v54_nullable,
       b.is_nullable v60_nullable,
       a.data_type   v54_datatype,
       b.data_type   v60_datatype
  from cdm_v540 a
  join cdm_v601 b
    on a.table_name  = b.table_name 
   and a.column_name = b.column_name
   and (a.is_nullable != b.is_nullable or a.data_type != b.data_type)
order by 1,2;