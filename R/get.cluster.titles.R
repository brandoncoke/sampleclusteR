get.cluster.titles= function(exp_design_frame){# bodge pls fix.
  labels=NULL
  labels_of_a_cluster= NULL
  new_label=NULL
  #remove unecessary junk in titles- makes end file names more readable
  for(i in 1:ncol(exp_design_frame)){
    labels_of_a_cluster= exp_design_frame[,i]
    labels_of_a_cluster= gsub(" ", "_", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("  ", "_", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("__", "_", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("-scr[0-9][0-9]$", "_scramble", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("-scr[0-9]$", "_scramble", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("-shrna[0-9]$", "_shRNA", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("-shrna[0-9]$", "_shRNA", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("control[0-9]$", "control", labels_of_a_cluster, ignore.case = T)#
    labels_of_a_cluster= gsub("change[0-9]$", "change", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("knockdown[0-9]$", "knockdown", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("24h", "24_hours", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("72h", "72_hours", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("48h", "48_hours", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("[+]", "_plus_", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("rep[0-9][0-9][0-9]", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("rep[0-9][0-9]", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("replicate.[0-9]", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("replicate[0-9]", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("replica.[0-9]", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("replica[0-9]", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("rep.[0-9]", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("rep[0-9]", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("   $", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("  $", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub(" $", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("rep[0-9][0-9]$", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("rep[0-9]$", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub(",", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("patient[0-9][0-9][0-9]|patient_[0-9][0-9][0-9]", "patient", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("patient[0-9][0-9]|patient_[0-9][0-9]", "patient", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("patient[0-9]|patient_[0-9]", "patient", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("sample[0-9][0-9][0-9]|sample_[0-9][0-9][0-9]", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("sample[0-9][0-9]|sample_[0-9][0-9]", "", labels_of_a_cluster, ignore.case = T)
    labels_of_a_cluster= gsub("sample[0-9]|sample_[0-9]", "", labels_of_a_cluster, ignore.case = T)




    labels_of_a_cluster= gsub("rep[0-9]", "_",labels_of_a_cluster)
    labels_of_a_cluster= gsub(".[0-9]^", "_",labels_of_a_cluster)
    labels_of_a_cluster= labels_of_a_cluster[!is.na(labels_of_a_cluster)]

    if(length(labels_of_a_cluster) > 1){ #need to remove unmatched words if more than one sample
      new_label= as.data.frame(strsplit(gsub("\\s|\\-", #converting to dataframe- list in wrong format
                                             "_",labels_of_a_cluster[1]), "\\,|\\_"))
      index_of_shared= #what words are shared across samples
      which(as.logical(lapply(new_label[,1],grep, labels_of_a_cluster[2]))) #bodge- implement check for all words i.e. !is.na(labels_of_a_cluster)
      if(length(index_of_shared) < 1){
       print(paste0("Title for group ", i, " needs manual annotation! Using first sample title as group name..."));
        index_of_shared= 1}
      labels= c(labels,paste0(new_label[index_of_shared,1],collapse= "_")) #return shared words

    }else{labels= c(labels,labels_of_a_cluster[1])}}
  labels= gsub("   ", "_",labels) #cleanup of whitepace
  labels= gsub("  ", "_",labels) #cleanup of whitepace
  labels= gsub(" ", "_",labels) #cleanup of whitepace
  labels= gsub("__|___|____", "_",labels) #cleanup of whitepace
  labels= gsub("___$", "",labels) #cleanup of whitepace
  labels= gsub("__$", "",labels) #cleanup of whitepace
  labels= gsub("_$", "",labels) #cleanup of whitepace
  labels= gsub("^___", "",labels) #cleanup of whitepace
  labels= gsub("^__", "",labels) #cleanup of whitepace
  labels= gsub("^_", "",labels) #cleanup of whitepace
  return(labels)
}
