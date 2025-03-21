#outputs experiment sets- 0= ctrl 1= treated
set.exp.groups= function(groups){
  combinations= get.group.combs(groups)
  lapply(combinations,function(X){
    exp_design= rep("X",length(groups))
    first_set= as.integer(unlist(strsplit(X, ":")))[1]
    second_set= as.integer(unlist(strsplit(X, ":")))[2]
    exp_design[groups == first_set]=0 #then assigns them on the exp_design
    exp_design[groups == second_set]=1
    paste(exp_design,collapse= "") #needed for setup.comparisons
    })
}
