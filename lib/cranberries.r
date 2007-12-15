#!/usr/bin/env r

suppressMessages(library(RSQLite))

verbose <- FALSE
commit <- TRUE

cranDate <- Sys.Date()
cranArchive <- "http://cran.r-project.org/src/contrib/Archive/"
localMirror <- "~/pkg-bioc/cran/sources"
blogInputDir <- "~/cranberries/bloginput/cran"

dbcon <- dbConnect(dbDriver("SQLite"), dbname = "/home/edd/cranberries/cranberries.sqlite")

addPackagToDB <- function(reposid, pkgData) {
  sql <- paste("insert into packages (repoid, package, version, priority, bundle, ", "contains, depends, imports, suggests, date) ",
               "values (", reposid, ",", gsub('"NA"', "NULL", paste('"', paste(pkgData[-9], collapse='","'), '"', sep="")), ',"', cranDate, '"', ');', sep="")
  if (commit) {
    rs <- dbSendQuery(dbcon, sql)
    dbClearResult(rs)
  }
  invisible(sql)
}

callDiffstat <- function(pkg, oldv, newv, oldd) {
  oldtar <- file.path(localMirror, paste(pkg, "_", oldv, ".tar.gz", sep=""))
  if (!file.exists(oldtar)) {
    archivefile <- file.path(cranArchive, toupper(substr(pkg,1,1)), paste(pkg, "_", oldv, ".tar.gz", sep=""))
    download.file(archivefile, oldtar, quiet=TRUE)
  }
  newtar <- file.path(localMirror, paste(pkg, "_", newv, ".tar.gz", sep=""))
  tempdir <- tempfile("cranberry")
  oldtmp <- file.path(tempdir, paste(pkg, oldv, sep="-"))
  newtmp <- file.path(tempdir, paste(pkg, newv, sep="-"))
  cmd <- paste("mkdir ", tempdir, oldtmp, newtmp, "; ",
               "tar -C ", oldtmp, " -x -z -f ", oldtar, "; ",
               "tar -C ", newtmp, " -x -z -f ", newtar, "; ",
               "diff -r ", oldtmp, " ", newtmp, " | diffstat; ",
               "rm -rf ", tempdir)
  if (verbose) cat(cmd, "\n")
  con <- pipe(cmd)
  diffstat <- readLines(con)
  close(con)
  invisible(diffstat)
}

closeBlogPost <- function(con, urlbase, pkg) {
  cat("\n</pre>\n", file=con)
  urlLine <- paste("<a href=\"", file.path(urlbase, "Descriptions", paste(pkg, ".html", sep="")),
                   "\">More information about ", pkg, " at CRAN</a>\n", sep="")
  cat(urlLine, "\n", file=con)
  close(con)
}
  
writeUpdatedBlogEntry <- function(curPkg, curVer, prvVer, prvDate, reposurl) {
  diffstat <- callDiffstat(curPkg, prvVer, curVer, prvDate)        	# compute the diffstat output
  blogpost <- file.path(blogInputDir, "updated", paste(curPkg, "_", curVer, ".txt", sep=""))
  con <- file(blogpost, "wt")  						# and write summary to the blogpost file
  cat("Package", curPkg, " updated to version", curVer, " with previous version", prvVer, "dated", prvDate,"\n\n", file=con)
  cat("Diff between", curPkg, "versions",  prvVer, "dated", prvDate, "and", curVer, "dated", format(cranDate), "\n", file=con)
  cat("<pre>\n", file=con)
  cat(paste(diffstat, collapse="\n"), file=con)
  closeBlogPost(con, contrib.url(reposurl), curPkg)
  invisible(NULL)
}

writeNewBlogEntry <- function(curPkg, curVer, reposurl) {
  ## and compute some sort of output for new package -- maybe get description ? NB does NOT work for BioC
  blogpost <- file.path(blogInputDir, "new", paste(curPkg, "_", curVer, ".txt", sep=""))
  con <- file(blogpost, "wt")
  cat("New package", curPkg, "with initial version", curVer,"\n\n", file=con)
  newpkgtxt <- file.path(contrib.url(reposurl), "Descriptions", paste(curPkg, "DESCRIPTION", sep="."))
  cat("<pre>", file=con)
  cat(paste("\n", paste(readLines(newpkgtxt), collapse="\n"), "\n", sep=""), file=con)
  closeBlogPost(con, contrib.url(reposurl), curPkg)
}
  
