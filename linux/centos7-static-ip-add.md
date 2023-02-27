## Static IP Configuration on CentOS 7

**Network configuration on CentOS 7 **

_list network interfaces_

```cmd
ip a
```
_or_

```cmd
nmcli -p dev
```
_DHCP typical configuration_

```cmd
sudo vi /etc/sysconfig/network-scripts/ifcfg-enp0s3
```

_default config file_

```cfg
DEVICE="enp0s3"  #need to change
ONBOOT=yes     #need to change yes to no
NETBOOT=yes
UUID="41171a6f-bce1-44de-8a6e-cf5e782f8bd6"    #need to change
IPV6INIT=yes
BOOTPROTO=dhcp                                 #need to change dhcp to none
HWADDR="00:08:a2:0a:ba:b8"                     #need to change or command it
TYPE=Ethernet
NAME="enp0s3"                                    # name given
```

_**Configuration**_

_Configuring an eth0 or enp0s3 interface_


`For static IP configuration, update or edit`

```cmd
sudo vi /etc/sysconfig/network-scripts/ifcfg-eth0
```

```cfg
#HWADDR=00:08:A2:0A:BA:B8
TYPE=Ethernet
BOOTPROTO=none
# Server IP #
IPADDR=192.168.1.10       #give selected static ip for node
# Subnet #
PREFIX=24
# Set default gateway IP #
GATEWAY=192.168.1.1  #give selected default gateway ip for node
# Set dns servers #
DNS1=192.168.1.1  #gateway interface ip 
DNS2=8.8.8.8
DNS3=8.8.4.4
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
# Disable ipv6 #
IPV6INIT=no
NAME=bond
# This is system specific and can be created using 'uuidgen eth0' command #
UUID=9fe753d9-15e9-489c-890d-cc0f1e44cd8e   # use above command to get the UUID in same node
DEVICE=
ONBOOT=yes
```
_OR_
```cnf
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
IPADDR=192.168.1.11
PREFIX=24
GATEWAY=192.168.1.1
DNS1=192.168.1.1                       
DNS2=8.8.8.8
DNS3=8.8.4.4
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="enp0s3"
UUID="a42d62dc-fdc9-4214-9cc8-f47eb1ab5881"
DEVICE="enp0s3"
ONBOOT="no"
```

_change default cfg_

go to `vi /etc/sysconfig/network-scripts/ifcfg-enp0s3` file and change these options

```bash
ONBOOT=no
BOOTPROTO=none
```
- Save and close the file. The system will automatically calculate the network and broadcast address. 

_restart the network service using:_

```cmd
sudo systemctl restart network
```

_Verify the settings_

_New IP_

```bash
ip a
```

_New routing_

```bash
ip r

_DNS servers_

```cmd
cat /etc/resolv.conf
```

Second Method The second method for configuring eth0 interface is the use of Network Manager nmtui command is used:
```bash
nmtui edit eth0
```











































