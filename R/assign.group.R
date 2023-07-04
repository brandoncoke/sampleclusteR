assign.group= function(assoc_list, clusterframe){
  group= NA
  for(i in 1:length(clusterframe)){ #will slow the code down but need to check all lists.
    if(assoc_list %in% clusterframe[[i]]){
      group= i
    }
  }
  return(group)
}
