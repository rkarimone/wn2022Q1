
-- https://www.caretech.io/2021/05/20/how-to-install-nextcloud-21-on-ubuntu-server-20-04-with-nginx-php-fpm-mariadb-and-redis/
-- Create Ubuntu 20.04 Container
-- Ensure Public IP and DNS A Record assumming it as nextcloud.domain.com = public-ip






ping google.com
apt update && upgrade -y
apt install iftop htop mtr mc traceroute bwm-ng glances nano openssh-server net-tools ifupdown vim sudo -y


sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved.service
rm -fr /etc/resolv.conf
touch /etc/resolv.conf
echo "nameserver 1.0.0.3" > /etc/resolv.conf

apt install python3-pip
pip3 install bpytop --upgrade
bpytop 


vi /etc/ssh/sshd_config
/etc/init.d/ssh restart
systemctl restart sshd
netstat -tulpn
dpkg-reconfigure tzdata

vim /etc/apt/sources.list
mirror.0x.sg


apt update
apt upgrade

hostname -f
apt install nginx mariadb-server
apt install php7.4 php7.4-fpm php7.4-common php7.4-gd php7.4-curl php7.4-zip php7.4-xml php7.4-mbstring php7.4-intl php7.4-imap php7.4-bcmath php7.4-redis php7.4-mysql php7.4-gmp php7.4-imagick redis image
magick -y

mysql_secure_installation
mysql

mysql -u root -p
MariaDB [(none)]> CREATE DATABASE nextclouddb;
MariaDB [(none)]> CREATE USER 'nextclouddbu'@'localhost' IDENTIFIED BY 'Password';
MariaDB [(none)]> GRANT ALL ON nextclouddb.* TO 'nextclouddbu'@'localhost' IDENTIFIED BY 'Password';
MariaDB [(none)]> FLUSH PRIVILEGES;
MariaDB [(none)]> exit

apt install unzip
wget 'https://download.nextcloud.com/server/releases/nextcloud-23.0.3.zip'
unzip nextcloud-23.0.3.zip
mv nextcloud /var/www/


vim /etc/nginx/nginx.conf 

cd /etc/nginx/sites-enabled/
vim default 

chown -R www-data:www-data /var/www/nextcloud
touch /etc/nginx/sites-available/nextcloud
vim /etc/nginx/sites-available/nextcloud

###########################################################----------############################################################################### 
#######################
upstream php-handler {
    #server 127.0.0.1:9000;
    server unix:/run/php/php7.4-fpm.sock;
}

