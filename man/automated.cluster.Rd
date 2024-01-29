\name{automated.cluster}
\alias{automated.cluster}
\title{Automating the clustering and production of output csvs from GEO dataseries.}
\usage{
automated.analysis(GEO_id, meta_data_and_combined=F, platform= "NONE", words_only= F)
}
\description{
Like automated.analysis- instead outputs all the group comparisons for a GEO dataseries and how they are clustered. X= Not part of any group, 0 = control or first group and 1 = Treated or second group.
}
\examples{
automated.cluster("GSE84881")
}
