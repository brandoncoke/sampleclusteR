\name{get.min.diss}
\alias{get.min.diss}
\title{Isolate minimum sized clusters from daisy::cluster function}
\usage{
get.experiment.designs(groups,assoc_cluster)
}
\description{
Returns the minimum sized clusters from a title clustering after converting sample feature to a dataframe. Needed in the various clustering functions like title.clustering.}

\examples{
gset= obtain.gset("GSE84881")
gsm_titles= obtain.gsm.titles(gset)
title_table <- data.frame(do.call(rbind,
                                    lapply(gsm_titles, gsm.title.managable)))
rownames(title_table)= gsm_titles
get.min.diss(title_table)
}
