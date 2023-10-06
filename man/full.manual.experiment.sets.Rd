\name{full.manual.experiment.sets}
\alias{full.manual.experiment.sets}
\title{Provide all possible intersample comparisons when provided with sample names and}
\usage{
full.manual.experiment.sets(sample_names, comb_groups)
}
\description{
Depricated use  manual.exp.sets instead for more control. Outputs all possible experiment designs for a given dataset for limma or DEG seq. 0 is control 1 is treated X is excluded and outputted as 00XX11.
}
\examples{
require(sampleclusteR)
gset= obtain.gset("GSE137040")
combined_table= get.combined.table(gset, T)
cluster_frame= cluster.metadata.frame(combined_table,
                                      columns_to_cluster = 3)
sample_names= cluster_frame$clustered_name
comb_groups= cluster_frame$group
full.manual.experiment.sets(
sample_names= sample_names, comb_groups= comb_groups)
}
