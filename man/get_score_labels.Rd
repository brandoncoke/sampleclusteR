\name{get_score_labels}
\alias{get_score_labels}
\title{Get score for samples}
\usage{
get_score_labels(sample_names)
}
\Arguments{
\item{sample_names}{character with sample names)}
}
\description{
Assigns 1 for upregulated samples, 2 downregulated sample and 0 for control samples when provided with a string of sample names
}
\examples{
sample_names= c("WT", "WT", "miNC", "niNC", "KD_COL1A1", "KD_COL1A1", "COL1A1_induced", "COL1A1_+")
  get_score_labels(sample_names)
  #based on these sample cluster names
  sample_names
}
