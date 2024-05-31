############### 2024 ############# UBUNTU 22.04 ###################################



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|Resolve Language+DNS Issue ||▼
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

apt update
apt upgrade
apt install rsyslog vim mtr nano


apt -y install locales locales-all
localectl set-locale LANG=en_US.UTF-8 LANGUAGE="en_US:en"
export LANG=en_US.UTF-8

cd /root/

echo "export LANG=en_US.UTF-8" >> .profile
echo "export LANG=en_US.UTF-8" >> .bashrc



# Fix default dns resolver #

sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved.service
rm -fr /etc/resolv.conf
touch /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|| LOGGING TO SYSLOG with Proper TimeStamp ||▼
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



vim /etc/rsyslog.conf

### Create Custome Log Format with the following....
#
$template myformat,"%TIMESTAMP:1:10:date-rfc3339% %TIMESTAMP:19:12:date-rfc3339% %syslogtag%%msg%\n"
$ActionFileDefaultTemplate myformat

# Include all config files in /etc/rsyslog.d/
#
$IncludeConfig /etc/rsyslog.d/*.conf


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|| MODIFYING OTHER CONFIGURATION ||▼
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mkdir -p /mnt/logdrive/logs-collect


sudo vim /etc/rsyslog.d/network-logs.conf

## /etc/rsyslog.d/network-logs.conf
#################
#### MODULES ####
#################

# provides UDP syslog reception
module(load="imudp")
input(type="imudp" port="514")

# provides TCP syslog reception
module(load="imtcp")
input(type="imtcp" port="514")


########### new log collection method #################
$template RemoteInputLogs, "/mnt/logdrive/logs-collect/%HOSTNAME%/%$year%-%$month%-%$day%-%$hour%.log"
if ($msg contains 'established') then
*.* ?RemoteInputLogs




########### LOG ROTATION #########################################

root@log-abuzz:~# cat /etc/logrotate.d/rsyslog
/var/log/syslog
/var/log/mail.info
/var/log/mail.warn
/var/log/mail.err
/var/log/mail.log
/var/log/daemon.log
/var/log/kern.log
/var/log/auth.log
/var/log/user.log
/var/log/lpr.log
/var/log/cron.log
/var/log/debug
/var/log/messages
/mnt/logdrive/logs-collect/*.log
{
        rotate 8
        hourly
        missingok
        notifempty
        compress
        delaycompress
        sharedscripts
        postrotate
        /usr/lib/rsyslog/rsyslog-rotate
        endscript
}


########### LOG ROTATION #########################################

## For lxc container need to execute the following two lines
chmod -R 777 /mnt/logdrive
sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

##### Next 3-Lines for proxmox CT ####
# systemctl disable ssh.socket
# systemctl enable ssh.service
# systemctl restart ssh.service

## For lxc container need to execute the following two lines ^


sudo systemctl restart rsyslog
sudo systemctl status rsyslog


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|MIKROTIK-CONFIGURATION ||▼
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Config In MikrotTik
system logging action add bsd-syslog=yes name=remotelogsrv1 remote=103.xxx.yy.237 syslog-facility=local6 target=remote
system logging set 0 topics=info,!firewall,!script
system logging add action=remotelogsrv1 topics=script
system logging add action=remotelogsrv1 topics=firewall
system logging add action=remotelogsrv1 topics=account
ip firewall mangle add action=log chain=prerouting connection-state=established protocol=tcp src-address=10.0.0.0/8 tcp-flags=fin


#ip firewall mangle add action=log chain=prerouting connection-state=established protocol=tcp src-address=10.0.0.0/8 tcp-flags=fin
#ppp profile set *0 on-up=":foreach dev in=[ppp active print detail as-value where name=\$user ] do={\r\n    /log info (\"PPPLOG \$user \" . (\$dev->\"caller-id\") . \" \" . (\$dev->\"address\"));\r\n}"



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|Log Processing Scripts ||▼
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mkdir -p /mnt/logdrive/ARCHIVE/
mkdir -p /mnt/logdrive/PPPOES/
mkdir -p /mnt/logdrive/STATIC/
mkdir -p /mnt/logdrive/TEMP/

mkdir -p /mnt/logdrive/PPPOES/ROUTER-IP
mkdir -p /mnt/logdrive/STATIC/ROUTER-IP
mkdir -p /mnt/logdrive/TEMP/ROUTER-IP




cat /usr/bin/xhourly_log_format.sh

#!/bin/bash
date_time=`date -d '1 hour ago' "+%Y-%m-%d-%H"`

### 103-xxx-xx-03-ABUZZ-SPR-NMC ### STATIC
cat /mnt/logdrive/logs-collect/103-xxx-xx-03-ABUZZ-SPR-NMC/$date_time.log |grep VLAN | awk '{print $1,$2,$9,$15}' | sed -e 's/,//g' -e 's/(//' -e 's/)//' -e 's/->/ /g' |grep -v proto |grep -v message > /mnt/logdrive/TEMP/103-xxx-xx-3/static_$date_time.txt
### 103-xxx-xx-03-ABUZZ-SPR-NMC ### PPPOE
cat /mnt/logdrive/logs-collect/103-xxx-xx-03-ABUZZ-SPR-NMC/$date_time.log |grep pppoe | awk '{print $1,$2,$4,$9,$15}' | sed -e 's/,//g' -e 's/in:<//g' -e 's/(//g' -e 's/->/ /g' -e 's/)//g' -e 's/>//g' |grep -v proto |grep -v message > /mnt/logdrive/TEMP/103-xxx-xx-3/pppoe_$date_time.txt


rsync -av /mnt/logdrive/TEMP/103-xxx-xx-3 /mnt/logdrive/ARCHIVE/
mv /mnt/logdrive/TEMP/103-xxx-xx-3/static_$date_time.txt /mnt/logdrive/STATIC/103-xxx-xx-3
mv /mnt/logdrive/TEMP/103-xxx-xx-3/pppoe_$date_time.txt /mnt/logdrive/PPPOES/103-xxx-xx-3

#sleep 2
#rm -fr /mnt/logdrive/TEMP/103-xxx-xx-3/$date_time.txt


### 103-xxx-xx-68-ABUZZ-108515 ### PPPOE
cat /mnt/logdrive/logs-collect/103-xxx-xx-68-ABUZZ-108515/$date_time.log |grep pppoe |  awk '{print $1,$2,$4,$9,$15}' | sed -e 's/,//g' -e 's/in:<//g' -e 's/(//g' -e 's/->/ /g' -e 's/)//g' -e 's/>//g' |grep -v proto |grep -v message > /mnt/logdrive/TEMP/103-xxx-xx-68/$date_time.txt
#
rsync -av /mnt/logdrive/TEMP/103-xxx-xx-68 /mnt/logdrive/ARCHIVE/
rsync -av /mnt/logdrive/TEMP/103-xxx-xx-68 /mnt/logdrive/PPPOES/
#
sleep 2
rm -fr /mnt/logdrive/TEMP/103-xxx-xx-68/$date_time.txt







################# some foot notes ##################################################

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# https://betterstack.com/community/guides/logging/rsyslog-explained/
# https://www.suse.com/support/kb/doc/?id=000019760

> > >> *$template TmplNationalIP_PL,
> > >> "/var/log/NIPFW/MX480/CGNAT_PL_%$year%.%$month%.%$day%"*
> > >> *if ($msg contains 'OR_NAT' and $msg contains '55.91.165.') then
> > >> ?TmplNationalIP_PL*
> > >> *& ~*


$template RemoteInputLogs, "/mnt/logdrive/logs-collect/%HOSTNAME%/%$year%-%$month%-%$day%-%$hour%.log"
if ($msg contains 'established') then
*.* ?RemoteInputLogs


 vim /etc/logrotate.d/network-log


/mnt/logdrive/logs-collect/103-xx-xxxx-1-RBD-CORE/*.log
{
        rotate 50
        hourly
        copytruncate
        missingok
        notifempty
        maxage 30
        sharedscripts
        postrotate
        sudo systemctl restart rsyslog.service
        endscript
}



# https://www.cyberciti.biz/tips/linux-unix-get-yesterdays-tomorrows-date.html

date -d 'now' "+%Y-%m-%d-%H"
date -d '1 hour ago' "+%Y-%m-%d-%H"
date -d 'next day' "+%Y-%m-%d-%H"

date --date="-1 days ago"
date --date="next day"




systemctl restart rsyslog.service

################# some foot notes ##################################################






root@ist-sys-log1:/mnt/logdrive/logs-collect/172-28-56-8-IST-GW1# cat /usr/bin/xhourly_log_format.sh 
#!/bin/bash
date_time=`date -d '1 hour ago' "+%Y-%m-%d-%H"`

### 172-28-56-8-IST-GW1 ### PPPOE
cat /mnt/logdrive/logs-collect/172-28-56-8-IST-GW1/$date_time.log  |grep pppoe | awk '{print $1,$2,$4,$9,$13}' | sed -e 's/,//g' -e 's/in:<//g' -e 's/(//g' -e 's/->/ /g' -e 's/)//g' -e 's/>//g' -e 's/pppoe-//g' |grep -v dnat |grep -v proto |grep -v message > /mnt/logdrive/TEMP/172-28-56-8-IST-GW1/$date_time.txt
sleep 1
rsync -av /mnt/logdrive/TEMP/172-28-56-8-IST-GW1 /mnt/logdrive/ARCHIVE/
sleep 1
mv /mnt/logdrive/TEMP/172-28-56-8-IST-GW1/$date_time.txt /mnt/logdrive/EXPORT/172-28-56-8-IST-GW1/



### 172-28-56-3-IST-GW2 ### PPPOE
cat /mnt/logdrive/logs-collect/172-28-56-3-IST-GW2/$date_time.log  |grep pppoe | awk '{print $1,$2,$4,$9,$13}' | sed -e 's/,//g' -e 's/in:<//g' -e 's/(//g' -e 's/->/ /g' -e 's/)//g' -e 's/>//g' -e 's/pppoe-//g' |grep -v dnat |grep -v proto |grep -v message > /mnt/logdrive/TEMP/172-28-56-3-IST-GW2/$date_time.txt
sleep 1
rsync -av /mnt/logdrive/TEMP/172-28-56-3-IST-GW2 /mnt/logdrive/ARCHIVE/
sleep 1
mv /mnt/logdrive/TEMP/172-28-56-3-IST-GW2/$date_time.txt /mnt/logdrive/EXPORT/172-28-56-3-IST-GW2/





