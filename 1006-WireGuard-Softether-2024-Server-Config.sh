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







############ 2024 #### with web-gui ####################





########### SOFTETHER VPN-SERVER ############# 2024

apt update
apt upgrade -y
apt install vim htop iftop mtr iperf3 wget axel bwm-ng iptables
vim /etc/ssh/sshd_config
systemctl restart ssh
systemctl restart sshd

ssh-keygen 
vim .ssh/authorized_keys

sudo vim /etc/network/interfaces

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug ens18
iface ens18 inet static
	address publicip.78/24
	gateway publicip.1
	# dns-* options are implemented by the resolvconf package, if installed
	dns-nameservers 8.8.8.8
	dns-search nt.lan


#
allow-hotplug ens19
iface ens19 inet static
	address 192.168.133.33/24


apt -y install locales locales-all wget curl vim sudo rsyslog -y
localectl set-locale LANG=en_US.UTF-8 LANGUAGE="en_US:en"
export LANG=en_US.UTF-8

echo "export LANG=en_US.UTF-8" >> .profile
echo "export LANG=en_US.UTF-8" >> .bashrc

sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved.service
rm -fr /etc/resolv.conf
touch /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf 

apt install build-essential gnupg2 gcc make ethtool iperf3
apt install gcc binutils gzip libreadline-dev libssl-dev libncurses5-dev libncursesw5-dev libpthread-stubs0-dev

cd /opt/
wget -c https://www.softether-download.com/files/softether/v4.42-9798-rtm-2023.06.30-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.42-9798-rtm-2023.06.30-linux-x64-64bit.tar.gz
tar zxvf softether-vpnserver-v4.42-9798-rtm-2023.06.30-linux-x64-64bit.tar.gz 

cd vpnserver/
make

cd ..
sudo mv vpnserver /opt/softether

sudo /opt/softether/vpnserver start
sudo vim /etc/systemd/system/softether-vpnserver.service

[Unit]
Description=SoftEther VPN server
After=network-online.target
After=dbus.service

[Service]
Type=forking
ExecStart=/opt/softether/vpnserver start
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target


chmod +x /etc/systemd/system/softether-vpnserver.service
sudo systemctl enable softether-vpnserver
sudo systemctl restart softether-vpnserver

sudo systemctl status softether-vpnserver
sudo journalctl -eu softether-vpnserver
sudo  ss -lnptu | grep vpnserver

# sudo ethtool -K ens18 tx off rx off sg off tso off
# sudo ethtool -K ens19 tx off rx off sg off tso off
vim /etc/sysctl.conf 

#kernel.sysrq=438
net.ipv4.ip_forward=1
fs.file-max = 2097152
net.ipv4.tcp_max_orphans = 60000
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_max_syn_backlog = 100000
net.ipv4.tcp_congestion_control=bbr
net.core.default_qdisc=fq
net.ipv4.tcp_mtu_probing=1
net.ipv4.tcp_synack_retries = 2 
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_fin_timeout = 15 
net.core.somaxconn = 100000
net.core.netdev_max_backlog = 100000
net.core.optmem_max = 25165824
net.ipv4.tcp_mem = 65536 131072 262144 
net.ipv4.udp_mem = 65536 131072 262144
net.core.rmem_default = 25165824
net.core.rmem_max = 25165824 
net.ipv4.tcp_rmem = 20480 12582912 25165824 
net.ipv4.udp_rmem_min = 16384
net.core.wmem_default = 25165824
net.core.wmem_max = 25165824
net.ipv4.tcp_wmem = 20480 12582912 25165824 
net.ipv4.udp_wmem_min = 16384
net.ipv4.tcp_max_tw_buckets = 1440000
net.ipv4.tcp_tw_reuse = 1 


### if you want to disable ipv6 network
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1


sudo sysctl -p

sudo vim /etc/security/limits.conf 

root soft     nproc          1024000
root hard     nproc          1024000
root soft     nofile         1024000
root hard     nofile         1024000


sudo reboot

### DISALBE HTML5-WEB-UI####

