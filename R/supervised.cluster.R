#GEO_id="GSE108345";  path="~/"; platform= "GPL570"; selection= 1 #debugging
supervised.analysis.cluster= function(GEO_id,  path="~/", platform= "NONE", words_only= F){
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
  output_titles= switch(selection, #getting output file names
                        get.experiment.designs.manual(groups,title_clusters,experiment_sets),
                        get.experiment.designs.manual(groups,charateristics_clusters, experiment_sets),
                        get.experiment.designs.manual(groups,source_clusters, experiment_sets),
                        get.experiment.designs.manual(groups,comb_clusters, experiment_sets),
                        {"This shouldn't happen"})
  check_output_file_length= as.logical(lapply(output_titles, function(x){
    nchar(x) > 40
  }))
  if(any(check_output_file_length)){
    for(i in which(check_output_file_length)){
      output_titles[i]= shorten_output_titles(output_titles[i])
    }
  }


  return(data.frame(comparisons= output_titles, experiment_sets,
                    GEO= GEO_id))
}
