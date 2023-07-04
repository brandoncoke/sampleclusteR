\name{cut_down_redundancy}
\alias{cut_down_redundancy}
\title{Assigning sample groups based on cluster}
\usage{
cut_down_redundancy(control_indices,
                              treated_indices,
                              label_score,
                              comb_tables_managable_table,
                              gsm_template,
                              comb_groups)
}
\description{
Used in automated analysis to generate the experiment designs- 0 is control and 1 is treated. X is excluded
}
\examples{
GEO_id="GSE30494"; words_only= F; platform= "NONE"
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

  #instances where titles are all unique- so cannot cluster
  if(length(source_clusters) > (nrow(combined_table)-1)){
    combined_table$souceInfo= "_"
    gsm_source= rep("Sample", nrow(combined_table))
    source_clusters= list("Sample")
  }

  combined_table$source_groups= as.integer(lapply(gsm_source,
                                                  assign.group,
                                                  source_clusters))
  comb_groups= as.numeric(apply(combined_table[, 4:6], 1, sum)) #so if no new groups identified from an attribute- i.e. sample titles; column values are the same so no new groups identified when sum taken
  comb_groups_uni= unique(comb_groups)
  comb_groups= as.numeric(lapply(comb_groups, function(value){ #resets groups back to 1 to X
    which(value == unique(comb_groups_uni))}))
  combined_table$combined_groups= comb_groups
  #remove excess text from combined text
  unique_features= which(as.logical(apply(combined_table[,1:3], 2,
                                          function(x){
                                            length(unique(x)) > 1
                                          })))
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

  #automated.analysis means no human interference
  gsm_template= rep("X", nrow(combined_table))
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
  }
  #multiple controls so use function
  cut_down_redundancy(control_indices,
                                             treated_indices,
                                             label_score,
                                             comb_tables_managable_table,
                                             gsm_template,
                                             comb_groups)

}
