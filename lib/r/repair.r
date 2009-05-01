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
