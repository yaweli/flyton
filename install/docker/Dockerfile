# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment non-interactive to prevent prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install Apache2, MySQL client, and PHP with MySQL support
RUN apt-get update && \
    apt-get install -y apache2 python3 python3-pip mysql-server supervisor mysql-client && \
    pip install mysql-connector-python && \
    a2enmod cgi && \
    mkdir -p /var/log/supervisor /var/run/mysqld && \
    mkdir -p /var/www/cgi-bin && \
    mkdir -p /data && \
    mkdir -p /data/fly && \
    mkdir -p /data/fly/server && \
    mkdir -p /data/fly/server/cgi-bin && \
    mkdir -p /data/fly/server/apis && \
    mkdir -p /data/fly/server/apis/tools && \
    mkdir -p /data/fly/server/apis/api && \
    mkdir -p /data/fly/client && \
    mkdir -p /data/fly/client/lib && \
    mkdir -p /data/fly/client/pages && \
    mkdir -p /data/fly/client/pages/im && \
    mkdir -p /data/fly/client/app && \
    mkdir -p /data/fly/client/app/weba && \
    mkdir -p /data/fly/client/app/admin && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy website files from your local directory to the Apache web root
# Make sure your website files are in the same directory as the Dockerfile
COPY ./html/index.html  /var/www/html/
COPY ./fly_config.py /data/fly/server/
COPY ./lib/*         /data/fly/client/lib/
COPY ./cgi/*         /data/fly/server/cgi-bin/
COPY ./cgi.py         /data/fly/server/apis/
COPY ./tools/*        /data/fly/server/apis/tools/

# Apache CGI conf (for /cgi-bin/, AddHandler .py)
COPY ./apache2.conf /etc/apache2/
COPY ./serve-cgi-bin.conf   /etc/apache2/conf-enabled/
COPY ./000-default.conf /etc/apache2/sites-enabled/
RUN ln -s /data/fly/client/pages /var/www/html/
RUN ln -s /data/fly/client/lib /var/www/html/
#RUN echo 'ScriptAlias /cgi-bin/ /opt/flyton/server/apis/\n<Directory "/opt/flyton/server/apis">\nAllowOverride None\nOptions +ExecCGI -MultiViews +SymLinksIfOwnerMatch\nRequire all granted\nAddHandler cgi-script .py\n</Directory>' >> /etc/apache2/apache2.conf

# MySQL init script (if data dir empty, init, then start)
RUN echo '#!/bin/bash\n\
if [ ! -d "/var/lib/mysql/mysql" ]; then\n\
  mysqld --initialize-insecure --user=mysql\n\
fi\n\
exec /usr/sbin/mysqld --user=mysql' > /init-db.sh && \
    chmod +x /init-db.sh

# Supervisor config to run both Apache and MySQL automatically
RUN echo '[supervisord]\n\
nodaemon=true\n\
\n\
[program:apache2]\n\
command=/usr/sbin/apache2ctl -D FOREGROUND\n\
autorestart=true\n\
\n\
[program:mysqld]\n\
command=/init-db.sh\n\
autorestart=true' > /etc/supervisor/conf.d/supervisord.conf

# Expose port 80 to allow incoming web traffic
EXPOSE 80

# Run Supervisor to manage both processes automatically on container start
CMD ["/usr/bin/supervisord", "-n"]





# install : cd /home/fly/Flyton/install/docker && docker build -t flyton1 .
# run     : docker run -d --name fly  -p 8080:80 flyton1
# enter into the container:   docker exec -i -t fly /bin/bash
# works : curl http://127.0.0.1:8080
#<html>
#    <meta source="tcn.ng.2025" />
#    Welcome to your new Flyton project
#
# docker stop fly
# docker restart fly
# docker rm fly



