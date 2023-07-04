#for automated analysis when there are multiple controls with a single point of comparison
cut_down_redundancy= function(control_indices,
                              treated_indices,
                              label_score,
                              comb_tables_managable_table,
                              gsm_template,
                              comb_groups,
                              experiment_sets){
  ori_experiment_sets= experiment_sets
  #removing redundancy in treated samples titles
  #by identifiying words unique to the treated samples
  treated_samples= comb_tables_managable_table[label_score != 0,1]
  treated_samples_frame= data.frame(do.call(rbind,
                                    lapply(treated_samples,
                                           break.down.combined.titles)))
  repeated_words= !as.logical(apply(treated_samples_frame, 2,
                                   function(x){
                                     any(x[1] != x[-1])
                                   }))
  repeated_words= treated_samples_frame[1, repeated_words]
  repeated_words= unique(repeated_words)
  repeated_words= repeated_words[
    as.integer(lapply(repeated_words, function(q){
      sum(sample(grepl(q, treated_samples)))
    })) == length(treated_samples)

  ]
  treated_samples= gsub(paste0(repeated_words, collapse = "|"), "", treated_samples)
  treated_samples= gsub("_$", "", treated_samples)
  treated_samples= gsub("_$", "", treated_samples)
  def_groups= NA
  for(control_indice in control_indices){
    #print(control_indice)
    def_gsm_temp= gsm_template
    def_gsm_temp[comb_groups == control_indice]= 0
    treated_indice_valid_comparison=
    for(treated_indice in treated_indices){
      #deal with gaps when removing repeated words
      cluster_words= gsub("___", "_",
                          treated_samples[which(treated_indice == treated_indices)])
      cluster_words= gsub("__", "_",
                          cluster_words)
      cluster_words= gsub("_", "|",
                          cluster_words)


      if(grepl(cluster_words, comb_tables_managable_table[control_indice,1])){
        def_gsm_temp_perm= def_gsm_temp
        def_gsm_temp_perm[comb_groups == treated_indice]= 1
        def_gsm_temp_perm= paste(def_gsm_temp_perm, collapse= "")
        def_groups= c(def_groups, def_gsm_temp_perm)
      }
      }
  }
  #cases where I cant match any of the controls with treated samples
  if(!any(!is.na(def_groups))){
    message("Unable to reduce reduncancy of pairwise comparisons- sticking with full list")
    def_groups= ori_experiment_sets

    }
  def_groups= def_groups[!is.na(def_groups)]
  return(def_groups)
}
