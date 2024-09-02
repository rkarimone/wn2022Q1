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

systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
systemctl status wg-quick@wg0


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







################## WindowsWireguardWatchdog ###########################################
### https://github.com/irmo-de/WindowsWireguardWatchdog?tab=readme-ov-file

This PowerShell script allows you to monitor the connectivity to a specific IP address and restart the `WireGuardTunnel$wg0` service if the ping fails.

// Script Overview //
The script performs the following tasks:

- Defines the target host IP address and the ping interval.
- Implements a function to ping the target host.
- Implements a function to restart the WireGuard service.
- Loops indefinitely, pinging the target host at the specified interval.
- If the ping fails, the script logs an error and restarts the WireGuard service.
- The script continues to monitor and repeat the process until manually stopped.



// Installation Steps //
// To install the PowerShell script as a Windows service using NSSM: //

- Download NSSM (Non-Sucking Service Manager) from the official repository: https://nssm.cc/download | (https://nssm.cc/builds)
	Extract as : C:\nssm\win64
- Extract the downloaded ZIP file and navigate to the extracted directory.
- Open a command prompt with administrator privileges and navigate to the NSSM directory.
- Run the following command to install the PowerShell script as a Windows service:

cd C:\nssm\win64
./nssm.exe install WireGuardService "powershell.exe" "-ExecutionPolicy Bypass -File C:\nssm\win64\keep_wg0_up.ps1"

{ Replace C:\path\to\your\script.ps1 with the actual path to your PowerShell script. } 


// Edit/Create File - C:\nssm\win64\keep_wg0_up.ps1 //
// Modify the following variables to match your setup //
 
$TargetHost = "172.16.198.1"
$PingInterval = 2 * 60  # 2 minutes in seconds

function Ping-Host {
    param (
        [string]$Hostname
    )

    $pingResult = Test-Connection -ComputerName $Hostname -Count 1 -Quiet
    return $pingResult
}

function Restart-WireGuardService {
    # Restart WireGuard service
	# $serviceName = "WireGuardTunnel`$wg0"
    $serviceName = 'WireGuardTunnel$wg0'
    Restart-Service -Name $serviceName
}

while ($true) {
    if (!(Ping-Host -Hostname $TargetHost)) {
        Write-Host "Ping failed. Restarting WireGuard service..."
        Restart-WireGuardService
    }
    else {
        Write-Host "Ping successful."
    }

    Start-Sleep -Seconds $PingInterval
}





// To modify the target IP address for pinging, update the keep_alive.ps1 script: //


$TargetHost = "192.168.178.1"
$PingInterval = 5 * 60  # 5 minutes in seconds

[ Note: The IP address should be inside your WireGuard network. ]

nssm.exe edit WireGuardService
nssm.exe start WireGuardService


// Conclusion: ///

This script provides a convenient way to monitor the connectivity to a specific IP address and automatically restart the WireGuard service in case of failure. 
By installing it as a Windows service using NSSM, you can ensure continuous monitoring and automatic recovery without manual intervention.

Feel free to modify and customize the script as per your specific requirements.


################## WindowsWireguardWatchdog ###########################################

