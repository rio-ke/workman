## Configuring Static IP address on Ubuntu Server 

_Adding static ip link with ymal configuration_

- The first step toward setting up a static IP address is identifying the name of the ethernet interface you want to configure.

_To check_ip:_ 

```cmd
ip link
```

The command prints a list of all the available network interfaces. In this example, the name of the interface is `ens3`:

```txt
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:6c:13:63 brd ff:ff:ff:ff:ff:ff
```

- Netplan configuration files are stored in the /etc/netplan directory. You’ll probably find one or more YAML files in this directory. The name of the file may differ from setup to setup. Usually, the file is named either 01-netcfg.yaml, 50-cloud-init.yaml, or NN_interfaceName.yaml, but in your system it may be different.

- If your Ubuntu cloud instance is provisioned with cloud-init, you’ll need to disable it


_if your Ubuntu cloud instance is provisioned with cloud-init, you’ll need to disable it. To do so create the following file:_

```cmd
sudo vim /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
```
_Add below line in the `99-disable-network-config.cfg`_

```cnf
network: {config: disabled}
```

_To assign a static IP address on the network interface, open the YAML configuration file with your text editor 📗_

```cmd
sudo vim /etc/netplan/01-netcfg.yaml
```

* Each Netplan Yaml file starts with the network key that has at least two required elements. The first required element is the version of the network configuration format, and the second one is the device type. The device type can be ethernets, bonds, bridges, or vlans.


* The configuration above also has a line that shows the renderer type. Out of the box, if you installed Ubuntu in server mode, the renderer is configured to use networkd as the back end.

* Under the device’s type (ethernets), you can specify one or more network interfaces. In this example, we have only one interface ens3 that is configured to obtain IP addressing from a DHCP server dhcp4: yes.

* To assign a static IP address to ens3 interface, edit the file as follows:

1. Set DHCP to dhcp4: no.

2. Specify the static IP address. Under addresses: you can add one or more IPv4 or IPv6 IP addresses that will be assigned to the network interface.

3. Specify the gateway.

4. Under nameservers, set the IP addresses of the nameservers.

```yml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens3:
      dhcp4: yes

```


```yml

network:
  version: 2
  renderer: networkd
  ethernets:
    ens3:       # interface is if wifi [wlp2s0] if virBox [enp0s3]
      dhcp4: no
      addresses:
        - 192.168.XX.XXX/24
      gateway4: 192.168.XXX.XXX
      nameservers:
          addresses: [8.8.8.8, 1.1.1.1]

```

_service netplan_

```cmd
sudo netplan apply
```

_Verify the ip address changes_

```cmd 
ip add
```


















