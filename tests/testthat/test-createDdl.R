test_that("createDdl works", {
  # for(cdmVersion in listSupportedVersions()) { # 5.3 ddl csv control file is currently messed up.
    cdmVersion <- "5.4"
    sql <- createDdl(cdmVersion)
    expect_type(sql, "character")
    expect_gt(nchar(sql), 10)
  # }

  expect_error(createDdl(5.4))
  expect_error(createDdl("blah"))

})

test_that("createPrimaryKeys works", {
  # for(cdmVersion in listSupportedVersions()) {
  cdmVersion <- "5.4"
  sql <- createPrimaryKeys(cdmVersion)
  expect_type(sql, "character")
  expect_gt(nchar(sql), 10)
  # }

  expect_error(createPrimaryKeys(5.4))
  expect_error(createPrimaryKeys("blah"))
})

test_that("createForeignKeys works", {
  # for(cdmVersion in listSupportedVersions()) {
  cdmVersion <- "5.4"
  sql <- createForeignKeys(cdmVersion)
  expect_type(sql, "character")
  expect_gt(nchar(sql), 10)
  # }

  expect_error(createForeignKeys(5.4))
  expect_error(createForeignKeys("blah"))
})


