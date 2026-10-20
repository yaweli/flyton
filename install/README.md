# Install a new Flyton system on an empty Ubuntu

The install is done by one script : `install/fly.bash` .
Every new system gets its own name - it is the directory `/data/<Name>` .

## The name

- first letter Upper case , then 1 to 9 lower case letters
- good : `Shop` , `Zg` , `Bridgekey`   bad : `shop` , `Z` , `SHop` , `Shop1`
- the code goes to `/data/<Name>` , the database and the mysql user are the name in lower case (`shop`)
- once installed the name is locked - to change it , uninstall (`fly U`) first

## Steps (as root)

1. create the user kic

        useradd -s /bin/bash -m kic
        passwd kic

2. get the script , and link it to `/usr/bin/fly`

        mkdir -p /ins && cd /ins && wget -q https://raw.githubusercontent.com/yaweli/flyton/main/install/fly.bash && chmod 755 fly.bash && ln -sf /ins/fly.bash /usr/bin/fly

3. pick the name , then install

        fly N
        fly I

4. **please change the default db password** (1964) - in mysql and in `/data/<Name>/server/config.py`

        mysql -e "ALTER USER 'shop'@'%' IDENTIFIED BY 'newpas';"

5. open `http://thisip/pages/login` - username `kic` , password `fly123`

## What `fly I` does

- apt install : git apache2 python3 python3-pip mysql-server mysql-client python3-mysql.connector , `a2enmod cgi`
- git clone of flyton into `/data/<Name>` - and the flyton `.git` is removed , it is now **your** project ,
  create your own git for it
- puts the name into the code : `server/cgi-bin/api` , `server/cgi-bin/p4web.py` ,
  `server/config.py` (made from `fly_config.py`) , `install/Grep` , `install/kic.bash`
- apache : `install/docker/000-default.conf` + `serve-cgi-bin.conf` , links `cgi-bin` , `pages` , `lib` , `app`
- the database from `install/docker/init.sql`
- links in `/usr/bin` : `fly` (this script) , `kic` (kic.bash) , `Grep`

## All options

| option | what |
|---|---|
| N  | name of the system |
| I  | install on an empty linux |
| U  | uninstall - the files and mysql data are renamed with the date , not deleted |
| A1 | apache is already installed - skip it (a server with more than one project) |
| R  | reload a new version of this script from the web |
| F  | first time instructions |
| l  | apache error log |
| s  | mysql |

The name is kept in `/ins/.env` .

## Docker

see `install/docker/README.md`
