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

  sapply(c(fs, ms), digest)
}

data_hashes <- function(pkg) {
  env <- paste("package", pkg, sep = ":")

  data_sets <- data(package = pkg)$results[, 3]
  data(list = data_sets, package = pkg)

  data <- lapply(data_sets, get)
  names(data) <- data_sets

  sapply(data, digest)
}

vignette_hashes <- function(pkg) {
  vignettes <- vignette(package=pkg)$results[, 3]
  paths <- sapply(vignettes, function(v) vignette(v, package = pkg)$file)

  sapply(paths, digest, file = TRUE)
}
