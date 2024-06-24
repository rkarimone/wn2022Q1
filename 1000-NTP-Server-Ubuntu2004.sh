

### Server Configuration

sudo apt install ntp ntpdate


root@xx253:~# cat  /etc/ntp.conf 
# /etc/ntp.conf, configuration for ntpd; see ntp.conf(5) for help
driftfile /var/lib/ntp/ntp.drift
leapfile /usr/share/zoneinfo/leap-seconds.list

statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable

server 192.168.101.221
#server 192.168.102.153

#pool 2.debian.pool.ntp.org iburst
pool bd.pool.ntp.org iburst

# By default, exchange time with everybody, but don't allow configuration.
restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited

# Local users may interrogate the ntp server more closely.
#restrict default ignore
restrict 127.0.0.1
restrict ::1

# Needed for adding pool entries
restrict 192.168.0.0 mask 255.255.0.0 nomodify notrap
restrict source notrap nomodify noquery




systemctl enable ntp
systemctl restart ntp
systemctl status ntp


ntpq -p
ntpq -pn
ntpdate -dv 192.168.101.221

### Client Configuration

root@sarkarim:~# cat /etc/ntp.conf 
# /etc/ntp.conf, configuration for ntpd; see ntp.conf(5) for help
driftfile /var/lib/ntp/ntp.drift

# Leap seconds definition provided by tzdata
leapfile /usr/share/zoneinfo/leap-seconds.list
#
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable
#
server 192.168.102.153
#
# By default, exchange time with everybody, but don't allow configuration.
restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited

# Local users may interrogate the ntp server more closely.
restrict 127.0.0.1
restrict ::1

# Needed for adding pool entries
restrict source notrap nomodify noquery




systemctl enable ntp
systemctl restart ntp
systemctl status ntp


ntpq -p
ntpq -pn
ntpdate -dv 192.168.102.153





#####################

oot@xx253:~# cat /etc/ntp.conf 
# /etc/ntp.conf, configuration for ntpd; see ntp.conf(5) for help
driftfile /var/lib/ntp/ntp.drift
leapfile /usr/share/zoneinfo/leap-seconds.list
logfile /var/log/ntp.log
#statistics loopstats peerstats clockstats
#filegen loopstats file loopstats type day enable
#filegen peerstats file peerstats type day enable
#filegen clockstats file clockstats type day enable

#server 192.168.101.221
#server 192.168.102.153

#pool 2.debian.pool.ntp.org iburst
pool bd.pool.ntp.org iburst

# By default, exchange time with everybody, but don't allow configuration.
#restrict -4 default kod notrap nomodify nopeer noquery limited
#restrict -6 default kod notrap nomodify nopeer noquery limited

# Local users may interrogate the ntp server more closely.

restrict default ignore
restrict 127.0.0.1

# Needed for adding pool entries
restrict 192.168.0.0 mask 255.255.0.0 nomodify notrap
restrict source notrap nomodify noquery



root@mfsstorage2:/var/log# cat /etc/ntp.conf 
# /etc/ntp.conf, configuration for ntpd; see ntp.conf(5) for help
driftfile /var/lib/ntp/ntp.drift
leapfile /usr/share/zoneinfo/leap-seconds.list
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable
#
server 192.168.102.153
#
restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited
restrict 127.0.0.1
restrict ::1
restrict source notrap nomodify noquery




###################





 1  atp update -y
    2  atp update
    3  apt update
    4  apt full-upgrade -y
    5  date 
    6  cat /etc/timezone 
    7  vi /etc/timezone 
    8  echo "Asis/Dhaka" > /etc/timezone 
    9  vi /etc/timezone 
   10  echo "Asia/Dhaka" > /etc/timezone 
   11  date 
   12  reboot 
   13  date 
   14  rm /etc/localtime 
   15  ln -s /usr/share/zoneinfo/Asia/Dhaka /etc/localtime 
   16  date 
   17  apt -y install chrony
   18  apt install -y ifupdown vim net-tools bash-completion wget
   19  apt autoremove -y --purge netplan.io resolvconf
   20  ifconfig 
   21  vi /etc/chrony/chrony.conf
   22  systemctl restart chrony
   23  vi /etc/chrony/chrony.conf
   24  systemctl restart chrony
   25  chronyc sources
   26  chronyc tracking 
   27  chronyc sources
   28  ifconfig 
   29  chronyc sources
   30  chronyc clients 
   31  vi /etc/chrony/chrony.conf
   32  chronyc clients 
   33  systemctl status chronyd
   34  systemctl enable chronyd
   35  reboot 
   36  systemctl status chronyd
   37  uptime 
   38  vi /etc/ssh/sshd_config
   39  systemctl restart ssh
   40  systemctl restart sshd
   41  vim /etc/chrony/chrony.conf 
   42  chronyc clients 
   43  chronyc server
   44  chrony server
   45  chronyc servers
   46  chronyc -h
   47  chronyc sources
   48  exit
   49  ls
   50  ifconfig 
   51  hostname -f
   52  ping ntp.cycloneone.net
   53  vim /etc/chrony/chrony.conf 
   54  history 
   55  history |grep  restart
   56  systemctl restart chrony
   57  vim /etc/chrony/chrony.conf 
   58  systemctl restart chrony
   59  systemctl status chrony
   60  ping google.com
   61  exit
   62  cd /etc/chrony/
   63  ls
   64  vim chrony.conf 
   65  history 
   66  systemctl restart chrony
   67  vim chrony.conf 
   68  systemctl restart chrony
   69  tail -f /var/log/syslog
   70  history |more
   71  chronyc clients
   72  exit
   73  vim /etc/chrony/chrony.conf 
   74  systemctl restart chrony
   75  history 




