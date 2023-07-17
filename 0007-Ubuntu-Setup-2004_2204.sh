
(01) INSTALL UBUNTU 20.04 LTS LEGACY-SERVER EDITION FROM BOOTABLE ISO/USB DRIVE
(02) Configure IP address+dns while installing the Operating System. (Important)
(03) After install complete, make sure you are geting Internet in the server.


(04) Remove netplan and Restore legacy network configuration options.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESTORING CLASSIC NETWORK CONFIGURATION OPTION

sudo vim /etc/apt/sources.list ; change mirror to 'mirror.amberit.com.bd' | 'mirror.0x.sg'
sudo apt update
sudo apt full-upgrade
sudo apt install -y ifupdown vim net-tools
sudo apt autoremove -y --purge netplan.io resolvconf
rm -fr /etc/netplan




ifconfig -a                             // find your ethernet interface name

sudo vim /etc/default/grub              // modify the file as follows
GRUB_DEFAULT=00
GRUB_TIMEOUT_STYLE=
GRUB_TIMEOUT=30
GRUB_CMDLINE_LINUX="netcfg/do_not_use_netplan=true"

// "Save+Exit"

sudo update-grub


sudo vim /etc/network/interfaces


########### Legacy Network Configuration
auto lo
iface lo inet loopback
#

auto eth0
iface eth0 inet static    
    address 172.16.208.25
    netmask 255.255.255.0
    gateway 172.16.208.1




// "Save+Exit"

apt install --install-recommends linux-generic-hwe-20.04
sudo apt autoremove --purge linux-generic-hwe-20.04 linux-oem-20.04 linux-hwe-* linux-oem-* linux-modules-5.4* linux-modules-5.8.0-* linux-modules-5.6.0-*


apt install --install-recommends linux-generic-hwe-18.04 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



(05) Fixing DNS Resolving Issue.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved.service
rm -fr /etc/resolv.conf
touch /etc/resolv.conf
echo "nameserver 9.9.9.9" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 1.0.0.3" >> /etc/resolv.conf


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  327  df -h
  328  apt-get install -y apt-cacher-ng
  329  echo "BindAddress: 0.0.0.0" >> /etc/apt-cacher-ng/acng.conf
  330  echo "Port:3142" >> /etc/apt-cacher-ng/acng.conf
  331  echo "PidFile: /var/run/apt-cacher-ng/pid" >> /etc/apt-cacher-ng/acng.conf
  332  /etc/init.d/apt-cacher-ng restart

echo 'Acquire::http { Proxy "http://127.0.0.1:3142"; };' > /etc/apt/apt.conf.d/50apt-cacher
echo 'Acquire::http { Proxy "http://192.168.166.200:3142"; };' > /etc/apt/apt.conf.d/50apt-cacher


# This is the network config written by 'subiquity'
network:
  version: 2
  ethernets:
    eth0:
      addresses:
      - 124.6.224.18/27
      gateway4: 124.6.224.1
      nameservers:
        addresses:
        - 202.51.183.6
        - 1.0.0.3

https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md


(06) Some Post-Installion Works.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			

keep thsese 3, 00-header  97-overlayroot  98-fsck-at-reboot
and delete all other files

mkdir -p /etc/default/grub.d
echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT apparmor=0"' | tee /etc/default/grub.d/apparmor.cfg
update-grub
reboot


sudo apt autoremove --purge unattended-upgrades landscape-common -y
sudo apt install -y wget axel iftop htop vim iperf3 mtr mc bwm-ng snmpd openssh-server arping rclone sshfs rsync telnet pv build-essential



### System Performance Tuning

sudo vim /etc/security/limits.conf

root soft     nproc          1024000
root hard     nproc          1024000
root soft     nofile         1024000
root hard     nofile         1024000


sudo vim /etc/sysctl.conf               //add the following lines

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
#

// "Save+Exit"


sudo sysctl -p

apt install python3-pip
pip3 install bpytop --upgrade

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




(07) CH24-VMX4 Specific Tasks.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sudo ip link add link eth2 name isp1 type macvtap
sudo ip link set isp1 up

sudo ip link add link eth3 name isp2 type macvtap
sudo ip link set isp2 up


sudo vim /etc/network/if-up.d/rc.local.sh

#!/bin/bash
sleep 240

### COMM1-LINK
sudo ip link add link eth2 name isp1 type macvtap
sudo ip link set isp1 up

### BDCOM-LINK
sudo ip link add link eth3 name isp2 type macvtap
sudo ip link set isp2 up

### LOCAL NETWORK

// "Save+Exit"

sudo vim /etc/network/if-up.d/rc.local.run.sh
#!/bin/bash
nohup /etc/network/if-up.d/rc.local.sh &

// "Save+Exit"

sudo chmod +x /etc/network/if-up.d/rc.local.*

sudo vim /etc/network/interfaces        ; add the following line at the end of file
post-up /etc/network/if-up.d/rc.local.run.sh

// "Save+Exit"

dpkg-reconfigure dash  ---> No


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




(08) Internal Storage Configuration with ZFS.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


https://askubuntu.com/questions/1379320/problem-installing-hp-proliant-utilities-on-ubuntu-server-20





   83  sudo echo "deb http://downloads.linux.hpe.com/SDR/repo/mcp bionic/current non-free" > /etc/apt/sources.list.d/mcp.list
   85  vim /etc/apt/sources.list.d/mcp.list   // change bionic -to- focal
   93  sudo curl http://downloads.linux.hpe.com/SDR/hpPublicKey1024.pub | sudo apt-key add -
   94  sudo curl http://downloads.linux.hpe.com/SDR/hpPublicKey2048.pub | sudo apt-key add -
   95  sudo curl http://downloads.linux.hpe.com/SDR/hpPublicKey2048_key1.pub | sudo apt-key add -
   96  sudo curl http://downloads.linux.hpe.com/SDR/hpePublicKey2048_key1.pub | sudo apt-key add -
   89  apt update
  100  sudo apt install hponcfg amsd ams ssacli ssaducli ssa

wget -c http://downloads.linux.hpe.com/SDR/repo/mcp/pool/non-free/hp-health_10.80-1874.10_amd64.deb
apt install gdebi-core
gdebi hp-health_10.80-1874.10_amd64.deb


https://gist.github.com/mrpeardotnet/a9ce41da99936c0175600f484fa20d03

  119  ssacli ctrl slot=0 pd all show
  120  ssacli ctrl slot=0 pd all show detail
  121  ssacli ctrl slot=0 pd all show detail |grep Serial



_____________

sudo add-apt-repository ppa:jonathonf/zfs
sudo apt update
sudo apt install zfsutils-linux gdisk

sudo fdisk -l |grep sd* |grep GiB            // find the available disks in the server

Disk /dev/sda: 279.37 GiB, 299966445568 bytes, 585871964 sectors
Disk /dev/sdc: 279.37 GiB, 299966445568 bytes, 585871964 sectors
Disk /dev/sdf: 279.37 GiB, 299966445568 bytes, 585871964 sectors
Disk /dev/sdb: 279.37 GiB, 299966445568 bytes, 585871964 sectors
Disk /dev/sdd: 279.37 GiB, 299966445568 bytes, 585871964 sectors
Disk /dev/sde: 279.37 GiB, 299966445568 bytes, 585871964 sectors
Disk /dev/sdg: 279.37 GiB, 299966445568 bytes, 585871964 sectors
Disk /dev/sdh: 232.87 GiB, 250023444480 bytes, 488327040 sectors


sudo fdisk -l | more Identify the OS disk, here it is "sda" 

Device     Boot   Start       End   Sectors   Size Id Type
/dev/sda1  *       2048   1050623   1048576   512M  b W95 FAT32
/dev/sda2       1052670 585871359 584818690 278.9G  5 Extended
/dev/sda5       1052672 585871359 584818688 278.9G 83 Linux


