\name{set.exp.groups}
\alias{set.exp.groups}
\title{Get sample metadata from a GEO dataset}
\usage{
set.exp.groups(GEOset)
}
\Arguments{
\item{gsm_titles}{character- 0 is control 1 is treated X is excluded and outputted as 00XX11}
\item{words_only}{exlude numbers in sample names from clustering}
}
\description{
Converts cluster frames into experiment sets used when analysing comparing the sample clusters to one another. 0 is control and 1 is treated X is excluded from the pairwise comparison.}
\examples{
gset= obtain.gset("GSE84881")
gsm_titles= obtain.gsm.titles(gset)
title_clusters= title.clustering(gsm_titles)
groups= as.integer(lapply(gsm_titles, assign.group, title_clusters))
set.exp.groups(groups)
}
