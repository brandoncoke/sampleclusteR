combined.clustering= function(GEOset){
  if(class(GEOset) != "ExpressionSet"){
    stop("Invalid input- need a GEO expression set; use obtain.gset().")
  }
  sample_names= paste0("gsm",1:length(obtain.gsm.titles(GEOset)))
  combined_table= get.combined.table(GEOset)
  combined.min.dis <- get.min.diss(combined_table)
  combNamesInClusters <- lapply(unique(combined.min.dis),
                             function(X){return(sample_names[X])})


}
