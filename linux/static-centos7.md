_To list network interfaces_

```cmd
nmcli -p dev
```
```cmd
vim /etc/sysconfig/network-scripts/ifcfg-eth0
```
```conf
TYPE=Ethernet
BOOTPROTO=none
# Server IP #
IPADDR=192.168.1.9
# Subnet #
PREFIX=24
# Set default gateway IP #
GATEWAY=192.168.1.9
# Set dns servers #
DNS1=192.168.1.9
DNS2=8.8.8.8
DNS3=8.8.4.4
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
# Disable ipv6 #
IPV6INIT=no
NAME=enp0s3
# This is system specific and can be created using 'uuidgen eth0' command #
UUID="c9d7b3c1-dd03-4eae-bd8b-a357c9f4cf22"
DEVICE=enp0s3
ONBOOT=yes
```
```cmd
systemctl restart network
```

