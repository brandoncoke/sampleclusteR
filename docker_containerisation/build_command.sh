#/bin/sh
cd docker_containerisation
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
#docker create sampleclusteR
#sudo docker container ls -a
#net stop winnat
#sudo docker start sampleclusteR
#net start winnat
sudo  docker build -o - . --tag sampleclusteR
sudo docker create sampleclusteR
sudo docker export --output="sampleclusteR_docker_container.tar.gz" sampleclusteR # create the docker image as a tar