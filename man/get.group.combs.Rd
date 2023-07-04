\name{get.group.combs}
\alias{get.group.combs}
\title{Generate all possible comparisons across assigned groups}
\usage{
get.experiment.designs(groups,assoc_cluster)
}
\description{
Generates all possible comparisons across assigned groups.i.e. if you had an experiment set like 1 1 2 2 3 3 with the numbers representing distinct sample groups it would generate a list of comparisons like 1 v 2, 1 v 3 and 2 v 3. Used in set.exp.groups.R.}
\examples{
gset= obtain.gset("GSE84881")
gsm_titles= obtain.gsm.titles(gset)
title_clusters= title.clustering(gsm_titles)
groups= as.integer(lapply(gsm_titles, assign.group, title_clusters))
get.group.combs(groups)
}
