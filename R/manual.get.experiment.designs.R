manual.get.experiment.designs= function(groups_identified, manual_names){
  #for loop obtains all of the permutations
  groups_identified_with_replicates= groups_identified[duplicated(groups_identified)] #bodge- as groups_identified factors are in the order they appear in dataset- i.e. if the first sample doesnt have replicates it needs to be skipped.
  groups_identified_with_replicates= as.numeric(unique(groups_identified_with_replicates))
  groups_identified_with_replicates= groups_identified_with_replicates[order(unique(groups_identified_with_replicates))]
  manual_names[groups_identified_with_replicates]
  output= NULL
  for(i in 1:(length(groups_identified_with_replicates)-1)){ #brackets needed
    base_group= manual_names[i]
    comparison_groups_identified= manual_names[(i+1):length(levels(
      groups_identified_with_replicates))]
    output= c(output,
              paste0(base_group,"_VS_", comparison_groups_identified))
  }
  output= gsub("/","_or_",output) #Deals with slashes in titles- prevents csv saving
  return(output)


}
