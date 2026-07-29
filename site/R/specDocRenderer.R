render_spec_doc <- function(table_file,
                            field_file,
                            add_section_headers = TRUE) {
  table_specs <- utils::read.csv(table_file, stringsAsFactors = FALSE)
  field_specs <- utils::read.csv(field_file, stringsAsFactors = FALSE)

  field_columns <- c(
    "CDM Table" = "cdmTableName",
    "CDM Field" = "cdmFieldName",
    "User Guide" = "userGuidance",
    "ETL Conventions" = "etlConventions",
    "Datatype" = "cdmDatatype",
    "Required" = "isRequired",
    "Primary Key" = "isPrimaryKey",
    "Foreign Key" = "isForeignKey",
    "FK Table" = "fkTableName",
    "FK Domain" = "fkDomain"
  )

  cdm_specs_clean <- field_specs[, unname(field_columns), drop = FALSE]
  names(cdm_specs_clean) <- names(field_columns)

  cdm_specs_clean[is.na(cdm_specs_clean)] <- ""
  table_specs[is.na(table_specs)] <- ""

  for (table_name in table_specs$cdmTableName) {
    # Assume that first table in section is always the same
    section_header <- switch(
      tolower(table_name),
      person = "Clinical Data Tables",
      location = "Health System Data Tables",
      payer_plan_period = "Health Economics Data Tables",
      drug_era = "Standardized Derived Elements",
      metadata = "Metadata Tables",
      concept = "Vocabulary Tables",
      NA
    )
    if (isTRUE(add_section_headers) && !is.na(section_header)) {
      cat("## ", section_header, "\n\n")
    }

    cat("### ", table_name, "{.tabset .tabset-pills}\n\n")

    table_info <- subset(table_specs, cdmTableName == table_name)
    cat("**Table Description**\n\n", table_info[, "tableDescription"], "\n\n")

    if (!isTRUE(table_info[, "userGuidance"] == "")) {
      cat("**User Guide**\n\n", table_info[, "userGuidance"], "\n\n")
    }

    if (!isTRUE(table_info[, "etlConventions"] == "")) {
      cat("**ETL Conventions**\n\n", table_info[, "etlConventions"], "\n\n")
    }

    loop_table <- subset(cdm_specs_clean, `CDM Table` == table_name)
    loop_table <- subset(loop_table, select = -c(1))

    table_html <- knitr::kable(
      x = loop_table,
      align = "l",
      row.names = FALSE,
      format = "html",
      escape = FALSE
    )
    table_html <- kableExtra::column_spec(table_html, 1, bold = TRUE)
    table_html <- kableExtra::kable_styling(
      table_html,
      c("condensed", "hover"),
      position = "center",
      full_width = TRUE,
      font_size = 13
    )

    print(table_html)
  }
}
