\name{geo.cluster}
\alias{geo.cluster}
\title{Get score for samples}
\usage{
geo.cluster(GEO_id,
platform= "NONE"
)
}
\Arguments{
\item{GEO_id}{GEO identifier like GSE84881- a character}
\item{platform}{GEO datasets can have multiple platforms assigned to them. To select a specific platform associated with the GEO id- enter the platform as a character e.g. GPL570}
}
\description{
Automate the clustering of GEO datasets using their metadata. Outputs a dataframe with the samples' title, source and character. Along with the groups identified and sample_type specifying if the sample is likely to be a control or treated sample.}
\examples{
  sdrf.cluster(
  GEO_id= "GSE84881",
  platform= "GPL570"
  )

}
