# OMOP CDM Metadata Schemas

This directory contains [JSON Schemas](https://json-schema.org/) (draft-04) that formally
describe the metadata columns of the OMOP CDM definition CSV files, as requested in
[discussion #746](https://github.com/OHDSI/CommonDataModel/discussions/746).

| Schema | Describes one row of |
| --- | --- |
| `OMOP_CDMv5.4_Table_Level.schema.json` | `inst/csv/OMOP_CDMv5.4_Table_Level.csv` |
| `OMOP_CDMv5.4_Field_Level.schema.json` | `inst/csv/OMOP_CDMv5.4_Field_Level.csv` |

These schemas document the **CDM definition metadata** — the rows that describe the
model itself and drive DDL generation, the published documentation, and the
[DataQualityDashboard](https://github.com/OHDSI/DataQualityDashboard) checks. They do
not describe or validate an instantiated patient-level database.

## CSV-to-JSON representation

JSON Schema validates JSON, not CSV. Each schema describes **one CSV row** converted
to a JSON object under the following rules:

- JSON property names are identical to the CSV column headers, including
  `unique DQ identifiers` (which contains spaces).
- Every CSV value is represented as a JSON string, even when it looks numeric
  (e.g. `measurePersonCompletenessThreshold` of `0` becomes `"0"`).
- The literal CSV value `NA` is preserved as the JSON string `"NA"`; it is not
  converted to JSON `null`.

Example (from the table-level file):

```json
{
  "cdmTableName": "person",
  "schema": "CDM",
  "isRequired": "Yes",
  "conceptPrefix": "NA",
  "measurePersonCompleteness": "No",
  "measurePersonCompletenessThreshold": "NA",
  "validation": "NA",
  "tableDescription": "This table serves as the central identity management for all Persons in the database...",
  "userGuidance": "All records in this table are independent Persons.",
  "etlConventions": "All Persons in a database needs one record in this table..."
}
```

## Relationship to the DataQualityDashboard

The CSV layout follows the DataQualityDashboard (DQD) threshold-file convention:
a data-quality check column named `<checkName>` (with values `Yes`/`No`) is paired
with a `<checkName>Threshold` column giving the check's failure threshold. In this
repository's copies, the table-level file carries the `measurePersonCompleteness`
check and the field-level file carries the `fkDomain` and `fkClass` check inputs;
DQD ships extended copies of these files with the full set of check columns.

Authoritative definitions of the checks:

- [measurePersonCompleteness](https://ohdsi.github.io/DataQualityDashboard/articles/checks/measurePersonCompleteness.html)
- [fkDomain](https://ohdsi.github.io/DataQualityDashboard/articles/checks/fkDomain.html)
- [fkClass](https://ohdsi.github.io/DataQualityDashboard/articles/checks/fkClass.html)

The `conceptPrefix`, `validation`, and `unique DQ identifiers` columns are part of
the historical threshold-file layout and are not currently consumed by the
CommonDataModel or DataQualityDashboard code; their descriptions in the schemas are
marked as pending confirmation by the CDM maintainers.

## Observed cross-field invariants

The following relationships hold for every well-formed row of the v5.4 files. They
are documented here as **observed invariants** rather than encoded as schema rules,
because they have not been confirmed as intentional conventions by the CDM
maintainers; a future revision may promote them into the schemas.

Table level:

- `measurePersonCompleteness` is `Yes` if and only if
  `measurePersonCompletenessThreshold` is not `NA`.
- `conceptPrefix` is set (not `NA`) exactly for the nine clinical event tables
  (`condition_occurrence`, `device_exposure`, `drug_exposure`, `measurement`,
  `observation`, `procedure_occurrence`, `specimen`, `visit_detail`,
  `visit_occurrence`), and lowercasing the prefix and appending `concept_id`
  always yields a real field of that table (e.g. `CONDITION_` →
  `condition_concept_id`).

Field level:

- `isForeignKey` is `Yes` if and only if both `fkTableName` and `fkFieldName`
  are not `NA`.
- Whenever `fkDomain` or `fkClass` is set (not `NA`), the field is a foreign key
  to the `CONCEPT` table.
- Whenever `fkClass` is set, `fkDomain` is also set.

## Validating the CSVs against the schemas

Two optional tools validate every CSV row against these schemas using the
representation rules above:

- `extras/validateMetadataSchemas.R` — standalone R script (requires `readr`,
  `jsonlite`, `jsonvalidate`); run from the repository root with
  `Rscript extras/validateMetadataSchemas.R`. It is not part of the package and
  is not run by `R CMD check`.
- `.github/workflows/validate-metadata.yml` — GitHub Actions workflow (Python)
  that runs automatically when the v5.4 metadata CSVs or the schemas change.

Known issue: one row of `OMOP_CDMv5.4_Field_Level.csv` (`cdm_source.`
`source_documentation_reference`, line 355) currently contains an unquoted comma
and fails validation; this is tracked in
[#744](https://github.com/OHDSI/CommonDataModel/issues/744) /
[#775](https://github.com/OHDSI/CommonDataModel/issues/775) and fixed by
[#792](https://github.com/OHDSI/CommonDataModel/pull/792). The CI workflow reports
it as a known-issue warning until that fix merges.
