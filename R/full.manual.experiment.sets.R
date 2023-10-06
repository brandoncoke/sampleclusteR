#gset= obtain.gset("GSE137040")
#combined_table= get.combined.table(gset, T)
#cluster_frame= cluster.metadata.frame(combined_table,
#                                      columns_to_cluster = 3)
#sample_names= cluster_frame$clustered_name
#comb_groups= cluster_frame$group
full.manual.experiment.sets= function(sample_names,
                                 comb_groups){
  experiment_sets= set.exp.groups(comb_groups)
  experiment_sets= experiment_sets[as.logical(lapply(experiment_sets,
                                                     experiment.set.check))]
  #below gets rid of invalid experiment sets where only one replicate (n <= 1) in either comparison. limma cant deal with that.
  experiment_sets= experiment_sets[as.logical(lapply(experiment_sets,
                                                     experiment.set.check))]
  if(length(experiment_sets) < 1){ #ensures at least one experiment set is present.
    stop("INVALID CLUSTERS- only one replicate in all clusters / single cluster identified. Need to manually assign groups with manual.analysis")
  }
  experiment_sets= experiment_sets[!is.na(experiment_sets)]
  cluster_names_frame= data.frame(group_number= unique(comb_groups),
                                  group_name= NA)
  group_names= NULL
  for(cluster_indice in unique(comb_groups)){
    cluster_name= sample_names[comb_groups == cluster_indice]
    if(length(cluster_name) > 1){ #need to remove unmatched words if more than one sample
      new_label= as.data.frame(strsplit(gsub("\\s|\\-", #converting to dataframe- list in wrong format
                                             "_",cluster_name[1]), "\\,|\\_"))
      index_of_shared= #what words are shared across samples
        which(as.logical(lapply(new_label[,1],grep, cluster_name[2]))) #bodge- implement check for all words i.e. !is.na(labels_of_a_cluster)
      group_names= c(group_names,paste0(new_label[index_of_shared,1],collapse= "_")) #return shared words
    }else{
      group_names= c(group_names,cluster_name[1])}
  }

  experiment_sets= unlist(experiment_sets)
  experiment_sets= as.character(experiment_sets)
  comparisons= NULL
  for(experiment_set in experiment_sets){
    experiment_set= as.character(unlist(strsplit(experiment_set, "")))
    control_indice=
      comb_groups[which(experiment_set == "0")[1]]
    treated_indice=
      comb_groups[which(experiment_set == "1")[1]]
    comparisons= c(
      comparisons,
      paste0(group_names[control_indice],
             "_vs_",
             group_names[treated_indice])
    )
  }
  data.frame(comparisons,
             experiment_sets)
}
