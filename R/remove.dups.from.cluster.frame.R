remove.dups.from.cluster.frame= function(cluster_frame){ #needed for combined clustering to work-ab
  duplicated_cols= NULL #if theres dups in the cluster frame- no groups will be identified.
  for(i in 1:ncol(cluster_frame)){
    duplicated_cols= c(duplicated_cols, length(unique(cluster_frame[,1])) <= 1) #why <=? There should only be 0 or negatives...
  }
  cluster_frame[,!duplicated_cols]
}
