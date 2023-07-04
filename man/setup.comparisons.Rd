\name{setup.comparisons}
\alias{setup.comparisons}
\title{Get sample metadata from a GEO dataset}
\usage{
setup.comparisons(exp_groups,GEOset)
}
\description{
Used in the automated analysis function. Requires GEO data set and experiment groups (created by set.exp.groups)}
\examples{
gset= obtain.gset("GSE84881")
gsm_titles= obtain.gsm.titles(gset)
title_clusters= title.clustering(gsm_titles)
groups= as.integer(lapply(gsm_titles, assign.group, title_clusters))
exp_groups= set.exp.groups(groups)
lapply(exp_groups, setup.comparisons , gset)
}