server {
    if ($host = nextcloud.domain.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    listen [::]:80;
    server_name nextcloud.domain.com;

    # Enforce HTTPS
    return 301 https://$server_name$request_uri;


}

server {
    listen 443      ssl http2;
    listen [::]:443 ssl http2;
    server_name nextcloud.domain.com;

    # Use Mozilla's guidelines for SSL/TLS settings
    # https://mozilla.github.io/server-side-tls/ssl-config-generator/
    ssl_certificate /etc/letsencrypt/live/nextcloud.domain.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/nextcloud.domain.com/privkey.pem; # managed by Certbot

    # HSTS settings
    # WARNING: Only add the preload option once you read about
    # the consequences in https://hstspreload.org/. This option
    # will add the domain to a hardcoded list that is shipped
    # in all major browsers and getting removed from this list
    # could take several months.
    add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;" always;

    # set max upload size
    client_max_body_size 512M;
    fastcgi_buffers 64 4K;

    # Enable gzip but do not remove ETag headers
    gzip on;
    gzip_vary on;
    gzip_comp_level 4;
    gzip_min_length 256;
    gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
    gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-f
ont-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc t
ext/vtt text/x-component text/x-cross-domain-policy;

    # Pagespeed is not supported by Nextcloud, so if your server is built
    # with the `ngx_pagespeed` module, uncomment this line to disable it.
    #pagespeed off;

    # HTTP response headers borrowed from Nextcloud `.htaccess`
    add_header Referrer-Policy                      "no-referrer"   always;
    add_header X-Content-Type-Options               "nosniff"       always;
    add_header X-Download-Options                   "noopen"        always;
    add_header X-Frame-Options                      "SAMEORIGIN"    always;
    add_header X-Permitted-Cross-Domain-Policies    "none"          always;
    add_header X-Robots-Tag                         "none"          always;
    add_header X-XSS-Protection                     "1; mode=block" always;

    # Remove X-Powered-By, which is an information leak
    fastcgi_hide_header X-Powered-By;

    # Path to the root of your installation
    root /var/www/nextcloud;

    # Specify how to handle directories -- specifying `/index.php$request_uri`
    # here as the fallback means that Nginx always exhibits the desired behaviour
    # when a client requests a path that corresponds to a directory that exists
    # on the server. In particular, if that directory contains an index.php file,
    # that file is correctly served; if it doesn't, then the request is passed to
    # the front-end controller. This consistent behaviour means that we don't need
    # to specify custom rules for certain paths (e.g. images and other assets,
    # `/updater`, `/ocm-provider`, `/ocs-provider`), and thus
    # `try_files $uri $uri/ /index.php$request_uri`
    # always provides the desired behaviour.
    index index.php index.html /index.php$request_uri;

    # Rule borrowed from `.htaccess` to handle Microsoft DAV clients
    location = / {
        if ( $http_user_agent ~ ^DavClnt ) {
            return 302 /remote.php/webdav/$is_args$args;
        }
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # Make a regex exception for `/.well-known` so that clients can still
    # access it despite the existence of the regex rule
    # `location ~ /(\.|autotest|...)` which would otherwise handle requests
    # for `/.well-known`.
    location ^~ /.well-known {
        # The rules in this block are an adaptation of the rules
        # in `.htaccess` that concern `/.well-known`.

        location = /.well-known/carddav { return 301 /remote.php/dav/; }
        location = /.well-known/caldav  { return 301 /remote.php/dav/; }

        location /.well-known/acme-challenge    { try_files $uri $uri/ =404; }
        location /.well-known/pki-validation    { try_files $uri $uri/ =404; }

        # Let Nextcloud's API for `/.well-known` URIs handle all other
        # requests by passing them to the front-end controller.
        return 301 /index.php$request_uri;
    }

    # Rules borrowed from `.htaccess` to hide certain paths from clients
    location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)  { return 404; }
    location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console)                { return 404; }



    # Ensure this block, which passes PHP files to the PHP process, is above the blocks
    # which handle static assets (as seen below). If this block is not declared first,
    # then Nginx will encounter an infinite rewriting loop when it prepends `/index.php`
    # to the URI, resulting in a HTTP 500 error response.
    location ~ \.php(?:$|/) {
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;
        set $path_info $fastcgi_path_info;

        try_files $fastcgi_script_name =404;

        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $path_info;
        fastcgi_param HTTPS on;

        fastcgi_param modHeadersAvailable true;         # Avoid sending the security headers twice
        fastcgi_param front_controller_active true;     # Enable pretty urls
        fastcgi_pass php-handler;

        fastcgi_intercept_errors on;
        fastcgi_request_buffering off;
    }

    location ~ \.(?:css|js|svg|gif)$ {
        try_files $uri /index.php$request_uri;
        expires 6M;         # Cache-Control policy borrowed from `.htaccess`
        access_log off;     # Optional: Don't log access to assets
    }

    location ~ \.woff2?$ {
        try_files $uri /index.php$request_uri;
        expires 7d;         # Cache-Control policy borrowed from `.htaccess`
        access_log off;     # Optional: Don't log access to assets
    }

    # Rule borrowed from `.htaccess`
    location /remote {
        return 301 /remote.php$request_uri;
    }

    location / {
        try_files $uri $uri/ /index.php$request_uri;
    }

}


-- Follow video instruction For Snake Oil Certificate...
###########################################################----------###############################################################################

ln -s /etc/nginx/sites-available/nextcloud /etc/nginx/sites-enabled/
nginx -t
apt install mlocate
updatedb
locate snakeoil.key
vim /etc/nginx/sites-available/nextcloud     ; adjust snakeoild location
nginx -t
systemctl reload nginx
poweroff 


-- added disk-mount-point | please follow video instrucktion
df -h
/etc/init.d/nginx stop
/etc/init.d/nginx start

cd /var/www/nextcloud/
chown -R www-data:www-data data


Run NextCloud Setup .. https://nextcloud.domain.com/    -- follow video instruction (Disabled Dashboard App)


apt install certbot python3-certbot-nginx
certbot --nginx -d nextcloud.domain.com  | -- please follow video instruction

nginx -t
systemctl restart nginx

vim /etc/nginx/sites-enabled/nextcloud 
add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;" always;  --enable this line

vim /etc/php/7.4/fpm/php.ini
date.timezone = Asia/Dhaka
memory_limit = 2048M
upload_max = 1024M
post_max = 1024M



vim /etc/php/7.4/fpm/pool.d/www.conf		-- enable following lines
env[HOSTNAME] = $HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp

systemctl restart nginx php7.4-fpm

vim /var/www/nextcloud/config/config.php
  'default_phone_region' => 'BD',		-- at this line at end


