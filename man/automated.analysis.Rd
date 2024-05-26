\name{automated.analysis}
\alias{automated.analysis}
\title{Automating the clustering of GEO data series.}
\usage{
automated.analysis(GEO_id,  path="~/", platform= "NONE",
limma_or_rankprod= "limma")
}
\Arguments{
\item{GEO_id}{a character GEO id used like GSE84881}
\item{platform}{a character- the platform to be used as dataseries can have multiple platforms}
\item{limma_or_rankprod}{Whether to use limma or RankProd to produce the differentially expressed gene list- limma by default}
}
\description{
For clustering a meta data frame formatted as a Sample and Data Relationship Format (.sdrf) meta data tables. User specifies the Sample and Data Relationship Format file location (sdrf loc). concise produces a clustered frame without the columns used to cluster the samples. Sample groups column of the clustered frame shows the text used to cluster the sample with the features appended with a colon (:) e.g. Organism:.
}
\description{
Automates the clustering of a GEO data series based on study metadata alone. User can specify a path to save the meta data table along with the analysed expression data once a valid GSE id has been provided. Platform specifies the platform associated with the GEO dataset used in the analysis.  limma_or_rankprod specifies if user wants to use either limma (10.1093/nar/gkv007) or RankProd (10.1093/bioinformatics/btx292) to caculate fold changes.
If an experiment has multiple controls- supervised.analysis is recommended.
}
\examples{
automated.analysis("GSE84881", "~/")
#CHECK YOU WORKING DIRECTORY- getwd() I.E. cd ~/ then ls in terminal. Metadata and comparison csv(s) should be present
}
