\name{assign.group}
\alias{assign.group}
\title{Assigning sample groups based on cluster}
\usage{
assign.group(assoc_list, sample_names)
}
\Arguments{
\item{assoc_list}{group list- obtained using functions like title.clustering}
\item{sample_names}{sample names}
}

\description{
Assigns group numbers after the samples are clustered.
Requires the user to specify a assoc_list (generated from functions such as title.clustering, characteristic.clustering or get.combined.clusters) and a associated list i.e. if the samples were clustered by their titles, a list of the sample tiles is needed.
}
\examples{
gset= obtain.gset("GSE84881")
gsm_titles= obtain.gsm.titles(gset)
title_clusters= title.clustering(gsm_titles)
as.integer(lapply(gsm_titles, assign.group, title_clusters))
}
