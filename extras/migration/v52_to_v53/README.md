# v5.2 to v5.3 CDM conversion

The *_migration.sql scripts in this folder migrate a v5.2 CDM to a v5.3 CDM.
These scripts follow the migration pattern already used in this repository and cover
the structural deltas reflected by the historical v5.2 DDLs and the v5.3 DDLs under inst/ddl.
Please replace @cdmDatabaseSchema with your schema name.
