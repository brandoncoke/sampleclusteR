#GEO_id="GSE108345";  path="~/"; platform= "GPL570"; selection= 1 #debugging
semi.supervised.analysis= function(GEO_id,  path="~/", platform= "NONE", meta_data_and_combined=T,
                              limma_or_rankprod= "limma", words_only= F){
  message(paste("Analysing", GEO_id)) #user aware of dataset analysed
  gset= obtain.gset(GEO_id, platform= platform) #getting expression dataset
  if(length(gset@phenoData@data[["geo_accession"]]) <= 3 ){ #quick exit if only one or 2 samples present- limma reqs 2 reps in at least 2 groups
    stop("Too few samples for limma!")
  }
  if(is.null(gset) | class(gset) != "ExpressionSet"){
    stop("gset NOT VALID")
  }
  combined_table= get.combined.table(gset,T)
  gsm_titles= gset@phenoData@data$title #origianlly due to get.cluster.titles reusing names of variables- avoid at all costs
  title_clusters= title.clustering(gsm_titles, words_only= words_only)

  #too many clusters based on titles- probably useless patient ids present
  if(length(title_clusters) > nrow(combined_table)*.75 &
     nrow(combined_table) > 6 & !words_only){
    message("Study is likely to have patient/sample ids. Removing them during clustering")
    title_clusters= title.clustering(gsm_titles, words_only= T)
  }

  combined_table$title_groups= as.integer(lapply(gsm_titles, assign.group,
                                                 title_clusters))
  #Characteristic clustering
  gsm_characteristics= obtain.charateristics(gset)
  charateristics_clusters= characteristic.clustering(gsm_characteristics)
  combined_table$characteristic_groups= as.integer(lapply(gsm_characteristics,
                                                          assign.group,
                                                          charateristics_clusters))
  #Source clustering
  gsm_source= obtain.gsm.source(gset)
  source_clusters= source.clustering(gsm_source)
  combined_table$source_groups= as.integer(lapply(gsm_source,
                                                  assign.group,
                                                  source_clusters))

  #combined groups
  comb_groups= apply(combined_table[,4:6], 1, paste, collapse= "")
  unique_combs= unique(comb_groups)
  comb_groups= as.integer(lapply(comb_groups, function(x){
    which(x == unique_combs)
  }))
  combined_table$combined_groups= comb_groups
  unique_features= which(as.logical(apply(combined_table[,1:3], 2,
                                          function(x){
                                            length(unique(x)) > 2
                                          })))
  if(length(unique_features)> 1){
    comb_titles= as.character(apply(combined_table[,unique_features], 1, paste, collapse= " "))
  }else{
    comb_titles= combined_table[,unique_features]
  }
  comb_clusters= list(comb_titles[comb_groups == 1])
  if(length(unique(comb_groups_uni)) > 1){ #non-ideal. Cluster objects are lists of lists- so need to be appended sequentially. Also cannot just NA then for loop 1:ect as NA will be included in list.
    for(i in 2:length(unique(comb_groups_uni))){
      comb_clusters= c(list(comb_titles[comb_groups == i]), comb_clusters)
    }
  }
  comb_tables_managable= as.character(lapply(comb_clusters, function(x){
    x= unlist(x)
    paste(gsm.title.managable(x[1]), collapse= "_")
  }))

  label_score= get_score_labels(comb_tables_managable)

  #no treated sample identified- use supervised.analysis
  if(!(
    any(label_score == 0) &
    any(label_score != 0)
  )
  ){
    stop("No control or treated samples identified- use supervised.analysis")
  }

  message("Control samples are:")
  ctrl_samples= comb_tables_managable[label_score == 0]
  treated_samples= comb_tables_managable[label_score != 0]
  message(ctrl_samples)
  if(is.null(ctrl_samples)){
    stop("No control samples identified")
  }

  gsm_template= rep("X", nrow(combined_table))
  experiment_sets= NA
  end_funct= F
  while(is.na(experiment_sets[1]) | end_funct | is.null(experiment_sets)){
    for(i in 1:length(ctrl_samples)){
      message(paste("For this control sample", ctrl_samples[i]))
      message("What are the treated samlpes?")
      message(paste(1:length(treated_samples),
                  treated_samples))
      treated_indices= readline(prompt="Select treated samples like 1 2 3: ")
      treated_indices= as.numeric(unlist(strsplit(treated_indices, " ")))
      #treated_indices= gsub("[',']|[A-Z]|[a-z]", "", treated_indices) #readline provides string- need to convert to numeric list
      treated_indices= treated_indices[!is.na(treated_indices)]
      treated_indices= treated_indices[treated_indices %in% 1:length(treated_samples)]
      if(length(treated_indices) > 0){
        ctrl_indice= which(as.character(comb_tables_managable) == ctrl_samples[i])
        treated_indices= which(as.character(comb_tables_managable) %in% treated_samples[treated_indices])
        def_gsm_temp= gsm_template
        def_gsm_temp[comb_groups == ctrl_indice]= 0
        def_groups= NA
        for(i in 1:length(treated_indices)){
          def_gsm_temp= def_gsm_temp
          def_gsm_temp[comb_groups == treated_indices[i]]= 1
          def_gsm_temp= paste(def_gsm_temp, collapse= "")
          def_groups= c(def_groups, def_gsm_temp)
          }
        experiment_sets= c(experiment_sets, def_groups[-1])
        }

    }
    experiment_sets= experiment_sets[!is.na(experiment_sets)]
    if(length(experiment_sets) == 0){
      end_funct= readline(prompt=
                            "No groups idenfied- need to exit?")
      end_funct= response %in% c("y","yes","ye","t","tru","true", "yep",
                                 "yup")
    }
  }


  #below gets rid of invalid experiment sets where only one replicate (n <= 1) in either comparison. limma cant deal with that.
  experiment_sets= experiment_sets[as.logical(lapply(experiment_sets,
                                                     experiment.set.check))]
  output_titles=
    get.experiment.designs.manual(comb_groups
                                  ,comb_clusters, experiment_sets)

  if(length(experiment_sets) < 1){ #ensures at least one experiment set is present.
    stop("INVALID CLUSTERS- only one replicate in all clusters / single cluster identified. Use supervised.analysis or manual.analysis")
  }
  experiment_data= NULL


  message("The comparisons are as follows") # have to put it here as switch messages the titles
  output_titles= get.experiment.designs.manual(comb_groups,comb_clusters, experiment_sets)
  check_output_file_length= as.logical(lapply(output_titles, function(x){
    nchar(x) > 40
  }))
  if(any(check_output_file_length)){
    for(i in which(check_output_file_length)){
      output_titles[i]= shorten_output_titles(output_titles[i])
    }
  }

  print(output_titles)
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
