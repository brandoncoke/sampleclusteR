#find matching groups- remove them
unique.feature.redun= function(unique_features, combined_table){
  group_string_1=  paste0(combined_table[, unique_features[1]+3],
                          collapse = "")
  bool_list= NULL
  for(i in unique_features[-1]){
    group_string_loop=  paste0(combined_table[, i+3],
                            collapse = "")
    bool_list= c(bool_list, (group_string_1 != group_string_loop))
  }
  return(
    unique_features[c(T, bool_list)])


}
