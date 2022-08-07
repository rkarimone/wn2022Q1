

echo "1 enp1s0f1" >>/etc/iproute2/rt_tables   # (1st Internet Line & system default route)
echo "2 enp1s0f2" >>/etc/iproute2/rt_tables   # (2nd Internet Line)

# 2nd Interface IP address
IP: 123.200.2.36/29 | GW: 123.200.2.33 


ip route add 123.200.2.32/29 dev enp1s0f2 src 123.200.2.36 table enp1s0f2
ip route add default via 123.200.2.33 dev enp1s0f2 table enp1s0f2

ip rule add from 123.200.2.36/32 table enp1s0f2
ip rule add to 123.200.2.36/32 table enp1s0f2

ip route flush cache





#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

touch /var/lock/subsys/local

#mbm - 04/16/2012 - add additional routes
for interface_file in $(ls /etc/sysconfig/network-scripts/ifcfg-eth* | grep -v ifcfg-eth0) ;do
  . ${interface_file}
  prefix=$(ipcalc -p ${IPADDR} ${NETMASK} | awk -F= '{print $2}')
  tablenum=$(echo ${DEVICE} | sed 's/eth//g')
  if [ ${ONBOOT} != 'yes' ] ;then
    continue
  fi
  if ! grep "^${tablenum} ${DEVICE}$" /etc/iproute2/rt_tables >/dev/null ;then
    echo "${tablenum} ${DEVICE}" >>/etc/iproute2/rt_tables
  fi
  ip route add ${NETWORK}/${prefix} dev ${DEVICE} src ${IPADDR} table ${DEVICE}
  ip route add default via ${ROUTER} dev ${DEVICE} table ${DEVICE}
  ip rule add from ${IPADDR}/32 table ${DEVICE}
  ip rule add to ${IPADDR}/32 table ${DEVICE}
done




cd /tmp/
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.10/amd64/linux-headers-5.10.0-051000_5.10.0-051000.202012132330_all.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.10/amd64/linux-headers-5.10.0-051000-generic_5.10.0-051000.202012132330_amd64.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.10/amd64/linux-image-unsigned-5.10.0-051000-generic_5.10.0-051000.202012132330_amd64.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.10/amd64/linux-modules-5.10.0-051000-generic_5.10.0-051000.202012132330_amd64.deb
sudo dpkg -i *.deb