-Stop the service(deamon) in linux or windows (or whatever you run softether in/on)
-edit the "vpn_server.config" file with your favorite editor,
-change "bool DisableJsonRpcWebApi" from "false" to "true",
-save file,
-start service(deamon) again.










## https://insights.ditatompel.com/en/tutorials/how-to-setup-your-own-wireguard-vpn-server/
########################  WireGuard-VPN Server ############ 2024 ##################
# https://insights.ditatompel.com/en/tutorials/installing-wireguard-ui-to-manage-your-wireguard-vpn-server/

apt-get update && apt-get install wireguard mc uuid net-tools ifupdown
cd /opt/
mkdir wireguard-ui
cd wireguard-ui/
wget -c https://github.com/ngoduykhanh/wireguard-ui/releases/download/v0.6.2/wireguard-ui-v0.6.2-linux-amd64.tar.gz
tar xvf wireguard-ui-v0.6.2-linux-amd64.tar.gz 
sysctl -p
uuid
vim .env

SESSION_SECRET=455a6af0-eecb-11ee-9298-8b824abde0ee
WGUI_USERNAME=wgadmin
WGUI_PASSWORD=Strong_Password_3366
BIND_ADDRESS=8083
SUBNET_RANGES=100.123.8.0/23
WGUI_ENDPOINT_ADDRESS=publicip.78
WGUI_PERSISTENT_KEEPALIVE=30
WGUI_SERVER_INTERFACE_ADDRESSES=100.123.8.1/23
WGUI_SERVER_LISTEN_PORT=8443
WGUI_DEFAULT_CLIENT_ALLOWED_IPS=100.123.8.0/23
WGUI_DEFAULT_CLIENT_ENABLE_AFTER_CREATION=true


<b> ########### </b>
vim /etc/systemd/system/wireguard-ui-daemon.service

[Unit]
Description=WireGuard UI Daemon
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
WorkingDirectory=/opt/wireguard-ui
EnvironmentFile=/opt/wireguard-ui/.env
ExecStart=/opt/wireguard-ui/wireguard-ui -bind-address "publicip.78:8083"

[Install]
WantedBy=multi-user.target

sudo vim /etc/systemd/system/wgui.service
[Unit]
Description=Restart WireGuard
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/systemctl restart wg-quick@wg0.service

[Install]
RequiredBy=wgui.path


sudo vim /etc/systemd/system/wgui.path
[Unit]
Description=Watch /etc/wireguard/wg0.conf for_changes

[Path]
PathModified=/etc/wireguard/wg0.conf

[Install]
WantedBy=multi-user.target



chmod +x /etc/systemd/system/wireguard-ui-daemon.service
chmod +x /etc/systemd/system/wgui.*

sudo systemctl enable wireguard-ui-daemon.service
sudo systemctl enable wgui.{path,service}

sudo systemctl daemon-reload

sudo systemctl start wgui.path
sudo systemctl start wgui.service
sudo systemctl start wireguard-ui-daemon.service

sudo systemctl status wgui.path
sudo systemctl status wgui.service
sudo systemctl status wireguard-ui-daemon.service

netstat -tulpn





### https://help.clouding.io/hc/en-us/articles/8492891803932-How-to-change-Wireguard-UI-panel-password ####
sudo vim /opt/wireguard-ui/db/users/wgadmin.json    ######## RESETING PASSWORD


{
  "username": "admin",
  "password": "7bFsfsdfasfsdajB",
  "password_hash": "",
  "admin": true
}

[access web-url]  http://publiccip.78:8083/



sudo vim /etc/wireguard/wg0.conf
https://insights.ditatompel.com/en/tutorials/installing-wireguard-ui-to-manage-your-wireguard-vpn-server/
[Interface]
Address = 100.123.8.1/23
ListenPort = 8443
PrivateKey = yxsfsdfjsddoifsofosdjfjsdlkjfsdjflsjdlW8mQ=
MTU = 1450
PostUp = 
PreDown = 
PostDown = 
Table = auto



sudo reboot 








############ 2024 #### with web-gui ####################
