\name{crantastic.tag}
\alias{crantastic.tag}
\title{Tag a package on crantastic}
\description{
  Tag a package on crantastic right from your R console. Consult
  \url{http://crantastic.org/tags} for a list of existing tags.
}
\usage{
crantastic.tag(package, tags)
}
\arguments{
  \item{package}{a string containing the name of the package you wish to
    tag.}
  \item{tags}{a comma-separated string consisting of tag names (no
    spaces are allowed in the tag names).}
}
\examples{
## tag ggplot2 with the graphics tag
crantastic.tag("ggplot2", "graphics")

## tag languageR with the nlp, linguistics, and language tags
crantastic.tag("languageR", "nlp, linguistics, language")
}
