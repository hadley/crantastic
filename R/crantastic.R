crantasticToken <- as.vector(Sys.getenv("CRANTASTIC_TOKEN"))
baseUrl <- "crantastic.org"

## Tag a package on crantastic. Tags should be a comma-separated string
## consisting of tag names (no spaces are allowed).
`crantastic.tag` <- function(package, tags)
{
  postData(baseUrl,
           paste("/packages/", package, "/taggings", sep=""),
           paste(getToken(), "&tag_name=", tags, sep=""))
}

## Submits all installed packages to http://crantastic.org/ (marks them as being used by you).
`crantastic.submitInstalledPackages` <- function(){
  ## Excludes packages from base
  packages <- paste(installed.packages(priority=c("NA", "recommended"))[, c(1)], collapse=",")

  postData(baseUrl, "/votes",
           paste(getToken(), "&packages=", packages, sep=""))
}

###############
## Utilities ##
###############

## Sends data to a remote server via HTTP POST.
`postData` <- function(host, path="/", data, port=80)
{
  header <- paste(c(paste("POST", path, "HTTP/1.1"),
                    paste("Host:", host),
                    "Content-type: application/x-www-form-urlencoded",
                    "Accept: application/xml",
                    paste("Content-length:", length(strsplit(data, "")[[1]])),
                    "Connection: Keep-Alive"),
                  collapse="\r\n")

  datatosend <- paste(header, "\r\n\r\n", data, sep="")

  fp <- make.socket(host=host, port=port, server=FALSE)
  write.socket(fp, datatosend)

  output <- character(0)
  repeat {
    ss <- read.socket(fp,loop=FALSE)
    output <- paste(output,ss,sep="")
    if (regexpr("\r\n0\r\n\r\n",ss)>-1) break();
    if (ss == "") break();
  }
  close.socket(fp)
  print(output)

  ## Returns TRUE or FALSE, depending on the returned HTTP Status Code.
  return(grepl("200 OK|201 Created", output))
}

`getToken` <- function()
{
  if (crantasticToken == "") {
    print("Please define your crantastic token by setting the CRANTATSIC_TOKEN environment variable.")
    return(FALSE)
  } else {
    return(paste("user_credentials=", crantasticToken, sep=""))
  }
}
