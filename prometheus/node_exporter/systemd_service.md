```cnf
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter --web.listen-address="0.0.0.0:9100" --collector.cpu --collector.loadavg --collector.meminfo --collector.diskstats --collector.filesystem --collector.netdev --collector.tcpstat --collector.bonding --collector.systemd \
--collector.systemd.unit-whitelist="(sshd|httpd|node_exporter|vsftpd|crond|firewalld|rsyslog).service"

[Install]
WantedBy=multi-user.target
```
