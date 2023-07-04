get.clusters.as.frame= function(cluster_list){
  cluster_list=as.list(cluster_list)
  cluster_list_lengths= as.integer(lapply(cluster_list,length)) #gets lengths of cluster titles
  cluster_list_lengths_max= cluster_list_lengths[which.max(cluster_list_lengths)[1]] #identifies length of cluster title with longest title
  cluster_frame= NULL
  #cbind the clusters sample names- fill with NA by selecting an indice range outide of length
  for(i in 1:length(cluster_list)){
    a_cluster_list= as.data.frame(cluster_list[i])
    a_cluster_list= a_cluster_list[,1]
    a_cluster_list= a_cluster_list[1:cluster_list_lengths_max]
    a_cluster_list= as.character(a_cluster_list)
    cluster_frame=cbind(cluster_frame,a_cluster_list)
    colnames(cluster_frame)[i]= paste0("Cluster_",i)
  }
  output= as.data.frame(cluster_frame)
  output= as.data.frame(apply(output, 2, function(x){
    gsub("[(|)]", "_", x)})) #as parenthesis treated as regex... get rid of.
  return(output)



}
