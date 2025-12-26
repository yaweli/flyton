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

# run

docker run -d --name fly  -p 8080:80 flyton1


try to browse : curl http://127.0.0.1:8080

or              http://myserver_ip:8080

# What's it good for:

This is a pulic project , it's a full server side plus client side , python based environment

If you need a fast project to create on your linux server , use the docker hub to get the yaweli/flyton:v1 and in few secode you have a project with database and web interface - add you code to it to be able to continue you project , also good for AI to create the project instead of explaining how to. 

# We are Flyton v 1