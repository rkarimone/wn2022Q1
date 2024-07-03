

sudo apt update
sudo apt full-upgrade
sudo apt install build-essential wget -y

#sudo ethtool -K eth4 tx off rx off sg off tso off
#sudo ethtool --offload eth0  rx off  tx off

# https://michael.mulqueen.me.uk/2018/08/disable-offloading-netplan-ubuntu/
# https://docs.openstack.org/developer/performance-docs/test_plans/hardware_features/hardware_offloads/plan.html
sudo ethtool -K eth4 tx off rx off sg off tso off
sudo ethtool -K eth3 tx off rx off sg off tso off
sudo ethtool -K eth2 tx off rx off sg off tso off
sudo ethtool -K eth1 tx off rx off sg off tso off
sudo ethtool -K eth0 tx off rx off sg off tso off


sudo ethtool -K xenbr0 tx off rx off sg off tso off
sudo ethtool -K xenbr1 tx off rx off sg off tso off
sudo ethtool -K xenbr2 tx off rx off sg off tso off
sudo ethtool -K xenbr3 tx off rx off sg off tso off
sudo ethtool -K xenbr4 tx off rx off sg off tso off


rx - receive (RX) checksumming
tx - transmit (TX) checksumming
sg - scatter-gather
tso - TCP segmentation offload
ufo - UDP fragmentation offload
gso - generic segmentation offload
gro - generic receive offload
lro - large receive offload
rxvlan - receive (RX) VLAN acceleration
txvlan - transmit (TX) VLAN acceleration
ntuple - receive (RX) ntuple filters and actions
rxhash - receive hashing offload

ethtool -k em1
ethtool -S eth0 | egrep 'miss|over|drop|lost|fifo'
ethtool -g eth0
ethtool -c
echo "3000" > limit_max
ethtool -K eth0 tso off gso off






cd /usr/src/

wget http://119.15.159.166:8443/Software/SoftEtherV4.34/softether-vpnserver-v4.34-9745-rtm-2020.04.05-linux-x64-64bit.tar.gz
tar zxvf softether-vpnserver-v4.34-9745-rtm-2020.04.05-linux-x64-64bit.tar.gz

cd vpnserver/

make		; agree to all Q by #1
cd ..
mv vpnserver /usr/local/
cd /usr/local/vpnserver/

chmod 600 *
chmod 700 vpnserver
chmod 700 vpncmd

vim /etc/init.d/vpnserver

#!/bin/sh
# chkconfig: 2345 99 01
# description: SoftEther VPN Server
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x $DAEMON || exit 0
case "$1" in
        start)
                $DAEMON start
                touch $LOCK
                ;;
        stop)
                $DAEMON stop
                rm $LOCK
                ;;
        restart)
                $DAEMON stop
                sleep 3
                $DAEMON start
                ;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0



chmod +x /etc/init.d/vpnserver
mkdir /var/lock/subsys
/etc/init.d/vpnserver start
update-rc.d vpnserver defaults



################################################## RUN AT START THE SERVER

sudo vim /etc/network/if-up.d/rc.local.sh

#!/bin/bash
sleep 240
/etc/init.d/vpnserver start
sleep 5
/etc/init.d/vpnserver restart

// "Save+Exit"

sudo vim /etc/network/if-up.d/rc.local.run.sh
#!/bin/bash
nohup /etc/network/if-up.d/rc.local.sh &

// "Save+Exit"

sudo chmod +x /etc/network/if-up.d/rc.local.*

sudo vim /etc/network/interfaces        ; add the following line at the end of file
post-up /etc/network/if-up.d/rc.local.run.sh

// "Save+Exit"


##################################### END SERVER #########################################





##################################### START VPN BRIDGE CLINET ############################


apt install build-essential wget -y
cd /usr/src/
wget -c http://119.15.159.166:8443/Software/SoftEtherV4.34/softether-vpnbridge-v4.34-9745-rtm-2020.04.05-linux-x64-64bit.tar.gz
tar zxvf softether-vpnbridge-v4.34-9745-rtm-2020.04.05-linux-x64-64bit.tar.gz

cd vpnbridge/
make
cd ..
mv vpnbridge /usr/local/
cd /usr/local/vpnbridge/

chmod 600 *
chmod 700 vpnbridge
chmod 700 vpncmd

sudo vim /etc/init.d/vpnbridge
#!/bin/sh
# chkconfig: 2345 99 01
# description: SoftEther VPN Server
DAEMON=/usr/local/vpnbridge/vpnbridge
LOCK=/var/lock/subsys/vpnbridge
test -x $DAEMON || exit 0
case "$1" in
	start)
		$DAEMON start
		touch $LOCK
		;;
	stop)
		$DAEMON stop
		rm $LOCK
		;;
	restart)
		$DAEMON stop
	sleep 3
	$DAEMON start
	;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0

