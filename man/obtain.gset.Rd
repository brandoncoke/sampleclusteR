\name{obtain.gset}
\alias{obtain.gset}
\title{Get a GEO dataset}
\usage{
obtain.gset(GEO_id, platform)
}
\description{
Obtain a GEO data set using GEOquery. When a GEO data set has data from multiple platforms to outputs a list. platform argument resolves this- enables user to specify a valid GEO platform e.g. GPL570.}

\examples{
GPL570_list= GEOquery::getGEO('GPL570') #only required if you need a list of valid GSE codes.
gset= obtain.gset("GSE84881",platform= "GPL570")
}
