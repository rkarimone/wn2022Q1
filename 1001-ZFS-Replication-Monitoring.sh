#####################################################################################
#                                                                               #####
########### // ZFS Snapshot and Replication //                                  ##### 
#                                                                               #####
#####################################################################################

###### SOURCE-SERVER ########

# Preparation ...
cd /root/
ssh-keygen -t rsa                   // Press all Enter //
ssh-copy-id -p 1122 -i /root/.ssh/id_rsa.pub 'root@172.16.108.71'   // 172.16.108.71 --is remote server IP //

; test connection
ssh root@172.16.108.71 -p 1122		; // this should not ask any password




# Step-1: 
sudo zfs create groupXvol1/gXsysconfig
cd /root/
date_time=`date +%Y%m%d-%H%M%S`;
zfs snapshot -r groupXvol1/gXsubvol1@$date_time;
zfs send -R groupXvol1/gXsubvol1$date_time| ssh root@172.16.108.71 -p 1122 "zfs receive -dvF groupYvol1"
echo $date_time > /groupXvol1/gXsysconfig/gXsubvol1_lsnapid;



zfs send -R lxc/qmail1@hpg8 | ssh root@192.168.141.20 -p 7878 "zfs receive -dvF dell2uvol1/backup"

zfs send -R n1vol1/lxc/gl-1@02112021_205556 | ssh root@192.168.131.253 -p 7878 "zfs receive -dvF glbox1vol1/lxc"


n1vol1/lxc/gl-1@02112021_205556


date_time=`date +%Y%m%d-%H%M%S`;
zfs snapshot -r eph1hdpool1/N1-SR300NFS-HDD@$date_time;
zfs list -t snapshot
zfs send -R eph1hdpool1/N1-SR300NFS-HDD@$date_time | ssh root@192.168.124.254  "zfs receive -dvF eph2hdpool1"
echo $date_time > /eph1hdpool1/n1sysconfig/n1_lsnapid;


# Step-2: 

vim /groupXvol1/gXsysconfig/gXreplication-script.sh

#!/bin/bash
zfs list -rt snapshot -o name |grep groupXvol1/gXsubvol1 |sort |head -n -5 |xargs -n 1 zfs destroy -r 2> /dev/null;
date_time=`date +%Y%m%d-%H%M%S`;
zfs snapshot -r groupXvol1/gXsubvol1@$date_time;
new_snap_id="groupXvol1/gXsubvol1@$date_time";
old_snap_id=`cat /groupXvol1/gXsysconfig/gXsubvol1_lsnapid`;
zfs send -I groupXvol1/gXsubvol1@$old_snap_id -R $new_snap_id | ssh root@172.16.108.71 "zfs receive -dvF groupYvol1" ;
echo $date_time > /groupXvol1/gXsysconfig/gXsubvol1_lsnapid;


chmod +x /groupXvol1/gXsysconfig/gXreplication-script.sh


vim /etc/crontab
*/5 * * * * root /groupXvol1/gXsysconfig/gXreplication-script.sh 








#####################################################################################
#                                                                               #####
########### // ZFS Snapshot and Replication MONITORING //                       ##### 
#                                                                               #####
#####################################################################################




#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

#nvme153
dsh -m root@192.168.101.153 -o '-p 22' zfs list -rt snapshot -o name |grep rpool/nvmevms153@ |sort |tail -n1 > /home/rkarim/zfsmon/xx153nvme
dsh -m root@192.168.102.153 -o '-p 22' zfs list -rt snapshot -o name |grep xx253hdd/nvmevms153@ |sort |tail -n1 > /home/rkarim/zfsmon/xx253nvme

xx153nvme=`cat /home/rkarim/zfsmon/xx153nvme`;
xx153nvme1=`cut -d "/" -f2 <<< "$xx153nvme"`

xx253nvme=`cat /home/rkarim/zfsmon/xx253nvme`
xx253nvme1=`cut -d "/" -f2 <<< "$xx253nvme"`


if [ "$xx153nvme1" = "$xx253nvme1" ]; then
    echo "PROXMOX XX153-TO-XX253 nvmevms153 ${green} ZFS REPLICATION [ OK ]${reset} $xx153nvme1"
else
    echo "PROXMOX XX153-TO-XX253 nvmevms153 ${red} ZFS REPLICATION FAILED.${reset}"
fi




#vms153
dsh -m root@192.168.101.153 -o '-p 22' zfs list -rt snapshot -o name |grep xx153hdd/vms153@ |sort |tail -n1 > /home/rkarim/zfsmon/xx153vms
dsh -m root@192.168.102.153 -o '-p 22' zfs list -rt snapshot -o name |grep xx253hdd/vms153@ |sort |tail -n1 > /home/rkarim/zfsmon/xx253vms

xx153vms=`cat /home/rkarim/zfsmon/xx153vms`;
xx153vms1=`cut -d "/" -f2 <<< "$xx153vms"`

