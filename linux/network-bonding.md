# Network bonding configuration


**Bonding configuration type**

There are 7 types of Network Bonding:

* mode=0 (Balance Round Robin)
* mode=1 (Active backup) ⇒ Explained in this below section
* mode=2 (Balance XOR)
* mode=3 (Broadcast)
* mode=4 (802.3ad)
* mode=5 (Balance TLB)
* mode=6 (Balance ALB)

**Configure Bond0 Interface**

* In CentOS 7, the bonding module is not loaded by default. Enter the following command as root user to enable it.

```bash
modprobe --first-time bonding
```

* You can view the bonding module information using command:

```bash
modinfo bonding
```

login as root user now

```bash
sudo -i
```

**Create bond0 configuration file:**

```bash
vi /etc/sysconfig/network-scripts/ifcfg-bond0
```

- Add the following lines

```bash
DEVICE=bond0
NAME=bond0
TYPE=Bond
BONDING_MASTER=yes
IPADDR=192.168.1.150
PREFIX=24
ONBOOT=yes
BOOTPROTO=none
BONDING_OPTS="mode=1 miimon=100"
```

**activate the Network interfaces.**

```bash
ifup ifcfg-enp0s8
ifup ifcfg-enp0s9
```

* enter the following command to make Network Manager aware the changes.
```bash
nmcli con reload
```
* Restart network service to take effect the changes.

```bash
systemctl restart network
```

**Test Network Bonding**

- enter the following command to check whether the bonding interface bond0 is up and running:


```bash
cat /proc/net/bonding/bond0
```