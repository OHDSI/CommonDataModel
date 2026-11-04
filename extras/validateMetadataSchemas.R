# Validate the OMOP CDM v5.4 metadata CSV files against the JSON Schemas in
# inst/schema/. See inst/schema/README.md for the CSV-to-JSON representation
# the schemas describe.
#
# This is a standalone maintenance script; it is not part of the package and
# is not run by R CMD check. Run it from the repository root:
#
#   Rscript extras/validateMetadataSchemas.R
#
# Requires: readr, jsonlite, jsonvalidate (install from CRAN).

library(readr)
library(jsonlite)
library(jsonvalidate)

validateMetadataFile <- function(csvPath, schemaPath) {
  cat(sprintf("\nValidating %s\n  against %s\n", csvPath, schemaPath))

  # Read every cell as a character string and keep literal "NA" values as the
  # string "NA" (na = character()), matching the representation documented in
  # inst/schema/README.md.
  metadata <- read_csv(
    csvPath,
    col_types = cols(.default = col_character()),
    na = character(),
    show_col_types = FALSE
  )

  validator <- json_validator(schemaPath, engine = "ajv")

  failures <- 0
  for (rowNumber in seq_len(nrow(metadata))) {
    record <- as.list(metadata[rowNumber, , drop = FALSE])
    recordJson <- toJSON(record, auto_unbox = TRUE, na = "string")
    result <- validator(recordJson, verbose = TRUE)
    if (!isTRUE(result)) {
      failures <- failures + 1
      # CSV line number = data row + 1 header line
      cat(sprintf("  FAIL line %d (%s):\n", rowNumber + 1,
                  paste(record$cdmTableName, record$cdmFieldName, sep = ".")))
      print(attr(result, "errors"))
    }
  }

  cat(sprintf("  %d rows checked, %d failures\n", nrow(metadata), failures))
  failures
}

totalFailures <-
  validateMetadataFile(
    "inst/csv/OMOP_CDMv5.4_Table_Level.csv",
    "inst/schema/OMOP_CDMv5.4_Table_Level.schema.json"
  ) +
  validateMetadataFile(
    "inst/csv/OMOP_CDMv5.4_Field_Level.csv",
    "inst/schema/OMOP_CDMv5.4_Field_Level.schema.json"
  )

if (totalFailures > 0) {
  stop(sprintf("%d metadata rows failed schema validation", totalFailures))
}
cat("\nAll metadata rows conform to the schemas.\n")
