\name{obtain.gsm.titles}
\alias{obtain.gsm.titles}
\title{Get sample titles from a GEO dataset}
\Arguments{
\item{GEOset}{GEO dataseries object- use obtain.gset}
}

\usage{
obtain.gsm.titles(GEOset)
}
\description{
Obtain the sample titles used in a GEO dataset.}

\examples{
gset= obtain.gset("GSE84881")
obtain.gsm.titles(gset)
}
