#GEO_id="GSE108345"; path="~/"; meta_data_and_combined=F; platform= "NONE"; limma_or_rankprod= "limma"; words_only= F
#GEO_id="GSE79695";  path="~/"; platform= "GPL570"; selection= 1; words_only= T #debugging
automated.analysis= function(GEO_id,  path="~/",
                             meta_data_and_combined=F,
                             platform= "NONE",
                             limma_or_rankprod= "limma",
                             words_only= F ){
  message(paste("Analysing", GEO_id)) #user aware of dataset analysed
  gset= obtain.gset(GEO_id, platform= platform) #getting expression dataset
  if(length(gset@phenoData@data[["geo_accession"]]) < 2 ){ #quick exit if only one or 2 samples present- limma reqs 2 reps in at least 2 groups
    stop("Too few samples for limma!")
  }
  if(is.null(gset) | class(gset) != "ExpressionSet"){
    stop("gset NOT VALID")
  }
  combined_table= get.combined.table(gset,T)
  combined_table
  gsm_titles= gset@phenoData@data$title #origianlly due to get.cluster.titles reusing names of variables- avoid at all costs
  title_clusters= title.clustering(gsm_titles, words_only= words_only)
  #if clustering did not work
  if(length(title_clusters) == nrow(combined_table)){
    message("Study is likely to have patient/sample ids. Removing them during clustering")
    title_clusters= title.clustering(gsm_titles, words_only= T)
  }

  #too many clusters- might be due to junk patient ids
  if(length(title_clusters) > nrow(combined_table)*.75 &
     nrow(combined_table) > 6){
    message("Study is likely to have patient/sample ids. Removing them during clustering")
    title_clusters= title.clustering(gsm_titles, words_only= T)
  }

  #instances where titles are all unique- so cannot cluster
  if(length(title_clusters) > (nrow(combined_table)-1) |
     as.character(title_clusters[1]) == "character(0)"){
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

  #instances where source are all unique- so cannot cluster
  if(length(source_clusters) > (nrow(combined_table)-1)){
    combined_table$souceInfo= "_"
    gsm_source= rep("Sample")
    source_clusters= list("Sample")
  }
  combined_table$soruce_groups= as.integer(lapply(gsm_source,
                                                          assign.group,
                                                  source_clusters))

  #Combined clustering
  #combined groups
  comb_groups= apply(combined_table[,4:6], 1, paste, collapse= "")
  unique_combs= unique(comb_groups)
  comb_groups= as.integer(lapply(comb_groups, function(x){
    which(x == unique_combs)
  }))
  combined_table$combined_groups= comb_groups
  #remove excess text from combined text
  unique_features= which(as.logical(apply(combined_table[,1:3], 2,
                                          function(x){
                                            length(unique(x)) > 1
                                          })))
  if(!any(as.logical(apply(combined_table[,1:3], 2,
                          function(x){
                            length(unique(x)) > 1
                          })))){
    stop("No unique samples identified based on metadata")
  }



  #if the same groups are identified across different features- no need to include them
  #when assigning sample group titles
  switch(length(unique_features),
         unique_features= unique_features,
         unique_features= unique.feature.redun(unique_features, combined_table),
         unique_features= unique.feature.redun(unique_features, combined_table),
         unique_features= unique.feature.redun(unique_features, combined_table) #why?
  )


  #if multiple columns used for clustering- use that informaiton to lable the columns
  if(length(unique_features)> 1){
    comb_titles= as.character(apply(combined_table[,unique_features], 1, paste, collapse= " "))
  }else{
    comb_titles= combined_table[,unique_features]
  }


  comb_clusters= list(comb_titles[comb_groups == 1])
  for(i in unique(comb_groups)[-1]){
    comb_clusters= c(comb_clusters, list(comb_titles[comb_groups == i]))
  }
  if(length(comb_clusters) == 1 |
     length(comb_clusters) > nrow(combined_table) ){
    stop("No clusters were identified- use manual.analysis")
  }
  comb_tables_managable= unlist(comb_clusters[1])
  comb_tables_managable= comb_tables_managable[1]
  comb_tables_managable= paste(gsm.title.managable(comb_tables_managable),
                               collapse= "_")

  for(i in 2:length(comb_clusters)){
    temp= unlist(comb_clusters[i])
    temp= paste(gsm.title.managable(temp[1]),
                collapse= "_")
    comb_tables_managable= c(comb_tables_managable, temp)
  }
  comb_tables_managable
  comb_tables_managable_table= data.frame(comb_tables_managable,
                                          type= "Control")
  #assign control and treated samples 0 = control, 1= upreg, 2= down reg
  label_score= get_score_labels(comb_tables_managable)

  comb_tables_managable_table= data.frame(comb_tables_managable,
                                          type= "Control")
  #is it up or down regulated assign with score

  #automated.analysis means no human interference- setting up pairwise comparisons automatically.
  gsm_template= rep("X", nrow(combined_table))
  #check if at least 1 control and treated identified
  check= any(label_score == 0) &
    any(label_score == 2 | label_score == 1)


  if(check){
    message("Control and treated samples identfied setting pairwise comparisons")
    control_indices= which(label_score == 0)
    treated_indices= which(label_score != 0)
    def_groups= NA
    for(control_indice in control_indices){
      #message(control_indice)
      def_gsm_temp= gsm_template
      def_gsm_temp[comb_groups == control_indice]= 0
      for(treated_indice in treated_indices){
        #message(treated_indice)
        def_gsm_temp_perm= def_gsm_temp
        def_gsm_temp_perm[comb_groups == treated_indice]= 1
        def_gsm_temp_perm= paste(def_gsm_temp_perm, collapse= "")
        def_groups= c(def_groups, def_gsm_temp_perm)
      }
    }
    experiment_sets= def_groups

    check_multicontrol= sum(label_score == 0)
    check_multicontrol
    if(check_multicontrol != 1){
      message("Multiple controls identified- reducing redundancy")
        experiment_sets= cut_down_redundancy(control_indices,
                                             treated_indices,
                                             label_score,
                                             comb_tables_managable_table,
                                             gsm_template,
                                             comb_groups,
                                             experiment_sets)}

    }else{
    message("Doing all pairwise comparisons- no treated sample identifed from metadata")
    experiment_sets= set.exp.groups(comb_groups)
    experiment_sets= experiment_sets[as.logical(lapply(experiment_sets,
                                                       experiment.set.check))]
  }

  #final export

  #below gets rid of invalid experiment sets where only one replicate (n <= 1) in either comparison. limma cant deal with that.
  experiment_sets= experiment_sets[as.logical(lapply(experiment_sets,
                                                     experiment.set.check))]
  if(length(experiment_sets) < 1){ #ensures at least one experiment set is present.
    stop("INVALID CLUSTERS- only one replicate in all clusters / single cluster identified. Need to manually assign groups with manual.analysis")
  }
  experiment_sets= experiment_sets[!is.na(experiment_sets)]
  if(length(experiment_sets) == 0){
    stop("No groups idenfied- use manual.analysis")
  }
  message("The comparisons are as follows") # have to put it here as switch messages the titles
  output_titles= get.experiment.designs.manual(groups_identified= comb_groups,
                                               assoc_cluster= comb_clusters, experiment_sets)
  #linux issue saving files with large names- cut them down
  check_output_file_length= as.logical(lapply(output_titles, function(x){
    nchar(x) > 100
  }))
  if(any(check_output_file_length)){
    for(i in which(check_output_file_length)){
      output_titles[i]= shorten_output_titles(output_titles[i])
    }
  }
  print(output_titles)
  #lapply(1:length(experiment_sets), exporting.csvs,
  #       experiment_sets= experiment_sets, GEOset= gset,
  #       limma_or_rankprod= limma_or_rankprod, path= path,output_titles= output_titles,
  #       GEO_id= GEO_id)
  for(experiment_set_index in 1:length(experiment_sets)){
    exporting.csvs(experiment_set_index= experiment_set_index,
                   experiment_sets= experiment_sets, GEOset= gset,
                   limma_or_rankprod= limma_or_rankprod, path= path,output_titles= output_titles,
                   GEO_id= GEO_id)
  }



  if(meta_data_and_combined){
    meta_frame= do.call(rbind, lapply(experiment_sets, count_ctrl_treated))
    meta_frame= as.data.frame(meta_frame)
    colnames(meta_frame)= c("Control", "Treated")
    meta_frame$block_name_id= paste0(GEO_id, "_", output_titles)
    meta_frame$gse= GEO_id
    write.csv(meta_frame, paste0(path, GEO_id, "_metadata.csv"), row.names= F)
  }


  }
