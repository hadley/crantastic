require(RSQLite, quiet=TRUE)

dbcon <- dbConnect(dbDriver("SQLite"), dbname = "/Users/hadley/Documents/crantastic/db/cranberries.sqlite")

repos <- dbGetQuery(dbcon, "select id, desc, url from repos where desc == 'cran'")

addPackageToDB <- function(reposid, pkgData) {
  sql <- paste(
      "INSERT INTO packages (repoid, package, version, priority, bundle, ", 
      "contains, depends, imports, suggests, date) ",
      "values (", reposid, ",", 
      gsub('"NA"', "NULL", 
        paste('"', paste(pkgData[-9], collapse='","'), '"',sep="")
      ), ',"', cranDate, '"', ');', sep=""
    )



  rs <- dbSendQuery(dbcon, sql)
  dbClearResult(rs)
  invisible(sql)
}

existing.packages <- function(rid) {
  ##  note that we sort by date as package versions do not sort reliably (1.9 comes out larger than 1.10)
  ##  nb another refinement is to sort by id rather than date as we can have two uploads per day, and we what the later one (cf lme4 on 2007-07-10)
  sql <- paste(
    "SELECT distinct p.package, m.version, m.date ",
    "FROM packages p, packages m ",
    "WHERE p.repoid = ", rid, " ",
    "AND m.package = p.package ",
    "AND m.id in (select max(id) from packages where package = p.package and repoid =", rid, ") ",
   "order by p.package", sep="")
  dbGetQuery(dbcon, sql)
}

