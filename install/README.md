# Install flyton project on a Ubuntu system





1. clone the flyton repository 
2. systemctl status apache2
3. systemctl status mysql
4. apt -y update
5. export proj=zg
6.  apt-get install -y apache2 python3 python3-pip mysql-server supervisor mysql-client && \
    apt install python3-mysql.connector && \
    a2enmod cgi 
7. export src=/data/$proj/install/docker/
8. cp $src/serve-cgi-bin.conf /etc/apache2/conf-enabled/
9. cp $src/000-default.conf   /etc/apache2/sites-enabled/
10. systemctl restart apache2 
11. 


check

next

  ln -s /data/$proj/server/cgi-bin /var/www/
    rmdir /usr/lib/cgi-bin 2>/dev/null
    ln -s /var/www/cgi-bin /usr/lib/
    ln -s /data/$proj/client/pages /var/www/html/
    ln -s /data/$proj/client/lib /var/www/html/
    ln -s /data/$proj/client/app /var/www/html/
    # ln -s /data/$proj/server/apis/tools /data/$proj/client/app/
    # ln -s /data/$proj /home/kic/

next

sed -i "s/fly/$proj/g" /data/$proj/server/cgi-bin/api
sed -i "s/fly/$proj/g" /data/$proj/server/cgi-bin/p4web.py
sed -i "s/fly/$proj/g" /data/$proj/server/config.py


sed -i "s/fly/$proj/g" /data/$proj/install/docker/init.sql
cd /data/$proj/install/docker/
mysql < init.sql         
         