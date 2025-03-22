# sampleclusteR- commandline interface for large scale GEO dataset metanalysis

## A Quick and efficient way of clustering and analysing samples using .sdrf metadata and GEO metdata

sampleclusteR allows users to quickly analyse datasets from Gene Expression Omnibus (GEO) and ArrayExpress metadata sets (via Sample and Data Relationship Format tables (.sdrf)) using a command line interface.
To cluster GEO dataseries and produce a table with samples and their clusters such as GSE84881 a user can use
```R
sampleclusteR::geo.cluster("GSE84881")
```
Conversely to cluster an ArrayExpress dataset with its metadata formatted as a Sample and Data Relationship Format table; for example the metadata for 
E-MTAB-11935; this can be achieved with
```R
sampleclusteR::ArrayExpress.cluster("https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/935/E-MTAB-11935/Files/E-MTAB-11935.sdrf.txt")
```
Finally, sampleclusteR enables users to automate the generation of DEGs list for a given GEO data set via the supervised.analysis.
```R
sampleclusteR::supervised.analysis(GEO_id= "GSE130402", meta_data_and_combined= T, limma_or_rankprod = "limma")
```
sampleclusteR current features are:
- Automatically cluster GEO, ArrayExpress  and user provided metadata on the command-line.
- Automatically identify control and treated samples and correctly match them.
- Perform large scale meta analysis of GEO data by automating analysis of GEO datasets.
- Analyse GEO data sets using \emph{limma} or RankProd
Unlike GEOrcale the package does not use a SVM model to automate the selection of control and treated samples and requires user interaction to select the valid pairwise comparisons
### Installation and requirements
sampleclusteR requires the following:
- R  (≥ 4.4.3)
- cluster (≥ 2.0)
- rockchalk (≥ 1.8)
- BiocManager (≥ 3.2)
- limma (≥ 3.2)
- GEOquery (≥ 3.2)
- devtools (≥ 2.3)

### Installing from R console
After installing R from CRAN (https://cran.r-project.org/) the dependencies and sampleclusteR can be installed using the R code bellow.
```R
#In the R terminal- install these dependencies
install.packages("cluster", quiet= T)
install.packages("BiocManager", quiet= T)
install.packages("rockchalk", quiet= T)
BiocManager::install("limma", quiet= T)
BiocManager::install("GEOquery", quiet= T)
#Errors can occur when installing devtools- see next paragraph
install.packages("devtools", quiet= T)
#Use devtools to build package
devtools::install_github("brandoncoke/sampleclusteR")
```
### Using RankProd
To be able to analyse with RankProd; it requires the installation of the [RankProd package](https://www.bioconductor.org/packages/release/bioc/html/RankProd.html) from Bioconductor. The code below installs its dependencies.
```R
#Only if you need to analyse the datasets via RankProd. Run code below in R
install.packages("Rmpfr", quiet= T)
install.packages("gmp", quiet= T)
install.packages("BiocManager", quiet= T)
BiocManager::install("RankProd", quiet= T)
```
### Issues installing dependencies
If running into issues when installing lme4, devtools or rockchalk on debian or Ubuntu based operating systems. Run the code below in the terminal assuming you CRAN packages are available in your [repositories](https://cran.r-project.org/)
```sh
#Run in a linux terminal- check your packages can be installed with apt-get
sudo apt-get update #first two not necessary
sudo apt-get upgrade
#Dependencies required to install devtools
sudo apt-get -y build-dep libcurl4-gnutls-dev
sudo apt-get -y install libcurl4-gnutls-dev
#Requirements to install lme4, nloptr and rockchalk 
sudo apt-get -y --fix-broken install libarchive13 libjsoncpp25 libproc2-0 librhash0 libuv1 procps #dependencies for R packages
sudo apt-get -y install r-cran-gmp r-cran-rmpfr libxml2-dev #avoids issues with installing these packages in R
sudo apt-get -y install cmake-data #dependency for devtools
sudo apt-get -y install cmake
sudo apt-get install libssl-dev #another devtools dependency
R -e 'install.packages("lme4", quietly=T)'  
R -e 'install.packages("nloptr", quietly=T)'   
R -e 'install.packages("rockchalk", quietly=T)'  
R -e 'install.packages("cluster", quietly=T)' 
R -e 'install.packages("xml2", quietly=T)'   
R -e 'install.packages("BiocManager", quietly=T)'    
R -e 'BiocManager::install("RankProd", force=T)'
R -e 'BiocManager::install("GEOquery", force=T)'
R -e 'BiocManager::install("limma", force=T)'
R -e 'install.packages("devtools", quietly=T)'  
R -e 'devtools::install_github("brandoncoke/sampleclusteR")'
#Run in a linux terminal
```
### Installing and running docker image
Finally, a docker image can be built to run a containerised instance of the package. Ensure docker is installed (e.g. apt install docker or download [here](https://www.docker.com/)). The script to build the docker image can be located in the docker_containerisation directory. Ensure your current directory is the Git repository. Once the docker image is built; a tar directory (sampleclusteR_docker_image.tar.gz) will be created and be used to load the package and its dependencies using the code below in the linux terminal.
```sh
bash docker_containerisation/build_command.sh #this will create the sampleclusteR_docker_image.tar.gz image
docker load < sampleclusteR_docker_image.tar.gz #may require super user access- if so append sudo or doas or sudo !! after encountering an error
docker volume create sampleclusteR_data #to enable you to save the csvs
docker run -ti -v /home/:sampleclusteR_data sampleclusteR R #then type require("sampleclusteR")
#when saving csvs in ~ will be /var/lib/docker/volumes/sampleclusteR_data on the host machine
```
