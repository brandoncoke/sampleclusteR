\name{remove.dups.from.cluster.frame}
\alias{remove.dups.from.cluster.frame}
\title{Removes duplicated columns from a cluster frame to avoid issues with clustering}
\usage{
remove.dups.from.cluster.frame(cluster_frame)
}
\description{
Used in combined.clustering. Removes duplicated columns which caused issues when using get.min.dis function on the cluster frame.
}
\examples{
gset= obtain.gset("GSE84881")
sample_names= paste0("gsm",1:length(obtain.gsm.titles(gset)))
combined_table= get.combined.table(gset) #table of the title, cell source and characteristics of cells
combined_table= remove.dups.from.cluster.frame(combined_table)
}
