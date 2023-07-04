\name{ArrayExpress.cluster}
\alias{ArrayExpress.cluster}
\title{Get score for samples}
\usage{
ArrayExpress.cluster(sdrf_loc,
columns_to_cluster= NULL,
consise=TRUE
)
}
\description{
For clustering a meta data frame formatted as a Sample and Data Relationship Format (.sdrf) meta data tables. User specifies the Sample and Data Relationship Format file location.The broad_cluster boolean argument attempts to reduce the complexity of the cluster by only selecting the features which have relatively large enough groups- i.e. fewer than 75\% of samples are in a distinct group. The consise boolean dictates whether a consise table of the clustered samples is returned.
}
\examples{
  ArrayExpress.cluster(
  sdrf_loc= "https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/935/E-MTAB-11935/Files/E-MTAB-11935.sdrf.txt",
  broad_cluster= TRUE,
  consise= TRUE
  )

}
