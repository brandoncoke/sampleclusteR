#assigns groups numbers
assign.group= function(assoc_list, sample_names){
  group= NA
  for(i in 1:length(sample_names)){ #will slow the code down but need to check all lists.
    if(assoc_list %in% clusterframe[[i]]){
      group= i
    }
  }
  return(group)
}
