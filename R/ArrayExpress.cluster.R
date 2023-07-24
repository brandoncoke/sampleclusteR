#automate the clustering of ArrayExpress data
ArrayExpress.cluster= function(
    sdrf_loc= "https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/935/E-MTAB-11935/Files/E-MTAB-11935.sdrf.txt",
    concise= T){
  #import sdrf metadata frame
  metadata= read.delim(sdrf_loc, sep= "\t", header = T)
  metadata[is.na(metadata)]= ""
  #get the sample names
  sample_source= metadata$Source.Name
  #remove uneccessary columns
  metadata= metadata[!grepl("id|file|accession|source[.]Name|scan[.]|comment[.]", colnames(metadata),
                                    ignore.case= T)]
  #cols_all_unique= apply(metadata, 2, function(x){
  #  round(length(x)*broad_cluster_thres) > length(unique(x)) &
  #    length(unique(x)) != 1
  #cut down on redundancy- select columns where the are multiple values
  cols_all_unique= apply(metadata, 2, function(x){
    length(unique(x)) != 1
  })

  cluster_frame= metadata[,cols_all_unique]
  #then remove columns where the same value is provided for a given row
  nonredundant_col_indices= as.list(apply(cluster_frame, 1, function(x){which(!duplicated(x))}))
  nonredundant_col_indices= unique(unlist(nonredundant_col_indices))
  cluster_frame= cluster_frame[, nonredundant_col_indices]
  #drop columns with sample ids or file ids to make automated clusters more
  #readable
  cols_to_keep= colnames(cluster_frame)

  cluster_frame= metadata[,cols_to_keep]
  #append column name i.e. append original column name from sdrf metadata table
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
    #upper case first letter
    append_col=
      paste0(toupper(substr(append_col,1,1)),
             substr(append_col,2,nchar(append_col)))
    append_col= gsub("^_|_$", "", append_col)
    append_col= paste0(append_col, ":_")

    cluster_frame[,i]= gsub(" ", "_", paste0(append_col, cluster_frame[,i],
                              sep= "_"))
  }
  row.names(cluster_frame)= 1:nrow(cluster_frame)
  clustered_frame= cluster.metadata.frame(cluster_frame,
                                          concise= concise)
  clustered_frame$sample= sample_source
  return(clustered_frame)
}
