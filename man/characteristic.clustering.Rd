\name{characteristic.clustering}
\alias{characteristic.clustering}
\title{Cluster based on the characteristics present in the GEO dataset}
\usage{
characteristic.clustering(gsm_characteristics)
}
\Arguments{
\item{gsm_characteristics}{GEO dataseries object obtained using obtain.gset}
}
\description{
Enables user to cluster based on the characteristics of samples- not recommended as many studies use duplicate values i.e. no distinct clusters will be identifed as many studies use the same characteristic across samples.
Used in the combined clustering function.
}
\examples{
gset= obtain.gset("GSE84881")
characteristics= obtain.charateristics(gset)
characteristic.clustering()
}
