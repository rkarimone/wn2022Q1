[Interface]
Address = 172.16.180.9/23
PrivateKey = XYZ

[Peer]
PublicKey = YXZ
PresharedKey = ZXY
AllowedIPs = 172.16.180.0/23
Endpoint = 123.duisho.dosh.1chabbis:8443
PersistentKeepalive = 25



sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
sudo systemctl status wg-quick@wg0


sudo systemctl restart wg-quick@wg0

sudo wg
sudo ip a show wg0





sudo vim /usr/bin/wg0-check.sh


#!/bin/bash
count=$(ping -c 10 -i 0.2 172.16.180.1 | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }');
if [ $count -eq 0 ]; then
 nohup /usr/bin/wg0-reset.sh &
 exit 0;
fi


sudo vim /usr/bin/wg0-reset.sh
#!/bin/bash
sudo systemctl restart wg-quick@wg0


chmod +x /usr/bin/wg0*

sudo vim /etc/crontab
*/5 * * * * root  wg0-check.sh


