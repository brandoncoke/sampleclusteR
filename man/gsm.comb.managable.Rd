\name{gsm.comb.managable}
\alias{gsm.comb.managable}
\title{Making the title cluster frame more usable for clustering.}
\usage{
gsm.comb.managable(title)
}
\Arguments{
\item{title}{a character of title samples}
}

\description{
Alternative to gsm.title.managable- without miRNA bodge}

\examples{
GEO_id= "GSE17385"
gset= obtain.gset(GEO_id)
gsm_titles= obtain.gsm.titles(gset)
combined_table= get.combined.table(gset,T)
  gsm_titles= gset@phenoData@data$title #origianlly due to get.cluster.titles reusing names of variables- avoid at all costs
  title_clusters= title.clustering(gsm_titles)
  combined_table$title_groups= as.integer(lapply(gsm_titles, assign.group,
                                                 title_clusters))
  #Characteristic clustering
  gsm_characteristics= obtain.charateristics(gset)
  charateristics_clusters= characteristic.clustering(gsm_characteristics)
  combined_table$characteristic_groups= as.integer(lapply(gsm_characteristics,
                                                          assign.group,
                                                          charateristics_clusters))
  #Source clustering
  gsm_source= obtain.gsm.source(gset)
  source_clusters= source.clustering(gsm_source)
  combined_table$source_groups= as.integer(lapply(gsm_source,
                                                  assign.group,
                                                  source_clusters))
  comb_groups= as.numeric(apply(combined_table[, 4:6], 1, sum)) #so if no new groups identified from an attribute- i.e. sample titles; column values are the same so no new groups identified when sum taken
  comb_groups_uni= unique(comb_groups)
  comb_groups= as.numeric(lapply(comb_groups, function(value){ #resets groups back to 1 to X
    which(value == unique(comb_groups_uni))}))
  combined_table$combined_groups= comb_groups
  comb_titles= as.character(apply(combined_table[,1:3], 1, paste, collapse= " "))
  comb_clusters= list(comb_titles[comb_groups == 1])
  if(length(unique(comb_groups_uni)) > 1){ #non-ideal. Cluster objects are lists of lists- so need to be appended sequentially. Also cannot just NA then for loop 1:ect as NA will be included in list.
    for(i in 2:length(unique(comb_groups_uni))){
      comb_clusters= c(list(comb_titles[comb_groups == i]), comb_clusters)
    }
  }
  comb_tables_managable= as.character(lapply(comb_clusters, function(x){
    x= unlist(x)
    paste(gsm.title.managable(x[1]), collapse= "_")
  }))
  comb_tables_managable #human readable clustering

}
