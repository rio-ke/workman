### _Configure Prometheus, Grafana, and Node Exporter_

**_`Install Prometheus`_**

```cmd
wget https://github.com/prometheus/prometheus/releases/download/v2.49.0-rc.1/prometheus-2.49.0-rc.1.linux-amd64.tar.gz
tar xvfz prometheus-*.tar.gz
sudo mkdir /etc/prometheus /var/lib/prometheus
cd prometheus-2.37.6.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo mv consoles/ console_libraries/ /etc/prometheus/
```
_`Prometheus user config`_

```cmd
sudo useradd -rs /bin/false prometheus
sudo chown -R prometheus: /etc/prometheus /var/lib/prometheus
```

_`Configure Prometheus systemd service`_

```cmd
sudo vim /etc/systemd/system/prometheus.service
```
```service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090 \
    --web.enable-lifecycle \
    --log.level=info

[Install]
WantedBy=multi-user.target
```
```cmd
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus
```
_check config_

```cmd
ss -tulpn | grep 9090
curl -i http://localhost:9090/status
```

`_**Configure Node Exporter in remote server**_`

```cmd
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar -xvfz node_exporter-*.tar.gz
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin
node_exporter
sudo useradd -rs /bin/false node_exporter
```
```cmd
sudo vim /etc/systemd/system/node_exporter.service
```
```service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
  # for local server node expoter
ExecStart=/usr/local/bin/node_exporter
  # For aws other server node exporter services
#ExecStart=/usr/local/bin/node_exporter --web.listen-address=0.0.0.0:9100 --collector.textfile --collector.diskstats --collector.filesystem --collector.loadavg --collector.node-meta

[Install]
WantedBy=multi-user.target
```
```cmd
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter
```
_To add remote-server to prometheus.yml_

```cmd
sudo vi /etc/prometheus/prometheus.yml
```
```yml
- job_name: "riok_server"
  scrape_interval: 10s
  static_configs:
    - targets: ["remote-aws_pub_ip:9100"]
```
```cmd
sudo systemctl restart prometheus.service
```

**`_Grafana_`**

```cmd
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_10.0.2_amd64.deb
sudo dpkg -i grafana_10.0.2_amd64.deb
sudo /bin/systemctl start grafana-server
```
_Login and change password_

```bash
http://pub_ip:3000
```
* To create a Prometheus data source in Grafana
  - Open the Configuration menu.
  - Click on “Data Sources”.
  - Click on “Add data source”.
  - Select “Prometheus” as the type.
  - In setting http use private ip for better 
  - Set the appropriate Prometheus server URL 
  -  for example
      - http://public_ipv4_address:9090/
      - http://localhost:9090/
      - http://localhost:9090/ 
      - Save & Exit.
* import the pre-built dashboard   
   - Go to /dashboards and select New > Import
   -  give 1860 in import via grafana.com
   - Load and select the Prometheus data source. Finally, Import

   
**`Alert manager use url below`**

```url
https://github.com/januo-org/proof-of-concepts/blob/main/prometheus/alert-manager.md
```
