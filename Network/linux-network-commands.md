# Basic Linux networking commands

```cmd
ifconfig eth0
```
```cmd
ip add
```

* To avoid the reverse DNS lookup, add -n in the command syntax.
```cmd
traceroute -n google.com
```

```cmd
tracepath google.in
```

* To limit the number of pockets
```cmd
ping -c google.in or ip add
```
```cmd
netstat -p
```
```cmd
ss -t4 state established
ss dst 192.168.xxx.xxx
```
```cmd
dig google.in
```
```cmd
nslookup 
```
```cmd
route -n
```
```cmd
host
```
```cmd
arp -n
```
```cmd
iwconfig 
```
```cmd
hostname 
```
```cmd
curl 
```
```cmd
wget 
```
```cmd
mtr 
```
```cmd
whois
```
```cmd
ifplugstatus
```
```cmd
iftop
```
```cmd
tcpdum
```
