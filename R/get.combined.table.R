get.combined.table <- function(GEOset, split_titles= F){
  if(class(GEOset) != "ExpressionSet"){
    stop("Input invalid. Need a GEO expression set. Use obtain.gseted()")
  }
  titleTable= GEOset@phenoData@data$title
  if(split_titles){
    characteristicsTable= GEOset@phenoData@data[["molecule_ch1"]]
    souceInfo <- GEOset@phenoData@data[["source_name_ch1"]]
    combined.table <- cbind(titleTable,characteristicsTable,souceInfo)
    combined.table= as.data.frame(combined.table)
    rownames(combined.table)= paste0("Sample_",1:nrow(combined.table))
    return(combined.table)}
  else{titleTable= data.frame(do.call(rbind,lapply(titleTable, gsm.title.managable)))
  characteristicsTable= GEOset@phenoData@data[["molecule_ch1"]]
  souceInfo <- GEOset@phenoData@data[["source_name_ch1"]]
  combined.table <- cbind(titleTable,characteristicsTable,souceInfo)
  combined.table= as.data.frame(combined.table)
  rownames(combined.table)= paste0("gsm",1:nrow(combined.table))
  return(combined.table)}
}
