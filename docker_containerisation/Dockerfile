
# syntax=docker/dockerfile:1
#sudo docker build .
#set image and working directory
FROM rocker/r-devel
ARG WHEN
WORKDIR /home/
#RUN mkdir /home/
#copy the R script for dependency install
#COPY ./docker_install.R /home/
RUN apt install libarchive13 libjsoncpp25 libproc2-0 librhash0 libuv1 procps cmake-data r-cran-gmp r-cran-rmpfr libxml2-dev cmake
RUN R -e 'install.packages("lme4", quietly=T)'  
RUN R -e 'install.packages("nloptr", quietly=T)'   
RUN R -e 'install.packages("rockchalk", quietly=T)'  
RUN R -e 'install.packages("cluster", quietly=T)' 
RUN R -e 'install.packages("xml2", quietly=T)'   
RUN R -e 'install.packages("devtools", quietly=T)'   
RUN R -e 'install.packages("BiocManager", quietly=T)'    
RUN R -e 'BiocManager::install("RankProd", force=T)'
RUN R -e 'BiocManager::install("GEOquery", force=T)'
RUN R -e 'BiocManager::install("limma", force=T)'
RUN R -e 'devtools::install_github("brandoncoke/sampleclusteR")'
#avoid having root user- no need after installing
RUN addgroup --system temp_acc \
    && adduser --system --ingroup temp_acc temp_acc
RUN chown temp_acc -R /home/
USER temp_acc
#Set port for container
#EXPOSE 3838 #not shiny just CMD
#Exit and load in R
CMD ["R", "-e", "require("GEOpythia")"]
