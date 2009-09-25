## Early development version of an envisioned HTTP client for R
##
## Usage:
##
## sess <- Session("http://208.78.99.54:5984")
##
## > GET("/packages", sess)
##
## Which results in a GET request to http://208.78.99.54:5984/packages
##
## So basically sess is like a config store, which must be passed in to all the
## other functions.

library(RCurl)
library(rjson)
library(yaml)

Session <- function(base.url, timeout=5, format="", headers=NULL) {
  list(base.url=base.url, timeout=timeout, format=tolower(format), headers=headers)
}

DELETE <- function(path, sess) {
  curr("DELETE", path, sess)
}

GET <- function(path, sess) {
  curr("GET", path, sess)
}

POST <- function(path, content="", header="", sess) {
  if (!is.null(sess$headers)) header <- sess$headers
  curr("POST", path, sess, content, header)
}

PUT <- function(path, content="", header="", sess) {
  if (!is.null(sess$headers)) header <- sess$headers
  curr("PUT", path, sess, content, header)
}


## Utilities -- not exported

## TODO: XML
curr <- function(method, path, sess, content=NULL, header=NULL) {
  handle <- getCurlHandle()
  url <- paste(sess$base.url, path, sep="")

  ## Format conversion for outgoing data
  if (!is.null(content)) {
    if (sess$format == "json") {
      content <- toJSON(content)
    } else if (sess$format == "yaml") {
      content <- as.yaml(content)
    }
  }

  body <- if (method == "DELETE") {

    body <- getURL(url,
                   customrequest=method,
                   curl=handle)

  } else if (method == "PUT") {

    getURL(url,
           customrequest=method,
           postfields=content,
           postfieldsize=strlen(content),
           httpheader=header,
           curl=handle)

  } else if (method == "POST") {

    getURL(url,
           customrequest=method,
           postfields=content,
           postfieldsize=strlen(content),
           httpheader=header,
           curl=handle)

  } else {

    getURL(url, curl=handle)

  }

  ## Converts the returned data (not to yaml, though. I don't know of
  ## any services that actually return yaml data)
  if (sess$format == "json") {
    body <- fromJSON(body)
  }

  response(body, handle)
}

response <- function(body, handle) {
  info <- getCurlInfo(handle)
  list(body=body,
       content.type=info$content.type,
       status=info$response.code,
       redirect.count=info$redirect.count,
       url=info$effective.url)
}

strlen <- function(str) {
  length(strsplit(str, "")[[1]])
}

is.empty.str <- function(str) {
  str == ""
}
