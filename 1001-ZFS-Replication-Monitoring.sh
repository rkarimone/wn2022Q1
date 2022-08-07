

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