//Here also "sdh" is "SSD" which we will use as zfs-read-cache (L2ARC)
Disk /dev/sdh: 232.87 GiB, 250023444480 bytes, 488327040 sectors, 

//So, Our data disk will be,
sdb,sdc,sdd,sde,sdf,sdg

// Lets Create "ZFS RAIDZ2" Pool with "SSD" Read Cache.

// Here we have to find th disk-id from the OS

ls -la /dev/disk/by-id/   # We found something like bellow

...
lrwxrwxrwx 1 root root   9 Jun 29 09:43 scsi-0HP_LOGICAL_VOLUME_01000000 -> ../../sdb
lrwxrwxrwx 1 root root   9 Jun 29 09:43 scsi-0HP_LOGICAL_VOLUME_02000000 -> ../../sdc
lrwxrwxrwx 1 root root   9 Jun 29 09:43 scsi-0HP_LOGICAL_VOLUME_03000000 -> ../../sdd
lrwxrwxrwx 1 root root   9 Jun 29 09:43 scsi-0HP_LOGICAL_VOLUME_04000000 -> ../../sde
lrwxrwxrwx 1 root root   9 Jun 29 09:43 scsi-0HP_LOGICAL_VOLUME_05000000 -> ../../sdf
lrwxrwxrwx 1 root root   9 Jun 29 09:43 scsi-0HP_LOGICAL_VOLUME_06000000 -> ../../sdg
lrwxrwxrwx 1 root root   9 Jun 29 09:43 scsi-0HP_LOGICAL_VOLUME_07000000 -> ../../sdh
...
lrwxrwxrwx 1 root root   9 Jun 29 09:43 wwn-0x600508b1001c3ec64937950785d1504e -> ../../sdh
...
lrwxrwxrwx 1 root root   9 Jun 29 09:43 wwn-0x600508b1001c7a52ca05eec4e0afb73d -> ../../sdd
lrwxrwxrwx 1 root root   9 Jun 29 09:43 wwn-0x600508b1001c7d1b4b8d5a871e56535c -> ../../sde
lrwxrwxrwx 1 root root   9 Jun 29 09:43 wwn-0x600508b1001c840d4ccf29d8bbfb351f -> ../../sdg
lrwxrwxrwx 1 root root   9 Jun 29 09:43 wwn-0x600508b1001c84793a4ef7c5740c9b1c -> ../../sdb
lrwxrwxrwx 1 root root   9 Jun 29 09:43 wwn-0x600508b1001c8c1e2292e6dd06954823 -> ../../sdf
lrwxrwxrwx 1 root root   9 Jun 29 09:43 wwn-0x600508b1001cda713c46c79584b9ca22 -> ../../sdc

...


### Here we will use disk-id which starts with "WWN"

// First, initalize all disk by following command

sgdisk --zap-all /dev/sdb
sgdisk --zap-all /dev/sdc
sgdisk --zap-all /dev/sdd
sgdisk --zap-all /dev/sde
sgdisk --zap-all /dev/sdf
sgdisk --zap-all /dev/sdg
sgdisk --zap-all /dev/sdh


lrwxrwxrwx 1 root root   9 Aug 10 09:15 wwn-0x5000c5003c300e57 -> ../../sdd
lrwxrwxrwx 1 root root   9 Aug 10 09:16 wwn-0x5000c5004320e41f -> ../../sde

sudo zpool create -o ashift=12 -f vol1 mirror \
wwn-0x5000c5003c300e57 \
wwn-0x5000c5004320e41f

sudo zpool create -o ashift=12 -f n2vol1 wwn-0x600605b007f6c16027d30b892e8240fe-part4

// Create ZFS Pool

sudo zpool create -o ashift=12 -f vmx4vol1 raidz2 \
wwn-0x600508b1001c84793a4ef7c5740c9b1c \
wwn-0x600508b1001cda713c46c79584b9ca22 \
wwn-0x600508b1001c7a52ca05eec4e0afb73d \
wwn-0x600508b1001c7d1b4b8d5a871e56535c \
wwn-0x600508b1001c8c1e2292e6dd06954823 \
wwn-0x600508b1001c840d4ccf29d8bbfb351f

// Add SSD-Read-Cache "/dev/sdh"
sudo zpool add -f vmx4vol1 cache wwn-0x600508b1001c3ec64937950785d1504e

sudo zpool status


sudo zfs set sync=disabled vmx4vol1
sudo zfs set compress=lz4 vmx4vol1
sudo zfs set atime=off vmx4vol1
sudo zfs set xattr=sa vmx4vol1
sudo zfs set relatime=off vmx4vol1
sudo zfs set acltype=posixacl vmx4vol1

sudo zfs set sync=disabled ctvol1
sudo zfs set compress=lz4 ctvol1
sudo zfs set atime=off ctvol1
sudo zfs set xattr=sa ctvol1
sudo zfs set relatime=off ctvol1
sudo zfs set acltype=posixacl ctvol1


sudo zfs create vmx4vol1/iso
sudo zfs create vmx4vol1/lxc
sudo zfs create vmx4vol1/kvm


// Set ZFS RAM Cache...
## 8GB (Total RAM 32GB, assigining 8GB for zfs cache) // 1073741824 = 1GB
echo "options zfs zfs_arc_max=8589934592" > /etc/modprobe.d/zfs.conf
echo "options zfs zfs_arc_max=6442450944" > /etc/modprobe.d/zfs.conf


echo "options zfs zfs_arc_max=17179869184" > /etc/modprobe.d/zfs.conf
echo "options zfs zfs_arc_max=25769803776" > /etc/modprobe.d/zfs.conf


sudo add-apt-repository ppa:jonathonf/zfs
sudo apt-get update

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


echo "options zfs zfs_arc_max=4294967296" > /etc/modprobe.d/zfs.conf
echo "4294967296" >> /sys/module/zfs/parameters/zfs_arc_max
sync; echo 3 > /proc/sys/vm/drop_caches




(09) Install KVM and LXC foR virtualization.



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

https://www.how2shout.com/linux/how-to-install-linux-kernel-5-10-on-ubuntu-20-04-lts/




Become root. 

sudo su
dpkg -l | grep linux-image

echo linux-image-2.6.32-38-generic hold  
dpkg --set-selections; 
echo linux-image-generic hold 
dpkg --set-selections; 
echo linux-generic hold 
dpkg --set-selections;



sudo aptitude update;
sudo aptitude safe-upgrade;


nano /etc/apt/apt.conf.d/50unattended-upgrades

sudo apt-mark hold linux-image-generic linux-headers-generic
sudo apt-mark hold linux-generic linux-image-generic linux-headers-generic

https://www.cyberciti.biz/faq/apt-get-hold-back-packages-command




rm -fr /etc/update-motd.d/50-motd-news
rm -fr /etc/update-motd.d/80-esm
rm -fr /etc/update-motd.d/80-livepatch



### Check that your server-hardware is capable of running kvm
grep -E -c "vmx|svm" /proc/cpuinfo
sudo apt install -y cpu-checker
sudo kvm-ok
lsmod | grep -i kvm

### disable apparmor
sudo systemctl stop apparmor
sudo systemctl disable apparmor
sudo apt remove --assume-yes --purge apparmor
sudo apt-get autoremove --purge apparmor


sudo apt remove --purge lxd lxd-client
sudo apt autoremove --purge unattended-upgrades


sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils openvswitch-switch lxc lxc-templates virt-top libguestfs-tools libosinfo-bin  qemu-system

sudo apt autoremove -y --purge lxd lxd-client
sudo apt install lxc lxc-templates


sudo systemctl status libvirtd.service

sudo virsh net-destroy default
sudo virsh net-undefine default

