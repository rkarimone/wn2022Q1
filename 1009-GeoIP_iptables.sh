
############  UBUNTU 22.04/24.04 #########################

# Install packages
apt-get install xtables-addons-common libtext-csv-xs-perl unzip

# Check modules
modprobe xt_geoip
sudo lsmod | grep ^xt_geoip

# Create the directory where the country data should live
mkdir /usr/share/xt_geoip

# Download and install the latest country data
mkdir /tmp/xt_geoip_dl
cd /tmp/xt_geoip_dl

/usr/libexec/xtables-addons/xt_geoip_dl
/usr/libexec/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip *.csv

# Test rules to DROP Singapore
iptables -I INPUT 1 -m geoip --src-cc SG -j DROP


######### Automatic script ##########

vim /usr/local/bin/geo-update.sh

____________________________________________________________________________
#!/bin/bash
mkdir -p /tmp/xt_geoip_dl
echo -e "Doing CD TMP \n"
cd /tmp/xt_geoip_dl
sleep 1
echo -e "Downloading \n"
/usr/libexec/xtables-addons/xt_geoip_dl
sleep 1
echo -e "Converting Or Bulding \n"
/usr/libexec/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip *.csv
sleep 2
echo -e "Removing TMP \n"
rm -fr /tmp/xt_geoip_dl
sleep 1
echo -e "Removing Dot CSV TMP \n"
rm -fr /usr/share/xt_geoip/dbip-country-lite.csv
sleep 7
echo -e "Reloading Iptables Rules \n"
/opt/iptables-script-rules.sh
____________________________________________________________________________
( Save+Exit )


### User Defined Iptables Script ###
vim /opt/iptables-script-rules.sh
____________________________________________________________________________

#!/bin/bash
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
iptables -F -t mangle
iptables -F -t nat
iptables -F
iptables -X
iptables -Z
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z
iptables --table nat -F
iptables --delete-chain
iptables --table nat --delete-chain
iptables -t mangle --delete-chain

#systemctl stop postfix
#systemctl stop dovecot
#systemctl restart ufw
#systemctl restart fail2ban

#/etc/init.d/ufw restart
#/etc/init.d/fail2ban restart
sleep 5
while read IP; do
    iptables -I INPUT -s $IP -j DROP
done < /opt/fight-spam/extracted-ip-list.txt
iptables -I INPUT 1 -i lo -j ACCEPT
#iptables -I INPUT 2 -i wg0 -j ACCEPT
#iptables -I INPUT 3 -i wg1 -j ACCEPT
#
iptables -I INPUT 2 -i ens18 -m geoip -p tcp -m multiport --dports 22,25,7878,7979,110,143,465,587,993,995,8080,8081 --src-cc BR,RU,CN,PL,TW,CA,JP,HK,KR,UA,DE,TR,ID,IN,FR -j DROP
iptables -I INPUT 3 -i ens18 -m geoip -p tcp -m multiport --dports 22,25,7878,7979,110,143,465,587,993,995,8080,8081 --src-cc GB,NL,SK,ZA,VN,KH,MX,MZ,LT,IT,AL,RO,US,IR,CZ -j DROP
iptables -I INPUT 4 -i ens18 -m geoip -p tcp -m multiport --dports 22,25,7878,7979,110,143,465,587,993,995,8080,8081 --src-cc AR,BG,IQ,EG,PY,NP,AU,NO,SG,DE,PT,NG,DO,SE,PK -j DROP
iptables -I INPUT 5 -i ens18 -m geoip -p tcp -m multiport --dports 22,25,7878,7979,110,143,465,587,993,995,8080,8081 --src-cc ET,IL,MT,ES,KN,TN,RS,ZM,CL,TH,LR,AM,CO,MD -j DROP
#
iptables -P INPUT ACCEPT
#
#systemctl start postfix
#systemctl start dovecot
____________________________________________________________________________
( Save+Exit )

vim /opt/fight-spam/extracted-ip-list.txt
80.94.95.0/24
( Save+Exit )

# Provide Exec Permission ###
chmod +x /usr/local/bin/geo-update.sh
chmod +x /opt/iptables-script-rules.sh

# Run ...
/usr/local/bin/geo-update.sh


# Check rules ...
iptables -L INPUT --line-numbers -vn



