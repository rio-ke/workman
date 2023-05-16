#!/bin/bash
echo "cpu Usage Precentage $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')"
echo ""
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head
