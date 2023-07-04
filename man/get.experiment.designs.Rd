\name{get.experiment.designs}
\alias{get.experiment.designs}
\title{Obtain experiment design titles}
\usage{
get.experiment.designs(groups,assoc_cluster)
}
\description{
Used to automatically retrieve the names of the experiment sets for the output files produced from either automated.analysis or supervised.analysis}

\examples{
GEO_id= "GSE84881"
gset= obtain.gset(GEO_id)
gsm_titles= obtain.gsm.titles(gset)
title_clusters= title.clustering(gsm_titles)
experiment_sets= set.exp.groups(groups)
get.experiment.designs(groups,title_clusters)
}
