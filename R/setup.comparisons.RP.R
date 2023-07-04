setup.comparisons.RP= function(exp_groups,GEOset,rand_seed= 0451, up_or_down= "both"){
  if("BiocManager" %in% rownames(installed.packages()) == FALSE){
    install.packages("BiocManager")}
  require("BiocManager")
  if("RankProd" %in% rownames(installed.packages()) == FALSE){
    BiocManager::install("RankProd")}
  require("RankProd")
  rank_prod_comp= unlist(strsplit(as.character(exp_groups), ""))
  rank_prod_comp_subset= as.numeric(rank_prod_comp[rank_prod_comp != "X"])
  Biobase::fvarLabels(GEOset) <- make.names(fvarLabels(GEOset))
  express_data= GEOset@assayData[["exprs"]]
  express_data= as.matrix(express_data)
  express_data=express_data[ , rank_prod_comp != "X"] #no nas just the cols with the values
  exp_groups= exp_groups[which(!is.na(exp_groups))] # as dropping the cols- no NAs can be in the groups
  rank_object <- RankProd::RankProducts(express_data, rank_prod_comp_subset, logged=TRUE, #getting rankprod FCs
                                        gene.names = rownames(express_data),
                                        na.rm=FALSE,plot=FALSE,  rand=rand_seed)
  RPs= RankProd::topGene(rank_object,cutoff=0.05,method="pfp",
                         logged=TRUE,logbase=2,
                         gene.names=rownames(express_data))
  switch(tolower(up_or_down),
         "down"={
           RPs[["Table2"]]},
         "up"={
           return(RPs[["Table1"]])
         },
         {return(rbind(RPs[["Table1"]], RPs[["Table2"]]))}) #Default outcome


   #output of both up and down reg list
}

