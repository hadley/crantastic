library(digest)

reshape74 <- list(name = "reshape", version = "0.7.4")
reshape73 <- list(name = "reshape", version = "0.7.3")
sqlite <- list(name = "RSQLite", version = "0.6-3")
mpcmod <- list(name = "MCPMod", version = "0.1-4")

localMirror <- "~/cran"
local.file <- function(pkg) {
  paste(local.dir(pkg),".tar.gz", sep="")
}

local.dir <- function(pkg, extracted = FALSE) {
  path <- file.path(localMirror, paste(pkg$name, "_", pkg$version, sep=""))
  if (extracted) file.path(path, pkg$name) else path
}


# http://rh-mirror.linux.iastate.edu/CRAN/src
# http://rh-mirror.linux.iastate.edu/CRAN/src/contrib/A
package.download <- function(pkg) {
  path <- local.file(pkg)
  if (file.exists(path) && file.info(path)$size > 0) return(TRUE)

  if (is.null(attr(pkg, "archive"))) {
    cranpath <- file.path(
      "http://cran.r-project.org",  "src/contrib", 
      paste(pkg$name, "_", pkg$version, ".tar.gz", sep = "")
    )
  } else {
    cranpath <- file.path(
      "http://cran.r-project.org",  "src/contrib/Archive", 
      toupper(substr(pkg$name,1,1)), 
      paste(pkg$name, "_", pkg$version, ".tar.gz", sep = "")
    )
  }
  
  status <- download.file(cranpath, path, quiet = TRUE) == 0
  if (!status) unlink(path)
  status
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
  fields <- c("title", "license", "description", "author", "maintainer",  "date", "url", "depends", "suggests")
  
  desc <- packageDescription(pkg$name, local.dir(pkg))
  desc <- unclass(desc)
  names(desc) <- tolower(names(desc))
  attr(desc, "file") <- NULL
  
  desc$date <- as.character(strptime(desc$date, "%Y-%m-%d"))
  
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
  extract(new)
  pkg <- c(
    new,
    details(new),
    special.files(new)#,
    # diff = diff.versions(new, old)
  )
  
  pkg <- lapply(pkg, iconv, sub = "?")
  cleanup(new)
  
  pkg
}