chmod +x /etc/init.d/vpnbridge
update-rc.d vpnbridge defaults

mkdir /var/lock/subsys
/etc/init.d/vpnbridge start
/etc/init.d/vpnbridge restart





################################################## RUN AT START THE SERVER

sudo vim /etc/network/if-up.d/rc.local.sh

#!/bin/bash
sleep 240
/etc/init.d/vpnbridge start
sleep 5
/etc/init.d/vpnbridge restart

// "Save+Exit"

sudo vim /etc/network/if-up.d/rc.local.run.sh
#!/bin/bash
nohup /etc/network/if-up.d/rc.local.sh &

// "Save+Exit"

sudo chmod +x /etc/network/if-up.d/rc.local.*

sudo vim /etc/network/interfaces        ; add the following line at the end of file
post-up /etc/network/if-up.d/rc.local.run.sh

// "Save+Exit"






##############2024 #################
# https://operavps.com/docs/install-softether-vpn-on-ubuntu/
# https://www.linuxbabe.com/ubuntu/set-up-softether-vpn-server



apt-get update –y
apt-get install build-essential gnupg2 gcc make –y

wget https://www.softether-download.com/files/softether/v4.42-9798-rtm-2023.06.30-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.42-9798-rtm-2023.06.30-linux-x64-64bit.tar.gz
tar xvf softether-vpnserver-*.tar.gz
cd vpnserver/

sudo apt install gcc binutils gzip libreadline-dev libssl-dev libncurses5-dev libncursesw5-dev libpthread-stubs0-dev
make


cd ..
sudo mv vpnserver /opt/softether
sudo /opt/softether/vpnserver start
sudo /opt/softether/vpnserver stop



sudo nano /etc/systemd/system/softether-vpnserver.service

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


sudo systemctl start softether-vpnserver
sudo systemctl enable softether-vpnserver
systemctl status softether-vpnserver


sudo journalctl -eu softether-vpnserver
sudo  ss -lnptu | grep vpnserver

sudo ufw allow 80,443,992,1194,555/tcp
sudo ufw allow 1194,51612,53400,56452,40085/udp

ufw reload



/opt/softether/vpncmd

Hub DEFAULT
UserCreate username

UserPasswordSet username

SecureNatEnable

DhcpSet
exit


##############2024 #################



# https://www.linuxbabe.com/ubuntu/set-up-softether-vpn-server

wget https://www.softether-download.com/files/softether/v4.41-9787-rtm-2023.03.14-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.41-9787-rtm-2023.03.14-linux-x64-64bit.tar.gz

tar xvf softether-vpnserver-*.tar.gz
cd vpnserver/
sudo apt install gcc binutils gzip libreadline-dev libssl-dev libncurses5-dev libncursesw5-dev libpthread-stubs0-dev

make
cd ..
sudo mv vpnserver /opt/softether

sudo /opt/softether/vpnserver start
sudo /opt/softether/vpnserver stop


sudo nano /etc/systemd/system/softether-vpnserver.service

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


sudo systemctl start softether-vpnserver
sudo systemctl enable softether-vpnserver
systemctl status softether-vpnserver


sudo journalctl -eu softether-vpnserver
sudo  ss -lnptu | grep vpnserver

sudo ufw allow 80,443,992,1194,555/tcp
sudo ufw allow 1194,51612,53400,56452,40085/udp


/opt/softether/vpncmd




network:
    ethernets:
        enp3s0:
            dhcp4: false
            addresses: [192.168.1.19/22]
            gateway4: 192.168.1.1
            nameservers:
              addresses: [8.8.8.8,8.8.4.4,192.168.1.1]
    version: 2


    





##############2024 #################


*How disable the file transfer between the host machine and windows virtual machine*


With Windows Server, you can disable File Transfer through RDP by managing the 'Remote Desktop Session Host' properties - This will be through Group Policy.

In Windows, search for 'Edit Group Policy'
In the Local Group Policy Editor, navigate to 'Computer Configuration' > 'Administrative Templates' > 'Windows Components' > 'Remote Desktop Services' > 'Remote Desktop Session Host' > 'Device and Resource Redirection'.
Then set 'Do not allow Clipboard redirection' to 'Enabled'. You can also set 'Do not allow drive redirection' to 'Enabled' if you want to prevent the Virtual Machine from accessing local drives.



