## Prometheus moniter configuration

**Update the server** 
```cmd
sudo yum update
```
**Install wget module**
```cmd
sudo yum install wget -y
```

**_Create user for prometheus_**

```cmd
sudo useradd --system --no-create-home --shell /usr/sbin/nologin prometheus
```
---

check user details
```cmd
cat /etc/passwd
```     
_go to Download dir_
```cmd
cd ~/Downloads
```
**Download prometheus form third repo**
```cmd
wget https://github.com/prometheus/prometheus/releases/download/v2.28.0/prometheus-2.28.0.linux-amd64.tar.gz
```
Check downloaded file
```
ls -ltrh
```
_extract the downloaded file_
```cmd
tar xvzf prometheus-2.28.0.linux-amd64.tar.gz
``` 

- move the prometheus-2.28.0.linux-amd64 directory to /opt/ directory and rename it to prometheus 
```cmd
sudo mv -v prometheus-2.28.0.linux-amd64 /opt/prometheus
```     
Change the user and group of all the files and directories of the /opt/prometheus/ directory to root
sudo chown -Rfv root:root /opt/prometheus
     
Fix the file and directory permissions of all the files and directories of the /opt/prometheus/ directory
      sudo chmod -Rfv 0755 /opt/prometheus
      
The configuration file of Prometheus is /opt/prometheus/prometheus.yml.
      sudo vim /opt/prometheus/prometheus.yml
        
(optional) If you want, you can remove the comment lines from the configuration file /opt/prometheus/prometheus.yml with the following command:

```cmd
egrep -v '(^[ ]*#)|(^$)' /opt/prometheus/prometheus.yml | sudo tee /opt/prometheus/prometheus.yml
```

* Prometheus needs a directory where it can store the metrics that it had collected. In this article, I will store it in the /opt/prometheus/data/ directory.

* create a new directory data/ in the /opt/prometheus/ directory as follows

```cmd
sudo mkdir -v /opt/prometheus/data
```

```cmd
sudo chown -Rfv prometheus:prometheus /opt/prometheus/data
```

```cmd
sudo vim /etc/systemd/system/prometheus.service
```

```cmd
sudo systemctl daemon-reload
```
```cmd
sudo systemctl start prometheus.service
sudo systemctl enable prometheus.service
sudo systemctl status prometheus.service
```

```cmd
hostname -I
ip a
cat /etc/hosts
```
```cmd
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
```
```bash
tar xzf node_exporter-1.1.2.linux-amd64.tar.gz
```
```sudo mv -v node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin/
sudo chown root:root /usr/local/bin/node_exporter
node_exporter --version
sudo vim /etc/systemd/system/node-exporter.servic
sudo systemctl daemon-reload 
sudo systemctl start node-exporter.service
sudo vim /etc/systemd/system/node-exporter.servic
sudo nano /etc/systemd/system/node-exporter.service
sudo vim /etc/systemd/system/node-exporter.service
sudo systemctl daemon-reload 
sudo systemctl start node-exporter.service
```
```cmd
cd /etc/
cd systemd/system/
ll
sudo rm node-exporter.servic
ll
```

```cmd
sudo systemctl status node-exporter.service 
sudo systemctl enable node-exporter.service
sudo systemctl status node-exporter.service 
```































