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





