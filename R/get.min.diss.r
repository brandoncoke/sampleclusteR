get.min.diss= function(a_table){
  require(cluster)
  a_table[is.na(a_table)]= "a" #resolves issues with NA; cluster::daisy does not work with NAs
  a_table= data.matrix(a_table)
  diss.mat <- data.matrix(cluster::daisy(a_table))
  min.dis <- lapply(1:nrow(diss.mat), function(X){
    return(unlist(which(diss.mat[X,] == min(diss.mat[X,]))))
  })
  return(min.dis)
}

