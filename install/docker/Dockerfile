#
# Flyton under DOCKER
#
# the project name in docker is always "fly" - every container is a machine of its own ,
# so /data/fly and the database fly never meet another project . name the CONTAINER instead
#
# the code is NOT copied into this folder - it is built from the ONE original copy ,
# server/ and client/ of the repo . so the build runs from the REPO ROOT :
#
#   cd <repo> && docker build -f install/docker/Dockerfile -t flyton .
#   docker run -d --name fly -p 9080:80 flyton
#
# the same steps as install/fly.bash "I" , with proj=fly
#
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# services - the same list as fly.bash , plus supervisor (runs apache + mysql) and curl (healthcheck)
# ubuntu 24 = python 3.12 : the apt python3-mysql.connector (8.0.15) calls ssl.wrap_socket ,
# which 3.12 removed - every query fails . the new one from pip , the same as Bridgekey ins.bash
RUN apt-get update && \
    apt-get install -y apache2 python3 python3-pip python3-mysql.connector mysql-server mysql-client supervisor curl && \
    pip install --upgrade mysql-connector-python --break-system-packages && \
    a2enmod cgi && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    mkdir -p /var/log/supervisor /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# the one original copy of the code
COPY server  /data/fly/server
COPY client  /data/fly/client
COPY install /data/fly/install

# the name into the code - only the 2 lines that say Myproj , all the rest already say fly
# config.py from fly_config.py , and the login page /pages/login/ opens index.html
RUN sed -i 's/^\( *myproj *= *\)"Myproj"/\1"fly"/'      /data/fly/server/cgi-bin/api && \
    sed -i 's/^CompanyTitle="Myproj"/CompanyTitle="fly"/' /data/fly/server/cgi-bin/p4web.py && \
    grep -q 'myproj = "fly"'      /data/fly/server/cgi-bin/api && \
    grep -q 'CompanyTitle="fly"'  /data/fly/server/cgi-bin/p4web.py && \
    mv /data/fly/server/fly_config.py /data/fly/server/config.py && \
    cp /data/fly/client/pages/login/fly_index.html /data/fly/client/pages/login/index.html && \
    chmod 755 /data/fly/server/cgi-bin/* /data/fly/install/kic.bash && \
    ln -s /data/fly/install/kic.bash /usr/bin/kic

# apache - the same confs as fly.bash , plus our apache2.conf
# (client/app/tools is already in the repo - a relative link to server/apis/tools)
COPY install/docker/apache2.conf /etc/apache2/
RUN cp /data/fly/install/docker/serve-cgi-bin.conf /etc/apache2/conf-enabled/ && \
    cp /data/fly/install/docker/000-default.conf   /etc/apache2/sites-enabled/ && \
    ln -s /data/fly/server/cgi-bin /var/www/ && \
    rm -fr /usr/lib/cgi-bin && \
    ln -s /var/www/cgi-bin /usr/lib/ && \
    ln -s /data/fly/client/pages /var/www/html/ && \
    ln -s /data/fly/client/lib   /var/www/html/ && \
    ln -s /data/fly/client/app   /var/www/html/ && \
    ln -s /data/fly/server/cgi-bin    /data/fly/client/app/ && \
    cp /data/fly/install/docker/html/index.html /var/www/html/index.html && \
    apache2ctl configtest

# database + mysql user "fly" , with the startup tables
RUN service mysql start && \
    mysql < /data/fly/install/docker/init.sql && \
    service mysql stop

# mysql start - make the data dir only if it is empty (a new volume)
RUN printf '#!/bin/bash\n\
mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld\n\
if [ ! -d "/var/lib/mysql/mysql" ]; then\n\
  mysqld --initialize-insecure --user=mysql\n\
fi\n\
exec /usr/sbin/mysqld --user=mysql\n' > /init-db.sh && \
    chmod +x /init-db.sh

# apache start - after a "docker restart" the old cgid socket + pid are still there ,
# and inside a container apache gets the same pid again , so cgid cannot bind and
# every /cgi-bin/ page fails . clean them first
RUN printf '#!/bin/bash\n\
rm -f /var/run/apache2/apache2.pid /var/run/apache2/socks/cgisock.*\n\
exec /usr/sbin/apache2ctl -D FOREGROUND\n' > /start-apache.sh && \
    chmod +x /start-apache.sh

# supervisor runs both apache and mysql
RUN printf '[supervisord]\n\
nodaemon=true\n\
\n\
[program:apache2]\n\
command=/start-apache.sh\n\
autorestart=true\n\
\n\
[program:mysqld]\n\
command=/init-db.sh\n\
autorestart=true\n' > /etc/supervisor/conf.d/supervisord.conf

RUN echo "" && \
    echo " please change default db password (1964) - see install/docker/README.md" && \
    echo ""

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
    CMD curl -sf -o /dev/null "http://127.0.0.1/cgi-bin/p?app=start" || exit 1

CMD ["/usr/bin/supervisord", "-n"]
