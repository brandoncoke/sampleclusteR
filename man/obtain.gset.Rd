\name{obtain.gset}
\alias{obtain.gset}
\title{Get a GEO dataset}
\usage{
obtain.gset(GEO_id, platform)
}
\Arguments{
\item{GEO_id}{a character GEO id used like GSE84881}
\item{platform}{a character- the platform to be used as dataseries can have multiple platforms- none specified- uses the first one in the gset object}
}

\description{
Obtain a GEO data set using GEOquery. When a GEO data set has data from multiple platforms to outputs a list. platform argument resolves this- enables user to specify a valid GEO platform e.g. GPL570.}

\examples{
GPL570_list= GEOquery::getGEO('GPL570') #only required if you need a list of valid GSE codes.
gset= obtain.gset("GSE84881",platform= "GPL570")
}