sudo ip link   // find the virtual interfaces
sudo ip link delete virbr0 type brigde
sudo ip link delete virbr0-nic
sudo ip link delete lxcbr0 type brigde


sudo systemctl restart libvirtd.service
sudo systemctl status libvirtd.service

## Increase Swap Space if require

sudo swapoff /swapfile
sudo fallocate -l 24G /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile


## Configure SSH on PORT 5060 and Set Root Password.

// Enable following lines
sudo vim /etc/ssh/sshd_config

Port 5060
PermitRootLogin yes
UseDNS no

// "Save+Exit"


passwd root     // set the root password

sudo reboot

## After Reboot Try to connect Server in Virt-Manager from another PC (Linux Desktop)





@reboot sleep 180 && rc.local.sh

##############################################

sudo /etc/systemd/system/omninet.service

[Unit]
Description=OmniNet Startup Network Service
After=network.target

[Service]
Type=oneshot
ExecStart=/opt/omninet.sh

[Install]
WantedBy=multi-user.target


sudo vim /opt/omninet.sh
#!/bin/bash
vppctl enable tap-inject
vppctl set interface state GigabitEthernet4/0/0 up
ip link set vpp2 up
ifconfig vpp2 192.168.156.201/24 up


sudo systemctl daemon-reload
sudo systemctl enable omninet






https://linuxize.com/post/how-to-add-swap-space-on-ubuntu-20-04/

481  zfs create -V 24G rpool/swapfile
  482  fdisk -l
  483  sgdisk --zap-all /dev/zd0
  484  sgdisk --zap-all /dev/zd0
  485  fdisk -l
  486   swapon --show
  487  swapon --show
  488  free -h
  489  fdisk /dev/zd0
  490  free -h
  491  fdisk -l
  492  mkfs.xfs -f /dev/zd0p1
  493  fdisk -l
  494  mkdir /swapdisk
  495  mount /dev/zd0p1 /swapdisk
  496  df -h
  497  fallocate -l 23G /swapdisk/swapfile
  498  dd if=/dev/zero of=/swapdisk/swapfile bs=1024 count=2097152
  499  chmod 600 /swapdisk/swapfile
  500  mkswap /swapdisk/swapfile
  501  swapon /swapdisk/swapfile
  502  htop
  503  swapoff /swapdisk/swapfile
  504  dd if=/dev/zero of=/swapdisk/swapfile bs=1024 count=46137344
  505  chmod 600 /swapdisk/swapfile
  506  mkswap /swapdisk/swapfile
  507  swapon /swapdisk/swapfile
  508  htop
  509  vim /usr/bin/free-ram
  510  chmod +x /usr/bin/free-ram
  511  /usr/bin/free-ram
  512  htop
  513  vim /etc/crontab 
  514  htop
  515  ifconfig 
  516  htop
  517  history 




~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



(10) Configure SNMP.



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sudo apt-get install snmpd -y
sudo mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.old
sudo su -

sudo vim /etc/snmp/snmpd.conf
# Change public below to your preferred SNMP community string
com2sec readonly  default         OmniPathPublic

group MySNMP v2c        readonly
view all    included  .1                               80
access MySNMP ""      any       noauth    exact  all    none   none

sysLocation C1NOC, Banani, Dhaka
sysContact Rezaul Karim (rkarim@omnitechone.com)

#Distro Detection
extend .1.3.6.1.4.1.2021.7890.1 distro /usr/bin/distro

// "Save+Exit"

sudo curl -o /usr/bin/distro https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro
sudo chmod +x /usr/bin/distro
sudo service snmpd restart

#Edit sysLocation and sysContact if needed

https://techexpert.tips/zabbix/zabbix-5-install-ubuntu-linux/
https://www.youtube.com/watch?v=ZR0VX8mY72M

   51  apt install snmp-mibs-downloader
   52  vim /etc/snmp/snmp.conf 
   53  /etc/init.d/snmpd restart
   54  download-mibs 
   55  history 


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




(11) Create LXC Container.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sudo vim /usr/bin/lxc-list
#!/bin/bash
lxc-ls --fancy

// "Save+Exit"

sudo chmod +x /usr/bin/lxc-list
sudo lxc-list

sudo lxc-create -t download -n ubuntu1804 -- -d ubuntu -r bionic -a amd64


sudo vim /var/lib/lxc/ubuntu1804/config


lxc.apparmor.profile = unconfined

# Network configuration (Access-vlan.208)
lxc.net.0.type = macvlan
lxc.net.0.macvlan.mode = bridge
lxc.net.0.flags = up
lxc.net.0.link = eth0
lxc.net.0.name = eth0

####
lxc.cgroup.memory.limit_in_bytes = 4096M
lxc.cgroup.cpuset.cpus = 4-7
lxc.cgroup.cpu.shares = 256


// Save+Exit


The cpu.shares options defines the CPU priority of the group. By default, 
all groups inherit 1,024 shares or 100% of CPU time. By bringing this value down to something a bit more conservative, 
like 100, the group will be limited to approximately 10% of the CPU time.


# Use Following Line If there is any GPG Error
sudo lxc-create -t download -n ubuntu1804 -- -d ubuntu -r bionic -a amd64 --keyserver hkp://keyserver.ubuntu.com 


sudo lxc-list

vim /usr/share/lxc/config/common.conf
--> disable following lines
#lxc.cap.drop = mac_admin mac_override sys_time sys_module sys_rawio
#lxc.cgroup.devices.deny = a
#lxc.seccomp.profile = /usr/share/lxc/config/common.seccomp
--> add following line
lxc.apparmor.profile = unconfined




lxc.mount.entry=/path/in/host/mount_point mount_point_in_container none bind 0 0
# Exposes /dev/sde in the container
lxc.mount.entry = /dev/sde dev/sde none bind,optional,create=file
lxc.mount.entry = /dev/mapper/lvmfs-home-partition home ext4 defaults 0 2
lxc.mount.entry = /home home none bind,rw 0 0





#	ECRAFT 
lxc.include = /usr/share/lxc/config/ubuntu.common.conf
# Container specific configuration
lxc.arch = amd64
# Network configuration
lxc.net.0.type = macvlan
lxc.net.0.macvlan.mode = bridge
lxc.net.0.flags = up
lxc.net.0.link = eno1
lxc.net.0.name = eth0
lxc.net.0.hwaddr = 00:16:3e:40:9e:4d
#
lxc.net.0.type = macvlan
lxc.net.0.macvlan.mode = bridge
lxc.net.0.flags = up
lxc.net.0.link = eno2
lxc.net.0.name = eth1
lxc.net.0.hwaddr = 00:16:3e:3d:09:d1
#
lxc.rootfs.path = dir:/var/lib/lxc/mvgl/rootfs
lxc.uts.name = mvgl
# Added by lxc postinst, migration of autostart flag
lxc.start.auto = 1
lxc.start.delay = 5





~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



(12) Configure a Virtual-Interface and Mount Storage Z400 NAS and Migragte VMs from Some Other Server.



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sudo ip addr add 192.168.188.134/24 dev isp2
// Also add the above line in the file "/etc/network/if-up.d/rc.local.sh".
sudo ip link set eth2 up
sudo ip link set eth3 up


sudo mkdir /mnt/nfs4kvm  /mnt/ch24ftps
sudo apt install nfs-kernel-server nfs-common

sudo vim /etc/fstab
192.168.188.100:/mnt/watertank/nfs4kvm /mnt/nfs4kvm nfs nofail,rw,vers=4,rsize=32768,wsize=32768,hard,proto=tcp,timeo=600,retrans=2,sec=sys,addr=192.168.188.100 0 0
192.168.188.100:/mnt/watertank/ch24ftps /mnt/ch24ftps nfs nofail,rw,vers=4,rsize=32768,wsize=32768,hard,proto=tcp,timeo=600,retrans=2,sec=sys,addr=192.168.188.100 0 0

