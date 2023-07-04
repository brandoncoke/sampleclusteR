#Package installation
if("gprofiler2" %in% rownames(installed.packages()) == FALSE){
  install.packages("gprofiler2")}
require(gprofiler2)
if("ggplot2" %in% rownames(installed.packages()) == FALSE){
  install.packages("ggplot2")}
if("gplots" %in% rownames(installed.packages()) == FALSE){
  install.packages("gplots")}
require(ggplot2)
if("ggVennDiagram" %in% rownames(installed.packages()) == FALSE){
  install.packages("ggVennDiagram")}
require(ggplot2)
if("devtools" %in% rownames(installed.packages()) == FALSE){
  install.packages("devtools")}
if("GEOcluster" %in% rownames(installed.packages()) == FALSE){
  devtools::install_github("brandoncoke/GEOcluster,")}
require(GEOcluster)
#saving in the only place that will be present the working directory
csv_loc= "~/"
#Obtain DEG lists
GSEs_interested_in= c("GSE17385",
                      "GSE56896",
                      "GSE57728",
                      "GSE44097")
#time to analyse data series
lapply(GSEs_interested_in,
       automated.analysis,
       path= csv_loc,
       platform= "GPL570",
       limma_or_rankprod= "limma"
)
#speedier on mac or linux (even WSL on windows) with the code below
#assuming you have 4 threads for forking- i.e. don't run this on
# a cheap computer
#require(parallel)
#mclapply(GSEs_interested_in,
#       automated.analysis,
#       path= csv_loc,
#       platform= "GPL570",
#       limma_or_rankprod= "limma",
#       mc.cores = 4
#)
#pick out the csvs for analysis- do know how cluttered home directory is
#doing a quick filter
my_csvs= list.files(csv_loc)
my_csvs= my_csvs[grepl(paste0(GSEs_interested_in,collapse =  "|"), my_csvs) &
                   grepl(".csv$", my_csvs)]
#here are the csvs from the analysis
my_csvs
#Selecting a subset of the csvs
csvs_interested_in= c("GSE17385_pKLO_GFP_control_vs_pKLO_beta_catenin_shRNA",
                      "GSE57728_Control_siRNA_at_T48_AsPC_1_transfected_with_20nM_vs_CTNNB1_siRNA_at_T48_AsPC_1_transfected_with_20nM_",
                      "GSE56896_LS174T_ET_1_vs_LS174T_NET_1",
                      "GSE44097_SW480_siRNA_mock_treated_vs_SW480_siRNA_treated"
)
#titles automatically generated- and so may cut early to ensure file name
#length is not too long
#time to process the DEG lists generated from limma
process_DEG_frame= function(limma_DEG_frame_loc){
  if(!file.exists(limma_DEG_frame_loc)){
    stop(paste0(limma_DEG_frame_loc, " does not exist!"))
  }
  the_frame= read.csv(limma_DEG_frame_loc)
  #obtain statstically significant DEGs with absolute fold changes > 2
  the_filter= the_frame$P.Value <= 0.05 &
    abs(the_frame$logFC) >= 1
  the_frame= subset(the_frame, the_filter)
  the_frame= the_frame[ , c("GEO_id", "Gene.symbol", "Gene.ID",
                            "logFC")]
  the_frame= the_frame[!duplicated(the_frame$Gene.symbol), ]
  return(the_frame[!is.na(the_frame$Gene.symbol), ])

}
#create frame of shared DEGs
shared_DEGs= do.call(rbind, lapply(paste0(csv_loc, csvs_interested_in, ".csv"),
                                   process_DEG_frame))
venn_list <- list(
  GSE17385= shared_DEGs$Gene.ID[shared_DEGs$GEO_id == "GSE17385"],
  GSE57728= shared_DEGs$Gene.ID[shared_DEGs$GEO_id == "GSE57728"],
  GSE56896= shared_DEGs$Gene.ID[shared_DEGs$GEO_id == "GSE56896"],
  GSE44097= shared_DEGs$Gene.ID[shared_DEGs$GEO_id == "GSE44097"])
require(ggVennDiagram)
ggVennDiagram(venn_list) +
  scale_fill_gradient2(name="Number of DEGs",
                       low="blue",
                       mid= "white",
                       high = "red") +
  labs(title =
         "Shared differentially expressed genes (DEGs) across studies")
ggsave("~/Venn diagram of 4 Wnt disruption studies.png",width=3000,height= 1500,units = "px")

#Obtain list of differentially expressed genes (DEGs) shared in at least 2 of the four studies
count_DEG_appearance= table(shared_DEGs$Gene.symbol) > 2
shared_DEG_array= names(count_DEG_appearance[count_DEG_appearance])
#deal with probes targetting multiple genes
shared_DEG_array= as.character(unlist(strsplit(shared_DEG_array, "/[/][/]")))
#Gene ontology (GO) analysis
require(gprofiler2)
gostres= gost(query = shared_DEG_array, #gprofiler search
              organism = "hsapiens",
              sources= c("GO:BP", "REAC", "CORUM"),
              correction_method= "fdr",
              significant= T)
GOs= gostres$result
#rank by most statstically signficant terms
GOs= GOs[order(GOs$p_value), ]
#ensures bars in right order
GOs$term_name= factor(GOs$term_name,
                      levels= GOs$term_name[order(GOs$p_value, decreasing = T)])
