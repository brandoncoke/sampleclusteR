#groups_identified= comb_groups; assoc_cluster=title_clusters
get.experiment.designs.manual= function(groups_identified,assoc_cluster,experiment_sets,
                                        words_only= F){ #setting up all posible groups_identified
  exp_design_frame= get.clusters.as.frame(assoc_cluster)
  cluster_names= get.cluster.titles(exp_design_frame)
  #groups_identified_with_replicates= groups_identified[duplicated(groups_identified)] #bodge- as groups_identified factors are in the order they appear in dataset- i.e. if the first sample doesnt have replicates it needs to be skipped.
  #groups_identified_with_replicates= unique(groups_identified)
  #groups_identified_with_replicates[order(groups_identified_with_replicates)] #as if groups duplicated not sequentially- titles will not line up
  #cluster_names= unique(cluster_names)
  output= NULL
  #for loop obtains all of the permutations
  output= as.character(lapply(unlist(experiment_sets), function(x){
    assigned_groups= unlist(strsplit(x,""))
    indice_of_control= groups_identified[which(assigned_groups == "0")[1]]
    indice_of_treated= groups_identified[which(assigned_groups == "1")[1]]

    paste0(cluster_names[indice_of_control], #bodge but gets the groups aligned correctly
           "_vs_",
           cluster_names[indice_of_treated])


  }))

  output= gsub("/mg","_per_mg",output) #Deals with slashes in titles- prevents csv saving
  output= gsub("/ug","_per_ug",output) #cant regex [ug|mg]- cuts off unit i.e. returns _per_g
  output= gsub("/ul","_per_ul",output)
  output= gsub("/ml","_per_ml",output)
  output= gsub("/g","_per_g",output)
  output= gsub("/l","_per_l",output)
  output= gsub("/kg","_per_kg",output)
  output= gsub("[/]","_or_",output) #assume other slashes are for alternatives
  output= gsub("rep.[0-9]|rep.[0-9][0-9]|rep.[0-9][0-9][0-9]$","replicates",output)
  output= gsub("rep[0-9]|rep[0-9][0-9]|rep[0-9][0-9][0-9]$","replicates",output)
  output= gsub("replicate.[0-9][0-9]|replicate.[0-9]|replicate[0-9]", "replicates",output, ignore.case = T) #sometimes number is retained in final output- i.e. 10 replicates so sample 1 shares a 1 with sample 10.
  output= gsub("sample.[0-9][0-9]|sample.[0-9]|sample[0-9]", "samples",output, ignore.case = T)
  output= gsub("patient.[0-9][0-9]|patient.[0-9]|patient[0-9]", "output",output, ignore.case = T) #can you spot why the second is redundant. eh...
  output= gsub("replica.[0-9]|replica[0-9]", "", output, ignore.case = T)
  output= gsub("patient[0-9][0-9][0-9]", "patient_", output, ignore.case = T)
  output= gsub("patient[0-9][0-9]", "patient_", output, ignore.case = T)
  output= gsub("patient[0-9]", "patient_", output, ignore.case = T)
  output= gsub("replica.[a-z]|replica[a-z]", "", output, ignore.case = T)
  output= gsub("duplicate", "", output, ignore.case = T)
  output= gsub("h_[0-9]$|h_[0-9][0-9]$|hr[0-9]$|hr.[0-9]", "hr", output, ignore.case = T)
  output= gsub("biological", "", output, ignore.case = T) #usually pointless info about being biological replicate
  #output= gsub("___", "_", output, ignore.case = T)
  #output= gsub("__", "_", output, ignore.case = T)
  #output= gsub("_$", "", output, ignore.case = T)
  #clean up from previous gsubs- dead space like __ or _ at end
  for(i in 1:length(output)){
    while(grepl("_$|__", output[i]) & nchar(output[i]) > 1){
      output[i]= gsub("_$", "", output[i], ignore.case = T)
      output[i]= gsub("__", "_", output[i], ignore.case = T)
      output[i]= gsub("^_", "", output[i], ignore.case = T)
    }
  }
  if(words_only){
    output= gsub("[0-9]", "", output, ignore.case = T)
  }
  return(output)
}
