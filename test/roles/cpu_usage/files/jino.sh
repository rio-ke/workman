#!/bin/bash
echo "CPU Usage Details"
echo "--------------------"
echo ""
echo "Load Average: $(cat /proc/loadavg | awk '{print $1 " " $2 " " $3}')"
echo ""
echo "cpu Usage Precentage: $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')"
echo ""
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head
