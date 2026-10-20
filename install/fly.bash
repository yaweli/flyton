#!/bin/bash
#
# Flyton - install a new Flyton system on an EMPTY ubuntu linux
#
# the system gets its own name ($proj) , picked once with "N" , and lives in /data/$proj
# see instruction at the end of this file
#
# (c) kicdev 10.2026 - learned from the Bridgekey installation kit (ins.bash)
#
ver=2026.10.20.001 # first version - N I U A1 R F l s
ver=2026.10.20.002 # UA - uninstall all , for a scratch test machine , with safety checks
ver=2026.10.20.003 # serve-cgi-bin.conf gets the $proj name
ver=2026.10.20.004 # pip mysql-connector-python - ubuntu 24 (python 3.12) needs it
echo "=========================================================="
echo "== Welcome to Flyton install script manager             =="
echo "=========================================================="

user=$USER
proj=""                             # the system name - picked with "N" , kept in $envf
docker=0                            # docker=1 , only 0 supported
act_os=`lsb_release -sr`            # version 24 or 22
act_ar=`dpkg --print-architecture`  # amd64
envf=/ins/.env                      # where "N" remembers the name
src=https://github.com/yaweli/flyton.git
raw=https://raw.githubusercontent.com/yaweli/flyton/main/install/fly.bash

#
#  the remembered name
#
#  read with grep , not with  . $envf  - a sourced file is executed , and this one is
#  only ever meant to carry a name . a value that is not a good name is dropped .
#
function name_ok()
{
    echo "$1" | grep -qE "^[A-Z][a-z]{1,9}$"
}

if [ -f $envf ]
then was=`grep "^proj=" $envf | tail -1 | cut -d= -f2 | tr -d " \t\r"`
     if name_ok "$was"
     then proj=$was
     fi
     if [ "x$was" != "x" ] && [ "x$proj" = "x" ]
     then echo "WARNING: $envf holds proj=[$was] which is not a good name - ignored"
     fi
fi
db=`echo $proj | tr "[:upper:]" "[:lower:]"`   # database + mysql user - the name in lower case

#
# Green
function mes()
{
    echo -e "\e[32m$1 .. $2\e[0m"
}
#
# Red
function gored()
{
    echo -en "\e[31m"
}
function goback()
{
    echo -en "\e[0m"
}

#
#  ask for the name until it is a good one , and keep it in $envf
#
#  first letter upper case , then 1 to 9 lower case letters :  Zg  Shop  Bridgekey
#
function name_ask()
{
    while true
    do echo ""
       echo "System name - first letter Upper case , then 1-9 lower case letters (e.g. Shop) : "
       read n
       if name_ok "$n"
       then break
       fi
       gored ; echo "[$n] is not a good name" ; goback
    done
    mkdir -p /ins 2>/dev/null
    echo "# Flyton - written by the 'N' option of fly.bash , do not edit by hand" >  $envf
    echo "proj=$n"                                                              >> $envf
    chmod 600 $envf
    proj=$n
    db=`echo $proj | tr "[:upper:]" "[:lower:]"`
    mes "System name is now [$proj]" "saved in $envf"
}

if [ "x$proj" = "x" ]
then pname="(none yet - use N)"
else pname="$proj - /data/$proj - database $db"
fi
echo "Ver: $ver   User: $user"
echo "Os.: $act_os   Architecture: $act_ar"
gored
echo "System: $pname"
goback
echo "=========================================================="
if [ -f /etc/apache2/flyton.skip ]
then gored
    echo "Skip apache install mode = ON"
    goback
fi
if [ "x$user" == "xroot" ]
then #
    echo "N     - Name of the system - pick it before install"
    echo "I     - install Flyton [$proj] on an empty linux"
    echo "U     - uninstall All - Totaly erase all data from mysql !"
    echo "UA    - uninstall ALL , nothing kept - user kic too - scratch test machine only"
    echo "F     - first time - instruction"
    echo "A1    - set apache flag on - already have apache - skip apache install"
    echo "R     - Reload this script new version from the web"
    echo "---"
