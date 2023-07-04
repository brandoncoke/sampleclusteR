#experiment_set_index= 1; GEOset= gset; limma_or_rankprod= limma_or_rankprod; path= path;output_titles= output_titles; GEO_id= GEO_id

exporting.csvs= function(experiment_set_index, experiment_sets= experiment_sets, GEOset= gset, limma_or_rankprod= "limma", path= path, output_titles= output_titles, GEO_id= GEO_id){
  experiment_set= experiment_sets[experiment_set_index]
  output_title= output_titles[experiment_set_index]
  limma_or_rankprod= tolower(limma_or_rankprod)
  final_path= as.character(paste0(path,GEO_id,"_",output_title,".csv"))
  #Avoid whitespace in the final file
  final_path= gsub("    ", "_", final_path)
  final_path= gsub("   ", "_", final_path)
  final_path= gsub(" ", "_", final_path)
  final_path= gsub("___", "_", final_path)
  final_path= gsub("__", "_", final_path)
  limma_or_rankprod= tolower(limma_or_rankprod)
  switch(limma_or_rankprod,
         "limma"={experiment_data= setup.comparisons(GEOset = GEOset,
                                                     exp_groups = experiment_set);
         experiment_data$GEO_id= GEO_id
         write.csv(experiment_data, final_path)},
         "rankprod"={experiment_data= setup.comparisons.RP(GEOset = GEOset,
                                                           exp_groups = experiment_set);
         write.csv(experiment_data, final_path, row.names = F)},
         {print('Invalid analysis method (limma_or_rankprod argument)- either limma or rankprod')}) #Default outcome
}
