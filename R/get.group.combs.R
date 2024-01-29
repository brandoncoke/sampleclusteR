get.group.combs= function(groups){ #setting up all possible group combinations e.g. 12 13 23 and so on assumming only 3 groups identified.
  groups= factor(groups)
  group_levels= levels(groups)
  group_levels= group_levels[group_levels != "X"]
  output= NULL
  i=1
  total_levels= length(group_levels)
  while(i < total_levels){
    output= c(output,
              paste0(group_levels[i], ":", group_levels[(i+1):total_levels])
              )
    i= i+1
    }
  return(output)
  }