// "Save+Exit"

sudo mount -a


// Now add the follwing lines in the file "/etc/network/if-up.d/rc.local.sh" at the end of file.

### Reload /etc/fstab
mount -a



// "Save+Exit"

apt -y install locales-all
localectl set-locale LANG=en_GB.UTF-8 LANGUAGE="en_GB:en"
export LANG=en_GB.UTF-8

cd /root/
vim .profile //export LANG=en_GB.UTF-8
vim .bashrc //export LANG=en_GB.UTF-8


source .profile
source .bashrc




~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



(13) Configure Dedicated Storage Interface and Mount Storage FreeNAS (HP DL380 G7).




(14) Create Local Multi VLAN (139,201-210, 250).


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# First, Configure CISCO Switch Port as Trunk and Pass Vlan 139,200-210,250

# Now Login into server via IP 192.168.188.134 from Current VMX3/VMX6, then apply following commands.


### Right now we will up essential vlans, later we will up other vlan as require
sudo ip link add link eth0 name eth0.139 type vlan id 139
sudo ip link set eth0.139 up
# sudo ip -d link show eth0.139  //command to display the interface

sudo ip link add link eth0 name eth0.207 type vlan id 207
sudo ip link set eth0.207 up

sudo ip link add link eth0 name eth0.208 type vlan id 208
sudo ip link set eth0.208 up


sudo ip link add link eth0 name eth0.210 type vlan id 210
sudo ip link set eth0.210 up

sudo ip link add link eth0 name eth0.250 type vlan id 250
sudo ip link set eth0.250 up

sudo ip addr add 172.16.208.25/24 dev eth0.208
sudo ip route add default via 172.16.208.1



// Now add the above lines in the file "/etc/network/if-up.d/rc.local.sh" under the "# LOCAL NETWORK #" Section

sudo vim /etc/network/if-up.d/rc.local.sh



//Adjust the network interface file "/etc/network/interfaces" as follows;


auto eth0
iface eth0 inet manual

auto eth1
iface eth1 inet manual

auto eth2
iface eth2 inet manual

auto eth3
iface eth3 inet manual

auto eth4
iface eth4 inet manual

post-up /etc/network/if-up.d/rc.local.run.sh

// "Save+Exit"

sudo reboot         // Check everyting after reboot




wget -qO - http://images.45drives.com/repo/keys/aptpubkey.asc | apt-key add -
cd /etc/apt/sources.list.d
sudo curl -LO http://images.45drives.com/repo/debian/45drives.list
vim 45drives.list
deb [arch=amd64] http://images.45drives.com/repo/debian focal main

apt update
apt install -y cockpit cockpit-zfs-manager cockpit-benchmark cockpit-navigator cockpit-file-sharing cockpit-45drives-hardware cockpit-machines realmd tuned zfs-dkms nfs-kernel-server nfs-client
apt remove 45drives-tools cockpit-45drives-hardware -y
apt --fix-broken install




sudo apt install cockpit cockpit-bridge cockpit-dashboard cockpit-machines cockpit-networkmanager cockpit-packagekit cockpit-pcp cockpit-storaged cockpit-system cockpit-ws  



https://www.ostechnix.com/install-and-configure-kvm-in-ubuntu-20-04-headless-server/


https://www.ostechnix.com/how-to-enable-nested-virtualization-in-kvm-in-linux/
sudo modprobe -r kvm_intel
sudo modprobe -r kvm_amd

sudo modprobe kvm_intel nested=1
sudo modprobe kvm_amd nested=1

sudo vi /etc/modprobe.d/kvm.conf
options kvm_intel nested=1
options kvm_amd nested=1

 cat /sys/module/kvm_intel/parameters/nested

https://www.ostechnix.com/install-nginx-mysql-php-lemp-stack-on-ubuntu-20-04-lts/


3Bsp8ZEMWMDs


virsh domifaddr centos8
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



(15) Mount GFX NAS and Migragte VMs from Some Other Server.







~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# https://ubuntu.com/server/docs/openvswitch-dpdk

sudo apt-get install openvswitch-switch-dpdk
sudo update-alternatives --set ovs-vswitchd /usr/lib/openvswitch-switch-dpdk/ovs-vswitchd-dpdk
ovs-vsctl set Open_vSwitch . "other_config:dpdk-init=true"
# run on core 0 only
ovs-vsctl set Open_vSwitch . "other_config:dpdk-lcore-mask=0x1"
# Allocate 2G huge pages (not Numa node aware)
ovs-vsctl set Open_vSwitch . "other_config:dpdk-alloc-mem=2048"
# limit to one whitelisted device
ovs-vsctl set Open_vSwitch . "other_config:dpdk-extra=--pci-whitelist=0000:04:00.0"
sudo service openvswitch-switch restart


ovs-vsctl add-br ovsdpdkbr0 -- set bridge ovsdpdkbr0 datapath_type=netdev
ovs-vsctl add-port ovsdpdkbr0 dpdk0 -- set Interface dpdk0 type=dpdk  "options:dpdk-devargs=${OVSDEV_PCIID}"      


ovs-vsctl set Interface dpdk0 "options:n_rxq=2"



ovs-vsctl add-port ovsdpdkbr0 vhost-user-1 -- set Interface vhost-user-1 type=dpdkvhostuserclient "options:vhost-server-path=/var/run/vhostuserclient/vhost-user-client-1"


<interface type='vhostuser'>
<source type='unix'
path='/var/run/openvswitch/vhost-user-client-1'
mode='server'/>
<model type='virtio'/>
</interface>



ovs-vsctl set Open_vSwitch . other_config:n-dpdk-rxqs=2
ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=0x6




sudo service openvswitch-switch restart


CMD: sudo ovs-vsctl add-br ovsdpdkbr0 -- set bridge ovsdpdkbr0 datapath_type=netdev
CMD: sudo ovs-vsctl add-port ovsdpdkbr0 dpdk0 -- set Interface dpdk0 type=dpdk
CMD: sudo ovs-vsctl add-port ovsdpdkbr0 vhost-user-1 -- set Interface vhost-user-1 type=dpdkvhostuser


# http://docs.openvswitch.org/en/latest/howto/dpdk/



$ ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
$ ovs-vsctl add-port br0 dpdk-p0 -- set Interface dpdk-p0 type=dpdk \
    options:dpdk-devargs=0000:01:00.0
$ ovs-vsctl add-port br0 dpdk-p1 -- set Interface dpdk-p1 type=dpdk \
    options:dpdk-devargs=0000:01:00.1

$ ovs-vsctl add-port br0 dpdk-p0 -- set Interface dpdk-p0 type=dpdk \
    options:dpdk-devargs="class=eth,mac=00:11:22:33:44:55"
$ ovs-vsctl add-port br0 dpdk-p1 -- set Interface dpdk-p1 type=dpdk \
    options:dpdk-devargs="class=eth,mac=00:11:22:33:44:56"


$ top -H
$ ps -eLo pid,psr,comm | grep pmd


$ ovs-vsctl add-bond br0 dpdkbond p0 p1 \
    -- set Interface p0 type=dpdk options:dpdk-devargs=0000:01:00.0 \
    -- set Interface p1 type=dpdk options:dpdk-devargs=0000:01:00.1



$ ovs-appctl -t ovs-vswitchd exit
$ ovs-appctl -t ovsdb-server exit
$ ovs-vsctl del-br br0


https://ubuntu.com/server/docs/network-dpdk


iommu=pt intel_iommu=on          

http://docs.openvswitch.org/en/latest/topics/dpdk/qos/#rate-limiting-ingress-policing





https://wiki.debian.org/TrafficControl

