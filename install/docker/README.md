# Install Flyton under DOCKER

On your linux machine (ubuntu , preffered on AWS) . The image is Ubuntu 24.04 + apache2 + mysql + python3 .

The project name inside docker is always **fly** - `/data/fly` , database `fly` , mysql user `fly` .
Every container is a machine of its own , so name the **container** for your project instead (`--name shop`) .

## One original copy

This folder does **not** hold a copy of the code . The image is built from the repo's own
`server/` and `client/` - so the build runs from the **repo root** :

    cd <repo>
    docker build -f install/docker/Dockerfile -t flyton .

What is in this folder :

| file | what |
|---|---|
| Dockerfile | the build - the same steps as `install/fly.bash` "I" , with the name fly |
| apache2.conf | apache main conf for the container |
| 000-default.conf , serve-cgi-bin.conf | apache site + cgi-bin - also used by `install/fly.bash` |
| init.sql | the first tables + the mysql user - also used by `install/fly.bash` |
| html/index.html | the welcome page at `/` - also used by `install/fly.bash` |

The `.dockerignore` at the repo root keeps `.git` , the pdf and the big images out of the build .

## Run

    docker run -d --name fly -p 9080:80 -v fly-db:/var/lib/mysql flyton

- browse : `http://myserver_ip:9080/pages/login` - username `kic` , password `fly123`
- `-v fly-db:/var/lib/mysql` keeps the database in a docker volume , so it survives `docker rm` .
  use a **named** volume (like `fly-db`) - an empty host directory would start mysql with no `fly` database
- the container has a healthcheck : `docker ps` shows `(healthy)`

**please change default db password** (1964) :

    docker exec fly mysql -e "ALTER USER 'fly'@'%' IDENTIFIED BY 'newpas';"
    docker exec fly sed -i 's/^password = "1964"/password = "newpas"/' /data/fly/server/config.py

## Every day

    docker exec -it fly /bin/bash          # enter the container
    docker exec -it fly kic                # the flyton admin script (s - mysql , l - error log)
    docker logs fly
    docker restart fly
    docker stop fly && docker rm fly       # the database stays in the fly-db volume

Wrap the url with `https://my_domain.com` - map it to port 9080 with CloudFront and Certificate Manager on AWS .

## Docker Hub

    docker login -u yaweli
    docker build -f install/docker/Dockerfile -t yaweli/flyton:v2 .
    docker push yaweli/flyton:v2

and on any machine :

    docker run -d --name fly -p 9080:80 -v fly-db:/var/lib/mysql yaweli/flyton:v2

## What it's good for

This is a public project , a full server side plus client side , python based environment .
If you need a fast project on your linux server , in a few seconds you have a project with a
database and a web interface - add your code to it and go on . Also good for AI to create the
project instead of explaining how to .
