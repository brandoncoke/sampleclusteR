combined.clustering= function(GEOset){
  if(class(GEOset) != "ExpressionSet"){
    stop("Invalid input- need a GEO expression set; use obtain.gset().")
  }
  sample_names= paste0("gsm",1:length(obtain.gsm.titles(gset)))
  combined_table= get.combined.table(GEOset)
  combined_table= remove.dups.from.cluster.frame(combined_table)
  combined.min.dis <- get.min.diss(combined_table[,-6])
  combNamesInClusters <- lapply(unique(combined.min.dis),
                             function(X){return(sample_names[X])})
  combNamesInClusters


}
