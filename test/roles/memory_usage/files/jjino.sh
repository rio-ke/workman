#!/bin/bash
memory=`free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }' | awk -F . '{print $1}'`
memory_precentage=`free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'`

if [ $memory -gt 3 ];
then
    echo "server name : $(hostname)"
    echo "State       : Critical"
    echo "Usage       : $memory_precentage"
elif [ $memory -gt 80 ];
then
    echo "server name : $(hostname)"
    echo "State       : Warning level - 2"
    echo "Usage       : $memory_precentage"
elif [ $memory -gt 70 ];
then
    echo "server name : $(hostname)"
    echo "State       : Warning level - 1"
    echo "Usage       : $memory_precentage"
fi
