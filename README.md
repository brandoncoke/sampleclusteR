# sampleclusteR- A R package to simiplify the clustering of samples based on their metadata

## A Quick and efficient way of clustering and analysing samples using .sdrf metadata and GEO metdata

sampleclusteR allows users to quickly analyse datasets from Gene Expression Omnibus (GEO) and ArrayExpress metadata sets (via Sample and Data Relationship Format tables (.sdrf) using a command line interface.
To cluster GEO dataseries and produce a table with samples and their clusters a user can use the geo.cluster function. Below is an example for the GSE84881 dataseries. 
```R
sampleclusteR::geo.cluster(GEO_id= "GSE84881", platform= "GPL570")
```
Conversely to cluster a .sdrf formatted metadata table- the sdrf.cluster function can be used. Below is an example use case for an ArrayExpress dataset- E-MTAB-11935. The output will be a more concise metadata table with the samples' groups.
```R
sampleclusteR::sdrf.cluster("https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/935/E-MTAB-11935/Files/E-MTAB-11935.sdrf.txt")
```
Finally, sampleclusteR enables users to automate the generation of DEGs list for a given GEO data set via the supervised.analysis.
```R
sampleclusteR::supervised.analysis(GEO_id= "GSE130402", meta_data_and_combined= T, limma_or_rankprod = "limma", path="~/")
```
### Features
sampleclusteR current features are:
- Can cluster Sample and Data Relationship Format (.sdrf) formatted metadata, for example metadata from ArrayExpress and PRIDE. 
- Can cluster datasets with user specified metadata. 
- Able to be run on the command line for more concise workflows 
- Automatically identify control and treated samples and correctly match them.
- Analyse GEO data sets using \emph{limma} or RankProd and produce a DEG list.
### Installation and requirements
sampleclusteR requires the following:
- R  (≥ 4.4.3)
- cluster (≥ 2.0)
- rockchalk (≥ 1.8)
- BiocManager (≥ 3.2)
- limma (≥ 3.2)
- Biobase (≥ 3.2)
- GEOquery (≥ 3.2)
- devtools (≥ 2.3)
- OPTIONAL RankProd (≥ 3.2)

### Installing from R console
After installing R from CRAN (https://cran.r-project.org/) the dependencies and sampleclusteR can be installed using the R code bellow. Issues installing rockchalk, cluster and GEOquery are common when using linux. See the 'Issues installing dependencies' section.
```R
#In the R terminal- install these dependencies
install.packages("cluster", quiet= T)
install.packages("BiocManager", quiet= T)
install.packages("rockchalk", quiet= T)
BiocManager::install("limma", quiet= T)
BiocManager::install("GEOquery", quiet= T)
#Errors can occur when installing devtools- see 'Issues installing dependencies' section
install.packages("devtools", quiet= T)
#Use devtools to build package
devtools::install_github("brandoncoke/sampleclusteR")
```
Alternatively you can install the package without using devtools which can have compatibility issues. To do this use the code below.
```R
#In the R terminal- install these dependencies
install.packages("cluster", quiet= T)
install.packages("BiocManager", quiet= T)
install.packages("rockchalk", quiet= T)
BiocManager::install("limma", quiet= T)
BiocManager::install("GEOquery", quiet= T)
#Errors can occur when installing devtools- see 'Issues installing dependencies' section
install.packages("devtools", quiet= T)
install.packages(file.choose()) #if you need a GUI to point to the sampleclusteR_1.00.zip file
#USE THIS IF THE REPO WAS CLONNED TO YOUR HOME DIRECTORY
install.packages(~/sampleclusteR/sampleclusteR_1.00.zip)
```
### Using RankProd
To be able to analyse with RankProd; it requires the installation of the [RankProd package](https://www.bioconductor.org/packages/release/bioc/html/RankProd.html) from Bioconductor. The code below installs its dependencies using the R console.
```R
#Only if you need to analyse the datasets via RankProd. Run code below in R
install.packages("Rmpfr", quiet= T)
install.packages("gmp", quiet= T)
install.packages("BiocManager", quiet= T)
BiocManager::install("RankProd", quiet= T)
```
### Issues installing dependencies
If running into issues when installing lme4, GEOquery, devtools and/or rockchalk on debian or Ubuntu based operating systems. Run the code below in the terminal assuming you CRAN packages are available in your [repositories](https://cran.r-project.org/). You need to add the CRAN repository to enable you to install r-cran and r-bioc packages.
```sh
#Run in a linux terminal- check your packages can be installed with apt-get
sudo apt-get update #first two not necessary
sudo apt-get upgrade
#Dependencies required to install devtools
sudo apt-get -y install r-cran-devtools
#Requirements to install lme4, nloptr and rockchalk 
sudo apt-get -y install r-cran-rockchalk r-cran-lme4 r-cran-nloptr
#GEOquery install
sudo apt -y install r-bioc-biobase
sudo apt-get -y install r-bioc-geoquery
#Then install R package dependencies
R -e 'install.packages("lme4", quietly=T)'  
R -e 'install.packages("nloptr", quietly=T)'   
R -e 'install.packages("rockchalk", quietly=T)'  
R -e 'install.packages("cluster", quietly=T)' 
R -e 'install.packages("xml2", quietly=T)'   
R -e 'install.packages("BiocManager", quietly=T)'    
R -e 'BiocManager::install("RankProd", force=T)'
R -e 'BiocManager::install("Biobase", force=T)'
R -e 'BiocManager::install("GEOquery", force=T)'
R -e 'BiocManager::install("limma", force=T)'
R -e 'install.packages("devtools", quietly=T)'
#Install package directly from the git repo
R -e 'devtools::install_github("brandoncoke/sampleclusteR")'
#Run in a linux terminal
```
### Installing and running docker image
Finally, a docker image can be built to run a containerised instance of the package. Ensure docker is installed (e.g. apt install docker or download [here](https://www.docker.com/)). The script to build the docker image can be located in the docker_containerisation directory along with the Dockerfile. Ensure your current directory is set to the docker_containerisation directory and the use the build_command.sh script to create and image and tar.gz directory of the image.
