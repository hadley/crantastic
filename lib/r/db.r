require(RSQLite, quiet=TRUE)

dbcon <- dbConnect(dbDriver("SQLite"), dbname = "/Users/hadley/Documents/crantastic/db/cranberries.sqlite")

insert_version <- function(pkg) {
  pkg$package_id <- packages[packages$name == pkg$name, "id"]
  sqliteWriteTable(dbcon, "version", pkg, row.names = FALSE)
}
insert_package <- function(pkg) {
  sqliteWriteTable(dbcon, "package", pkg[,c("name")], row.names = FALSE)
  packages <<- load.packages()
}


load.packages <- function() {
  ##  note that we sort by date as package versions do not sort reliably (1.9 comes out larger than 1.10)
  ##  nb another refinement is to sort by id rather than date as we can have two uploads per day, and we what the later one (cf lme4 on 2007-07-10)
  sql <- paste(
    "SELECT distinct p.package, m.version, m.date ",
    "FROM packages p, packages m ",
    "AND m.package = p.package ",
    "AND m.id in (select max(id) from packages where package = p.package and repoid =", rid, ") ",
   "order by p.package", sep="")
  dbGetQuery(dbcon, sql)
}

