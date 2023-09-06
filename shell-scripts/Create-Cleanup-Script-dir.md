**Create a Cleanup Script**

```bash
#!/bin/bash

# Set the threshold for disk usage (e.g., 90%)
threshold=90

# Get the current disk usage percentage for the root filesystem
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)

# Check if disk usage exceeds the threshold
if [ "$disk_usage" -ge "$threshold" ]; then
    echo "Disk usage exceeded $threshold% - Cleaning /tmp"
    find /tmp -type f -delete
else
    echo "Disk usage is below $threshold% - No action needed"
fi
```
```cmd
chmod +x cleanup_tmp.sh
```

**Schedule the Cleanup Script:**

```cmd
crontab -e
```
* Add a line to schedule the script to run, for example, every hour:
```cnf
0 * * * * /path/to/cleanup_tmp.sh
```





```
