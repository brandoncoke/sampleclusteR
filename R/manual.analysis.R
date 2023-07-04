#GEO_set= gset; assigned_groups = groups; path= "~/"; clustering, meta_data_and_combined= F; limma_or_rankprod= "limma"
manual.analysis= function(GEO_set,assigned_groups, group_names= NA, path="~/", clustering, meta_data_and_combined= T,
                          limma_or_rankprod= "limma"){
  GEO_id= GEO_set@experimentData@other[["geo_accession"]]
  print(paste0("Analysing ", GEO_id,
               " via manual group assignment.")) #preamble
  combined_table= get.combined.table(GEO_set, T) #table of sample titles, source and characteristics
  if(length(assigned_groups) != nrow(combined_table)){ #quick exit if user does provide a valid list of groups
  stop(paste0("Invalid assigned groups!!! Needs to be ", nrow(combined_table), " long!"))} #message to fix error
  combined_table$assigned_group= assigned_groups #slapping on user defined groups
  print("Groups are as follows")
  print(combined_table)
  selection= readline(prompt="Are your group clusters correct?")
  selection= tolower(selection)
  while(!(tolower(selection) %in% c("y","yes","ye","n","no","nope","nop"))){ #if user doesnt specify a valid answer
    selection= readline(prompt="Please answer yes or no. Are your group clusters correct?")
    print(combined_table)
  }
  if(tolower(selection) %in% c("n","no","nope","nop")){
  stop("Re-enter your groups list in the function i.e. manual.analysis")}
  dup_groups_no_X= assigned_groups[assigned_groups != "X"]
  dup_groups_no_X= unique(dup_groups_no_X[duplicated(dup_groups_no_X)])
  output_titles= NULL
  for(i in 1:(length(dup_groups_no_X)-1)){ #brackets needed
    base_group= dup_groups_no_X[i]
    comparison_groups_identified= dup_groups_no_X[(i+1):length(dup_groups_no_X)]
    output_titles= c(output_titles,
              paste0(base_group,"_VS_", comparison_groups_identified))
  }
  groups_for_designs= assigned_groups
  for(i in 1:length(dup_groups_no_X)){
    #print(groups_for_designs)
    groups_for_designs[assigned_groups == dup_groups_no_X[i]]= i
  }
  experiment_sets= set.exp.groups(groups_for_designs)
  #below gets rid of invalid experiment sets where only one replicate (n <= 1) in either comparison. limma cant deal with that.
  experiment_sets= experiment_sets[as.logical(lapply(experiment_sets,
                                                     experiment.set.check))]
  experiment_data= NULL

  print("The comparisons are as follows:")
  print(output_titles)
  #lapplying the export as slightly faster than for looping
  lapply(1:length(experiment_sets), exporting.csvs,
         experiment_sets= experiment_sets, GEOset= gset,
         limma_or_rankprod= "limma", path= path,output_titles= output_titles,
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
