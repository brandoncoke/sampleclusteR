\name{gsm.characteristics.managable}
\alias{gsm.characteristics.managable}
\title{Making the characteristic cluster frame more usable for clustering.}
\usage{
gsm.characteristics.managable(characteristic)
}
\Arguments{
\item{characteristic}{a character array with characternames}
}
\description{
Used in characteristic.clustering function. Makes the characteristic titles more managable i.e. removes the excess text like "biological replicate" so when the samples are clustered via diasy there are fewer errors and incorrect sample clusters}

\examples{
gset= obtain.gset(GEO_id)
gsm_characteristics= obtain.charateristics(gset)
data.frame(do.call(rbind,lapply(gsm_characteristics, gsm.characteristics.managable)))
}
