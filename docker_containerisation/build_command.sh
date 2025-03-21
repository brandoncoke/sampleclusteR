#/bin/sh
docker stop $(sudo docker ps -a -q)
docker rm $(sudo docker ps -a -q)
docker container ls -a
net stop winnat
net start winnat
#sudo docker create samplecluster
docker build -t samplecluster . #cannot name image with upper case- hence all lower
docker save --output="sampleclusteR_docker_container.tar.gz" samplecluster
#Below loads the samplecluster image and then runs it with local directory- loads with temp_acc user.
docker load < sampleclusteR_docker_container.tar.gz
docker run -ti -v /home:/home samplecluster R
