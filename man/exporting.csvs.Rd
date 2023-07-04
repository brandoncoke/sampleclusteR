\name{exporting.csvs}
\alias{exporting.csvs}
\title{Exports csvs based on the valid experiment sets identified}
\usage{
exporting.csvs(experiment_set_index, experiment_sets= experiment_sets, GEOset= gset, limma_or_rankprod= "limma", path= path, output_titles= output_titles)
}
\description{
A function which creates all of the csv intersample comparisons identified from the clustering. Takes serveral arguments defined in the example code.
experiment_set_index is a 1 to X list of integers representing the index of experiment sets. experiment sets is the intersample comparisons with treated (labelled as 1)
againist control (labelled as 0). GEOset is a GEOquery Expression dataset. limma_or_prod is the string defining whether limma or RankProd is used see setup.comparisons and setup.comparisons.RP respectively. path is the path used to save the csvs and output titles.
To use RankProd it requires installation of RankProd and its dependencies (Rmpfr and gmp). If installing RankProd via Debian or Ubuntu based operating systems issues can arise from these dependencies. Use sudo apt install r-cran-gmp r-cran-rmpfr to alleviate this after adding the R repository.
}
\examples{
gset= obtain.gset("GSE74572")
gsm_source= obtain.gsm.source(gset)
source_clusters= source.clustering(gsm_source)
groups= as.integer(lapply(gsm_source, assign.group, source_clusters))
experiment_sets= set.exp.groups(groups)
output_titles= get.experiment.designs(groups,source_clusters)
GEO_id= as.character(gset@experimentData@other[["geo_accession"]])
lapply(1:length(experiment_sets), exporting.csvs,
  experiment_sets= experiment_sets, GEOset= gset,
  limma_or_rankprod= "limma", path= "~/",output_titles= output_titles,
  GEO_id= GEO_id)
#Check your home directory.
}
