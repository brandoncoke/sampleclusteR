\name{get.experiment.designs}
\alias{get.experiment.designs}
\title{Obtain experiment design titles}
\usage{
get.experiment.designs(groups_identified,assoc_cluster,
words_only= F)
}
\Arguments{
\item{groups}{numeric array- samples }
\item{assoc_cluster}{list containing associated clusters from clustering functions- like title.clustering}
}
\description{
Used to automatically retrieve the names of the experiment sets comparisons for the output files produced from either automated.analysis or supervised.analysis}

\examples{
gset= obtain.gset("GSE84881")
gsm_titles= obtain.gsm.titles(gset)
title_clusters= title.clustering(gsm_titles)
groups= as.integer(lapply(gsm_titles, assign.group, title_clusters))
get.experiment.designs(groups, title_clusters)
}
