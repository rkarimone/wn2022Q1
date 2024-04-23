

https://kifarunix.com/setup-rsyslog-server-on-ubuntu-20-04/
https://yallalabs.com/linux/how-to-setup-loganalyzer-with-rsyslog-on-ubuntu-16-04-lts-ubuntu-18-04-lts/
https://linoxide.com/how-to-setup-central-logging-server-using-rsyslog-on-ubuntu-20-04/


https://docs.urduheim.de/ubuntu-tutorials/urduheim-syslog-server

https://www.tecmint.com/install-rsyslog-centralized-logging-in-centos-ubuntu/
https://www.xmodulo.com/configure-syslog-server-linux.html
https://www.xmodulo.com/configure-rsyslog-client-centos.html



apt install rsyslog

mkdir /savol2/network-logs
mkdir /var/log/network-logs/logs-archive

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
input(type="imtcp" port="5140")

#Custom template to generate the log filename dynamically based on the client's IP address or Hostname.
$template RemoteInputLogs, "/savol2/network-logs/%FROMHOST%.log"
*.* ?RemoteInputLogs

#$template RemoteLogs,”/var/log/%HOSTNAME%/%PROGRAMNAME%.log””.
#$template RemoteLogs,"/savol2/network-logs/%HOSTNAME%/%PROGRAMNAME%.log"
#*.* ?RemoteLogs 
#& ~


sudo vim /etc/logrotate.d/network-logs

/var/log/network-logs/*.log
{
        size 300M
        copytruncate
        create
        compress
        olddir /var/log/network-logs/logs-archive
        rotate 4
        postrotate
                /usr/lib/rsyslog/rsyslog-rotate
        endscript
}


sudo systemctl restart rsyslog
sudo systemctl status rsyslog



-- http://loganalyzer.adiscon.com/downloads/
-- https://www.youtube.com/c/YallaLabs/videos
-- https://forums.lawrencesystems.com/t/open-source-logging-getting-started-with-graylog/8797

-- http://techies-world.com/configure-nginx-to-send-logs-to-rsyslog/


Step1: Open the rsyslog config file

#vi /etc/rsyslog.conf

Step2: Add the following line before the line $IncludeConfig /etc/rsyslog.d/*.conf

$ModLoad imfile

Step3: Create a new file for_ nginx rsyslog configuration

#vi /etc/rsyslog.d/nginx.conf

Step4: Update the following lines.

# error log
$InputFileName /var/log/nginx/error.log
$InputFileTag nginx:
$InputFileStateFile stat-nginx-error
$InputFileSeverity error
$InputFileFacility local6
$InputFilePollInterval 1
$InputRunFileMonitor

# access log
$InputFileName /var/log/nginx/access.log
$InputFileTag nginx:
$InputFileStateFile stat-nginx-access
$InputFileSeverity notice
$InputFileFacility local6
$InputFilePollInterval 1
$InputRunFileMonitor

Step5: Restart rsyslog service

#service rsyslog restart


-- https://luvpreetsingh.github.io/nginx-to-rsyslog/
-- https://ipcorenetworks.blogspot.com/2021/09/how-to-install-configure-loganalyzer.html

-- https://www.youtube.com/watch?v=d0zwT98MAgw


cat /usr/bin/xhourly_log_format.sh


root@log-abuzz:/mnt/logdrive/TEMP# cat /usr/bin/xhourly_log_format.sh
#!/bin/bash
date_time=`date -d '1 hour ago' "+%Y-%m-%d-%H"`

### 103-118-84-03-ABUZZ-SPR-NMC ### STATIC
cat /mnt/logdrive/logs-collect/103-118-84-03-ABUZZ-SPR-NMC/$date_time.log |grep VLAN | awk '{print $1,$2,$9,$15}' | sed -e 's/,//g' -e 's/(//' -e 's/)//' -e 's/->/ /g' |grep -v proto > /mnt/logdrive/TEMP/103-118-84-3/static_$date_time.txt
### 103-118-84-03-ABUZZ-SPR-NMC ### PPPOE
cat /mnt/logdrive/logs-collect/103-118-84-03-ABUZZ-SPR-NMC/$date_time.log |grep pppoe | awk '{print $1,$2,$4,$9,$15}' | sed -e 's/,//g' -e 's/in:<//g' -e 's/(//g' -e 's/->/ /g' -e 's/)//g' -e 's/>//g' |grep -v proto > /mnt/logdrive/TEMP/103-118-84-3/pppoe_$date_time.txt


rsync -av /mnt/logdrive/TEMP/103-118-84-3 /mnt/logdrive/ARCHIVE/
mv /mnt/logdrive/TEMP/103-118-84-3/static_$date_time.txt /mnt/logdrive/STATIC/103-118-84-3
mv /mnt/logdrive/TEMP/103-118-84-3/pppoe_$date_time.txt /mnt/logdrive/PPPOES/103-118-84-3

#sleep 2
#rm -fr /mnt/logdrive/TEMP/103-118-84-3/$date_time.txt


### 103-118-84-68-ABUZZ-108515 ### PPPOE
cat /mnt/logdrive/logs-collect/103-118-84-68-ABUZZ-108515/$date_time.log |grep pppoe |  awk '{print $1,$2,$4,$9,$15}' | sed -e 's/,//g' -e 's/in:<//g' -e 's/(//g' -e 's/->/ /g' -e 's/)//g' -e 's/>//g' |grep -v proto > /mnt/logdrive/TEMP/103-118-84-68/$date_time.txt
#
rsync -av /mnt/logdrive/TEMP/103-118-84-68 /mnt/logdrive/ARCHIVE/
rsync -av /mnt/logdrive/TEMP/103-118-84-68 /mnt/logdrive/PPPOES/
#
sleep 2
rm -fr /mnt/logdrive/TEMP/103-118-84-68/$date_time.txt