fi
echo "l - view error logs  s - mysql"
echo "=="

echo "Options: "

if [ "x$1" = "x" ]
then read x
else x=$1
fi

#
#  N  -  the system name
#
#  once the system is installed the name is locked - /data/$proj , the database and the
#  code all carry it , so a new name would point to nothing .
#
if [ "x$x-$user" = "xN-root" ]
then if [ "x$proj" != "x" ] && [ -d /data/$proj ]
     then gored
          echo "[$proj] is installed in /data/$proj - the name is locked (uninstall first - U)"
          goback
          exit
     fi
     if [ "x$proj" != "x" ]
     then echo "now : [$proj]"
     fi
     name_ask
fi


if [ "x$x" = "xl" ]
then tail -f /var/log/apache2/error.log
fi

if [ "x$x" = "xs" ]
then mysql $db
fi


if [ "x$user-$x" = "xroot-A1" ]
then echo "light flag ignor - and dont install apache"
     echo "use for a test servers with more than one project on it"
     mkdir -p /etc/apache2 2>/dev/null
     echo "SKIP" > /etc/apache2/flyton.skip
fi


if [ "x$x-$user" = "xF-root" ]
then
    echo ""
    echo ""
    echo "useradd -s /bin/bash -m kic"
    echo "passwd kic"
    echo "then : fly N   - pick the system name"
    echo "then : fly I   - install"
    echo ""
fi


