\name{obtain.metadata}
\alias{obtain.metadata}
\title{Get sample metadata from a GEO dataset}
\usage{
obtain.metadata(GEOset)
}
\Arguments{
\item{GEOset}{GEO dataseries object- use obtain.gset}
}
\description{
Obtain the metadata from a GEO dataset used in automated.analysis when creating metadata csv output}

\examples{
gset= obtain.gset("GSE84881")
obtain.metadata(gset)
}
