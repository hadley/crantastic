library(digest)

is.generic <- function(x) inherits(x, "standardGeneric")

function_hashes <- function(pkg) {
  env <- paste("package", pkg, sep = ":")

  library(pkg, character.only = TRUE)
  obj_names <- ls(env)
  if (length(obj_names) == 0) return(character())

  objs <- lapply(obj_names, get, env)
  names(objs) <- obj_names
  fs <- Filter(function(x) is.function(x) & !is.generic(x), objs)

  method_names <- obj_names[sapply(objs, is.generic)]

  names(method_names) <- method_names
  ms <- do.call("c", lapply(method_names, findMethods, where = env))

  mfs <- c(fs, ms)

  ## Creating a new vector with only unique key names, as JSON data can't have
  ## multiple entries of the same key. The only package I've encountered which
  ## produces duplicated keys is 'spam'.
  unique_mfs <-  mfs[!duplicated(names(mfs))]
  ## I'm not really sure if this is the best way to solve this problem, but it
  ## does work. We do lose some info since we only store one digest for the keys
  ## that are duplicate. I think it's bad package design, though, to have
  ## multiple functions with the same name.

  sapply(unique_mfs, digest)
}

data_hashes <- function(pkg) {
  env <- paste("package", pkg, sep = ":")

  data_sets <- data(package = pkg)$results[, 3]

  ## If alias different from, name extract name
  aliased <- grepl("\\(.*\\)", data_sets)
  if (any(aliased)) {
    data_sets[aliased] <- gsub("^.*\\((.*)\\)$", "\\1", data_sets[aliased])
    data_sets <- unique(data_sets)
  }

  data(list = data_sets, package = pkg)
  data <- lapply(data_sets, failwith(NULL, get))
  names(data) <- data_sets

  sapply(compact(data), digest)
}



vignette_hashes <- function(pkg) {
  vignettes <- vignette(package=pkg)$results[, 3]
  paths <- sapply(vignettes, function(v) vignette(v, package = pkg)$file)

  sapply(paths, digest, file = TRUE)
}


try_default <- function(expr, default, quiet = FALSE) {
  result <- default
  if (quiet) {
    tryCatch(result <- expr, error = function(e) {})
  } else {
    try(result <- expr)
  }
  result
}
failwith <- function(default = NULL, f, quiet = FALSE) {
  f <- match.fun(f)
  function(...) try_default(f(...), default, quiet = quiet)
}
compact <- function(l) Filter(Negate(is.null), l)