apt-get install iproute2
tc qdisc del root dev eth0
tc qdisc add dev ppp0 root tbf rate 220kbit latency 50ms burst 1540
tc qdisc add dev eth0 root sfq perturb 10



tc qdisc add dev eth0 root tbf rate 1mbit burst 32kbit latency 400ms
tc qdisc add dev eth1 root tbf rate 220kbit latency 50ms burst 1540 

qdisc - queueing discipline 
latency - number of bytes that can be queued waiting for tokens to become available.
burst - Size of the bucket, in bytes.
rate - speedknob


tc qdisc add dev eth1 root sfq perturb 10





# This line sets a HTB qdisc on the root of eth0, and it specifies that the class 1:30 is used by default. It sets the name of the root as 1:, for future references.
tc qdisc add dev eth0 root handle 1: htb default 30

# This creates a class called 1:1, which is direct descendant of root (the parent is 1:), this class gets assigned also an HTB qdisc, and then it sets a max rate of 6mbits, with a burst of 15k
tc class add dev eth0 parent 1: classid 1:1 htb rate 6mbit burst 15k

# The previous class has this branches:

# Class 1:10, which has a rate of 5mbit
tc class add dev eth0 parent 1:1 classid 1:10 htb rate 5mbit burst 15k

# Class 1:20, which has a rate of 3mbit
tc class add dev eth0 parent 1:1 classid 1:20 htb rate 3mbit ceil 6mbit burst 15k

# Class 1:30, which has a rate of 1kbit. This one is the default class.
tc class add dev eth0 parent 1:1 classid 1:30 htb rate 1kbit ceil 6mbit burst 15k

# Martin Devera, author of HTB, then recommends SFQ for beneath these classes:
tc qdisc add dev eth0 parent 1:10 handle 10: sfq perturb 10
tc qdisc add dev eth0 parent 1:20 handle 20: sfq perturb 10
tc qdisc add dev eth0 parent 1:30 handle 30: sfq perturb 10




https://www.badunetworks.com/traffic-shaping-with-tc/


http://docs.openvswitch.org/en/latest/howto/qos/


$ ovs-vsctl set interface tap0 ingress_policing_rate=1000
$ ovs-vsctl set interface tap0 ingress_policing_burst=100

$ ovs-vsctl set interface tap1 ingress_policing_rate=10000
$ ovs-vsctl set interface tap1 ingress_policing_burst=1000


$ ovs-vsctl list interface tap0


(installing Netperf usually starts netserver as a daemon, meaning this is running by default).

For this example, we assume that the Measurement Host has an IP of 10.0.0.100 and is reachable from both VMs.

$ netperf -H 10.0.0.100




##################

$ ovs-vsctl add-port br0 vlan1000 -- set Interface vlan1000 type=internal
$ ifconfig vlan1000
$ ifconfig vlan1000 <ip> netmask <mask> up

$ ovs-vsctl show

tcpdump -e -i vlan1000 'icmp'


https://software.intel.com/content/www/us/en/develop/articles/rate-limiting-configuration-and-usage-For-open-vswitch-with-dpdk.html




sudo apt-mark hold linux-image-generic linux-headers-generic
sudo apt-get update 
sudo apt-get upgrade -y 
sudo apt-mark unhold linux-image-generic linux-headers-generic

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
vim /etc/network/if-up.d/rc.bwm.sh

#!/bin/bash
### Ejogajog ##
tc qdisc del root dev enp5s0f1.733
tc qdisc add dev enp5s0f1.733 root handle 1: htb default 10
tc class add dev enp5s0f1.733 parent 1: classid 1:1 htb rate 500mbit ceil 500mbit
tc class add dev enp5s0f1.733 parent 1:1 classid 1:10 htb rate 305mbit ceil 305mbit
tc qdisc add dev enp5s0f1.733 parent 1:10 handle 10: sfq perturb 10

### Dulal ###
tc qdisc del root dev enp5s0f1.731
tc qdisc add dev enp5s0f1.731 root handle 1: htb default 10
tc class add dev enp5s0f1.731 parent 1: classid 1:1 htb rate 500mbit ceil 500mbit
tc class add dev enp5s0f1.731 parent 1:1 classid 1:10 htb rate 205mbit ceil 205mbit
tc qdisc add dev enp5s0f1.731 parent 1:10 handle 10: sfq perturb 10

### Habib ###
tc qdisc del root dev enp5s0f1.732
tc qdisc add dev enp5s0f1.732 root handle 1: htb default 10
tc class add dev enp5s0f1.732 parent 1: classid 1:1 htb rate 500mbit ceil 500mbit
tc class add dev enp5s0f1.732 parent 1:1 classid 1:10 htb rate 125mbit ceil 125mbit
tc qdisc add dev enp5s0f1.732 parent 1:10 handle 10: sfq perturb 10

### Rozen ###
tc qdisc del root dev enp5s0f1.729
tc qdisc add dev enp5s0f1.729 root handle 1: htb default 10
tc class add dev enp5s0f1.729 parent 1: classid 1:1 htb rate 500mbit ceil 500mbit
tc class add dev enp5s0f1.729 parent 1:1 classid 1:10 htb rate 105mbit ceil 105mbit
tc qdisc add dev enp5s0f1.729 parent 1:10 handle 10: sfq perturb 10

### GoldCable ###
tc qdisc del root dev enp5s0f1.728
tc qdisc add dev enp5s0f1.728 root handle 1: htb default 10
tc class add dev enp5s0f1.728 parent 1: classid 1:1 htb rate 500mbit ceil 500mbit
tc class add dev enp5s0f1.728 parent 1:1 classid 1:10 htb rate 105mbit ceil 105mbit
tc qdisc add dev enp5s0f1.728 parent 1:10 handle 10: sfq perturb 10



#!/bin/bash

sleep 30

ethtool -K enp5s0f0 lro off
ethtool -K enp5s0f1 lro off

ethtool -K enp5s0f0 tso off
ethtool -K enp5s0f1 tso off

### L3-Primary ####
sudo ip link add link enp5s0f0 name enp5s0f0.308 type vlan id 308
sudo ip link set enp5s0f0.308 up
ip addr add 43.224.114.18/30 broadcast 43.224.114.19 dev enp5s0f0.308

### L3-Second ####
sudo ip link add link enp5s0f0 name enp5s0f0.305 type vlan id 305
sudo ip link set enp5s0f0.305 up
ip addr add 43.228.211.18/30 broadcast 43.228.211.19 dev enp5s0f0.305


### BSD-GW ###
sudo ip link add link enp5s0f1 name enp5s0f1.1982 type vlan id 1982
sudo ip link set enp5s0f1.1982 up
sudo ip addr add 172.17.236.1/30 broadcast 172.17.236.3 dev enp5s0f1.1982

### GoldCable ####
sudo ip link add link enp5s0f1 name enp5s0f1.728 type vlan id 728
sudo ip link set enp5s0f1.728 up
ip addr add 172.17.235.25/30 broadcast 172.17.235.27 dev enp5s0f1.728


### Rozen ####
sudo ip link add link enp5s0f1 name enp5s0f1.729 type vlan id 729
sudo ip link set enp5s0f1.729 up
ip addr add 172.17.235.29/30 broadcast 172.17.235.31 dev enp5s0f1.729

### Dulal ####
sudo ip link add link enp5s0f1 name enp5s0f1.731 type vlan id 731
sudo ip link set enp5s0f1.731 up
ip addr add 172.17.235.21/30 broadcast 172.17.235.23 dev enp5s0f1.731

### Habib ####
sudo ip link add link enp5s0f1 name enp5s0f1.732 type vlan id 732
sudo ip link set enp5s0f1.732 up
ip addr add 172.17.235.17/30 broadcast 172.17.235.19 dev enp5s0f1.732

