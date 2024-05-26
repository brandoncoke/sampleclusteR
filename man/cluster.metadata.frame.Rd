\name{cluster.metadata.frame}
\alias{cluster.metadata.frame}
\title{Get score for samples}
\usage{
cluster.metadata.frame(meta_data_frame,
columns_to_cluster= NULL,
consise=TRUE
)
}
\Arguments{
\item{meta_data_frame}{dataframe of metdata- columns represent details rownames the samples' names}
\item{columns_to_cluster}{Specify a subset of sample columns to use- NULL by default uses all of them}
\item{consise}{Makes the output of the clustered metadata more consise only outputting the columns used in the clustering process}
}
\description{
For clustering a meta data frame. User specifies a meta data frame describing their samples. If no columns are specified via the columns_to_cluster option then the function clusters the samples using all of the features in the metadata column. The consise set to TRUE or T then the function only displays the combined  clustered groups
}
\examples{
  meta_data_frame=  get.combined.table(obtain.gset("GSE35351", platform= "GPL570"),T)
  #columns describe the samples
  cluster.metadata.frame(meta_data_frame,
  columns_to_cluster= 1:3,
  consise=FALSE
  )

}
