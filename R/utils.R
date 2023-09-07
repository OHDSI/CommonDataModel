# these packages are used in utilities or functions outside of check's vision
# this function ensures that check is satisfied and does not report the
# packages as imported but not imported from
checkSatisfier <- function() {
  DBI::dbConnect
  dplyr::sql
  rmarkdown::draft
}
