\name{semi.supervised.cluster}
\alias{semi.supervised.cluster}
\title{Automating the clustering of a GEO dataset and export experiment comparisons as a dataframe}
\usage{
semi.supervised.cluster(GEO_id,  path="~/", platform= "NONE")
}
\description{
Like semi.supervised.analysis but instead outputs the gsm experiment sets for limma or RankProd using the setup.comparisons or setup.comparisons.RP functions. Outputs the experiment design like XXX000111 with 0 representing a control sample and 1 representing a treated sample. X excluded from the comparison
}
\examples{
require(GEOquery)
GEO_id= "GSE108345"
#GEOquery::GPL570_list= getGEO('GPL570') #only needed if you require a list of valid GSE codes.
experiment_sets= semi.supervised.cluster(GEO_id= GEO_id, path= "~/")
experiment_sets #0= control 1= treated
#then produce a DEG list for the first comparison
gset= obtain.gset(GEO_id, platform= "GPL570")
comparison_1_DEGs= setup.comparisons(experiment_sets[1,2], GEOset= gset)

}