### Ejogajog ####
sudo ip link add link enp5s0f1 name enp5s0f1.733 type vlan id 733
sudo ip link set enp5s0f1.733 up
ip addr add 172.17.235.13/30 broadcast 172.17.235.15 dev enp5s0f1.733

### CoreMKT-1 ####
sudo ip link add link enp5s0f1 name enp5s0f1.734 type vlan id 734
sudo ip link set enp5s0f1.734 up
ip addr add 172.17.235.1/30 broadcast 172.17.235.3 dev enp5s0f1.734


#### NAT
iptables -t nat -A POSTROUTING -s 172.17.235.0/24 -o enp5s0f0.308 -j SNAT --to 43.224.114.18
iptables -t nat -A POSTROUTING -s 172.17.235.0/24 -o enp5s0f0.305 -j SNAT --to 43.228.211.18

### LOAD BWM RULES
/etc/network/if-up.d/rc.bwm.sh

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# https://www.softprayog.in/tutorials/cut-command-in-linux
# https://www.softprayog.in/tutorials/network-traffic-control-with-tc-command-in-linux

sudo tc qdisc add dev eth0 root fq_codel
sudo tc -s qdisc show dev eth0
 
tc qdisc add dev wlan0 root handle 1:0 hfsc default 1
tc class add dev wlan0 parent 1:0 classid 1:1 hfsc sc rate 1mbit ul rate 1mbit
tc class add dev wlan0 parent 1:0 classid 1:2 hfsc sc rate 400kbit ul rate 400kbit
tc filter add dev wlan0 protocol all parent 1: u32 match ip dst 192.168.2.157 flowid 1:2




~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





qemu-img resize --shrink U2004.qcow2 -16G





sudo qemu-img resize /var/lib/libvirt/images/rhel8.qcow2 +10G
sudo qemu-img resize /var/lib/libvirt/images/rhel8.qcow2 +10G
sudo qemu-img info /var/lib/libvirt/images/rhel8.qcow2

sudo virsh blockresize rhel8 /var/lib/libvirt/images/rhel8.qcow2 40G

fdisk -l /var/lib/libvirt/images/rhel8.qcow2

qemu-img resize kvm1.qcow2 +20G
cp kvm1.qcow2 kvm1-orig.qcow2
virt-resize --expand /dev/sda1 kvm1-orig.qcow2 kvm1.qcow2

qemu-img resize kvm1.qcow2 +20G
cp kvm1.qcow2 kvm1-orig.qcow2
virt-resize --expand /dev/sda1 kvm1-orig.qcow2 kvm1.qcow






apt install lsscsi

root@Z800:~# lsscsi
[0:0:0:0]    disk    ATA      PNY CS1311 240GB 1122  /dev/sda 
[6:0:0:0]    disk    HITACHI  HUS156060VLS600  HPH1  /dev/sdb 
[6:0:1:0]    disk    SEAGATE  ST3600057SS      HPS1  /dev/sdc 
[6:0:2:0]    disk    SEAGATE  ST3600057SS      HPS1  /dev/sdd 
[6:0:3:0]    disk    ATA      ST31000524AS     HP63  /dev/sde 

root@Z800:~# lsblk -S

 apt install sg3-utils

root@Z800:~#  sginfo -M /dev/sda

root@Z800:/vol1/iso# sginfo -a /dev/sda |grep Serial
Serial Number 'PNY33160133910204C95'








164  ls /etc/apparmor.d/
  165  sudo ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/
  166  apparmor_parser -R /etc/apparmor.d/disable/usr.sbin.mysqld
  167  sudo systemctl disable apparmor
  168  aa-status 
  169  apparmor_status
  170  vim /etc/default/grub.d/apparmor.cfg
  171  vim /etc/default/grub.d/50_linuxmint.cfg 
  172  apt purge apparmor
  173  sudo apt autoremove --purge
  174  sudo apt autoclean
  175  aa-status
  176  cd
  177  cd /etc/default/grub.d
  178  ls
  179  echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT apparmor=0"' | tee /etc/default/grub.d/apparmor.cfg
  180  update-grub



user@ubuntu:~$ sudo vim /etc/security/limits.conf

# add following lines to it
* soft     nproc          65535    
* hard     nproc          65535   
* soft     nofile         65535   
* hard     nofile         65535
root soft     nproc          65535    
root hard     nproc          65535   
root soft     nofile         65535   
root hard     nofile         65535

# edit the following file
user@ubuntu:~$ sudo vim /etc/pam.d/common-session

# add this line to it
session required pam_limits.so

# logout and login and try the following command
user@ubuntu:~$ ulimit -n
65535



#######

   29  apt install -y ifupdown vim net-tools resolvconf
   30  sudo apt autoremove -y --purge netplan.io
   31  rm -fr /etc/netplan
   32  ifconfig -a
   33  sudo vim /etc/default/grub
   34  sudo update-grub
   35  sudo vim /etc/network/interfaces
   36  sudo systemctl stop systemd-resolved
   37  sudo systemctl disable systemd-resolved.service
   38  rm -fr /etc/resolv.conf
   39  touch /etc/resolv.conf
   40  echo "nameserver 1.0.0.1" > /etc/resolv.conf
   41  cd /etc/update-motd.d
   42  mc
   43  apt install mc
   44  mc
   45  mkdir -p /etc/default/grub.d
   46  echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT apparmor=0"' | tee /etc/default/grub.d/apparmor.cfg
   47  update-grub
   48  sudo apt autoremove --purge unattended-upgrades landscape-common -y
   49  sudo apt install -y wget axel iftop htop vim iperf3 mtr mc bwm-ng openssh-server arping rclone sshfs rsync telnet pv build-essential
   50  sudo vim /etc/security/limits.conf
   51  vim /etc/sysctl.conf
   52  sudo sysctl -p
   53  apt install python3-pip
   54  pip3 install bpytop --upgrade
   55  bpytop
   56  dpkg-reconfigure dash  ---> No
   57  dpkg-reconfigure dash
   58  sudo systemctl stop apparmor
   59  sudo systemctl disable apparmor
   60  sudo apt remove --assume-yes --purge apparmor
   61  cd
   62  reboot
   63  vim /etc/ssh/sshd_config
   64  passwd root
   65  cd
   66  /etc/init.d/ssh restart
   67  wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh
   68  sudo install ubuntu-mainline-kernel.sh /usr/local/bin/
   69  ubuntu-mainline-kernel.sh -c
   70  sudo ubuntu-mainline-kernel.sh -i
   71  history


To disable the driver, either adjust /etc/libvirt/qemu.conf to have'security_driver = “none”' or remove the AppArmor profilefor libvirtd from the kernel and restart libvirtd


echo -e "link-status-of enp9s0"
ethtool enp9s0 |grep 'Link detected'

echo -e "link-status-of enp10s0"
ethtool enp10s0 |grep 'Link detected'

echo -e "link-status-of enp4s0f0"
ethtool enp4s0f0 |grep 'Link detected'

echo -e "link-status-of enp4s0f1"
ethtool enp4s0f1 |grep 'Link detected'

echo -e "link-status-of enp5s0f0"
ethtool enp5s0f0 |grep 'Link detected'

echo -e "link-status-of enp5s0f1"
ethtool enp5s0f1 |grep 'Link detected'








  220  systemctl disable ksm
  221  cat /sys/kernel/mm/ksm/run
  222  echo 2 >/sys/kernel/mm/ksm/run
  223  vim /etc/network/interfaces
  224  cat /sys/kernel/mm/ksm/pages_sharing
  225  cat /etc/ksmtuned.conf
  226  vim /etc/ksmtuned.conf
  227  systemctl disable ksmtuned
  228  watch cat /sys/kernel/mm/ksm/pages_sharing
  229  history



