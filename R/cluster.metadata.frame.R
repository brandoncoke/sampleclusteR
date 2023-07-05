#meta_data_frame=  get.combined.table(obtain.gset("GSE35351", platform= "none"),T); columns_to_cluster= NULL
cluster.metadata.frame= function(meta_data_frame, columns_to_cluster= NULL,
                                 concise= T){
  if(is.null(columns_to_cluster) | class(columns_to_cluster) != "integer"){
    columns_to_cluster= 1:ncol(meta_data_frame)
    message("No columns specified for clustering- clustering by all columns")
  }
    columns_to_cluster= columns_to_cluster[columns_to_cluster %in%  1:ncol(meta_data_frame)]
  appended_names= paste0(colnames(meta_data_frame[, columns_to_cluster]),
                         "_group")
  columns_to_cluster_unique= apply(meta_data_frame, 2, function(x){
    length(unique(x)) != 1
  })
  if(sum(columns_to_cluster_unique) == 0){
    stop("All samples unique cannot cluster- need a another column")
  }
  columns_to_cluster= as.numeric(which(columns_to_cluster_unique))
  if(length(columns_to_cluster) > 1){
    sample_labels= apply(meta_data_frame[, columns_to_cluster_unique], 1,
                         paste, collapse = "_")
  }else{
    sample_labels= meta_data_frame[, columns_to_cluster_unique]
  }
  if(length(sample_labels) != length(unique(sample_labels))){
    sample_labels= paste0(sample_labels, "_sample_", 1:length(sample_labels))
  }


  column_clusters= title.clustering(
    sample_labels, words_only= F)
  if(length(column_clusters) > nrow(meta_data_frame)*.75){
    message("Sample ids are likely to be present- making clustering more broad")
    column_clusters= title.clustering(
      sample_labels,
      words_only= T)
  }
  #assign samples with group numbers
  clusters= as.integer(lapply(sample_labels, function(x){
    group= NULL
    for(i in 1:length(column_clusters)){
      group= c(group, x %in% unlist(column_clusters[i]))
    }
    which(group)
  }))
  #detecting control and treated samples
  label_score= as.integer(lapply(sample_labels, get_score_labels))
  if(any(label_score == 1) | any(label_score == 2)){
    label_score[label_score == 0]= "Control"
    label_score[label_score == 1]= "Treated upregulated"
    label_score[label_score == 2]= "Treated downregulated"
  }else{
    label_score= rep("Unknown", length(label_score))
  }
  meta_data_frame$group= clusters
  meta_data_frame$sample_type= label_score
  exp_design_frame= get.clusters.as.frame(column_clusters)
  cluster_names= get.cluster.titles(exp_design_frame)
  meta_data_frame$group_name= cluster_names[clusters]
  if(concise){
    return(
      data.frame(
        "sample"= paste0("Sample_", 1:nrow(meta_data_frame)),
        "clustered_name"= cluster_names[clusters],
        "group"= meta_data_frame[ , "group"]
      )
    )
  }else{
    return(meta_data_frame)
  }
  }
