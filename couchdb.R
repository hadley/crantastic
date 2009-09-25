## Usage:
## db <- Database("http://208.78.99.54:5984/", "packages")
##
## Insert(key, value, db)
##
## Note that values are automatically converted to JSON.

source("curr.R")

# The DB is created if it doesnt exist
Database <- function(url, db.name) {
  db <- list(sess=Session(url, format="json",
               headers="Content-Type: application/json"),
             database=db.name)
  if (!ExistsDb(db)) { CreateDb(db) }
  return(db)
}

CreateDb <- function(db) {
  PUT(db$database, sess=db$sess)$status == 201
}

DropDb <- function(db) {
  DELETE(db$database, db$sess)$status == 200
}

ExistsDb <- function(db) {
  GET(db$database, db$sess)$status == 200
}

Insert <- function(key, value, db, timestamp=TRUE) {
  if (timestamp) value$created_at <- Timestamp()
  PUT(paste(db$database, "/", key, sep=""), value, sess=db$sess)
}

Delete <- function(key, db) {
  rev <- LastRev(key, db)
  DELETE(paste(db$database, "/", key, "?rev=", rev, sep=""),
             sess=db$sess)$status == 200
}

GetKey <- function(key, db) {
  GET(paste(db$database, "/", key, sep=""), db$sess)
}

LastRev <- function(key, db) {
  GetKey(key, db)$body$`_rev`
}

## Utilities

## timestamp
Timestamp <- function() {
  format(as.POSIXlt(Sys.time(), "UTC"), "%Y/%m/%d %H:%M:%S +0000")
}
