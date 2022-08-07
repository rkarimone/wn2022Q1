

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


