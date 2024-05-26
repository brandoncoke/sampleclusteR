\name{sdrf.cluster}
\alias{sdrf.cluster}
\title{Get score for samples}
\usage{
sdrf.cluster(sdrf_loc,
columns_to_cluster= NULL,
consise=TRUE
)
}
\Arguments{
\item{sdrf_loc}{a character where the sdrf is located like https://ftp.ebi.ac.uk/biostudies/fire/E-GEOD-/882/E-GEOD-60882/Files/E-GEOD-60882.sdrf.txt}
\item{columns_to_cluster}{Specify a subset of sample columns to use- NULL by default uses all of them}
\item{consise}{Makes the output of the clustered metadata more consise only outputting the columns used in the clustering process}
}
\description{
For clustering a meta data frame formatted as a Sample and Data Relationship Format (.sdrf) meta data tables. User specifies the Sample and Data Relationship Format file location (sdrf loc). concise produces a clustered frame without the columns used to cluster the samples. Sample groups column of the clustered frame shows the text used to cluster the sample with the features appended with a colon (:) e.g. Organism:.
}
\examples{
  sdrf.cluster(
  sdrf_loc= "https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/935/E-MTAB-11935/Files/E-MTAB-11935.sdrf.txt",
  concise= TRUE
  )

}