xx253vms=`cat /home/rkarim/zfsmon/xx253vms`
xx253vms1=`cut -d "/" -f2 <<< "$xx253vms"`


if [ "$xx153vms1" = "$xx253vms1" ]; then
    echo "PROXMOX XX153-TO-XX253 vms153 ${green}     ZFS REPLICATION [ OK ]${reset} $xx153vms1"
else
    echo "PROXMOX XX153-TO-XX253 vms153 ${red} ZFS REPLICATION FAILED.${reset}"
fi


#vms253
dsh -m root@192.168.102.153 -o '-p 22' zfs list -rt snapshot -o name |grep xx253hdd/vms253@ |sort |tail -n1 > /home/rkarim/zfsmon/xxvms253S
dsh -m root@192.168.101.153 -o '-p 22' zfs list -rt snapshot -o name |grep xx153hdd/vms253@ |sort |tail -n1 > /home/rkarim/zfsmon/xxvms253D


xxvms253S=`cat /home/rkarim/zfsmon/xxvms253S`;
xxvms253S1=`cut -d "/" -f2 <<< "$xxvms253S"`

xxvms253D=`cat /home/rkarim/zfsmon/xxvms253D`
xxvms253D1=`cut -d "/" -f2 <<< "$xxvms253D"`


if [ "$xxvms253S1" = "$xxvms253D1" ]; then
    echo "PROXMOX XX253-TO-XX153 vms253 ${green}     ZFS REPLICATION [ OK ]${reset} $xxvms253S1"
else
    echo "PROXMOX XX253-TO-XX153 vms253 ${red} ZFS REPLICATION FAILED.${reset}"
fi



#lxc253
dsh -m root@192.168.102.153 -o '-p 22' zfs list -rt snapshot -o name |grep xx253hdd/lxc253@ |sort |tail -n1 > /home/rkarim/zfsmon/xxlxc253S
dsh -m root@192.168.101.153 -o '-p 22' zfs list -rt snapshot -o name |grep xx153hdd/lxc253@ |sort |tail -n1 > /home/rkarim/zfsmon/xxlxc253D


xxlxc253S=`cat /home/rkarim/zfsmon/xxlxc253S`;
xxlxc253S1=`cut -d "/" -f2 <<< "$xxlxc253S"`

xxlxc253D=`cat /home/rkarim/zfsmon/xxlxc253D`
xxlxc253D1=`cut -d "/" -f2 <<< "$xxlxc253D"`


if [ "$xxlxc253S1" = "$xxlxc253D1" ]; then
    echo "PROXMOX XX253-TO-XX153 lxc253 ${green}     ZFS REPLICATION [ OK ]${reset} $xxlxc253S1"
else
    echo "PROXMOX XX253-TO-XX153 lxc253 ${red} ZFS REPLICATION FAILED.${reset}"
fi








// Handling Disk Failure //

|||||||||| Manualy Fail a disk  (lab instructor will do)

syntax: zpool replace [poolname] [old drive id] [new disk drive]

// Replace old/damaged disks //
zpool status                // find the failed disk

 state: DEGRADED
status: One or more devices could not be used because the label is missing or
	invalid.  Sufficient replicas exist for the pool to continue
	functioning in a degraded state.
action: Replace the device using 'zpool replace'.
   see: http://zfsonlinux.org/msg/ZFS-8000-4J
  scan: none requested
config:

	NAME                      STATE     READ WRITE CKSUM
	groupXvol1                DEGRADED     0     0     0
	  raidz1-0                DEGRADED     0     0     0
	    xvdb                  ONLINE       0     0     0
	    xvdc                  ONLINE       0     0     0
	    16626827190568113194  UNAVAIL      0     0     0  was /dev/xvde1

errors: No known data errors

|||||||||| Add a new disk (lab instructor will do)
|||||||||| Initialize New Disk  (participant will do)
sudo sgdisk --zap-all /dev/xvdf


zpool replace groupXvol1 16626827190568113194 /dev/xvdf
watch zpool status
zpool clear groupXvol1
zpool status



########### zfs fast-replication #############
1st-Receiving Side
apt install mbuffer
mbuffer -4 -s 128k -m 4G -I 8000 | zfs receive -vF n2vol1/n1vms

2nd-Sendng side
apt install mbuffer
zfs send -R n1vol0/n1vms@20240127-215024 | mbuffer -s 128k -m 4G -O 10.10.20.2:8000



###################


