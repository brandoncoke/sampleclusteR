\name{manual.exp.sets}
\alias{manual.exp.sets}
\title{Making the title cluster frame more usable for clustering.}
\usage{
manual.exp.sets(title)
}
\description{
Clusters samples based on the automated sets- groups. Requires a comb_table- i.e. metadata from the the GEO study- produces a comparison string (X0XX011)- 1 = treated, 0= control}

\examples{
GEO_id="GSE84881"
gset= obtain.gset(GEO_id)
gsm_titles= obtain.gsm.titles(gset)
combined_table= get.combined.table(gset,T)
  gsm_titles= gset@phenoData@data$title #origianlly due to get.cluster.titles reusing names of variables- avoid at all costs
  title_clusters= title.clustering(gsm_titles)
  combined_table$title_groups= as.integer(lapply(gsm_titles, assign.group,
                                                 title_clusters))
  groups= combined_table$title_groups
  manual.exp.sets(groups, combined_table)


}
