#!/usr/bin/env bash
cpu=`top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}' | awk -F . '{print $1}'`
cpu_core=`grep -c ^processor /proc/cpuinfo`
cpu_precentage=`top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'`
if [ $cpu -gt 90 ]
then
    echo "server name: $(hostname)"
	echo "State      : Critical"
	echo "CPU core   : ($cpu_core core)"
	echo "CPU % usage: $cpu_precentage"
elif [ $cpu -gt 80 ]
then
    echo "server name: $(hostname)"
	echo "State      : Warning Level - 2"
	echo "CPU core   : ($cpu_core core)"
	echo "CPU % usage: $cpu_precentage"
elif [ $cpu -gt 70 ]
then
    echo "server name: $(hostname)"
	echo "State      : Warning Level - 1"
	echo "CPU core   : ($cpu_core core)"
	echo "CPU % usage: $cpu_precentage"
fi
