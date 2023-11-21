## Install Node exporter in Ubuntu server

```cmd
sh node-exporter.sh
```
```bash
#!/bin/bash

sudo apt-get update
sudo apt-get install prometheus-node-exporter -y
sudo systemctl status prometheus-node-exporter
```
