\name{source.clustering}
\alias{source.clustering}
\title{Get sample metadata from a GEO dataset}
\usage{
source.clustering(GEOset)
}
\Arguments{
\item{GEOset}{geo dataserires object- use obtain.gset}

}
\description{
Creates a cluster list from the sources names from a GEO dataset.}
\examples{
gset= obtain.gset("GSE84881")
source.clustering(gset)
}
