**Node exporter**


_Download Node Exporter_

```cmd
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-arm64.tar.gz
```

_Extract the Archive_

```cmd
tar xvfz node_exporter-1.6.1.linux-arm64.tar.gz
```
_User-creaion_

```cmd
sudo useradd -c "Monitoring user" -d /home/node_exporter -s /bin/false node_exporter
```

_Move Node Exporter Binary_

- [ ] By moving it to /usr/local/bin/, you ensure that Node Exporter is in your system's executable path
  
```cmd
sudo mv /home/ubuntu/Downloads/node_exporter-1.6.1.linux-amd64 /usr/local/bin/
```

_Set Permissions (Optional)_

```cmd
sudo chmod +x /usr/local/bin/node_exporter
```

**_Create a systemd Service Unit_**

```cmd
vim /etc/systemd/system/node_exporter.service
```

* Refe the systemd file from path here
https://github.com/rio-ke/workman/blob/main/prometheus/node_exporter/systemd_service.md

_Enable and Start Node Exporter Service_

```cmd
sudo systemctl daemon-reload
```

```cmd
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
```