root@soltion-bd-ip3:~# 
root@soltion-bd-ip3:~# 
root@soltion-bd-ip3:~# cat /etc/crontab 
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user	command
17 *	* * *	root    cd / && run-parts --report /etc/cron.hourly
25 6	* * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6	* * 7	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6	1 * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
30 */2	* * *	root	/volume1/sysconfig/volume1-auto-replica-ip3-to-ip2-task.sh
root@soltion-bd-ip3:~# cat /volume1/sysconfig/volume1-auto-replica-ip3-to-ip2-task.sh
#!/bin/bash
HOSTS="100.66.33.12"
COUNT=10
for myHost in $HOSTS
do
  count=$(ping -c $COUNT -i 0.3 $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  if [ $count -ne 0 ]; then
     /volume1/sysconfig/volume1-auto-replica-ip3-to-ip2-run.sh
    echo "[$(date)] [ OK OK! ] SLBD-IP3-TO-IP2 REPLICATION-STRTED" >> /volume1/sysconfig/replication.log
  else
    echo "[$(date)] [ FAILED ] SLBD-IP3-TO-IP2 REPLICATION FAILED" >> /volume1/sysconfig/replication.log
  fi
done



###

root@soltion-bd-ip3:~# cat /volume1/sysconfig/volume1-auto-replica-ip3-to-ip2-task.sh
#!/bin/bash
HOSTS="100.66.33.12"
COUNT=10
for myHost in $HOSTS
do
  count=$(ping -c $COUNT -i 0.3 $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  if [ $count -ne 0 ]; then
     /volume1/sysconfig/volume1-auto-replica-ip3-to-ip2-run.sh
    echo "[$(date)] [ OK OK! ] SLBD-IP3-TO-IP2 REPLICATION-STRTED" >> /volume1/sysconfig/replication.log
  else
    echo "[$(date)] [ FAILED ] SLBD-IP3-TO-IP2 REPLICATION FAILED" >> /volume1/sysconfig/replication.log
  fi
done
root@soltion-bd-ip3:~# cat /volume1/sysconfig/volume1-auto-replica-ip3-to-ip2-run.sh
#!/bin/bash
nohup sh /volume1/sysconfig/volume1-auto-replica-ip3-to-ip2-script.sh &
root@soltion-bd-ip3:~# cat /volume1/sysconfig/volume1-auto-replica-ip3-to-ip2-script.sh 
####### SNAPSHOT+REPLICATION-WORKS######################

date_time=`date +%Y%m%d-%H%M%S`;

######## CHECKMK-NMS ####
zfs list -rt snapshot -o name |grep volume1/containers/checkmknms@ |sort |head -n -10 |xargs -n 1 zfs destroy -r 2> /dev/null;
zfs snapshot -r volume1/containers/checkmknms@$date_time;
new_snap_id="volume1/containers/checkmknms@$date_time";
old_snap_id=`cat /volume1/sysconfig/volume1_lsnap_id.txt`;
zfs send -I volume1/containers/checkmknms@$old_snap_id -R $new_snap_id | ssh root@100.66.33.12 -p 9898 zfs recv -dvF volume1;

######## fmdns2 ####
zfs list -rt snapshot -o name |grep volume1/containers/fmdns2@ |sort |head -n -10 |xargs -n 1 zfs destroy -r 2> /dev/null;
zfs snapshot -r volume1/containers/fmdns2@$date_time;
new_snap_id="volume1/containers/fmdns2@$date_time";
old_snap_id=`cat /volume1/sysconfig/volume1_lsnap_id.txt`;
zfs send -I volume1/containers/fmdns2@$old_snap_id -R $new_snap_id | ssh root@100.66.33.12 -p 9898 zfs recv -dvF volume1;

######## ns2 ####
zfs list -rt snapshot -o name |grep volume1/containers/ns2@ |sort |head -n -10 |xargs -n 1 zfs destroy -r 2> /dev/null;
zfs snapshot -r volume1/containers/ns2@$date_time;
new_snap_id="volume1/containers/ns2@$date_time";
old_snap_id=`cat /volume1/sysconfig/volume1_lsnap_id.txt`;
zfs send -I volume1/containers/ns2@$old_snap_id -R $new_snap_id | ssh root@100.66.33.12 -p 9898 zfs recv -dvF volume1;

######## VPN ####
zfs list -rt snapshot -o name |grep volume1/vpn@ |sort |head -n -10 |xargs -n 1 zfs destroy -r 2> /dev/null;
zfs snapshot -r volume1/vpn@$date_time;
new_snap_id="volume1/vpn@$date_time";
old_snap_id=`cat /volume1/sysconfig/volume1_lsnap_id.txt`;
zfs send -I volume1/vpn@$old_snap_id -R $new_snap_id | ssh root@100.66.33.12 -p 9898 zfs recv -dvF volume1;

######## ippbx ####
zfs list -rt snapshot -o name |grep volume1/ippbx@ |sort |head -n -10 |xargs -n 1 zfs destroy -r 2> /dev/null;
zfs snapshot -r volume1/ippbx@$date_time;
new_snap_id="volume1/ippbx@$date_time";
old_snap_id=`cat /volume1/sysconfig/volume1_lsnap_id.txt`;
zfs send -I volume1/ippbx@$old_snap_id -R $new_snap_id | ssh root@100.66.33.12 -p 9898 zfs recv -dvF volume1;

####
echo $date_time > /volume1/sysconfig/volume1_lsnap_id.txt;