# systemctl disable ksm
# systemctl disable ksmtuned
# echo 2 >/sys/kernel/mm/ksm/run





~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim /etc/network/vpnlink0.up

#!/bin/bash
BRIDGE="vpnlink0"
ovs-vsctl --may-exist add-br $BRIDGE
ovs-vsctl --if-exists del-port $BRIDGE $5
ovs-vsctl --may-exist add-port $BRIDGE $5

vim /etc/network/vpnlink0.dn

#!/bin/bash
ovsBr=vpnlink0
ovs-vsctl --if-exists del-port ${obsBr} $5

chmod +x /etc/network/vpnlink0.*


# Network configuration
lxc.net.0.type = veth
lxc.net.0.flags = up
lxc.net.0.script.up = /etc/network/vpnlink0.up
lxc.net.0.script.down = /etc/network/vpnlink0.dn

#lxc.net.0.hwaddr = 00:16:3e:95:2a:46



lxc.net.0.script.up = /etc/network/vpnlink0.up
lxc.net.0.script.down = /etc/network/vpnlink0.dn





##########
option domain-name "hashtag.lan";
option domain-name-servers vpn.hashtag.lan;
default-lease-time 3600; 
max-lease-time 7200;
authoritative;


subnet 192.168.130.0 netmask 255.255.255.0 {
        option routers                  192.168.130.1;
        option subnet-mask              255.255.255.0;
        option domain-search            "hashtag.lan";
        option domain-name-servers      1.0.0.3;
#        range   192.168.10.10   192.168.10.100;
        range   192.168.130.100   192.168.130.199;
}




host centos-node {
	 hardware ethernet 00:f0:m4:6y:89:0g;
	 fixed-address 192.168.10.105;
 }

host fedora-node {
	 hardware ethernet 00:4g:8h:13:8h:3a;
	 fixed-address 192.168.10.106;
 }
 
 
------------ SystemD ------------ 
$ sudo systemctl start isc-dhcp-server.service
$ sudo systemctl enable isc-dhcp-server.service


------------ SysVinit ------------ 
$ sudo service isc-dhcp-server.service start
$ sudo service isc-dhcp-server.service enable






