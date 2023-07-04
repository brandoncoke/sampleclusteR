\name{shorten_output_titles}
\alias{shorten_output_titles}
\title{Shortens output csvs}
\usage{
shorten_output_titles(title)
}
\description{
Shortens the output titles when producing csvs.
}
\examples{

GEO_id= "GSE39904"
gset= obtain.gset(GEO_id)
gsm_titles= obtain.gsm.titles(gset)
title_clusters= title.clustering(gsm_titles)
groups= as.integer(lapply(gsm_titles, assign.group, title_clusters))
experiment_sets= set.exp.groups(groups)
output_titles= get.experiment.designs(groups,title_clusters)
shorten_output_titles(output_titles[1])
}
