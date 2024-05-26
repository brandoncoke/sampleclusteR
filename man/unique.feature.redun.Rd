\name{unique.feature.redun}
\alias{unique.feature.redun}
\title{Remove redundant columns when assigning automated group titles}
\usage{
unique.feature.redun(unique_features, combined_table)
}
\Arguments{
\item{unique_features}{non-redundant column indices}
\item{combined_table}{cluster frame with sample groups- use GEO.cluster or cluster.metadata.frame}
}

\description{
Exclusively used in automated.analysis and only for GEO dataseries metadata tables. Ensures there are no redundant columns when automatically generating group names}
\examples{
require(GEOcluster)
combined_table= geo.cluster("GSE57728")
unique_features= which(as.logical(apply(combined_table[,1:3], 2,
                                          function(x){
                                            length(unique(x)) > 1
                                          })))
unique_features #columns 1 and 3 used to cluster samples but cluster the same way
unique.feature.redun(unique_features, combined_table) #function identifies that column 1 is only needed to name the groups

}
