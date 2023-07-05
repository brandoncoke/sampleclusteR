#automate the clustering of ArrayExpress data
ArrayExpress.cluster= function(
    sdrf_loc= "https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/935/E-MTAB-11935/Files/E-MTAB-11935.sdrf.txt",
    broad_cluster= T,
    concise= T){
  metadata= read.table(sdrf_loc, sep= "\t", header = T)
  metadata[is.na(metadata)]= ""
  sample_source= metadata$Source.Name
  metadata= metadata[!grepl("id|file|accession|source[.]Name", colnames(metadata),
                                    ignore.case= T)]


  #a way to avoid making too many clusters
  if(broad_cluster){
    cols_all_unique= apply(metadata, 2, function(x){
      round(length(x)*0.6) > length(unique(x)) &
        length(unique(x)) != 1
    })

  }else{
    cols_all_unique= apply(metadata, 2, function(x){
      length(unique(x)) != 1
    })
  }

  cluster_frame= metadata[,cols_all_unique]
  #drop columns with sample ids or file ids to make automated clusters more
  #readable
  cols_to_keep= colnames(cluster_frame)

  cluster_frame= metadata[,cols_to_keep]
  #append column name to make sense of values
  for(i in 1:ncol(cluster_frame)){
    append_col= colnames(cluster_frame)[i]
    append_col= gsub("characteristics.|factor.value",
                     "",
                     append_col,
                     ignore.case = T)
    append_col= gsub("[.]",
                     "_",
                     append_col,
                     ignore.case = T)
    cluster_frame[,i]= gsub(" ", "_", paste0(append_col, cluster_frame[,i],
                              sep= "_"))
  }
  row.names(cluster_frame)= 1:nrow(cluster_frame)
  clustered_frame= cluster.metadata.frame(cluster_frame,
                                          concise= concise)
  clustered_frame$sample= sample_source
  return(clustered_frame)
}
