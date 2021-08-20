test_that("writeDdl works", {

  outputfolder <- tempdir(TRUE)
  filename <- writeDdl(targetDialect = "postgresql", cdmVersion = "5.4", outputfolder = outputfolder)

  expect_true(file.exists(file.path(outputfolder, filename)))
  sql <- readr::read_file(file.path(outputfolder, filename))

  expect_type(sql, "character")
  expect_gt(nchar(sql), 10)

})

test_that("writePrimaryKeys works", {

  outputfolder <- tempdir(TRUE)
  filename <- writePrimaryKeys(targetDialect = "postgresql", cdmVersion = "5.4", outputfolder = outputfolder)

  expect_true(file.exists(file.path(outputfolder, filename)))
  sql <- readr::read_file(file.path(outputfolder, filename))

  expect_type(sql, "character")
  expect_gt(nchar(sql), 10)

})

test_that("writeForeignKeys works", {

  outputfolder <- tempdir(TRUE)
  filename <- writeForeignKeys(targetDialect = "postgresql", cdmVersion = "5.4", outputfolder = outputfolder)

  expect_true(file.exists(file.path(outputfolder, filename)))
  sql <- readr::read_file(file.path(outputfolder, filename))

  expect_type(sql, "character")
  expect_gt(nchar(sql), 10)

})

test_that("writeIndex works", {

  outputfolder <- tempdir(TRUE)
  filename <- writeIndex(targetDialect = "postgresql", cdmVersion = "5.4", outputfolder = outputfolder)

  expect_true(file.exists(file.path(outputfolder, filename)))
  sql <- readr::read_file(file.path(outputfolder, filename))

  expect_type(sql, "character")
  expect_gt(nchar(sql), 10)

})
