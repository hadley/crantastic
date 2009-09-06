#!/usr/bin/env Rscript

source("couchdb.R")
source("function-hashes.R")

PkgVersion <- function(pkg) installed.packages()[,3][pkg][[1]]

## From my OSX install of R 2.9.1:
## [1] "/Library/Frameworks/R.framework/Resources/bin/exec/i386/R"
## [2] "--slave"
## [3] "--no-restore"
## [4] "--file=./crantastic-store-functions.R"
## [5] "--args"
##
## (pkg name and pkg differs if we're dealing with pkg bundles)
## So, we want the sixth (pkg name), seventh (pkg), and eight (id) elements:
name <- commandArgs()[6]
pkg <- commandArgs()[7]
id <- commandArgs()[8]

key <- paste(pkg, "_", PkgVersion(pkg), sep="")
value <- list(package=name,
              version_id=id,
              function_hashes=function_hashes(pkg),
              data_hashes=data_hashes(pkg),
              vignette_hashes=vignette_hashes(pkg))

db <- Database("http://208.78.99.54:5984/", "packages")

result <- Insert(key, value, db)

if (result$status == 201) {
  system("exit 0")
} else {
  system("exit 1")
}
