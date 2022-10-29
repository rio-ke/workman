## Active-Passive cluster

change hostname to both server 

```bash
hostnamectl set-hostname node1
hostnamectl set-hostname node2
```
_restart the both nodes_

```bash
init 6 or #reboot
```

**_Host entry to both nodes_**

``` bash
vim /etc/hosts
```
|server|ip|host|
|---|-----|------|
|server1|192.168.0.1|node1|
|server2|192.168.0.2|node2|

_**Install packeges for drbd and cluster on both nodes**_

```bash
yum update -y
# install packages like httpd, drbd, pcs
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum install -y kmod-drbd84 drbd84-utils -y
yum install pacemaker pcs psmisc policycoreutils-python
yum install httpd -y
yum install vsftpd -y
```

**Allow ports through firewalld or Diseble the system firewall on both nodes**

**node1**
```bash
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.0.105" port port="7789" protocol="tcp" accept'
firewall-cmd --reload
```
**node2**
```bash
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.122.101" port port="7789" protocol="tcp" accept'
firewall-cmd --reload
```
## or 

_**disable the firewalld**_

```bash
systemctl stop firewalld
systemctl disable firewalld
```

_**Configure DRBD on both nodes**_

```bash 
vi /etc/drbd.d/clusterdb.res
```
 * give resource name `clusterdb`
 * change ipaddress on node1 and node2

```bash
resource clusterdb {
  protocol C;
  handlers {
    pri-on-incon-degr "/usr/lib/drbd/notify-pri-on-incon-degr.sh; /usr/lib/drbd/notifyemergency-reboot.sh; echo b > /proc/sysrq-trigger ; reboot -f";
    pri-lost-after-sb "/usr/lib/drbd/notify-pri-lost-after-sb.sh; /usr/lib/drbd/notifyemergency-reboot.sh; echo b > /proc/sysrq-trigger; reboot -f";
    local-io-error "/usr/lib/drbd/notify-io-error.sh; /usr/lib/drbd/notify-emergencyshutdown.sh; echo o > /proc/sysrq-trigger ; halt -f";
    fence-peer "/usr/lib/drbd/crm-fence-peer.sh";
    split-brain "/usr/lib/drbd/notify-split-brain.sh admin@acme.com";
    out-of-sync "/usr/lib/drbd/notify-out-of-sync.sh admin@acme.com";
  }
  startup {
    degr-wfc-timeout 120; # 2 minutes.
    outdated-wfc-timeout 2; # 2 seconds.
  }
  disk {
    on-io-error detach;
  }
  net {
   cram-hmac-alg "sha1";
   shared-secret "clusterdb";
   after-sb-0pri disconnect;
   after-sb-1pri disconnect;
   after-sb-2pri disconnect;
   rr-conflict disconnect;

  }
  syncer {
    rate 150M;
    # Also Linbit told me so personally.
    # The recommended range for this should be between 7 and 3833. The default value is 127
    al-extents 257;
    on-no-data-accessible io-error;
  }
  on node1 {
    device /dev/drbd0;
    disk /dev/sdb;
    address 192.168.0.105:7788;
    flexible-meta-disk internal;
  }
 on node2 {
    device /dev/drbd0;
    disk /dev/sdb;
    address 192.168.0.108:7788;
    meta-disk internal;
  }
}
```



















