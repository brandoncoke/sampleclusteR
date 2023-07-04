get.group.combs= function(groups){ #setting up all possible group combinations e.g. 12 13 23 and so on assumming only 3 groups identified.
  groups= factor(groups)
  group_levels= levels(groups)
  group_levels= group_levels[group_levels != "X"]
  output= NULL
  i=1
  while(i < length(group_levels)){ #cleaner- all permutations for comparison. Recursion no faster in R... 
    #paste every combo up to the length of the levels until i is the last group which cant have any combos without repeating or doing a self comparison
    output= c(output,
      paste0(group_levels[i], group_levels[(i+1):length(group_levels)]))
    i=i+1
  }
  return(output)
  }
