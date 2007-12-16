source("db.r")
source("package-info.r")

## compare AP to EP and update db if necessary
update.packages <- function(AP, EP, repos) {
  for (j in 1:nrow(AP))
    update.package(AP[j, ], EP, repos)
}

update.package <- function(new, existing, repos) {  
  if (new$package %in% existing$package) {
    # Look up in list of known packages
    cur <- existing[cur$package == existing$package, ]
    
    if (cur$version != new$version)  {
      cat("Updated package", cur$package, " (", cur$version, " -> ", pkg$version," )\n")

      addPackageToDB(repos$id, AP[j, ])
    } else {
      if (verbose) cat(curPkg, "with version", curVer, "already in db\n")      
    }
    
  } else {
    cat("New package: ", curPkg, " (", curVer, ")\n")
    addPackageToDB(repos$id, AP[j, ])
  }
}

update <- function(dbcon) {
  for (i in 1:nrow(repos)) {
    r <- repos[i, ]

    EP <- existing.packages(dbcon, r$id)
    AP <- available.packages(contrib.url(r$url))
    update.packages(AP, EP, r)
  }
}
