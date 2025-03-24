#assigns groups numbers
assign.group= function(sample_name, assoc_list){
  group= NA
  for(i in 1:length(assoc_list)){ #will slow the code down but need to check all lists. Then break
    if(sample_name %in%
       unlist(assoc_list[i])
      ){
      group= i
      break
    }
  }
  return(group)
}
