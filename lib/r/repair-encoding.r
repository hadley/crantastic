# This script repairs broken encodings in the base database.  These 
# flawed encodings are produced by non-utf changelogs and news files.
source("repair.r")

fix_table <- function(name) {

  fixup <- function(x) ifelse(is.na(x), NA, iconv(x, to = "UTF-8", sub = "?"))
  
  df <- dbReadTable(db, name)
  char <- sapply(df, is.character)
  df[char] <- lapply(df[char], fixup)
  
  a_ply(df, 1, update_row, table = name)
}

# fix_table("version")
# fix_table("author")
