# Configure SSL VPN client in Ubuntu using OpenVPN


**Configuring the SSL VPN on Ubuntu**

Follow these steps to configure SSL VPN Client in Ubuntu:
 
1.Sign in to Sophos Firewall's User Portal by browsing to https://<WAN IP address of Sophos>:443 
  
2. Go to SSL VPN.
  
3. Click Download Configuration for Other OSs.
  
`A compressed file named .ovpn is downloaded.`
  
4.Go to where the ovpn file was downloaded and execute the following command: 
  
```cmd 
sudo openvpn --config kendanic__ssl_vpn_config.ovpn
```
5. Enter the username and password.
