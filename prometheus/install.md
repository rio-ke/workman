    sudo yum update
     
    sudo yum install wget -y
     
    sudo useradd --system --no-create-home --shell /usr/sbin/nologin prometheus
     
    cat /etc/passwd
     
   cd ~/Downloads
     
   wget https://github.com/prometheus/prometheus/releases/download/v2.28.0/prometheus-2.28.0.linux-amd64.tar.gz
  ll

tar xvzf prometheus-2.28.0.linux-amd64.tar.gz
  ll
   move the prometheus-2.28.0.linux-amd64 directory to /opt/ directory and rename it to prometheus 
     sudo mv -v prometheus-2.28.0.linux-amd64 /opt/prometheus
     
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

Prometheus needs a directory where it can store the metrics that it had collected. In this article, I will store it in the /opt/prometheus/data/ directory.

So, create a new directory data/ in the /opt/prometheus/ directory as follows

sudo mkdir -v /opt/prometheus/data

sudo chown -Rfv prometheus:prometheus /opt/prometheus/data
  sudo vim /etc/systemd/system/prometheus.service
   sudo systemctl daemon-reload
   sudo systemctl start prometheus.service
   sudo systemctl enable prometheus.service
   sudo systemctl status prometheus.service
   hostname -I
   ip a
   cat /etc/hosts
   wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
   ll
   tar xzf node_exporter-1.1.2.linux-amd64.tar.gz
   ll
   sudo mv -v node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin/
   sudo chown root:root /usr/local/bin/node_exporter
   node_exporter --version
  sudo vim /etc/systemd/system/node-exporter.servic
    sudo systemctl daemon-reload 
    sudo systemctl start node-exporter.service
    sudo vim /etc/systemd/system/node-exporter.servic
    $ sudo nano /etc/systemd/system/node-exporter.service
    sudo vim /etc/systemd/system/node-exporter.service
    sudo systemctl daemon-reload 
    sudo systemctl start node-exporter.service
    cd /etc/
    cd systemd/system/
    ll
     sudo rm node-exporter.servic
     ll
     sudo systemctl status node-exporter.service 
     sudo systemctl enable node-exporter.service
     sudo systemctl status node-exporter.service 
