root@hashtagvpn_zfs:~# ifconfig n
n: error fetching interface information: Device not found
root@hashtagvpn_zfs:~# ifconfig -a
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 103.144.200.13  netmask 255.255.255.240  broadcast 103.144.200.15
        inet6 fe80::216:3eff:fe95:2a46  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:95:2a:46  txqueuelen 1000  (Ethernet)
        RX packets 4361  bytes 1156666 (1.1 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 4222  bytes 1191072 (1.1 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.130.1  netmask 255.255.255.0  broadcast 192.168.130.255
        inet6 fe80::488b:f9ff:fe3b:a8c8  prefixlen 64  scopeid 0x20<link>
        ether 4a:8b:f9:3b:a8:c8  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 11  bytes 866 (866.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 3342  bytes 267540 (267.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 3342  bytes 267540 (267.5 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0





   67  wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh
   68  sudo install ubuntu-mainline-kernel.sh /usr/local/bin/
   69  ubuntu-mainline-kernel.sh -c
   70  sudo ubuntu-mainline-kernel.sh -i
   71  history





vim /etc/network/vpnlink0.xml

<network>
	<name>vpnlink0</name>
	<forward mode='bridge'/>
	<bridge name='vpnlink0'/>
	<virtualport type='openvswitch' />
</network>

<network>
  <name>vlink0</name>
  <forward mode='bridge'/>
  <bridge name='vlink0'/>
  <virtualport type='openvswitch' />
</network>




Hastag-VPN Server: 103.144.200.13 | User:admin Passwd:Htag!VPNsE2021 | root-ssh-pw: Htag!VPNsE2021 | ssh-port: 9898


#!/bin/bash
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
iptables -F -t mangle
iptables -F -t nat
iptables -F
iptables -X
iptables -Z
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z
iptables --table nat -F
iptables --delete-chain
iptables --table nat --delete-chain
iptables -t mangle --delete-chain


iptables --table nat --append POSTROUTING --out-interface enp1s0 -j MASQUERADE
iptables -t nat -A PREROUTING -s 192.168.1.2 -i eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to 192.168.1.1

iptables -t nat -A POSTROUTING -o eth1 -j SNAT --to 192.168.20.1


iptables -t nat -A POSTROUTING -o enp1s0 -s 192.168.130.0/24 -p all -j SNAT --to 103.144.200.13



root@vrouter-vpn:~# cat /opt/vpn-fire-nat.sh
#!/bin/bash
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
iptables -F -t mangle
iptables -F -t nat
iptables -F
iptables -X
iptables -Z
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z
iptables --table nat -F
iptables --delete-chain
iptables --table nat --delete-chain
iptables -t mangle --delete-chain


#iptables --table nat --append POSTROUTING --out-interface enp1s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.168.172.0/24 -j SNAT --to 103.144.200.13
#iptables -t nat -A POSTROUTING -o enp1s0 -s 192.168.1.3 -j SNAT --to 10.1.1.9




zpool create \
    -o cachefile=/etc/zfs/zpool.cache \
    -o ashift=12 -o autotrim=on -d \
    -o feature@async_destroy=enabled \
    -o feature@bookmarks=enabled \
    -o feature@embedded_data=enabled \
    -o feature@empty_bpobj=enabled \
    -o feature@enabled_txg=enabled \
    -o feature@extensible_dataset=enabled \
    -o feature@filesystem_limits=enabled \
    -o feature@hole_birth=enabled \
    -o feature@large_blocks=enabled \
    -o feature@lz4_compress=enabled \
    -o feature@spacemap_histogram=enabled \
    -O acltype=posixacl -O canmount=off -O compression=lz4 \
    -O devices=off -O normalization=formD -O relatime=on -O xattr=sa \
    -O mountpoint=/boot -R /mnt \
    bpool ${DISK}-part3
    

zpool create \
    -o ashift=12 -o autotrim=on \
    -O acltype=posixacl -O canmount=off -O compression=lz4 \
    -O dnodesize=auto -O normalization=formD -O relatime=on \
    -O xattr=sa -O mountpoint=/ -R /mnt \
    rpool ${DISK}-part4






~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
https://firewalld.org/
https://www.answertopia.com/ubuntu/basic-ubuntu-firewall-configuration-with-firewalld/
https://computingforgeeks.com/install-and-use-firewalld-on-ubuntu-18-04-ubuntu-16-04/



sudo apt -y install firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --state
sudo ufw disable


sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
sudo firewall-cmd --list-services

sudo firewall-cmd --zone=public --permanent --add-port=5000/tcp
sudo firewall-cmd --zone=public --permanent --add-port=5900-5999/udp

sudo firewall-cmd --permanent --new-zone=myoffice
sudo firewall-cmd --reload
sudo firewall-cmd --zone=public --change-interface=eth0



 firewall-cmd --zone=external --query-masquerade
 firewall-cmd --zone=external --add-masquerade
 
 
sudo firewall-cmd --list-all
sudo firewall-cmd --get-services

sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --permanent --add-service={http,https} --permanent
sudo firewall-cmd --add-port=7070/tcp --permanent
sudo firewall-cmd --add-port=514/udp --permanent

sudo firewall-cmd --new-zone=myzone --permanent
sudo firewall-cmd --zone=myzone --add-port=4567/tcp --permanent
sudo firewall-cmd --set-default-zone=public --permanent


sudo firewall-cmd --get-zone-of-interface=eth0 --permanent
sudo firewall-cmd --zone=<zone> --add-interface=eth0 --permanent


sudo firewall-cmd --add-rich-rule 'rule family="ipv4" service name="ssh" source address="192.168.0.12/32" accept' --permanent
sudo firewall-cmd --add-rich-rule 'rule family="ipv4" service name="ssh" source address="10.1.1.0/24" accept' --permanent


sudo firewall-cmd --list-rich-rules


# Enable masquerading
sudo firewall-cmd --add-masquerade --permanent

# Port forward to a different port within same server ( 22 > 2022)
sudo firewall-cmd --add-forward-port=port=22:proto=tcp:toport=2022 --permanent

# Port forward to same port on a different server (local:22 > 192.168.2.10:22)
sudo firewall-cmd --add-forward-port=port=22:proto=tcp:toaddr=192.168.2.10 --permanent

# Port forward to different port on a different server (local:7071 > 10.50.142.37:9071)
sudo firewall-cmd --add-forward-port=port=7071:proto=tcp:toport=9071:toaddr=10.50.142.37 --permanent


Removing port/service
Replace --add with –-remove




https://superuser.com/questions/634469/need-iptables-rule-to-accept-all-incoming-traffic



iptables -I INPUT -j ACCEPT

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT -m comment --comment "Allow all loopback traffic"
iptables -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT -m comment --comment "Drop all traffic to 127 that doesn't use lo"
iptables -A OUTPUT -j ACCEPT -m comment --comment "Accept all outgoing"
iptables -A INPUT -j ACCEPT -m comment --comment "Accept all incoming"
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT -m comment --comment "Allow all incoming on established connections"
iptables -A INPUT -j REJECT -m comment --comment "Reject all incoming"
iptables -A FORWARD -j REJECT -m comment --comment "Reject all forwarded"


iptables -I INPUT -p tcp --dport 80 -j ACCEPT -m comment --comment "Allow HTTP"
iptables -I INPUT -p tcp --dport 443 -j ACCEPT -m comment --comment "Allow HTTPS"
iptables -I INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT -m comment --comment "Allow SSH"
iptables -I INPUT -p tcp --dport 8071:8079 -j ACCEPT -m comment --comment "Allow torrents"






iptables-save > /etc/network/iptables.rules #Or wherever your iptables.rules file is



Edit before.rules file:
### NAT ###
*nat
:PREROUTING ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-F

# Port Forwardings
-A PREROUTING -i vmbr0 -p tcp --dport 80 -j DNAT --to-destination 10.99.99.254
-A PREROUTING -i vmbr0 -p tcp --dport 443 -j DNAT --to-destination 10.99.99.254

# Forward traffic through eth0 - Change to match you out-interface
-A POSTROUTING -s 10.99.99.0/24 -o vmbr0 -j MASQUERADE

COMMIT
### EOF NAT ###

Run these commands after that:
sysctl -p
sysctl --system

ufw allow 22/tcp
ufw allow 8006/tcp
ufw enable
systemctl enable ufw

ufw default allow outgoing
ufw default allow forward


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~








~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# https://cpaelzer.github.io/blogs/009-microvm-in-ubuntu/

sudo qemu-system-x86_64-microvm \                      # reduced binary
  -M microvm \                                           # reduced machine type
  -bios /usr/share/qemu/bios-microvm.bin \               # faster bios
  -kernel /boot/vmlinuz-5.4.0-39-generic \               # no internal bootloader
  -append "earlyprintk=ttyS0 console=ttyS0,115200,8n1" \
  -enable-kvm -cpu host -m 1G -smp 1 -nodefaults -no-user-config \
  -nographic -serial mon:stdio	

$ qemu-system-x86_64 -M microvm \
   -enable-kvm -cpu host -m 512m -smp 2 \
   -kernel vmlinux -append "earlyprintk=ttyS0 console=ttyS0 root=/dev/vda" \
   -nodefaults -no-user-config -nographic \
   -serial stdio \
   -drive id=test,file=test.img,format=raw,if=none \
   -device virtio-blk-device,drive=test \
   -netdev tap,id=tap0,script=no,downscript=no \
   -device virtio-net-device,netdev=tap0
   

$ qemu-system-x86_64 \
   -M microvm,x-option-roms=off,pit=off,pic=off,isa-serial=off,rtc=off \
   -enable-kvm -cpu host -m 512m -smp 2 \
   -kernel vmlinux -append "console=hvc0 root=/dev/vda" \
   -nodefaults -no-user-config -nographic \
   -chardev stdio,id=virtiocon0 \
   -device virtio-serial-device \
   -device virtconsole,chardev=virtiocon0 \
   -drive id=test,file=test.img,format=raw,if=none \
   -device virtio-blk-device,drive=test \
   -netdev tap,id=tap0,script=no,downscript=no \
   -device virtio-net-device,netdev=tap0
   
   



cd /var/lib/lxc/debian8/rootfs/
tar -czvf /var/lib/vz/template/cache/my_debian8_template.tar.gz ./
pct create 100 /var/lib/vz/template/cache/my_debian8_template.tar.gz \
    -description LXC -hostname pvecontainer01 -memory 1024 -nameserver 8.8.8.8 \
    -net0 name=eth0,hwaddr=52:4A:5E:26:58:D8,ip=192.168.15.147/24,gw=192.168.15.1,bridge=vmbr0 \
    -storage local -password changeme

So thats what I did:
1. Created tar (tar -czvf ./ct.tar.gz /var/lib/lxd/containers/container1/rootfs)
2. Moved the tar to the proxmox host

3. Created a disk (Im using ZFS storage):
Code:
    zfs create storage/subvol-100-disk-0
    zfs set xattr=sa storage/subvol-100-disk-0
    zfs set acltype=posixacl storage/subvol-100-disk-0

4. Using pct created a container:
pct create 100 /ct.tar.gz -description container1 -hostname container1 -memory 1024 -nameserver 8.8.8.8 -storage storage -password changeme --rootfs storage:subvol-100-disk-0,quota=0

Container is created, no errors in logs.













root@glbox1:/opt# history |grep echo
  482  echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  504  history |grep echo
root@glbox1:/opt# 

 481  apt-get install acpi-support acpid acpi
  482  echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  483  cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  484  cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor




root@glbox1:~# cat /opt/pervalue 
perf_cpu_time_max_percent
    echo  0 > /proc/sys/kernel/perf_cpu_time_max_percent
echo  10000 > /proc/sys/kernel/perf_event_max_sample_rate



sudo sysctl -a |grep perf
kernel.perf_cpu_time_max_percent = 0
kernel.perf_event_max_contexts_per_stack = 8
kernel.perf_event_max_sample_rate = 1
kernel.perf_event_max_stack = 127
kernel.perf_event_mlock_kb = 516
kernel.perf_event_paranoid = -1


sysctl -w kernel.perf_cpu_time_max_percent=1
sysctl -w kernel.perf_event_max_sample_rate=10000




apt-get update
apt-get install acpi-support acpid acpi

#edit /etc/default/grub and add intel_pstate=disable to GRUB_CMDLINE_LINUX_DEFAULT
GRUB_CMDLINE_LINUX_DEFAULT="intel_pstate=disable"

update-grub

reboot


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~






   49  sudo a2dismod php7.4
   50  sudo a2dismod php8.1
   51  systemctl restart apache2
   52  sudo a2dismod mpm_prefork
   53  systemctl restart apache2
   54  journalctl -xe
   55  sudo a2enmod mpm_event proxy_fcgi setenvif
   56  systemctl restart apache2
   57  sudo a2enconf php8.1-fpm
   58  systemctl restart apache2
   59  cd /etc/apache2/sites-enabled/
   60  ls
   61  ll
   62  cd ..
   63  ls
   64  cd sites-available/
   65  ls
   66  a2ensite 000-default.conf
   67  systemctl reload apache2
   68  vim 000-default.conf
   69  systemctl reload apache2
   70  systemctl restart apache2
   71  cd
   72  history


