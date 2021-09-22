test_that("buildRelease() output matches current ddl folder", {

  tempfolder <- tempdir(check = TRUE)
  generatedBaseFolder <- file.path(tempdir(check = TRUE), "ddl")
  currentBaseFolder <- system.file("ddl", package = "CommonDataModel", mustWork = TRUE)

  # build all of the releases in a temp folder
  buildRelease(outputfolder = generatedBaseFolder)

  # compare to the files in the current ddl folder of the package
  generatedDirectories <- list.dirs(generatedBaseFolder, full.names = F)
  currentDirectories <- list.dirs(currentBaseFolder, full.names = F)
  expect_gt(length(currentDirectories), 1)
  expect_setequal(generatedDirectories, currentDirectories)

  # compare filenames
  generatedFilenames <- list.files(generatedBaseFolder, recursive = TRUE)
  currentFilenames <- list.files(generatedBaseFolder, recursive = TRUE)
  expect_gt(length(currentFilenames), 1)
  expect_setequal(generatedFilenames, currentFilenames)

  # compare file contents using md5 hash
  generatedChecksums <- tools::md5sum(file.path(generatedBaseFolder, generatedFilenames))
  currentChecksums <- tools::md5sum(file.path(currentBaseFolder, currentFilenames))
  names(generatedChecksums) <- NULL
  names(currentChecksums) <- NULL
  expect_gt(length(currentChecksums), 1)
  expect_setequal(generatedChecksums, currentChecksums)

})
