\name{setup.comparisons}
\alias{setup.comparisons}
\title{Analyse data set using RankProd with a experiment design}
\usage{
setup_comparisons_RP(exp_groups,GEOset,rand_seed= 0451)
}
\description{
Used in the automated analysis function. Requires GEO data set and experiment groups (created by set.exp.groups) and a random seed (to ensure consistent values between runs). RankProd is described by Breitling <i> et al </i> 2004 (DOI: 10.1016/j.febslet.2004.07.055) and updated paper by Del Carratore <i>et al</i> 2017 (DOI: 10.1093/bioinformatics/btx292)}
\examples{
gset= obtain.gset("GSE84881") #getting geo dataset
gsm_titles= obtain.gsm.titles(gset) #getting titles as we are clustering samples via their titles
title_clusters= title.clustering(gsm_titles)
groups= as.integer(lapply(gsm_titles, assign.group, title_clusters)) #groups to compare
exp_groups= set.exp.groups(groups)
lapply(exp_groups, setup.setup_comparisons_RP , GEOset= gset, randseed= 0451) #seed is not neccessary- just ensures consistency when code re-run
}