## compare AP to EP and update db + blog where needed
examinePackages <- function(dbcon, AP, EP, repos) {
  for (j in 1:nrow(AP)) {               			# for all packages

    curPkg <- AP[j,"Package"]
    curVer <- AP[j,"Version"]

    if (curPkg %in% EP[,"package"]) {				# is the current package in the data.frame of exisiting package/date/version tupels?
      ind <- which(curPkg == EP[,"package"])
      if ( curVer != EP[ ind, "version"] )  { 			# but do we not yet have the current version ?  (NB has the most recent version, see getExistingPackages)
        prvDate <- EP[ind, "date"]
        prvVer <- EP[ind, "version"]
        cat("Package", curPkg, "version", curVer, "updates version", prvVer, "dated", prvDate,"\n")
        sql <- addPackagToDB(repos["id"], AP[j, ])
        ## get the new package
        if (!file.exists( file.path(localMirror, paste(curPkg, "_", curVer, ".tar.gz", sep=""))))  {
          download.packages(pkgs=curPkg, destdir=localMirror, available=AP, repos=repos["url"], type="source")
        }
        if (commit) {
          writeUpdatedBlogEntry(curPkg, curVer, prvVer, prvDate, repos["url"])
        }
      } else {
        if (verbose) cat(AP[j,"Package"], "with version", AP[j,"Version"], "already in db\n")      
      }
    } else {							# it's a new package
      cat("Package", curPkg, "version", curVer, "is new\n")
      sql <- addPackagToDB(repos["id"], AP[j, ])
      if (commit) {
        writeNewBlogEntry(curPkg, curVer, repos["url"]) 
      }
    }
  }
}
  
getExistingPackages <- function(dbcon, rid) {
  ##  note that we sort by date as package versions do not sort reliably (1.9 comes out larger than 1.10)
  ##  nb another refinement is to sort by id rather than date as we can have two uploads per day, and we what the later one (cf lme4 on 2007-07-10)
  sql <- paste("select distinct p.package, m.version, m.date ",
               "from packages p, packages m ",
               "where p.repoid=", rid, " ",
               "and m.package=p.package ",
               "and m.id in (select max(id) from packages where package=p.package and repoid=",rid,") ",
               "order by p.package", sep="");
  pkgs <- dbGetQuery(dbcon, sql)
  invisible(pkgs)
}

## convenience function to set records to the dates shown in directory listing
## should only be run once right after the sqlite db has been set up
setOriginalDates <- function(dbcon) {
  ## get original date
  ## links -dump http://cran.r-project.org/src/contrib/ | awk '/tar.gz/ {print $3, $4}'  
  OD <- read.table(pipe("links -dump http://cran.r-project.org/src/contrib/ | awk '/tar.gz/ {print $3, $4}'"), header=FALSE, col.names=c("file", "date"))

  OD$pkg <- sapply(as.character(OD[,"file"]), function(x) strsplit(x, "_")[[1]][1])
  OD$ver <- gsub(".tar.gz", "", sapply(as.character(OD[,"file"]), function(x) strsplit(x, "_")[[1]][2]))

  OD$parsedDate <- as.Date(as.character(OD$date), "%d-%b-%Y" )
  for (i in 1:nrow(OD)) {
    currow <- OD[i,] 
    sql <- paste("update packages set date='", currow$parsedDate, "' where package='", currow$pkg, "' and version='", currow$ver, "';", sep="")
    rs <- dbSendQuery(dbcon, sql)
    dbClearResult(rs)
  }
  invisible(NULL)
}

## remove cache of available packages -- needed as littler uses /tmp for tempdir()
clearCache <- function(repo) {
  remotecf <- file.path(tempdir(), paste("repos_", URLencode(repo, TRUE), ".rds", sep=""))
  if (file.exists(remotecf)) {
    if (verbose) cat("Removing remote cache file", remotecf, "\n")
    unlink(remotecf)
  }
}

lastModifiedAt <- function() {
  suppressMessages(library(RCurl))
  h <- basicTextGatherer()
  junk <- getURI("http://cran.r-project.org/src/contrib/PACKAGES.html", writeheader=h$update, header=TRUE, nobody=TRUE)
  h <- h$value()
  webpageT <- strptime(substr(strsplit(h, "\r\n")[[1]][4], 21, 45), "%d %b %Y %H:%M:%S")
  ## now get time from DB, compare, and return true if there is work to be done
}

## main worker function
dailyUpdate <- function(dbcon) {
  repos <- dbGetQuery(dbcon, "select max(id) as id, desc, url from repos where desc!='omegahat' group by desc")
  for (i in 1:nrow(repos)) {
    clearCache(contrib.url(repos[i,"url"]))			# clear cache (as littler uses /tmp)
    EP <- getExistingPackages(dbcon, repos[i,"id"]) 		# existing packages and version from db
    AP <- available.packages(contrib.url(repos[i,"url"]))	# available package at CRAN
    examinePackages(dbcon, AP, EP, repos[i,])
  }
  if (commit) {   # the silly passwd is needed for static page generation, blosxom has a default of dynamic/cgi mode
    #system("cd ~/cranberries && perl ./blosxom -f `pwd`/blosxom.conf -password='notVerySecretAtAll' -all=1")
    system("cd /home/edd/cranberries && sleep 2 && perl ./blosxom -f `pwd`/blosxom.conf -password='notVerySecretAtAll'")
  }
}

dailyUpdate(dbcon)						# main workhorse function
