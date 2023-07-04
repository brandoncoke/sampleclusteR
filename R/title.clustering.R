title.clustering= function(gsm_titles, words_only= F){ #modified TitleClustering
  title_table <- data.frame(do.call(rbind,
                                    lapply(gsm_titles, gsm.title.managable,
                                           words_only)))
  rownames(title_table)= gsm_titles
  title.min.dis <- get.min.diss(title_table)
  tNamesInClusters <- lapply(unique(title.min.dis),
                             function(X){return(gsm_titles[X])})
  return(tNamesInClusters)
}
