#!/usr/bin/env bash
df -PkH | egrep -vE 'loop|tmpfs|Filesystem' | awk '{ print $5 " " $1 " " $6 }'  | while read output;
#df -PkH | egrep -vE 'loop|tmpfs|Filesystem' | awk '{ print $5 " " $1 }'  | while read output;
do
  used=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  mount_name=$(echo $output | awk '{ print $3 }' )
  if [ $used -ge 90 ]; then
      echo "Server Name     : $(hostname)"
      echo "Server IP       : $(hostname -I)"
      echo "Partiton Name   : $partition"
      echo "Mount Point     : $mount_name"
      echo "Partiton Usage  : $used%"
      echo "State           : Critical"
      echo " "
  elif [ $used -ge 80 ]; then
      echo "Server Name     : $(hostname)"
      echo "Server IP       : $(hostname -I)"
      echo "Partiton Name   : $partition"
      echo "Mount Point     : $mount_name"
      echo "Partiton Usage  : $used%"
      echo "State           : Warning Level - 2"
      echo " "
  elif [ $used -ge 70 ]; then
      echo "Server Name     : $(hostname)"
      echo "Server IP       : $(hostname -I)"
      echo "Partiton Name   : $partition"
      echo "Mount Point     : $mount_name"
      echo "Partiton Usage  : $used%"
      echo "State           : Warning Level - 1"
      echo " "
  fi
done
