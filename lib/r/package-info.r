library(digest)

reshape74 <- list(package = "reshape", version = "0.7.4")
reshape73 <- list(package = "reshape", version = "0.7.3")
sqlite <- list(package = "RSQLite", version = "0.6-3")

localMirror <- "~/cran"
local.file <- function(pkg) {
  paste(local.dir(pkg),".tar.gz", sep="")
}

local.dir <- function(pkg, extracted = FALSE) {
  path <- file.path(localMirror, paste(pkg$package, "_", pkg$version, sep=""))
  if (extracted) file.path(path, pkg$package) else path
}


# http://rh-mirror.linux.iastate.edu/CRAN/src/contrib
package.download <- function(pkg) {
  path <- local.file(pkg)
  if (file.exists(path)) return(TRUE)

  cranpath <- file.path(
    options()$repos,  "src/contrib/Archive", 
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

tryNULL <- function (expr, default = NULL) {
  result <- default
  tryCatch(result <- expr, error = function(e) {})
  result
}
compact <- function(x) x[!sapply(x, is.null)]

# http://cran.r-project.org/doc/manuals/R-exts.html#Package-structure
special.files <- function(pkg) {
  extract(pkg)
  files <- c("README", "NEWS", "CHANGELOG")
  
  paths <- file.path(local.dir(pkg, TRUE), files)
  paths2 <- file.path(local.dir(pkg, TRUE), "inst", files)
  names(paths) <- tolower(files)
  
  suppressWarnings(
    compact(lapply(paths, function(path) tryNULL(paste(readLines(path), collapse="\n"))))
  )
}

# http://cran.r-project.org/doc/manuals/R-exts.html#The-DESCRIPTION-file
details <- function(pkg) {
  fields <- c("title", "license", "description", "author", "maintainer",  "date", "url")
  
  desc <- packageDescription(pkg$package, local.dir(reshape73))
  desc <- unclass(desc)
  names(desc) <- tolower(names(desc))
  attr(desc, "file") <- NULL
  
  desc[intersect(fields, names(desc))]
}

diff.versions <- function(new, old = NULL) {
  if (is.null(old)) return("")
  extract(old)
  extract(new)
  system(paste(
    "../python/diff_path.py", local.dir(old, TRUE), local.dir(new, TRUE)
  ), intern = TRUE)
}

package.data <- function(new, old = NULL) {
  c(
    details(pkg),
    special.files(pkg),
    diff = diff.versions(new, old)
  )
}