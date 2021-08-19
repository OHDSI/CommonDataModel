test_that("writeDdl works", {

  outputpath <- tempdir(TRUE)
  filename <- writeDdl(targetDialect = "postgresql", cdmVersion = "5.4", outputpath = outputpath)

  expect_true(file.exists(file.path(outputpath, filename)))
  sql <- readr::read_file(file.path(outputpath, filename))

  expect_type(sql, "character")
  expect_gt(nchar(sql), 10)

})

test_that("writePrimaryKeys works", {

  outputpath <- tempdir(TRUE)
  filename <- writePrimaryKeys(targetDialect = "postgresql", cdmVersion = "5.4", outputpath = outputpath)

  expect_true(file.exists(file.path(outputpath, filename)))
  sql <- readr::read_file(file.path(outputpath, filename))

  expect_type(sql, "character")
  expect_gt(nchar(sql), 10)

})

test_that("writeForeignKeys works", {

  outputpath <- tempdir(TRUE)
  filename <- writeForeignKeys(targetDialect = "postgresql", cdmVersion = "5.4", outputpath = outputpath)

  expect_true(file.exists(file.path(outputpath, filename)))
  sql <- readr::read_file(file.path(outputpath, filename))

  expect_type(sql, "character")
  expect_gt(nchar(sql), 10)

})

test_that("writeIndex works", {

  outputpath <- tempdir(TRUE)
  filename <- writeIndex(targetDialect = "postgresql", cdmVersion = "5.4", outputpath = outputpath)

  expect_true(file.exists(file.path(outputpath, filename)))
  sql <- readr::read_file(file.path(outputpath, filename))

  expect_type(sql, "character")
  expect_gt(nchar(sql), 10)

})
