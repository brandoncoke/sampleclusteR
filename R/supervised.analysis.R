#GEO_id="GSE79695";  path="~/"; platform= "GPL570"; selection= 1; words_only= T #debugging
supervised.analysis= function(GEO_id,  path="~/", platform= "NONE", meta_data_and_combined=T,
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
  title_clusters= title.clustering(gsm_titles, words_only)
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
  comb_titles= as.character(apply(combined_table[,1:3], 1, paste, collapse= " "))
  comb_clusters= list(comb_titles[comb_groups == 1])
  if(length(unique(comb_groups_uni)) > 1){ #non-ideal. Cluster objects are lists of lists- so need to be appended sequentially. Also cannot just NA then for loop 1:ect as NA will be included in list.
    for(i in 2:length(unique(comb_groups_uni))){
      comb_clusters= c(list(comb_titles[comb_groups == i]), comb_clusters)
    }
  }


  #User inputs below
  print(combined_table) #Table of automated clusters with sample titles, characteristics and sources.
  message("Select the groups for the sample comparison: 1: title_groups, 2: characteristic_groups, 3: source_groups, 4: combined_groups, 5: Manual assignment")
  selection= 0
  while(!(selection %in% 1:5)){ #if user doesn't specify a valid answer
    selection= as.numeric(
      readline(prompt="Enter an integer from 1 to 5: "))
  }
  switch(selection,
         message("Clustering based on title."),
         message("Clustering based on characteristics."),
         message("Clustering based on source."),
         message("Clustering based on title, characteristics and source."),
         stop("Use manual.analysis and cluster using user defnined groups."))
  groups= switch(selection, #getting group vector
                 combined_table$title_groups,
                 combined_table$characteristic_groups,
                 combined_table$source_groups,
                 combined_table$combined_groups,
                 {"This shouldn't happen"})
  if(length(unique(groups)) < 2){ #quick drop out if invalid clusters picked- no comparisons possible
    stop("Chosen clusters doesnt have any comparisons to make")
  }
  experiment_sets= manual.exp.sets(groups, combined_table= combined_table)
  #below gets rid of invalid experiment sets where only one replicate (n <= 1) in either comparison. limma cant deal with that.
  experiment_sets= experiment_sets[as.logical(lapply(experiment_sets,
                                                     experiment.set.check))]
  if(length(experiment_sets) < 1){ #ensures at least one experiment set is present.
    stop("INVALID CLUSTERS- only one replicate in all clusters / single cluster identified. Need to manually assign groups with manual.analysis")
  }
  experiment_data= NULL


  message("The comparisons are as follows") # have to put it here as switch messages the titles
  output_titles= switch(selection, #getting output file names
                        get.experiment.designs.manual(groups,title_clusters,experiment_sets, words_only),
                        get.experiment.designs.manual(groups,charateristics_clusters, experiment_sets),
                        get.experiment.designs.manual(groups,source_clusters, experiment_sets),
                        get.experiment.designs.manual(groups,comb_clusters, experiment_sets))

  print(output_titles)
  check_output_file_length= as.logical(lapply(output_titles, function(x){
    nchar(x) > 100
  }))
  if(any(check_output_file_length)){
    for(i in which(check_output_file_length)){
      output_titles[i]= shorten_output_titles(output_titles[i])
    }
  }

  lapply(1:length(experiment_sets), exporting.csvs,
         experiment_sets= experiment_sets, GEOset= gset,
         limma_or_rankprod= limma_or_rankprod, path= path,output_titles= output_titles,
         GEO_id= GEO_id)

  if(meta_data_and_combined){
    meta_frame= do.call(rbind, lapply(experiment_sets, count_ctrl_treated))
    meta_frame= as.data.frame(meta_frame)
    colnames(meta_frame)= c("Control", "Treated")
    meta_frame$block_name_id= paste0(GEO_id, "_", output_titles)
    meta_frame$gse= GEO_id
    write.csv(meta_frame, paste0(path, GEO_id, "_metadata.csv"), row.names= F)
  }
}
