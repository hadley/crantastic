library(digest)

reshape74 <- list(package = "reshape", version = "0.7.4")
reshape73 <- list(package = "reshape", version = "0.7.3")

localMirror <- "~/cran"
local.file <- function(pkg) {
  paste(local.dir(pkg),".tar.gz", sep="")
}

local.dir <- function(pkg, extracted = FALSE) {
  path <- file.path(localMirror, paste(pkg$package, "_", pkg$version, sep=""))
  if (extracted) file.path(path, pkg$package) else path
}

cranArchive <- "http://cran.r-project.org/src/contrib/Archive/"
package.download <- function(pkg) {
  path <- local.file(pkg)
  if (file.exists(path)) return(TRUE)

  cranpath <- file.path(
    options()$repos,  "src/contrib/Archive/", 
    toupper(substr(pkg$package,1,1)), 
    paste(pkg$package, "_", pkg$version, ".tar.gz", sep = "")
  )
  download.file(cranpath, path, quiet = TRUE) == 0
}

extract <- function(pkg) {
  path <- local.file(pkg)
  tempdir <- local.dir(pkg)
  if (file.exists(tempdir)) return(TRUE)
  
  cmd <- paste(
    "mkdir ", tempdir, "; ",
    "tar -C ", tempdir, " -xzf ", path, "; ", sep=""
  )
  system(cmd) == 0
}

cleanup <- function(pkg) {
  system(paste("rm -rf", local.dir(pkg))) == 0
}

diff <- function(old, new) {
  extract(old)
  extract(new)
  
}

tryNA <- function (expr, default = NA) {
  result <- default
  tryCatch(result <- expr, error = function(e) {})
  result
}


# http://cran.r-project.org/doc/manuals/R-exts.html#Package-structure
special.files <- function(pkg) {
  extract(pkg)
  files <- c("README", "NEWS", "CHANGELOG")
  
  paths <- file.path(local.dir(pkg, TRUE), files)
  paths2 <- file.path(local.dir(pkg, TRUE), "inst", files)
  names(paths) <- tolower(files)
  
  suppressWarnings(
    lapply(paths, function(path) tryNA(paste(readLines(path), collapse="\n")))
  )
}

# http://cran.r-project.org/doc/manuals/R-exts.html#The-DESCRIPTION-file
details <- function(pkg) {
  fields <- c("Title", "License", "Description", "Author", "Maintainer", "Date", "URL")
  
  desc <- packageDescription(pkg$package, local.dir(reshape73))
  desc <- unclass(desc)
  names(desc) <- tolower(names(desc))
  attr(desc, "file") <- NULL
  
  desc[fields]
}

callDiffstat <- function(pkg, oldv, newv, oldd) {
  oldtar <- file.path(localMirror, paste(pkg, "_", oldv, ".tar.gz", sep=""))

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
