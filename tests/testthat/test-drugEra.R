# Runs the example drug era script (inst/sql/sql_server/OMOP_CDM_drug_era.sql,
# shown on the "SQL Scripts" page of the website) against an in-memory SQLite
# CDM and checks the resulting eras. Scenarios taken from
# https://github.com/OHDSI/CommonDataModel/issues/761

skip_if_not_installed("DBI")
skip_if_not_installed("RSQLite")

# Day 1 of the scenarios below is 2020-01-01
scenarioDay <- function(day) {
  as.Date("2020-01-01") + (day - 1)
}

# Date literal in the yyyymmdd form that SqlRender translates for every dialect
dateLiteral <- function(date) {
  paste0("CAST('", format(date, "%Y%m%d"), "' AS DATE)")
}

# Create an empty CDM in the SQLite connection and load one ingredient, one
# drug mapped to it and the drug exposures. `exposures` is a data frame with
# columns `person_id`, `start_day` and `end_day` (inclusive, see scenarioDay).
loadDrugEraTestData <- function(con, cdmVersion, exposures) {
  executeOhdsiSql <- function(sql, ...) {
    sql <- SqlRender::render(sql, ...)
    sql <- SqlRender::translate(sql, targetDialect = "sqlite")
    for (statement in SqlRender::splitSql(sql)) {
      DBI::dbExecute(con, statement)
    }
  }

  executeOhdsiSql(createDdl(cdmVersion), cdmDatabaseSchema = "main")

  executeOhdsiSql(
    "INSERT INTO @cdm_schema.concept
       (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id,
        standard_concept, concept_code, valid_start_date, valid_end_date)
     VALUES
       (1, 'test ingredient', 'Drug', 'RxNorm', 'Ingredient', 'S', 'ING',
        CAST('19700101' AS DATE), CAST('20991231' AS DATE)),
       (2, 'test clinical drug', 'Drug', 'RxNorm', 'Clinical Drug', 'S', 'DRUG',
        CAST('19700101' AS DATE), CAST('20991231' AS DATE));
     INSERT INTO @cdm_schema.concept_ancestor
       (ancestor_concept_id, descendant_concept_id,
        min_levels_of_separation, max_levels_of_separation)
     VALUES (1, 1, 0, 0), (1, 2, 1, 1);",
    cdm_schema = "main"
  )

  for (i in seq_len(nrow(exposures))) {
    executeOhdsiSql(
      "INSERT INTO @cdm_schema.drug_exposure
         (drug_exposure_id, person_id, drug_concept_id,
          drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id)
       VALUES (@id, @person_id, 2, @start_date, @end_date, 0);",
      cdm_schema = "main",
      id = i,
      person_id = exposures$person_id[i],
      start_date = dateLiteral(scenarioDay(exposures$start_day[i])),
      end_date = dateLiteral(scenarioDay(exposures$end_day[i]))
    )
  }
}

runDrugEraScript <- function(con) {
  scriptFile <- system.file("sql", "sql_server", "OMOP_CDM_drug_era.sql",
                            package = "CommonDataModel", mustWork = TRUE)
  sql <- SqlRender::render(SqlRender::readSql(scriptFile), cdm_schema = "main")
  sql <- SqlRender::translate(sql, targetDialect = "sqlite")
  for (statement in SqlRender::splitSql(sql)) {
    DBI::dbExecute(con, statement)
  }

  eras <- DBI::dbGetQuery(
    con,
    "SELECT person_id, drug_concept_id, drug_era_start_date, drug_era_end_date,
            drug_exposure_count, gap_days
     FROM main.drug_era
     ORDER BY person_id, drug_era_start_date"
  )
  # SqlRender stores dates in SQLite as seconds since 1970-01-01
  toDate <- function(x) as.Date(as.POSIXct(x, origin = "1970-01-01", tz = "UTC"))
  eras$drug_era_start_date <- toDate(eras$drug_era_start_date)
  eras$drug_era_end_date <- toDate(eras$drug_era_end_date)
  return(eras)
}

for (cdmVersion in listSupportedVersions()) {
  test_that(paste("drug era script collapses overlapping and nearby exposures, CDM", cdmVersion), {
    # day:        1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
    # exposure 1: |-----------|
    # exposure 2:       |-----------|
    # exposure 3:                               |-----|
    # exposure 4:                                              |-----------|
    exposures <- data.frame(
      person_id = 1,
      start_day = c(1, 3, 11, 16),
      end_day = c(5, 7, 13, 20)
    )
    con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
    on.exit(DBI::dbDisconnect(con))
    loadDrugEraTestData(con, cdmVersion, exposures)

    eras <- runDrugEraScript(con)

    expect_equal(nrow(eras), 1)
    expect_equal(eras$person_id, 1)
    expect_equal(eras$drug_concept_id, 1)
    expect_equal(eras$drug_era_start_date, scenarioDay(1))
    expect_equal(eras$drug_era_end_date, scenarioDay(20))
    expect_equal(eras$drug_exposure_count, 4)
    # drug-free days are 8, 9, 10, 14 and 15
    expect_equal(eras$gap_days, 5)
  })

  test_that(paste("drug era script reports no gap days for consecutive exposures, CDM", cdmVersion), {
    # day:        1  2  3  4  5  6  7  8  9 10
    # exposure 1: |-----------|
    # exposure 2:                |-----------|
    exposures <- data.frame(
      person_id = 1,
      start_day = c(1, 6),
      end_day = c(5, 10)
    )
    con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
    on.exit(DBI::dbDisconnect(con))
    loadDrugEraTestData(con, cdmVersion, exposures)

    eras <- runDrugEraScript(con)

    expect_equal(nrow(eras), 1)
    expect_equal(eras$drug_era_start_date, scenarioDay(1))
    expect_equal(eras$drug_era_end_date, scenarioDay(10))
    expect_equal(eras$drug_exposure_count, 2)
    expect_equal(eras$gap_days, 0)
  })

  test_that(paste("drug era script starts a new era after more than 30 days, CDM", cdmVersion), {
    exposures <- data.frame(
      person_id = c(1, 1, 2),
      start_day = c(1, 40, 1),
      end_day = c(5, 45, 1)
    )
    con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
    on.exit(DBI::dbDisconnect(con))
    loadDrugEraTestData(con, cdmVersion, exposures)

    eras <- runDrugEraScript(con)

    expect_equal(nrow(eras), 3)
    expect_equal(eras$person_id, c(1, 1, 2))
    expect_equal(eras$drug_era_start_date, scenarioDay(c(1, 40, 1)))
    expect_equal(eras$drug_era_end_date, scenarioDay(c(5, 45, 1)))
    expect_equal(eras$drug_exposure_count, c(1, 1, 1))
    expect_equal(eras$gap_days, c(0, 0, 0))
  })
}
