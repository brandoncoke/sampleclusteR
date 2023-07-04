characteristic.clustering= function(gsm_characteristics) { #modified CharacteristicsClustering
  characteristics_table <- data.frame(do.call(rbind,
                                    lapply(gsm_characteristics, gsm.characteristics.managable))) #characteristic titles defined here
  char.min.dis <- get.min.diss(characteristics_table) #gets minimum dissimilarity across groups after cluster::daisy
  cNamesInClusters <- lapply(unique(char.min.dis),
                             function(X){return(gsm_characteristics[X])})
  return(cNamesInClusters)
}
