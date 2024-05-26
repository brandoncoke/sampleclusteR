\name{title.clustering}
\alias{title.clustering}
\title{Get sample metadata from a GEO dataset}
\usage{
title.clustering(gsm_titles)
}

\Arguments{
\item{gsm_titles}{character- titles for samples}
}

\description{
Creates list which clusters samples based on the sample titles names from a GEO dataset. Titles form a GEO data set can be obtained using the obtain.gsm.titles function.}
\examples{
gset= obtain.gset("GSE84881")
gsm_titles= obtain.gsm.titles(gset) #or gset@phenoData@data$title
title.clustering(gsm_titles)
}
