
cdmVersion <- '5.4'
cdmPart <- c('CDM','VOCAB', 'RESULTS')
cdmTables <- NULL #c('PERSON', 'OBSERVATION_PERIOD', 'VISIT_OCCURRENCE', 'CONDITION_OCCURRENCE', 'CONCEPT')

cdmTableCsvLoc <- system.file(file.path("csv", paste0("OMOP_CDMv", cdmVersion, "_Table_Level.csv")), package = "CommonDataModel", mustWork = TRUE)
cdmFieldCsvLoc <- system.file(file.path("csv", paste0("OMOP_CDMv", cdmVersion, "_Field_Level.csv")), package = "CommonDataModel", mustWork = TRUE)

tableSpecs <- read.csv(cdmTableCsvLoc, stringsAsFactors = FALSE)
cdmSpecs <- read.csv(cdmFieldCsvLoc, stringsAsFactors = FALSE)

mermaidDdlLines <- c()
mermaidFkLines <- c()
for (i in 1:nrow(tableSpecs)) {
  table <- tableSpecs[i,]
  tableName <- table$cdmTableName
  if (!(table$schema %in% cdmPart)) {
    next
  }
  if (!is.null(cdmTables) && !(table$cdmTableName %in% cdmTables)) {
    next
  }
  mermaidDdlLines <- c(mermaidDdlLines,
                       sprintf('  %s {', tableName))

  fields <- subset(cdmSpecs, cdmTableName == tableName)
  for (j in 1:nrow(fields)) {
    field <- fields[j,]
    cdmFieldName <- field$cdmFieldName
    cdmDataType <- field$cdmDatatype
    if (startsWith(cdmDataType, 'varchar')) {
      cdmDataType <- 'varchar'
    }
    if (cdmFieldName == '"offset"') {
      cdmFieldName <- 'offset'
    }
    mermaidDdlLines <- c(mermaidDdlLines,
                         sprintf('    %s %s', cdmFieldName, cdmDataType))

    if (field$isForeignKey == 'Yes') {
      fkTable <- subset(tableSpecs, cdmTableName == field$fkTableName)
      if (!(fkTable$schema %in% cdmPart)) {
        next
      }
      if (!is.null(cdmTables) && !(fkTable$cdmTableName %in% cdmTables)) {
        next
      }

      fkRelation <- sprintf('  %s ||--o{ %s : ""', tableName, field$fkTableName)
      if (fkRelation %in% mermaidFkLines) {
        next
      }
      mermaidFkLines <- c(mermaidFkLines,
                          fkRelation)
    }
  }
  mermaidDdlLines <- c(mermaidDdlLines, '  }')
}

mermaidString <- paste(c('erDiagram', mermaidDdlLines, mermaidFkLines), collapse = '\n')
fileName <- sprintf('OMOP_CDMv%s_ER_Diagram.mmd', cdmVersion)
write(mermaidString, file.path('extras', fileName))

