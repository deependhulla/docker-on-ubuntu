#!/bin/bash

cd /tmp/
curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
cd -


sudo systemctl stop docker
sudo systemctl stop docker.socket
### i keep all my data in /home ..as system backup works from there as root ...you can have some other locaiton is need.
mkdir -p /home/docker-container-live-data
rsync -aP /var/lib/docker/ /home/docker-container-live-data/
touch /etc/docker/daemon.json
echo '{' >/etc/docker/daemon.json
echo '  "data-root": "/home/docker-container-live-data" ' >> /etc/docker/daemon.json
echo '}' >> /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl start docker
docker info | grep "Docker Root Dir"
mv /var/lib/docker /var/lib/docker_to_del
