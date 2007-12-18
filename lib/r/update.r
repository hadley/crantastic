source("db.r")
source("package-info.r")

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
    
    if (cur$version != new$version)  {
      browser()
      cat("Updated package", cur$package, " (", cur$version, " -> ", pkg$version," )\n", sep="")
      add_version_to_db(pkg)
    } else {
      cat("Existing package: ", cur$name, " (", cur$version, ")\n", sep="")      
    }
    
  } else {
    cat("New package: ", new$name, " (", new$version, ")\n", sep="")
    add_version_to_db(new)
  }
}

latest.versions <- function() {
  pkgs <- available.packages()
  rownames(pkgs) <- NULL
  pkgs <- as.data.frame(pkgs, stringsAsFactors = FALSE)
  names(pkgs) <- tolower(names(pkgs))
  names(pkgs)[1] <- "name"

  apply(pkgs[, c("name", "version")], 1, as.list)
}