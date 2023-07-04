\name{automated.analysis}
\alias{automated.analysis}
\title{Automating the clustering and production of output csvs from GEO dataseries.}
\usage{
automated.analysis(GEO_id, platform= "NONE", words_only= F)
}
\description{
Automates the clustering of a GEO data series based on study metadata alone and attempts to match control and treated samples. Platform specifies the platform associated with the GEO dataset used in the analysis
If an experiment has multiple controls- supervised.cluster is recommended.
}
\examples{
automated.cluster("GSE84881")
}
