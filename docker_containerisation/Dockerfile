FROM rocker/r-devel
ARG WHEN
WORKDIR /home/
RUN apt-get update
RUN apt-get install -y libuv1 libuv1 procps cmake-data 
RUN apt-get install -y r-cran-gmp r-cran-rmpfr
RUN apt-get install -y cmake 
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
#EXPOSE 3838 #not shiny just CMD line
#Exit and load in R
CMD ["R", "-e", "require("sampleclusteR")"]
