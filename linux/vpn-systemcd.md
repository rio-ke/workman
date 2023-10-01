## systemd-service.md

This is only applicable for `linux` and `firewall` administrators.


create the folder under `/etc` folder

```bash
mkdir -p /etc/vpn/rits/
# copy the ssl vpn certificate file
cp pandi.conf /etc/vpn/rits/pandi.conf
echo "username" | sudo tee /etc/vpn/rits/rits.txt
echo "password" | sudo tee -a /etc/vpn/rits/rits.txt
```

_create the systemd service_

`vim /etc/systemd/system/rits-vpn.service`

```bash
[Unit]
Description=rits-vpn service
After=syslog.target network.target

[Service]
Type=simple
# Type=forking

ExecStart=sudo openvpn --config /etc/vpn/rits/pandi.conf --auth-user-pass /etc/vpn/rits/rits.txt
ExecStop=kill -9 $(pidof openvpn)

User=root
Group=root
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target

```

_systemd service_

```bash
sudo systemctl daemon-reload 
sudo systemctl start rits-vpn.service
sudo systemctl status rits-vpn.service
```
stop systemd service

```bash
sudo systemctl stop rits-vpn.service
```

