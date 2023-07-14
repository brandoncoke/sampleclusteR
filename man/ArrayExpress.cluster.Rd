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
For clustering a meta data frame formatted as a Sample and Data Relationship Format (.sdrf) meta data tables. User specifies the Sample and Data Relationship Format file location. concise produces a clustered frame without the columns used to cluster the samples. Sample groups column of the clustered frame shows the text used to cluster the sample with the features appended with a colon (:) e.g. Organism:.
}
\examples{
  ArrayExpress.cluster(
  sdrf_loc= "https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/935/E-MTAB-11935/Files/E-MTAB-11935.sdrf.txt",
  concise= TRUE
  )

}
