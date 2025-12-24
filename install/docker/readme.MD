# Install flyton under DOCKER



install : cd /home/fly/Flyton/install/docker && docker build -t flyton1 .

run     : docker run -d --name fly  -p 8080:80 flyton1

enter into the container:   docker exec -i -t fly /bin/bash

try to browse : curl http://127.0.0.1:8080


'''html
<html>
    <meta source="tcn.ng.2025" />
    Welcome to your new Flyton project
'''


# Install from docker Hub: 

docker login 

docker pull yaweli/flyton:v1

# run

docker run -d --name fly  -p 8080:80 flyton1


try to browse : curl http://127.0.0.1:8080

or              http://myserver_ip:8080


