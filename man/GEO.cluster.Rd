\name{geo.cluster}
\alias{geo.cluster}
\title{Automating the clustering and production of output csvs.}
\usage{
geo.cluster(GEO_id, platform= "NONE", words_only= F)
}
\description{
Clusters GEO data series based on study metadata alone. Produces a dataframe with the different samples' metadata and the groups they are a part of. Platform specifies the platform associated with the GEO dataset used in the analysis.
}
\examples{
geo.cluster("GSE84881")
#CHECK YOU WORKING DIRECTORY- getwd() I.E. cd ~/ then ls in terminal. Metadata and comparison csv(s) should be present
}
