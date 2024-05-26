\name{get.min.diss}
\alias{get.min.diss}
\title{Isolate minimum sized clusters from daisy::cluster function}
\usage{
get.min.diss(a_table)
}
\Arguments{
\item{a_table}{Cluster frame- with rownames that contain sample names}
}



\description{
Returns the minimum sized clusters from a title clustering after converting sample feature to a dataframe. Needed in the various clustering functions like title.clustering.}

\examples{
gset= obtain.gset("GSE84881")
gsm_titles= obtain.gsm.titles(gset)
title_table <- data.frame(do.call(rbind,
                                    lapply(gsm_titles, gsm.title.managable)))
rownames(title_table)= gsm_titles
get.min.diss(a_table= title_table)
}
