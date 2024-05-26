\name{semi.supervised.analysis}
\alias{semi.supervised.analysis}
\title{Automating the clustering and production of output csvs when there are multiple controls or multiple treated and only a single relevant control group.}
\usage{
semi.supervised.analysis(GEO_id,  path="~/", platform= "NONE", meta_data_and_combined= F, limma_or_rankprod= "limma",words_only= F)
}

\Arguments{
\item{GEO_id}{a character GEO id used like GSE84881}
\item{platform}{a character- the platform to be used as dataseries can have multiple platforms- none specified- uses the first one in the gset object}
\item{limma_or_rankprod}{Whether to use limma or RankProd to produce the differentially expressed gene list- limma by default}
\item{words_only}{exlude numbers in sample names from clustering}
}
\description{
Designed for studies like GSE130402 and GSE108345 where there are multiple distinct experiments within the GEO dataset i.e. multiple control samples. Unlike semi.supervised.analysis- less control and automates control and treated identification.
Requires a valid GSE id- can be obtained using GEOquery::getGEO(valid_platform_id). Provides the user more control when clustering samples- by first clustering samples by title, characteristics, or combined (by samples' titles, source and characteristics). The user is then prompted to select which method or exit out and perform manual clustering via manual.analysis. User can specify a path to save the meta data table along with the analysed expression data once a valid GSE id has been provided. Thereafter, the user can then select which pairwise comparisons to do.
meta_data_and_combined boolean when true saves a metadata table describing the comparisons whilst the combined table saves a csv table containing the sample sources, titles and characteristics.
words_only used when clustering by title- occassionally studies like GSE79695 have unecessary id numbers- this removes them improving the clustering capabilities.
}
\examples{
require(GEOquery)
#GEOquery::GPL570_list= getGEO('GPL570') #only needed if you require a list of valid GSE codes.
semi.supervised.analysis(GEO_id= "GSE130402", path= "~/", meta_data_and_combined= T)
#CHECK YOU WORKING DIRECTORY- getwd() I.E. cd ~/ then ls in terminal. Metadata and comparison csv(s) should be present
#alternative with words only
semi.supervised.analysis(GEO_id= "GSE79695", path= "~/", meta_data_and_combined= T,
words_only= T)
}
