obtain.gset= function(GSE_code, platform= "NONE"){ #user enters GSE code
  gset <- getGEO(GSE_code, GSEMatrix =T, AnnotGPL=T)
  if(length(gset) > 1 & any(grepl(platform, attr(gset, "names")))){
    idx= grep(platform, attr(gset, "names")) #bit of a bodge but assumes platform specified is enough to distinguish similar ones
    }else{
    idx= 1}
  gset <- gset[[idx]]
  print(paste0("Using platform ", gset@annotation,"."))
  # make proper column names to match toptable
  fvarLabels(gset) <- make.names(fvarLabels(gset))

  return(gset)
}
