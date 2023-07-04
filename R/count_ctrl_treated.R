count_ctrl_treated= function(experiment_set){
  split_set= strsplit(as.character(experiment_set), "")
  split_set= unlist(split_set)
  c(sum(split_set == "0"),
    sum(split_set == "1")
    )
}
