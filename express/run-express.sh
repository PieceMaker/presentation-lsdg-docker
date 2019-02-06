#!/usr/bin/env bash
docker build -t express-simple -f express/Dockerfile .
docker run --rm --name express express-simple
docker run --rm --name express -p 3000:3000 express-simple
docker run --rm --name express -p 80:3000 express-simple

docker save -o express-simple.backup express-simple
scp -i ~/.ssh/jadams.pem express-simple.backup ubuntu@<ipaddress>:/home/ubuntu
docker load -i express-simple.backup

docker run --rm --name express -p 80:3000 express-simple