GOs$log10pval= -log10(GOs$p_value)
#get top GOs- most statstically significant
top_gos= head(GOs,10)
#gostplot(gostres)
ggplot(top_gos, aes(x=log10pval,
                    y= term_name)) +
  geom_bar(stat = "identity", aes(fill= source)) + #008080 for pres
  theme_minimal() +
  scale_x_continuous(expand = c(0,0)) +
  labs(x="-log10(p-value)",y="GO term",title = "Gene ontology (GO) analysis of shared DEGs") +
  scale_fill_manual("Source of GO term", values= c("red", "blue", "purple", "darkgreen"))
ggsave("~/GO analysis of shared DEGs.png",width=3000,height= 1000,units = "px")

#heatmap of Wnt responsive genes
require(gplots)
data("wnt_responsive_genes") #part of the package
#wnt_responsive_genes= read.csv("~/wnt_responsive_genes.csv") #csv found at git repo here
#removing non-vertebrate species wingless targets (wnt othrologue)
wnt_responsive_genes= unique(wnt_responsive_genes$Gene[wnt_responsive_genes$Organism.system !=
                                                         "Drosophila"])
wnt_responsive_genes= wnt_responsive_genes[wnt_responsive_genes != ""]

obtain_wnt_fcs= function(limma_DEG_frame_loc){
  if(!file.exists(limma_DEG_frame_loc)){
    stop(paste0(limma_DEG_frame_loc, " does not exist!"))
  }
  the_frame= read.csv(limma_DEG_frame_loc)
  the_frame= subset(the_frame, Gene.symbol %in% wnt_responsive_genes)
  #obtain statstically significant DEGs with absolute fold changes > 2
  the_filter= the_frame$P.Value <= 0.05
  the_frame= subset(the_frame, the_filter)
  #redundant probes- get greatest change compared to control
  greatest_FC_change_compared_to_control= as.data.frame(tapply(the_frame$logFC,
                                                               the_frame$Gene.symbol,
                                                               function(x){
                                                                 x= x[!is.na(x)]
                                                                 maximum= which.max(x)
                                                                 minimum= which.min(x)
                                                                 if(abs(x[minimum]) > abs(x[maximum])){
                                                                   x[minimum]
                                                                 }else{
                                                                   x[maximum]
                                                                 }


                                                               }
  ))
  colnames(greatest_FC_change_compared_to_control)= the_frame$GEO_id[1]

  greatest_FC_change_compared_to_control$gene=
    row.names(greatest_FC_change_compared_to_control)

  row.names(greatest_FC_change_compared_to_control)=
    1:nrow(greatest_FC_change_compared_to_control)
  #greatest_FC_change_compared_to_control$genes= row.names(
  #  greatest_FC_change_compared_to_control
  #)
  return(greatest_FC_change_compared_to_control)
}
#have to merge
#heatmap_frame= do.call(rbind, lapply(paste0(csv_loc, csvs_interested_in, ".csv"),
#                                   obtain_wnt_fcs))
#as.data.frame(t(unstack(heatmap_frame,1~gene)))
heatmap_frame= obtain_wnt_fcs(paste0(csv_loc, csvs_interested_in[1], ".csv"))
for(i in 2:length(csvs_interested_in)){
  temp= obtain_wnt_fcs(paste0(csv_loc, csvs_interested_in[i], ".csv"))
  heatmap_frame= merge(heatmap_frame, temp, all= T)
}
heatmap_frame[is.na(heatmap_frame)]= 0
row.names(heatmap_frame)= heatmap_frame$gene
heatmap_frame= heatmap_frame[ , -1]
heatmap_frame= as.matrix(heatmap_frame)
require(gplots)
tiff("~/heatmap_wnt_targets.tiff",width=1200,height= 1200,units = "px")
gplots::heatmap.2(heatmap_frame,
          main="Wnt downstream fold changes",
          cexRow = 1,
          density.info="none",
          trace="none",
          key=T,
          srtCol=0,
          col = "bluered",
          labCol = colnames(heatmap_frame),
          labRow= rownames(heatmap_frame),
          dendrogram = 'row',
          scale = "col",
          #ylab="Wnt downstream target",
          #xlab="GEO data series"
)
dev.off()

#string network proteins
DEGs= unique(shared_DEG_array)
DEGs= DEGs[!is.na(DEGs) |
             DEGs == ""]
subset_shared_DEGs= subset(shared_DEGs,
                           Gene.symbol %in% DEGs)
subset_shared_DEGs$gene= factor(subset_shared_DEGs$Gene.symbol)
#get average absoluted log fold change across 4 studies- exclude NAs. Convert to dataframe
mean_absolute_fold_change=  as.data.frame(tapply(abs(subset_shared_DEGs$logFC),
                                                 subset_shared_DEGs$gene,
                                                 mean,
                                                 na.rm= T #exclude NAs
))
mean_absolute_fold_change[ , 1]= mean_absolute_fold_change[,1]
mean_absolute_fold_change$gene= row.names(mean_absolute_fold_change)
colnames(mean_absolute_fold_change)[1]= "mean_abs_logFC"
#export for string network
write.csv(mean_absolute_fold_change,
          "~/string_network_metadata.csv",
          row.names= F)
