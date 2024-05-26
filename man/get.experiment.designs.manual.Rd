\name{get.experiment.designs.manual}
\alias{get.experiment.designs}
\title{Obtain experiment design titles}
\usage{
get.experiment.designs(groups,assoc_cluster, words_only=F)
}
\Arguments{
\item{gsm_titles}{character- 0 is control 1 is treated X is excluded and outputted as 00XX11}
\item{words_only}{exlude numbers in sample names from clustering}
}

\description{
Used to automatically retrieve the names of the experiment sets for the output files produced from either automated.analysis or supervised.analysis.
words only removes any words from the output titles- this is useful when there are patient/sample ids which are useful when identifying clusters of samples}

\examples{
GEO_id= "GSE84881"
gset= obtain.gset(GEO_id)
gsm_titles= obtain.gsm.titles(gset)
title_clusters= title.clustering(gsm_titles)
groups= as.integer(lapply(gsm_titles, assign.group, title_clusters))
experiment_sets= set.exp.groups(groups)
get.experiment.designs(groups,title_clusters)
}