#### Crontab for Weekly Update ####

vim /etc/crontab
@weekly         root    /usr/local/bin/geo-update.sh >/dev/null 2>&1
____________________________________________________________________________________________________________________


##Old-scripts-bellow##
____________________________________________________________________________________________________________________

# https://www.xmodulo.com/block-network-traffic-by-country-linux.html
# https://docs.rackspace.com/support/how-to/block-ip-range-from-countries-with-geoip-and-iptables/
# https://think.unblog.ch/en/geoip-firewall-configuration-on-debian-and-ubuntu/
# https://ultramookie.com/2020/10/geoip-blocking-ubuntu-20.04/

# https://github.com/nawawi/xtables-addons -- MaxMind & DB-IP

############  UBUNTU 20.04 #########################
sudo apt-get update; 
sudo apt-get -y upgrade
sudo apt-get install curl unzip perl
sudo apt-get install xtables-addons-common
sudo apt-get install libtext-csv-xs-perl libmoosex-types-netaddr-ip-perl

sudo mkdir /usr/share/xt_geoip
chmod +x /usr/lib/xtables-addons/*
sudo vim /usr/local/bin/geo-update.sh

#!/bin/bash

MON=$(date +"%m")
YR=$(date +"%Y")

wget https://download.db-ip.com/free/dbip-country-lite-${YR}-${MON}.csv.gz -O /usr/share/xt_geoip/dbip-country-lite.csv.gz
gunzip /usr/share/xt_geoip/dbip-country-lite.csv.gz
/usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip/ -S /usr/share/xt_geoip/
rm /usr/share/xt_geoip/dbip-country-lite.csv

sudo chmod +x /usr/local/bin/geo-update.sh
sudo modprobe xt_geoip

# Run ...
/usr/local/bin/geo-update.sh

sudo lsmod | grep ^xt_geoip
sudo iptables -m geoip -h

sudo iptables -L INPUT --line-numbers -vn


sudo iptables -A INPUT -m geoip --src-cc BD,GB -j ACCEPT
# sudo iptables -A INPUT -m geoip ! --src-cc BD,GB -j DROP
sudo iptables -A INPUT -m geoip -p tcp -m multiport --dports 22,80,443,1431,1433,3306,33060 --src-cc BD,GB -j ACCEPT
sudo iptables -A INPUT -m geoip -p tcp -m multiport --dports 22,80,443,1431,1433,3306,33060 ! --src-cc BD,GB -j DROP




sudo iptables -L INPUT --line-numbers -vn



sudo vim /etc/ufw/before.rules

### Add following lines before COMMIT
# -A INPUT -m geoip --src-cc BD,GB -j ACCEPT
-A ufw-before-input -m geoip -p tcp -m multiport --dports 22,80,443,1431,1433,3306,33060 --src-cc BD,GB -j ACCEPT
-A ufw-before-input -m geoip -p tcp -m multiport --dports 22,80,443,1431,1433,3306,33060 ! --src-cc BD,GB -j DROP

# don't delete the 'COMMIT' line or these rules won't be processed
COMMIT


ufw reload














########### TV TV TV ##### J


root@mx1:~# cat /etc/network/if-up.d/rc.local.sh
iptables -F
iptables -A INPUT -s 127.0.0.0/8 -j ACCEPT
iptables -A INPUT -s 192.168.55.0/24 -j ACCEPT
iptables -A INPUT -m geoip -p tcp -m multiport --dports 22,80,143,993,443,4190,5432,5232 ! --src-cc BD -j DROP
iptables -A INPUT -m geoip --src-cc RU,CN,KR,KP,BR,UG -j DROP



root@email:~# cat /etc/network/if-up.d/rc.local.sh 
iptables -F
iptables -A INPUT -s 127.0.0.0/8 -j ACCEPT
iptables -A INPUT -s 192.168.55.0/24 -j ACCEPT
iptables -A INPUT -m geoip ! --src-cc BD -j DROP







kernel.shmmax=536870912
kernel.shmall=131072

max_connections = 200
shared_buffers = 256MB
effective_cache_size = 768MB
work_mem = 1310kB
maintenance_work_mem = 64MB
#checkpoint_segments = 32
checkpoint_completion_target = 0.7
wal_buffers = 7864kB
default_statistics_target = 100



