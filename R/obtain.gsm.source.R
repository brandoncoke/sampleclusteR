obtain.gsm.source= function(GEOset){ #use obtain_gset function to get a GEOset
  output= GEOset@phenoData@data[["source_name_ch1"]]
  return(output)
}
