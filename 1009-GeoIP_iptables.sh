# https://www.xmodulo.com/block-network-traffic-by-country-linux.html
# https://docs.rackspace.com/support/how-to/block-ip-range-from-countries-with-geoip-and-iptables/
# https://think.unblog.ch/en/geoip-firewall-configuration-on-debian-and-ubuntu/
# https://ultramookie.com/2020/10/geoip-blocking-ubuntu-20.04/

# https://github.com/nawawi/xtables-addons -- MaxMind & DB-IP


sudo apt-get update; sudo apt-get -y upgrade
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


