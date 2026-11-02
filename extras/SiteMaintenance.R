# Generate the site with Quarto ------------------------------------------

# Run this script from the root of the CommonDataModel repository. The
# output directory is configured as ../docs in site/_quarto.yml.

siteDirectory <- file.path(getwd(), "site")
quartoConfig <- file.path(siteDirectory, "_quarto.yml")

if (!file.exists(quartoConfig)) {
  stop(
    "Could not find site/_quarto.yml. Run this script from the root of ",
    "the CommonDataModel repository."
  )
}

quarto <- Sys.which("quarto")
if (!nzchar(quarto)) {
  stop("Quarto is not installed or is not available on PATH.")
}

status <- system2(
  command = unname(quarto),
  args = c("render", shQuote(normalizePath(siteDirectory)))
)

if (status != 0L) {
  stop("Quarto failed to render the site (exit status ", status, ").")
}

# Preview the site
quarto::quarto_preview(file = "site")