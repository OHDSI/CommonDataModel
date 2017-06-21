## Run this code and point it to the .Rmd file so it can convert the markdown files on the wiki to a pdf

rmarkdown::render(input = "C:/Git/CommonDataModel/Documentation/OMOP_CDM_PDF.Rmd", output_format = "pdf_document", output_file = "C:/Git/CommonDataModel/OMOP_CDM_v5_1_0.pdf")
