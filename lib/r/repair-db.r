# This script repairs broken encodings in the base database.  These 
# flawed encodings are produced by non-utf changelogs and news files.
library(plyr)
source("db.r")

update_sql <- function(table, values) {
  id <- values$id
  changes <- paste(names(values[, -1]), "= ?", collapse = ", ")
  
  paste(
    "UPDATE ", table, "\n", 
    "SET ", changes, "\n", 
    "WHERE id = ", id, ";",
    sep=""
  )
}

update_row <- function(table, values) {
  message("Updating row: ", values$id)
  values <- as.data.frame(values)
  res <- dbSendPreparedQuery(db, update_sql(table, values), 
    bind.data = values[, -1])
  dbClearResult(res) 
}


insert_version <- function(pkg) {
  pkg$package_id <- package_id(pkg)
  pkg$created_at <- date()
}

fix_table <- function(name) {

  fixup <- function(x) ifelse(is.na(x), NA, iconv(x, sub = "?"))
  
  df <- dbReadTable(db, name)
  char <- sapply(df, is.character)
  df[char] <- lapply(df[char], fixup)
  
  a_ply(df, 1, update_row, table = name)
}

# to text: description, license, depends, suggests, author