vim /var/www/nextcloud/config/config.php		-- enable Redis

'filelocking.enabled' => true,
'memcache.locking' => '\OC\Memcache\Redis',
'memcache.local' => '\OC\Memcache\Redis',
'memcache.distributed' => '\OC\Memcache\Redis',
'redis' => array(
   'host' => 'localhost',
   'port' => 6379,
   'timeout' => 0.0,
   'password' => '',

--- final /var/www/nextcloud/config/config.php

root@nextcloud:~# cat /var/www/nextcloud/config/config.php
<?php
$CONFIG = array (
  'instanceid' => 'oc528jpj8kkk',
  'passwordsalt' => 'r1yI3rrWMkDp+JC7SKorsfsd57seCt',
  'secret' => 'dkIh/Ipv08GQbZeg9kznsdfsdyVbT0TqyfNyi6URFEIgMhU8',
  'trusted_domains' => 
  array (
    0 => 'nextcloud.domain.com',
  ),
  'datadirectory' => '/var/www/nextcloud/data',
  'dbtype' => 'mysql',
  'version' => '23.0.3.2',
  'overwrite.cli.url' => 'https://nextcloud.domain.com',
  'dbname' => 'nextclouddb',
  'dbhost' => 'localhost',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'nextclouddbu',
  'dbpassword' => 'Password',
  'installed' => true,
  'default_phone_region' => 'BD',
  'filelocking.enabled' => true,
  'memcache.locking' => '\OC\Memcache\Redis',
  'memcache.local' => '\OC\Memcache\Redis',
  'memcache.distributed' => '\OC\Memcache\Redis',
  'redis' => array(
     'host' => 'localhost',
     'port' => 6379,
     'timeout' => 0.0,
     'password' => '',
      ),
);





vim /etc/crontab 
*/5  *  *  *  * /usr/bin/php -f /var/www/nextcloud/cron.php
/usr/bin/php -f /var/www/nextcloud/cron.php


also enable cront from nextcloud-admin-settings.

--- Create accounts and test
--- reboot


https://nextcloud.domain.com | ldapbackup | Passwed
https://nextcloud.domain.com | admin | Passwd




-- Install & Setup rclone
-- From Ubuntu/Linux Client

apt install rclone / yum install rclone    (in centos enable epel.repo)



rclone config



No remotes found, make a new one?
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n
name> ldapbackup
Type of storage to configure.
Choose a number from below, or type in your own value
[snip]
XX / Webdav
   \ "webdav"
[snip]
Storage> webdav
URL of http host to connect to
Choose a number from below, or type in your own value
 1 / Connect to example.com
   \ "https://example.com"
url> https://nextcloud.domain.com/remote.php/dav/files/ldapbackup/        --- find this url from user-settings  https://nextcloud.domain.com/remote.php/dav/files/ldapbackup/
Name of the Webdav site/service/software you are using
Choose a number from below, or type in your own value
 1 / Nextcloud
   \ "nextcloud"
 2 / Owncloud
   \ "owncloud"
 3 / Sharepoint Online, authenticated by Microsoft account.
   \ "sharepoint"
 4 / Sharepoint with NTLM authentication. Usually self-hosted or on-premises.
   \ "sharepoint-ntlm"
 5 / Other site/service or software
   \ "other"
vendor> 1
User name
user> ldapbackup
Password.
y) Yes type in my own password
g) Generate random password
n) No leave this optional password blank
y/g/n> y
Enter the password:
password:
Confirm the password:
password:
Bearer token instead of user/pass (e.g. a Macaroon)
bearer_token> Remote config

--------------------
[remote]
type = webdav
url = https://example.com/remote.php/webdav/
vendor = nextcloud
user = user
pass = *** ENCRYPTED ***
bearer_token =
--------------------
y) Yes this is OK
e) Edit this remote
d) Delete this remote
y/e/d> y





cd /home/rkarim
vim .config/rclone/rclone.conf




rclone ls ldapbackup:



sudo vim /opt/ldap_export_sync.sh

#!/bin/bash
date_time=`date +%d-%m-%Y-%H%M%S`
mkdir -p /opt/ldapbackup/$date_time/$date_time
slapcat -b "dc=ldap,dc=servicenginebd,dc=net" -l /opt/ldapbackup/$date_time/$date_time/$date_time-backup.ldif 2> /dev/null;
rclone copy /opt/ldapbackup/$date_time ldapbackup:ldapbackup


chmod +x /opt/ldap_export_sync.sh

ln -s /opt/ldap_export_sync.sh /usr/bin/


vim /etc/crontab
5 9  *  *  * root	ldap_export_sync.sh	

