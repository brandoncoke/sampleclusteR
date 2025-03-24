FROM rocker/r-devel
ARG WHEN
RUN apt-get update
#RUN apt-get install -y libuv1 libuv1 procps cmake-data 
RUN apt-get install -y r-cran-gmp r-cran-rmpfr
RUN apt-get install -y r-cran-lme4
#RUN R -e 'install.packages("lme4", quietly=T)'
RUN apt-get install -y r-cran-nloptr
RUN apt-get install -y r-cran-rockchalk
RUN apt-get install -y r-cran-cluster
RUN apt-get install -y r-cran-biocmanager
RUN apt-get install -y r-cran-xml2
RUN apt-get install -y r-cran-devtools    
RUN R -e 'BiocManager::install("RankProd", force=T)'
RUN apt-get install -y r-bioc-biobase
RUN apt-get install -y r-bioc-geoquery 
#RUN R -e 'BiocManager::install("GEOquery", force=T)'
RUN apt-get install -y r-bioc-limma
#RUN R -e 'BiocManager::install("limma", force=T)'
RUN R -e 'devtools::install_github("brandoncoke/sampleclusteR")'
#RUN addgroup -S $DOCKER_USER && adduser -S $DOCKER_USER -G $DOCKER_USER
#RUN chown $DOCKER_USER -R /home/
#RUN useradd -ms /bin/bash $DOCKER_USER
#RUN chown $DOCKER_USER -R /home/
WORKDIR /home/

#USER $DOCKER_USER
#Set port for container
#EXPOSE 3838 #not shiny just CMD line
#Exit and load in R
#CMD ["R", "-e", "require("sampleclusteR")"]
