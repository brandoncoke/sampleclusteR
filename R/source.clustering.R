source.clustering= function(gsm_source) { #modified CharacteristicsClustering
  source_table <- data.frame(do.call(rbind,
                                              lapply(gsm_source, gsm.characteristics.managable))) #as the clean_up doesnt require fancy reg expressions like titles.
  source.min.dis <- get.min.diss(source_table) #gets minimum dissimilarity across groups after cluster::daisy
  sNamesInClusters <- lapply(unique(source.min.dis),
                             function(X){return(gsm_source[X])})
  return(sNamesInClusters)
}
