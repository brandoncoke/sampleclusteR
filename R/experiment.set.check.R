experiment.set.check= function(experiment_set){ #do I have enough X (treated) and 0 (CTRL) in my experiment sets?
  list= NULL
  if(grepl(1,experiment_set) & grepl(0, experiment_set)){ #for outlier experiment sets where not 0 or 1 identified- else takes care of them
    for(i in 1:nchar(experiment_set)){
      list= c(list,substr(experiment_set,i,i))
    }
    frame= as.data.frame(table(list))
    #below does this experiment set have fewer than 1 replicate for either the control (0) or the comparison (1)?
    return(frame[frame$list == 1, 2] > 1 & frame[frame$list == 0, 2] > 1)
  } else{return(F)}


}
