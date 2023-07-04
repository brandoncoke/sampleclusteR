\name{gsm.title.managable}
\alias{gsm.title.managable}
\title{Making the title cluster frame more usable for clustering.}
\usage{
gsm.title.managable(title)
}
\description{
Used in title.clustering function. Makes the sample titles managable when creating a title dataframe. i.e. removes the excess text like "biological replicate" so when the sample is clustered via diasy it is better at detecting true replicates}

\examples{
gset= obtain.gset(GEO_id)
gsm_titles= obtain.gsm.titles(gset)
data.frame(do.call(rbind,lapply(gsm_titles, gsm.title.managable)))
}
