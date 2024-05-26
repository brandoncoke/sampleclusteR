\name{get.combined.table}
\alias{get.combined.table}
\title{Generate all possible comparisons across assigned groups}
\usage{
get.combined.table(gset)
}
\Arguments{
\item{gset}{GEO dataset object- use obtain.gset to obtain one}
}
\description{
Obtain study meta data from gset- GEO dataset- only requires a gset}
\examples{
gset= obtain.gset(GEO_id= "GSE108345", platform= "GPL570") #getting
get.combined.table(gset)
}
