#!/bin/bash

cd /root/
sudo apt update
sudp apt upgrade -y 

# sshfs -o allow_other,port=7887 sabpo@192.168.55.54:/savol2/sabpo /home/partimag
# username: sabpo--JB71




   77  sudo systemctl status mysql.service 
   78  sudo systemctl status rsyslog.service 
   79  sudo systemctl stop mysql
   84  sudo systemctl daemon-reload
   87  sudo systemctl start mysql
   88  sudo systemctl restart apparmor
   89  sudo systemctl start mysql
   90  sudo systemctl start logserver
   91  sudo systemctl restart apache2
   92  sudo systemctl status logserver.service 
   93  sudo systemctl status mysql.service 
   94  sudo systemctl status rsyslog.service 
   96  sudo systemctl status logserver.service 
  106  sudo systemctl restart logserver.service 
  107  sudo systemctl status logserver.service 
  149  systemctl status mysql
  150  systemctl start mysql
  151  systemctl status mysql
  159  systemctl start logserver
  160  systemctl status logserver
  163  history |grep systemctl




cd /tmp/
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.10/amd64/linux-headers-5.10.0-051000_5.10.0-051000.202012132330_all.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.10/amd64/linux-headers-5.10.0-051000-generic_5.10.0-051000.202012132330_amd64.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.10/amd64/linux-image-unsigned-5.10.0-051000-generic_5.10.0-051000.202012132330_amd64.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.10/amd64/linux-modules-5.10.0-051000-generic_5.10.0-051000.202012132330_amd64.deb
sudo dpkg -i *.deb






<network>
    <name>vmbr0lan</name>
    <forward mode="bridge" />
    <bridge name="vmbr0" />
</network>




apt-get install ifenslave


modprobe bonding mmiimon=100 mode=802.3ad lacp_rate=fast

modprobe bonding lacp_rate=fast  


https://gist.github.com/jameskyle/2998524
https://docs.rackspace.com/blog/lacp-bonding-and-linux-configuration/


echo 4      > /sys/class/net/bond0/bonding/mode
echo 100    > /sys/class/net/bond0/bonding/miimon

echo 200    > /sys/class/net/bond0/bonding/downdelay
echo 200    > /sys/class/net/bond0/bonding/updelay
echo 1      > /sys/class/net/bond0/bonding/ad_select
echo 1      > /sys/class/net/bond0/bonding/lacp_rate
echo 2      > /sys/class/net/bond0/bonding/xmit_hash_policy

echo 1 > /sys/class/net/bond0/bonding/all_slaves_active

echo +eth2  > /sys/class/net/bond0/bonding/slaves
echo +eth3  > /sys/class/net/bond0/bonding/slaves


  142  ip link set bond0 type bond lacp_rate 1
  143  ip link set bond0 type bond all_slaves_active 1


# bonding interface
ip link add name bond0 type bond lacp_rate 1 miimon 100 mode 802.3ad xmit_hash_policy layer3+4 updelay 300 all_slaves_active 1
ip link set bond0 up
ip address add 192.0.2.1/24 dev bond0
# first physical interface
ip link set dev eth0 name port1 up
ip link set dev port1 master bond0
ip link dev port1 set up
# second physical interface
ip link set dev eth1 name port2 up
ip link set dev port2 master bond0
ip link dev port2 set up


ip link add name bond0 type bond lacp_rate 1 miimon 100 mode 802.3ad xmit_hash_policy layer3+4 updelay 300 downdelay 300 all_slaves_active 1 ad_select 1

cat /proc/net/bonding/bond0


#!/bin/bash
sleep 90
echo eth > /sys/bus/pci/devices/0000\:04\:00.0/mlx4_port1
echo eth > /sys/bus/pci/devices/0000\:05\:00.0/mlx4_port2

sleep 10
## Config BOND0
modprobe bonding

sudo ifconfig eno49 down
sudo ifconfig eno49d1 down
sudo ip link add name bond0 type bond lacp_rate 1 miimon 100 mode 802.3ad xmit_hash_policy layer3+4 all_slaves_active 1 updelay 300
sudo ip link set eno49 master bond0
sudo ip link set eno49d1 master bond0
sleep 5

sudo ip link set eno49 up
sudo ip link set eno49d1 up
sudo ip link set bond0 up

sleep 5
ip link set eno49 mtu 9000
ip link set eno49d1 mtu 9000
ip link set bond0 mtu 9000


sleep 15
ifconfig eno49 txqueuelen 9000
ifconfig eno49d1 txqueuelen 9000
ifconfig bond0 txqueuelen 9000

sleep 3
ifconfig bond0 ip-addr/29
route add default gw ip-gw

sleep 3
ifconfig eno2 192.168.155.1/29

sleep 3
zpool import volume0 -f
zpool import volume1 -f


sleep 1
systemctl restart nginx

#
lxc-start -n tv2.ebox.live -d
lxc-start -n tvx.ebox.live -d

sleep 1
echo 'performance' > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor

sleep 5
iptables -F
iptables -F -t nat
ifconfig virbr0 0
ifconfig virbr0 down
ifconfig lxcbr0 0
ifconfig lxcbr0 down
iptables -F
iptables -F -t nat

#
#ip addr add IP-addr/29 brd + dev bond0
#ip link set bond0 up


#bhiya bdcom sw e bonding e ekta issue picelam. Issue holo bonding e capacity upgrade hoicelo thike tobe load blanch hoito na aber redundant kintu thik e kaj korto. 
#alada ekta command  "aggregator-group load-balance both-ip" aita daur por kaj korcelo perfectly. 
#jodeo cisco te aigula kora lage na. ekhon server e ki emon kono issue ache kena?


docker container prune -f
docker image prune -f
docker volume prune -f

