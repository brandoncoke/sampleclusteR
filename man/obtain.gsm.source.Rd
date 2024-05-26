\name{obtain.gsm.source}
\alias{obtain.gsm.source}
\title{Get source names from GEO dataset}
\usage{
obtain.gsm.source(GEOset)
}
\Arguments{
\item{GEOset}{GEO dataseries object- use obtain.gset}
}
\description{
Obtain the sources of the cells used in the GEO dataset.}

\examples{
gset= obtain.gset("GSE84881")
obtain.gsm.source(gset)
}
