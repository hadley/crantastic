source("curr.R")

submit_error <- function(api_key, error_message) {
  s <- Session("http://hoptoadapp.com",
               ##format="yaml",
               headers=c(
                 "Content-Type"="application/x-yaml",
                 Accept="text/xml, application/xml",
                 "X-Hoptoad-Client-Name"="hopR",
                 "X-Hoptoad-Client-Version"="0.0.1"))

  ## NOTE: couldn't get `as.yaml` to work exactly as needed, building the string
  ## manually instead.
  yaml <- paste("--- \nnotice:\n  api_key: ", api_key, "\n",
                "  error_message: ", error_message, "\n",
                "  backtrace: []\n\n  request: {}\n\n  session: {}\n\n",
                "  environment: {}\n\n", sep="")

  POST("/notices/", yaml, sess=s)
}
