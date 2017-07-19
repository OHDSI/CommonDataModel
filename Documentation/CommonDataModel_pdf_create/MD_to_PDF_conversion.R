## Run this code and point it to the .Rmd file so it can convert the markdown files on the wiki to a pdf
install.packages("rmarkdown")

rmarkdown::render(input = "OMOP_CDM_PDF.Rmd", output_format = "pdf_document", output_file = "OMOP_CDM_v5_2.pdf")
