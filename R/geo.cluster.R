#GEO_id="GSE7699"; platform= "NONE"; words_only= F
geo.cluster= function(GEO_id, words_only= F, platform= "NONE"){
  message(paste("Analysing", GEO_id)) #user aware of dataset analysed
  gset= obtain.gset(GEO_id, platform= platform) #getting expression dataset
  if(length(gset@phenoData@data[["geo_accession"]]) < 2 ){ #quick exit if only one or 2 samples present- limma reqs 2 reps in at least 2 groups
    stop("Insufficient samples for clustering")
  }
  if(is.null(gset) | class(gset) != "ExpressionSet"){
    stop("gset NOT VALID")
  }
  combined_table= get.combined.table(gset,T)
  gsm_titles= gset@phenoData@data$title #origianlly due to get.cluster.titles reusing names of variables- avoid at all costs
  title_clusters= title.clustering(gsm_titles, words_only= words_only)
  #to many clusters- might be due to junk patient ids
  if(length(title_clusters) > nrow(combined_table)*.75){
    title_clusters= title.clustering(gsm_titles, words_only= T)
  }
  #instances where titles are all unique- so cannot cluster
  if(length(title_clusters) > (nrow(combined_table)-1)){
    combined_table$titleTable= "_"
    gsm_titles= rep("Sample", nrow(combined_table))
    title_clusters= list("Sample")
  }
  combined_table$title_groups= as.integer(lapply(gsm_titles, assign.group,
                                                 title_clusters))
  #if the titles

  #Characteristic clustering
  gsm_characteristics= obtain.charateristics(gset)
  charateristics_clusters= characteristic.clustering(gsm_characteristics)

  #instances where characteristics are all unique- so cannot cluster
  if(length(charateristics_clusters) > (nrow(combined_table)-1)){
    combined_table$characteristicsTable= "_"
    gsm_characteristics= rep("Sample", nrow(combined_table))
    charateristics_clusters= list("Sample")
  }
  combined_table$characteristic_groups= as.integer(lapply(gsm_characteristics,
                                                          assign.group,
                                                          charateristics_clusters))
  #Source clustering
  gsm_source= obtain.gsm.source(gset)
  source_clusters= source.clustering(gsm_source)

  #instances where titles are all unique- so cannot cluster
  if(length(source_clusters) > (nrow(combined_table)-1)){
    combined_table$souceInfo= "_"
    gsm_source= rep("Sample", nrow(combined_table))
    source_clusters= list("Sample")
  }

  combined_table$source_groups= as.integer(lapply(gsm_source,
                                                  assign.group,
                                                  source_clusters))
  # comb_groups= as.numeric(apply(combined_table[, 4:6], 1, sum)) #so if no new groups identified from an attribute- i.e. sample titles; column values are the same so no new groups identified when sum taken
  comb_groups= apply(combined_table[,4:6], 1, paste, collapse= "")
  unique_combs= unique(comb_groups)
  comb_groups= as.integer(lapply(comb_groups, function(x){
    which(x == unique_combs)
  }))
  combined_table$combined_groups= comb_groups
  #remove excess text from combined text
  #which out of titles source and characteristics are useful for providing the titles of the clusters
  unique_features= which(as.logical(apply(combined_table[,1:3], 2,
                                          function(x){
                                            length(unique(x)) > 1
                                          })))
  #detecting control and treated samples
  label_score= unlist(apply(combined_table[,1:3], 1, paste0, collapse= " "))


  label_score= as.integer(lapply(label_score, get_score_labels))
  if(any(label_score == 1) | any(label_score == 2)){
    label_score[label_score == 0]= "Control"
    label_score[label_score == 1]= "Treated upregulated"
    label_score[label_score == 2]= "Treated downregulated"
  }else{
    label_score= rep("Unknown", length(label_score))
  }
  combined_table$sample_type= label_score



  if(length(unique_features)> 1){
    comb_titles= as.character(apply(combined_table[,unique_features], 1, paste, collapse= " "))
  }else{
    comb_titles= combined_table[,unique_features]
  }
  if(length(comb_titles) == 0){
    stop("No clusters identified- manual cluster")
  }

  comb_clusters= list(comb_titles[comb_groups == 1])
  for(i in unique(comb_groups)[-1]){
    comb_clusters= c(comb_clusters, list(comb_titles[comb_groups == i]))
  }
  if(length(comb_clusters) == 1 |
     length(comb_clusters) > nrow(combined_table) ){
    message("No clusters were identified- manually assign clusters")
  }
  return(combined_table)

  }
