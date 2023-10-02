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

```bash
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter --web.listen-address="0.0.0.0:9100" --collector.cpu --collector.loadavg --collector.meminfo --collector.diskstats --collector.filesystem --collector.netdev --collector.tcpstat --collector.bonding --collector.systemd \
--collector.systemd.unit-whitelist="(sshd|httpd|node_exporter|vsftpd|crond|firewalld|rsyslog).service" \
--collector.logind \
--collector.filesystem.ignored-mount-points "^(/snap/|/run/|/dev/|/sys|/run).*" \
--collector.netdev.ignored-devices "^lo.*"

[Install]
WantedBy=multi-user.target
```
```bash
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter --web.listen-address="0.0.0.0:9100" --collector.cpu --collector.loadavg --collector.meminfo --collector.diskstats --collector.filesystem --collector.netdev --collector.tcpstat --collector.bonding --collector.systemd \
--collector.systemd.unit-whitelist="(sshd|httpd|node_exporter|vsftpd|crond|firewalld|rsyslog).service" \
--collector.logind \
--collector.filesystem.ignored-mount-points "^(/snap/|/run/|/dev/|/sys|/run).*" \
--collector.netdev.ignored-devices "^lo.*" \
--collector.ipvs \
--collector.drbd

[Install]
WantedBy=multi-user.target
```

```bash
[Unit]
Description=Prometheus node exporter
After=network.target auditd.service

[Service]
User=prometheus
ExecStart=/usr/local/bin/node_exporter \
--web.listen-address=0.0.0.0:9100 \
--collector.tcpstat \
--collector.bonding \
--collector.systemd --collector.systemd.unit-whitelist=(sshd|httpd|crond|node_exporter|vsftpd|mysqld|firewalld|rsyslog).service \
--collector.meminfo_numa \
--collector.logind \
--collector.filesystem.ignored-mount-points "^(/snap/|/run/|/dev/|/sys|/run).*" \
--collector.netdev.ignored-devices "^lo.*" \
--no-collector.wifi \
--no-collector.nfs \
--no-collector.zfs \
--no-collector.nfsd  \
--no-collector.mdadm \
--no-collector.arp \
--no-collector.bcache \
--no-collector.buddyinfo \
--no-collector.edac \
--no-collector.hwmon \
--no-collector.qdisc \
--no-collector.infiniband \
--no-collector.entropy \
--collector.ipvs \
--collector.drbd

Restart=on-failure
StandardOutput=syslog
StandardError=syslog

[Install]
WantedBy=default.target
```
