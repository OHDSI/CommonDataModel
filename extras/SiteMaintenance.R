# Generate site from markdown files --------------------------------------

# Run this in standalone R session. Runs orders of magnitude faster compared
# to running in RStudio:

library(rmarkdown)

setwd("rmd")
rmarkdown::render_site()
