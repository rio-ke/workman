#!/usr/bin/env bash
GenInfo(){

	echo "General information"
    echo "-------------------"
    echo " "
    echo "computer architecture       : `uname -m`"
    echo "The Linux Kernel            : `uname -r`"
    echo "Linux Distro                : `head -n1 /etc/issue | awk '{print $1 " " $2}'`"
    echo "Hostname                    : `hostname`"
    echo "Hostname IP                 : `hostname -I`"
    echo "System Uptime               : `uptime | awk '{ gsub(/,/, ""); print $3 }'`"
    echo "Run level                   : `runlevel`"
    echo "Number of Running Process   : `ps ax | wc -l`"
    echo "current user login name     : `whoami`"
    echo "number of user this computer: `users | wc -w` user "
    echo "               User         : `whoami` (uid:"$UID")"
    echo "               Groups       : `groups`"
    echo "               Working dir  : `pwd`"
    echo "               Home dir     : "$HOME""
    echo " "

	echo "CPU information"
    echo "---------------"
    echo " "
    echo "CPU core count              : `grep -c 'processor' /proc/cpuinfo` CPU"
    echo "CPU vendor                  : `awk -F':' '/^vendor_id/ { print $2 }' /proc/cpuinfo | head -n1`"
    echo "CPU Cache Size              : `awk -F':' '/^cache size/ { print $2 }' /proc/cpuinfo | head -n1`"
    echo "CPU model name              :"

    cat /proc/cpuinfo | grep "model name\|processor" | awk '/processor/{printf "  Processor:\t" $3 " : " }/model\ name/{
    i=4
    while(i<=NF){
	    printf $i
	    if(i<NF){
		    echo " "
	    }
	    i++
    }
    printf "\n"
    }'
    echo " "
    echo "CPU Speed                   :"
    echo "`awk -F':' '/^cpu MHz/ { print $2 }' /proc/cpuinfo`"
    echo " "

	echo "CPU Full Information"
    echo "--------------------"
    lscpu | grep -v Flags

    echo " "
	echo "Memory Information"
    echo "------------------"

    echo "`cat /proc/meminfo | grep Mem`"
    echo "`cat /proc/meminfo | grep -i swap`"

    echo " "
	echo "Top 5 memory eating process"
    echo "---------------------------"
	ps auxf | sort -nr -k 4 | head -5

    echo " "
	echo "DISK Information"
    echo "----------------"
    echo " "
    echo "File System Space:"
    echo "~~~~~~~~~~~~~~~~~~"
    df -Th
    echo " "
    echo "File System inode:"
    echo "~~~~~~~~~~~~~~~~~~"
    df -iTh | grep -v 'squashfs'
    echo " "

	echo "IP Addresses Information"
    echo "------------------------"
	ip -4 address show


    echo " "
	echo "Network routing"
    echo "----------------"
	netstat -nr

    echo " "
	echo "Interface traffic information"
    echo "-----------------------------"

	netstat -i
}
GenInfo > /tmp/node_info.txt

