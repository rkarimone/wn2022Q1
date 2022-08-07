#!/bin/bash

----- INSTALL & CONFIGURE WIREGUARD (AUTO & EASY WAY)

# https://pve.proxmox.com/wiki/OpenVPN_in_LXC

Inside Main Server (aka proxmox 253)

vim /usr/share/lxc/config/common.conf.d/02-wireguardvpn.conf
lxc.cgroup2.devices.allow = c 10:200 rwm

chown 100000:100000 /dev/net/tun
ls -l /dev/net/tun



root@xx253:~# cat /usr/share/lxc/config/common.conf.d/02-openvpn.conf
lxc.cgroup2.devices.allow = c 10:200 rwm
root@xx253:~# cat /etc/pve/lxc/2530126.conf
arch: amd64
cores: 6
features: fuse=1,keyctl=1,mknod=1,nesting=1
hostname: wg01.sebpo.net
memory: 4096
nameserver: 9.9.9.11
net0: name=eth0,bridge=vmbr1,gw=123.200.10.97,hwaddr=F6:52:E3:1C:19:39,ip=123.200.10.126/27,type=veth
net1: name=eth1,bridge=vmbr0,hwaddr=22:68:C3:1B:17:1B,ip=192.168.103.144/16,type=veth
onboot: 1
ostype: ubuntu
rootfs: lxc253:2530126/vm-2530126-disk-0.raw,acl=0,mountoptions=noatime,replicate=0,size=20G
swap: 4096
unprivileged: 0
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net dev/net none bind,create=dir



sudo lxc-start -n 2530126




########## SERVER CONFIGURATION


--- default-script
wget https://git.io/wireguard -O wireguard-install.sh && bash wireguard-install.sh


--- custom-script
wget http://119.15.154.51:8480/docker/wireguard-install-mrk.sh


cd /root/
chmod 755 wireguard-install-mrk.sh

/root/wireguard-install-mrk.sh			// follow the screen & add a client


sudo iptables -nvL
sudo iptables -F -t nat
sudo iptables-save > /opt/iptables.rules
sudo iptables-restore /opt/iptables.rules
sudo iptables -nvL
sudo iptables-save


sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
sudo systemctl restart wg-quick@wg0
sudo systemctl status wg-quick@wg0

sudo vim /etc/sysctl.conf
net.ipv4.ip_forward=1

sudo sysctl -p





