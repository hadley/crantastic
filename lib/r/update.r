source("db.r")
source("package-info.r")

options(warn = 1)

## compare AP to EP and update db if necessary
update.packages <- function() {
  known_versions <- load.packages()
  latest <- latest.versions()
  invisible(lapply(latest, function(pkg) {
    try(update.package(pkg, known_versions))
  }))
}

update.package <- function(new, known) {  
  if (new$name %in% known$name) {
    # Look up in list of known packages
    cur <- known[new$name == known$name, ]
    browser()
    
    if (cur$version != new$version)  {
      cat("Updated package: ", cur$name, " (", cur$version, " -> ", new$version,")\n", sep="")
      add_version_to_db(new)
    } else {
      # cat("Existing package: ", cur$name, " (", cur$version, ")\n", sep="")      
    }
    
  } else {
    cat("New package: ", new$name, " (", new$version, ")\n", sep="")      
    add_version_to_db(new)
  }
}

latest.versions <- function() {
  pkgs <- available.packages(contrib.url("http://cran.r-project.org", type="source"))
  rownames(pkgs) <- NULL
  pkgs <- as.data.frame(pkgs, stringsAsFactors = FALSE)
  names(pkgs) <- tolower(names(pkgs))
  names(pkgs)[1] <- "name"

  apply(pkgs[, c("name", "version")], 1, as.list)
}