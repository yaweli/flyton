# Install flyton under DOCKER



install : cd /home/fly/Flyton/install/docker && docker build -t flyton1 .

run     : docker run -d --name fly  -p 8080:80 flyton1

enter into the container:   docker exec -i -t fly /bin/bash

works : curl http://127.0.0.1:8080



<html>
    <meta source="tcn.ng.2025" />
    Welcome to your new Flyton project






docker stop fly

docker restart fly

docker rm fly

