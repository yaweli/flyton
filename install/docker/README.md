# Install flyton under DOCKER
on you linux machine , ubuntu , preffered on AWS:



install : cd /home/fly/Flyton/install/docker && docker build -t flyton1 .

run     : docker run -d --name fly  -p 8080:80 flyton1

enter into the container:   docker exec -i -t fly /bin/bash

try to browse : curl http://127.0.0.1:8080


    <html>

    Welcome to your new Flyton project




# Install from docker Hub: 

docker login 

docker pull yaweli/flyton:v1

# run first time

docker run -d --name fly  -p 8080:80 yaweli/flyton:v1


try to browse : curl http://127.0.0.1:8080

or              http://myserver_ip:8080

Dont forget to wrap this url with https://my_domain.com with map to 8080 using CloudFront and CertManager on AWS



docker run -d -p 8080:80 -v /data/webkic/pages:/data/fly/client/pages 75f90f8289c9




# What it's good for:

This is a pulic project , it's a full server side plus client side , python based environment

If you need a fast project to create on your linux server , use the docker hub to get the yaweli/flyton:v1 and in few secode you have a project with database and web interface - add you code to it to be able to continue you project , also good for AI to create the project instead of explaining how to. 

# We are Flyton v 1