root@ntp:~# cat /etc/chrony/chrony.conf 
# Welcome to the chrony configuration file. See chrony.conf(5) for more
# information about usable directives.

# Include configuration files found in /etc/chrony/conf.d.
confdir /etc/chrony/conf.d

# This will use (up to):
# - 4 sources from ntp.ubuntu.com which some are ipv6 enabled
# - 2 sources from 2.ubuntu.pool.ntp.org which is ipv6 enabled as well
# - 1 source from [01].ubuntu.pool.ntp.org each (ipv4 only atm)
# This means by default, up to 6 dual-stack and up to 2 additional IPv4-only
# sources will be used.
# At the same time it retains some protection against one of the entries being
# down (compare to just using one of the lines). See (LP: #1754358) for the
# discussion.
#
# About using servers from the NTP Pool Project in general see (LP: #104525).
# Approved by Ubuntu Technical Board on 2011-02-08.
# See http://www.pool.ntp.org/join.html for more information.
#pool ntp.ubuntu.com        iburst maxsources 4
#pool 0.ubuntu.pool.ntp.org iburst maxsources 1
#pool 1.ubuntu.pool.ntp.org iburst maxsources 1
#pool 2.ubuntu.pool.ntp.org iburst maxsources 2

server 0.asia.pool.ntp.org iburst
server 1.asia.pool.ntp.org iburst
server 2.asia.pool.ntp.org iburst
server 3.asia.pool.ntp.org iburst
server bd.pool.ntp.org iburst

#add network range you allow to receive time syncing requests from clients
allow 103.7.248.0/24
allow 103.115.100.0/24
allow 103.115.101.0/24
allow 103.118.84.0/22
allow 103.12.204.0/23
allow 103.109.215.0/24
allow 103.132.180.0/24
allow 103.166.59.0/24
allow 103.138.250.0/24
allow 103.152.105.0/24
allow 103.179.124.0/24
allow 103.124.30.0/23
allow 103.229.83.0/24
allow 103.229.82.0/24

####
#### ALLOW CYCLONE ISP SUBNET HERE #####
####

# Use time sources from DHCP.
sourcedir /run/chrony-dhcp

# Use NTP sources found in /etc/chrony/sources.d.
sourcedir /etc/chrony/sources.d

# This directive specify the location of the file containing ID/key pairs for
# NTP authentication.
keyfile /etc/chrony/chrony.keys

# This directive specify the file into which chronyd will store the rate
# information.
driftfile /var/lib/chrony/chrony.drift

# Save NTS keys and cookies.
ntsdumpdir /var/lib/chrony

# Uncomment the following line to turn logging on.
#log tracking measurements statistics

# Log files location.
logdir /var/log/chrony

# Stop bad estimates upsetting machine clock.
maxupdateskew 100.0

# This directive enables kernel synchronisation (every 11 minutes) of the
# real-time clock. Note that it can’t be used along with the 'rtcfile' directive.
rtcsync

# Step the system clock instead of slewing it if the adjustment is larger than
# one second, but only in the first three clock updates.
makestep 1 3

# Get TAI-UTC offset and leap seconds from the system tz database.
# This directive must be commented out when using time sources serving
# leap-smeared time.
leapsectz right/UTC





#### Mikrotik Script

/system ntp client set enabled=yes
/system clock set time-zone-name=Asia/Dhaka
/system ntp client servers add address=103.12.205.40





ip firewall nat add action=src-nat chain=srcnat comment=___bd_ntp_server1___ dst-address=182.16.156.0/24 to-addresses=a.b.c.d
ip firewall nat add action=src-nat chain=srcnat comment=___bd_ntp_server2___ dst-address=27.54.117.0/24 to-addresses=a.b.c.d
system clock set time-zone-name=Asia/Dhaka
system ntp client set enabled=yes
system ntp client servers add address=182.16.156.246
system ntp client servers add address=182.16.156.5
system ntp client servers add address=27.54.117.72




## SG GOOGLE SERVERS ## time4.google.com
ip firewall nat add action=src-nat chain=srcnat comment=___sg_ntp_server3___ dst-address=216.239.35.0/24 to-addresses=a.b.c.d
system ntp client servers add address=216.239.35.12

rkarim@rfskypc:~$ nslookup time.cloudflare.com
Server:		8.8.8.8
Address:	8.8.8.8#53

Non-authoritative answer:
Name:	time.cloudflare.com
Address: 162.159.200.1
Name:	time.cloudflare.com
Address: 162.159.200.123
Name:	time.cloudflare.com
Address: 2606:4700:f1::1
Name:	time.cloudflare.com
Address: 2606:4700:f1::123

rkarim@rfskypc:~$ 



ALTER TABLE radacct CHANGE COLUMN nasportid nasportid VARCHAR(32);




ipfw add pipe 80 ip4 from any to any in via ix0                                 
ipfw pipe 80 config bw 550Mbits/s type fq_codel quantum 1514 ecn

ALTER TABLE radacct CHANGE COLUMN nasportid nasportid VARCHAR(32);
