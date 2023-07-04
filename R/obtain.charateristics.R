obtain.charateristics= function(GEOset){ #use obtain_gset function to get a GEOset
  return(GEOset@phenoData@data[["molecule_ch1"]])
}