if [ "x$user-$x" = "xroot-U" ]
then #
    if [ "x$proj" = "x" ]
    then echo "No system name - nothing to uninstall"
         exit
    fi
    echo "Danger !!!!!!!!!!!!!!!!"
    echo "Danger !!!!!!!!!!!!!!!!"
    echo "Danger !!!!!!!!!!!!!!!!"
    echo "This will delete the Database , and uninstall all module of [$proj]"
    if [ -f /etc/apache2/flyton.skip ]
    then echo "Will not removed apache2 - flag is on"
    fi
    echo "Are you sure? <n> (y/n) "
    read z
    if [ "x$z" != "xy" ]
    then exit
    fi
    echo "remove mysql .. [start] "
    systemctl stop mysql
    apt-get -y purge 'mysql-.*'
    apt-get autoremove -y
    apt-get autoclean
    echo "remove mysql .. [end] "

    if [ -f /etc/apache2/flyton.skip ]
    then echo "Will not removed !!!! - flag is on"
         echo "remove apache2 .. [skiped] "
    else echo "remove apache2 .. [start] "
        systemctl stop apache2
        apt-get -y purge apache2*
        apt-get autoremove -y
        apt-get autoclean
        rm -fr /var/www/* 2>/dev/null
        rm -f /usr/lib/cgi-bin 2>/dev/null
        echo "remove apache2 .. [end] "
    fi

    echo "remove files .. [start] "
    rm -f /home/kic/$proj 2>/dev/null
    if [ -d /data/$proj ]
    then export ddd=`date +%F-%H:%M`
        echo "Rename /data files /data/$proj /data/$proj-$ddd"
        mv /data/$proj /data/$proj-$ddd
        mv /var/lib/mysql /data/$proj-$ddd/var-lib-mysql
        mv /etc/mysql /data/$proj-$ddd/etc-mysql
    else echo "No rename need - not exist /data/$proj"
    fi
    echo "remove files .. [end] "

    echo "Uninstall completed........"
    echo ""
    echo "Some parts will not be removed"
    echo "1. user kic - will not removed"
    echo "2. /ins files - the name [$proj] is still kept in $envf"
    echo "3. apt modules python3 related will not be removed"
fi


#
#  UA  -  uninstall ALL , nothing is kept
#
#  for a scratch machine that tests this script : after UA the machine is back to empty
#  ubuntu , and "I" can run again . unlike U , nothing is renamed - it is DELETED :
#  the database , /data/$proj (and the /data/$proj-date copies U left) , the user kic
#  with all of /home/kic , the links in /usr/bin , and /ins
#
#  it refuses - and deletes nothing - when the machine does not look like a scratch one :
#     - /home/kic holds anything but the $proj link and the usual hidden files
#     - /home/kic or /data/$proj is older than 2 months
#     - user kic is logged in / has running processes
#  and it asks to type the system name , not just y
#
function age_days()
{
    t=`stat -c %W $1 2>/dev/null`         # birth time - 0 or - when the disk does not keep it
    if [ "x$t" = "x0" ] || [ "x$t" = "x-" ] || [ "x$t" = "x" ]
    then t=`stat -c %Y $1`                 # then the last change
    fi
    echo $(( (`date +%s` - t) / 86400 ))
}

if [ "x$user-$x" = "xroot-UA" ]
then #
    if [ "x$proj" = "x" ]
    then echo "No system name - nothing to uninstall"
         exit
    fi
    echo "Check.. this is a scratch machine"
    bad=0
    okh=" .bashrc .profile .bash_logout .bash_history .cache .local .config .ssh .sudo_as_admin_successful .mysql_history .lesshst .viminfo .wget-hsts .python_history "
    if [ -d /home/kic ]
    then for f in `ls -A /home/kic`
         do if [ "x$f" = "x$proj" ]
            then continue
            fi
            if echo "$okh" | grep -q " $f "
            then continue
            fi
            gored ; echo "   /home/kic/$f - not part of [$proj]" ; goback
            bad=1
         done
         d=`age_days /home/kic`
         if [ $d -gt 60 ]
         then gored ; echo "   /home/kic is $d days old - more than 2 months" ; goback
              bad=1
         fi
    fi
    if [ -d /data/$proj ]
    then d=`age_days /data/$proj`
         if [ $d -gt 60 ]
         then gored ; echo "   /data/$proj is $d days old - more than 2 months" ; goback
              bad=1
         fi
    fi
    if pgrep -u kic >/dev/null 2>&1
    then gored ; echo "   user kic is logged in / has running processes - log him out first" ; goback
         bad=1
    fi
    if [ "x$bad" = "x1" ]
    then gored
         echo "This does not look like a scratch test machine - UA refused , NOTHING deleted"
         echo "(use U - it keeps the data)"
         goback
         exit
    fi
    echo "check scratch machine [ok]"

    echo ""
    gored
    echo "Danger !!!!!!!!!!!!!!!!  UNINSTALL ALL - NOTHING IS KEPT"
    echo "Danger !!!!!!!!!!!!!!!!"
    goback
    echo "Will be DELETED :"
    echo "   mysql - packages + all databases   /var/lib/mysql /etc/mysql"
    if [ -f /etc/apache2/flyton.skip ]
    then echo "   apache2 - NOT removed (A1 flag is on) - only the $proj links in /var/www"
    else echo "   apache2 - packages + /var/www /etc/apache2"
    fi
    echo "   /data/$proj  `ls -d /data/$proj-* 2>/dev/null | tr '\n' ' '`"
    echo "   user kic + /home/kic"
    echo "   /usr/bin/fly /usr/bin/kic /usr/bin/Grep"
    echo "   /ins  (this script and the name [$proj])"
    echo ""
    echo "Type the system name [$proj] to go on : "
    read z
    if [ "x$z" != "x$proj" ]
    then echo "Exit - nothing deleted" ; exit
    fi

    step="mysql"
    mes "Next step [$step]" "start"
    systemctl stop mysql
    apt-get -y purge 'mysql-.*'
    rm -fr /var/lib/mysql /etc/mysql /var/log/mysql
    mes "Next step [$step]" "end"

    step="apache2"
    mes "Next step [$step]" "start"
    if [ -f /etc/apache2/flyton.skip ]
    then rm -f /var/www/cgi-bin /var/www/html/pages /var/www/html/lib /var/www/html/app
         echo "apache2 kept - A1 flag is on"
    else systemctl stop apache2
         apt-get -y purge 'apache2*'
         rm -fr /var/www /etc/apache2
         rm -f /usr/lib/cgi-bin
    fi
    mes "Next step [$step]" "end"

    step="apt cleanup"
    mes "Next step [$step]" "start"
    apt-get autoremove -y
    apt-get autoclean
    mes "Next step [$step]" "end"

    step="files"
    mes "Next step [$step]" "start"
    rm -fr /data/$proj /data/$proj-*
    rmdir /data 2>/dev/null
    rm -f /usr/bin/fly /usr/bin/kic /usr/bin/Grep
    mes "Next step [$step]" "end"

    step="user kic"
    mes "Next step [$step]" "start"
    userdel -r kic
    mes "Next step [$step]" "end"

    #  last - this script itself lives here
    rm -fr /ins

    echo ""
    echo "Uninstall ALL completed - the machine is back to empty"
    echo "to test again : useradd kic , get fly.bash (see F) , fly N , fly I"
    exit
fi


if [ "x$user-$x" = "xroot-I" ]
then #
    if [ "x$proj" = "x" ]
    then echo "No system name yet"
         name_ask
    fi
    echo "Check.. apache2"
    if [ -f /etc/apache2/flyton.skip ]
    then echo "Assume apache2 is already installed - skip"
    else n=`systemctl status apache2 2>/dev/null | wc -l`
        if [ "x$n" != x0 ]
        then echo "Uninstall apache2"
             exit
        fi
        echo "apache2 checked [ok]"
    fi
    echo "Check..mysql"
    n=`systemctl status mysql 2>/dev/null | wc -l`
    if [ "x$n" != x0 ]
    then echo "Uninstall mysql"
         exit
    fi
    echo "mysql checked [ok]"

    echo "Check..files"
    if [ -d /data/$proj ]
    then echo "Dir exist , must uninstall /data/$proj"
         exit
    fi
    if [ ! -d /home/kic ]
    then echo "user kic must be created !"
         echo "useradd -s /bin/bash -m kic"
         echo "passwd kic"
         exit
    fi
    if [ -e /home/kic/$proj ]
    then echo "Dir exist , must uninstall /home/kic/$proj"
         exit
    fi
    echo "check files [ok]"
    echo "* ver $ver"
    echo "* INSTALLATION OF [$proj] ON AN EMPTY SYSTEM "
    echo "* code     : /data/$proj"
    echo "* database : $db"
    echo "*"
    echo "Ready to install ? (y/n) <n> "
    read y
    if [ "x$y" != "xy" ]
    then echo "Exit" ; exit
    fi
    echo "Ready "

    step="apt update"
    mes "Next step [$step]" "start"
    apt -y update
    mes "Next step [$step]" "end"

    step="install git"
    mes "Next step [$step]" "start"
    export status=0
    apt-get install -y git && status=1
    if [ "x$status" = "x0" ]
    then echo "Fail - could not install git"
         exit
    fi
    mes "Next step [$step]" "end"

    #  the customer starts his OWN project - the flyton .git is removed , so a later
    #  git pull can never mix flyton updates into his code
    step="git clone"
    mes "Next step [$step]" "start"
    export status=0
    mkdir /data 2>/dev/null
    cd /data && git clone --depth 1 $src $proj && status=1
    if [ "x$status" = "x0" ]
    then echo "Fail"
         exit
    fi
    rm -fr /data/$proj/.git
    cd /data && ls -al
    mes "Next step [$step]" "end"

    step="services"
    mes "Next step [$step]" "start"
    export status=0
    apt-get install -y apache2 python3 python3-pip mysql-server mysql-client && \
    apt-get install -y python3-mysql.connector && \
    a2enmod cgi && status=1
    if [ "x$status" = "x0" ]
    then echo "Fail - could not install the services"
         exit
    fi
    mes "Next step [$step]" "end"

    #  ubuntu 24 = python 3.12 : the apt python3-mysql.connector (8.0.15) calls ssl.wrap_socket ,
    #  which 3.12 removed - every query fails . the new one from pip , the same as Bridgekey ins.bash
    #  ubuntu 22 : its pip does not know --break-system-packages - so try without it
    step="pip mysql-connector-python"
    mes "Next step [$step]" "start"
    export status=0
    pip install --upgrade mysql-connector-python --break-system-packages && status=1
    if [ "x$status" = "x0" ]
    then pip install --upgrade mysql-connector-python && status=1
    fi
    if [ "x$status" = "x0" ]
    then echo "Fail - could not install mysql-connector-python"
         exit
    fi
    mes "Next step [$step]" "end"

    #  the name goes into the SOURCE , BEFORE cgi-bin is exposed to /var/www .
    #  only the exact lines - never a blind s/fly//g
    step="name [$proj] into the code"
    mes "Next step [$step]" "start"
    if [ "x$docker" = "x0" ]
    then sed -i "s/^\( *myproj *= *\)\"Myproj\"/\1\"$proj\"/"           /data/$proj/server/cgi-bin/api
         sed -i "s/^CompanyTitle=\"Myproj\"/CompanyTitle=\"$proj\"/"     /data/$proj/server/cgi-bin/p4web.py
         sed -i "s/^proj=\"fly\"/proj=\"$proj\"/"                        /data/$proj/install/Grep
         sed -i "s/^export db_name=fly$/export db_name=$db/"             /data/$proj/install/kic.bash
         sed -i "s#/data/fly/server/cgi-bin/#/data/$proj/server/cgi-bin/#g" /data/$proj/install/docker/serve-cgi-bin.conf
    fi
    # config.py - first time only , from fly_config.py
    if [ ! -f /data/$proj/server/config.py ]
    then mv /data/$proj/server/fly_config.py /data/$proj/server/config.py
         sed -i "s/^sys_root = \"fly\"/sys_root = \"$proj\"/"           /data/$proj/server/config.py
         sed -i "s/^username = \"fly\"/username = \"$db\"/"             /data/$proj/server/config.py
         sed -i "s/^database = \"fly\"/database = \"$db\"/"             /data/$proj/server/config.py
    fi
    # the login page - /pages/login/ opens index.html
    if [ ! -f /data/$proj/client/pages/login/index.html ]
    then cp /data/$proj/client/pages/login/fly_index.html /data/$proj/client/pages/login/index.html
    fi
    grep -n "$proj" /data/$proj/server/cgi-bin/api /data/$proj/server/cgi-bin/p4web.py /data/$proj/server/config.py /data/$proj/install/docker/serve-cgi-bin.conf
    mes "Next step [$step]" "end"

    step="apache"
    mes "Next step [$step]" "start"
    export status=0
    if [ ! -f /etc/apache2/flyton.skip ]
    then cp /data/$proj/install/docker/serve-cgi-bin.conf /etc/apache2/conf-enabled/ && \
        cp /data/$proj/install/docker/000-default.conf /etc/apache2/sites-enabled/
        ln -s /data/$proj/server/cgi-bin /var/www/
        rm -fr /usr/lib/cgi-bin 2>/dev/null
        ln -s /var/www/cgi-bin /usr/lib/
    else mkdir -p /var/www/cgi-bin
         cp -rp /data/$proj/server/cgi-bin/* /var/www/cgi-bin/
    fi
    chmod 755 /var/www/cgi-bin/*
    apache2ctl configtest
    if [ "x$?" != "x0" ]
    then gored ; echo "apache refuses the conf - look at /etc/apache2/sites-enabled/" ; goback
         exit
    fi
    systemctl restart apache2 && status=1
    if [ "x$status" = "x0" ]
    then echo "Fail"
         exit
    fi
    mes "Next step [$step]" "end"

    step="link to /var/www/html/"
    mes "Next step [$step]" "start"
    ln -s /data/$proj/client/pages /var/www/html/
    ln -s /data/$proj/client/lib /var/www/html/
    ln -s /data/$proj/client/app /var/www/html/
    ln -s /data/$proj/server/apis/tools /data/$proj/client/app/
    cp /data/$proj/install/docker/html/index.html /var/www/html/index.html
    ln -s /data/$proj /home/kic/
    chown -R kic:kic /data/$proj
    mes "Next step [$step]" "end"

    #  database + mysql user = $db - only the exact lines of init.sql are changed
    step="create database"
    mes "Next step [$step]" "start"
    sed -e "s/^create database fly;/create database $db;/" \
        -e "s/^use fly;/use $db;/" \
        -e "s/'fly'@'%'/'$db'@'%'/g" \
        /data/$proj/install/docker/init.sql | mysql
    mes "Next step [$step]" "end"

    #  the admin tools - this script as "fly" , kic.bash as "kic" , Grep as "Grep"
    step="links in /usr/bin"
    mes "Next step [$step]" "start"
    me=`readlink -f $0`
    if [ "x$me" != "x/ins/fly.bash" ]
    then mkdir -p /ins && cp $me /ins/fly.bash
    fi
    chmod 755 /ins/fly.bash /data/$proj/install/kic.bash /data/$proj/install/Grep
    ln -sf /ins/fly.bash /usr/bin/fly
    ln -sf /data/$proj/install/kic.bash /usr/bin/kic
    ln -sf /data/$proj/install/Grep /usr/bin/Grep
    mes "Next step [$step]" "end"

    step="check"
    mes "Next step [$step]" "start"
    curl -s -o /dev/null -w "   /cgi-bin/p   -> %{http_code}\n" "http://127.0.0.1/cgi-bin/p?app=start"
    curl -s -o /dev/null -w "   /cgi-bin/api -> %{http_code}\n" -d '{"info":{"os":"a","ses":""}}' "http://127.0.0.1/cgi-bin/api?meth=ping"
    echo "a 200 on both is what it should be . if not : tail -f /var/log/apache2/error.log"
    mes "Next step [$step]" "end"

    echo ""
    echo "   END OF INSTALL [$proj]"
    echo "   END OF INSTALL [$proj]"
    echo "   END OF INSTALL [$proj]"
    echo ""
    gored
    echo " please change default db password (1964) :"
    echo "   mysql -e \"ALTER USER '$db'@'%' IDENTIFIED BY 'newpas';\""
    echo "   and the same password in /data/$proj/server/config.py"
    goback
    echo ""
    echo " http://thisip/pages/login    username kic , password fly123"
fi


if [ "x$user-$x" = "xroot-R" ]
then #
    mkdir -p /ins && cd /ins && rm -f fly.bash 2>/dev/null && wget -q $raw -O fly.bash && chmod 755 fly.bash && ln -sf /ins/fly.bash /usr/bin/fly && exec ./fly.bash
fi


exit
#
#
# Flyton installation on an empty ubuntu
#
# (1) first time:
#     useradd -s /bin/bash -m kic
#     passwd kic
#
# (2) then run (as root):
#     mkdir -p /ins && cd /ins && wget -q https://raw.githubusercontent.com/yaweli/flyton/main/install/fly.bash && chmod 755 fly.bash && ln -sf /ins/fly.bash /usr/bin/fly
#
# (3) then :
#     fly N   - pick the system name  ( Shop -> /data/Shop , database shop )
#     fly I   - full install
#
# fly U - full uninstall !DANGER erase all
# fly R - read new version of this script
