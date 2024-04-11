

echo "1 enp1s0f1" >>/etc/iproute2/rt_tables   # (1st Internet Line & system default route)
echo "2 enp1s0f2" >>/etc/iproute2/rt_tables   # (2nd Internet Line)

# 2nd Interface IP address
IP: 123.200.2.36/29 | GW: 123.200.2.33 


ip route add 123.200.2.32/29 dev enp1s0f2 src 123.200.2.36 table enp1s0f2
ip route add default via 123.200.2.33 dev enp1s0f2 table enp1s0f2

ip rule add from 123.200.2.36/32 table enp1s0f2
ip rule add to 123.200.2.36/32 table enp1s0f2

ip route flush cache


#another step (if require)
$ ip route
default via 10.255.254.1 dev eth0 proto static metric 100
default via 10.255.72.1 dev eth1 proto static metric 101
10.255.72.0/22 dev eth1 proto kernel scope link src 10.255.72.230 metric 101
10.255.254.0/24 dev eth0 proto kernel scope link src 10.255.254.45 metric 100




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


root@vpnserver:~# cat /etc/iproute2/rt_tables
#
# reserved values
#
255	local
254	main
253	default
0	unspec
#
# local
#
#1	inr.ruhep
1 enp1s0f1
2 enp1s0f2



root@vpnserver:~# cat /opt/link3_up.sh 
#!/bin/bash
#route del default
#ip route add default via 123.200.2.33

ip route add 123.200.2.32/29 dev enp1s0f2 src 123.200.2.36 table enp1s0f2
ip route add default via 123.200.2.33 dev enp1s0f2 table enp1s0f2
ip rule add from 123.200.2.36/32 table enp1s0f2
ip rule add to 123.200.2.36/32 table enp1s0f2
#
sleep 5
ethtool -K enp1s0f0 tso off
ethtool -K enp1s0f0 sg off
ethtool -K enp1s0f1 tso off
ethtool -K enp1s0f1 sg off
ethtool -K enp1s0f2 tso off
ethtool -K enp1s0f2 sg off
ethtool -K enp1s0f3 tso off
ethtool -K enp1s0f3 sg off

sleep 1
/etc/init.d/vpnserver restart >/dev/null 2>&1

root@vpnserver:~# cat /opt/nexto_up.sh 
#!/bin/bash
route del default
ip route add default via 103.230.62.65

#
sleep 5
ethtool -K enp1s0f0 tso off
ethtool -K enp1s0f0 sg off
ethtool -K enp1s0f1 tso off
ethtool -K enp1s0f1 sg off
ethtool -K enp1s0f2 tso off
ethtool -K enp1s0f2 sg off
ethtool -K enp1s0f3 tso off
ethtool -K enp1s0f3 sg off

sleep 1
/etc/init.d/vpnserver restart >/dev/null 2>&1


######## Another Method #####


I have two different ISPs. I want to set some kind of load balancing setup that will distribute packets to those providers. I know this can be done using different routing tables, but I wanted to use something called "multipath gateway".

Ive configured both interfaces in the /etc/network/interfaces file. Both of the connections work separately. I replaced the default gateways with the one below:

# ip route add default \
    nexthop via 192.168.1.1 dev bond0 weight 1 \
    nexthop via 10.143.105.17 dev wwan0 weight 1

#I added masquerade targets in iptables on both of the interfaces:

iptables -t nat -A POSTROUTING -o wwan0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o bond0 -j MASQUERADE

#Also I enabled (partially) reverse path filtering via sysctl:
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2

This setup works. Packets (connections) are sent via both interfaces. 


