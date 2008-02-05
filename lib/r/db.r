suppressMessages(require(RSQLite, quiet=TRUE))

if (exists("db")) dbDisconnect(db)
db <- dbConnect(dbDriver("SQLite"), dbname = "/Users/hadley/Documents/crantastic/db/development.sqlite3")

add_version_to_db <- function(pkg) {
  package.download(pkg)
  pkg <- package.data(pkg)
  insert_version(pkg)
}

insert_version <- function(pkg) {
  pkg$package_id <- package_id(pkg)
  pkg$created_at <- date()
  res <- dbSendPreparedQuery(db, insert_sql("version", pkg), bind.data = as.data.frame(pkg))
  dbClearResult(res) 
}

package_id <- function(pkg) {
  get_id <- function() dbGetQuery(db, paste("SELECT id FROM package WHERE name = ", shQuote(pkg$name), sep=""))$id
  
  id <- get_id()
  if (length(id) > 0) return(id)
  
  update <- data.frame(
    name = pkg$name,
    created_at = date()
  )
  
  res <- dbSendPreparedQuery(db, insert_sql("package", update), bind.data = as.data.frame(update))
  dbClearResult(res)
  
  get_id()
}

insert_sql <- function(table, values) {
  paste(
    "INSERT INTO ", table, 
    "(", paste(names(values), collapse=", "), ") ",
    "VALUES (", paste(rep("?", length(values)), collapse=", "), ");",
    sep=""
  )
}

load.packages <- function() {
  ##  note that we sort by date as package versions do not sort reliably (1.9 comes out larger than 1.10)
  ##  nb another refinement is to sort by id rather than date as we can have two uploads per day, and we what the later one (cf lme4 on 2007-07-10)
  sql <- paste(
    "SELECT * ",
    "FROM version ",
    "WHERE id in (select max(id) from version v where v.package_id = version.package_id) ",
    "ORDER BY name", sep="")
  dbGetQuery(db, sql)
}

