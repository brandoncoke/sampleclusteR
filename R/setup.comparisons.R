require(limma)
require(Biobase)
setup.comparisons = function(exp_groups,GEOset){
  gsms= exp_groups
  gsms= paste(gsms, collapse= "")
  Biobase::fvarLabels(GEOset) <- make.names(fvarLabels(GEOset))
  sml <- c() #enables sml to be called as a function for loop below.
  for (i in 1:nchar(gsms)) { sml[i] <- substr(gsms,i,i) } #Adding labels to microarray data.
  sel <- which(sml != "X")
  sml <- sml[sel]
  #if(length(sml[sml == "0"]) > 1 & length(sml[sml == "1"]) > 1){ #old function exit- automated.analysis already gets rid of experiment sets with a single replicate
  #  stop("Too few replicates in this cluster- manual intervention required!")
  #}
  GEOset <- GEOset[ ,sel]
  if(nrow(GEOset@assayData[["exprs"]]) > 1){
    ex <- GEOset@assayData[["exprs"]] #Dataframe of expression
    qx <- as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T)) #Getting quartiles for values
    LogC <- (qx[5] > 100) ||
      (qx[6]-qx[1] > 50 && qx[2] > 0) ||
      (qx[2] > 0 && qx[2] < 1 && qx[4] > 1 && qx[4] < 2)
    if(is.na(LogC)){LogC = F}# bodge if not much
    if (LogC) { ex[which(ex <= 0)] <- NaN #Gets rid of extreme outliers
    Biobase::exprs(GEOset) <- log2(ex) }
    gs <- factor(sml)
    groups <- make.names(c("1","2"))
    levels(gs) <- groups
    GEOset$group <- gs
    design <- model.matrix(~group + 0, GEOset)
    colnames(design) <- levels(gs)
    fit <- limma::lmFit(GEOset, design)
    cts <- paste(groups[1], groups[2], sep="-")
    cont.matrix <- limma::makeContrasts(contrasts=cts, levels=design)
    fit2 <- limma::contrasts.fit(fit, cont.matrix)
    fit2 <- limma::eBayes(fit2, 0.01)
    #tT= nrow(fit2$coefficients) #a bodge- fix in future
    tT= limma::topTable(fit2, adjust="fdr", sort.by="B", number=nrow(ex)) #bodge- numbers arbitary
    return(tT)
  }else{
    stop("Data set lacks matrix on GEO- go to https://www.ncbi.nlm.nih.gov/sra for NGS datasets.")
  }

}
