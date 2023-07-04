\name{get.cluster.titles}
\alias{get.cluster.titles}
\title{Obtaining the names of the samples within a cluster.}
\usage{
get.cluster.titles(cluster_frame)
}
\description{
Function used in get.experiment.designs to obtain the names of the clusters}

\examples{
gset= obtain.gset("GSE84881")
gsm_titles= obtain.gsm.titles(gset)
title_clusters= title.clustering(gsm_titles)
get.cluster.titles(get.clusters.as.frame(title_clusters))
}
