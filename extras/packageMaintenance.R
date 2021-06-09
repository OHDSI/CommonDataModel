
## Do this to get csv files from github
## Get the url of the zipped branch or tag to get the csvs from

# Set fileName variable to the name of the cdm version or branch being downloaded
fileName <- "cdm_v_5_3_1_fixes"

# get the url for the zip CDM files. This could be for a release or for a branch
zipUrl <- "https://github.com/OHDSI/CommonDataModel/archive/v5.3.1_fixes.zip"

# download the zipped files
download.file(url = zipUrl,
              destfile = paste0("inst/zip/", fileName ,".zip"))

# find the names of the csvs in the zipped file
zipped_csv_names <- grep('\\.csv$', unzip(paste0("inst/zip/", fileName ,".zip"), list=TRUE)$Name,
                         ignore.case=TRUE, value=TRUE)

# unzip only the csvs and put them in inst
unzip(paste0("inst/zip/", fileName ,".zip"), files=zipped_csv_names, exdir = "inst")

# paste the new csvs in the csv folder
zipFileList <- unzip(paste0("inst/zip/", fileName ,".zip"), list=TRUE)
folderName <- dplyr::filter(zipFileList, stringr::str_ends(Name, "/", negate = FALSE) & stringr::str_count(Name,"/") ==1)

newdir <- "inst/csv"
currentdir <- paste0("inst/",folderName$Name,"/")
listFiles <- list.files(currentdir)

file.copy(file.path(currentdir,listFiles), newdir, recursive = TRUE, overwrite = TRUE)

#rebuild package

