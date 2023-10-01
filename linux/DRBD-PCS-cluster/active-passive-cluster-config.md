* we don't restart or stop httpd and mysql service in drbd pcs cluster
* we have check and give correct partition `like disk /dev/sdb;` in drbd conf file

* once mysql resources started we can't change the my.cnf file we have cp my.cnf my.cnf.backup and edit my.cnf


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

```bash
vim /etc/hosts
```

| server  | ip          | host  |
| ------- | ----------- | ----- |
| server1 | 192.168.0.1 | node1 |
| server2 | 192.168.0.2 | node2 |

```bash
cat <<EOF >> /etc/hosts
192.168.1.10 node1
192.168.1.11 node2
EOF
```

_**Install packeges for drbd and cluster on both nodes**_

```cmd
yum update -y
```

_install packages like httpd, drbd, pcs, vim_

```bash
yum install httpd -y
yum install vim -y
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum install -y kmod-drbd84 drbd84-utils -y
yum install pacemaker pcs psmisc policycoreutils-python -y
rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum install mod_ssl openssl php55w php55w-common php55w-mbstring php55w-xml  php55w-mysqlnd php55w-gd php55w-mcrypt php55w-pdo php55w-curl php55w-cli php55w-opcache -y

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

_disble the selinux on both nodes_

```bash
setenforce 0
```

**_Enable the server status for httpd server_**

- For `webserver and webdata` pcs resource error we have to change document-root path in httpd.conf and cleanup the webserver pcs resource

```bash
cat <<EOF >> /etc/httpd/conf.d/status.conf
<Location /server-status>
    SetHandler server-status
    Require local
</Location>
EOF
```

_**Configure DRBD on both nodes**_

```bash
vi /etc/drbd.d/clusterdb.res
```

- give resource name `clusterdb`
- change ipaddress on node1 and node2

```bash
resource clusterdb {
  protocol C;
  handlers {
    pri-on-incon-degr "/usr/lib/drbd/notify-pri-on-incon-degr.sh; /usr/lib/drbd/notifyemergency-reboot.sh; echo b > /proc/sysrq-trigger ; reboot -f";
    pri-lost-after-sb "/usr/lib/drbd/notify-pri-lost-after-sb.sh; /usr/lib/drbd/notifyemergency-reboot.sh; echo b > /proc/sysrq-trigger; reboot -f";
    local-io-error "/usr/lib/drbd/notify-io-error.sh; /usr/lib/drbd/notify-emergencyshutdown.sh; echo o > /proc/sysrq-trigger ; halt -f";
    fence-peer "/usr/lib/drbd/crm-fence-peer.sh";
    # split-brain "/usr/lib/drbd/notify-split-brain.sh admin@acme.com";
    split-brain "/usr/lib/drbd/notify-split-brain.sh root";
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
  on node1 { #insted node1-2 hostname
    device /dev/drbd0;
    disk /dev/sdb;
    address 192.168.1.150:7788;
    flexible-meta-disk internal;
  }
 on node2 {
    device /dev/drbd0;
    disk /dev/sdb;
    address 192.168.1.151:7788;
    meta-disk internal;
  }
}

```

_**prepare the drbd setup both node1 and node2**_

```bash
drbdadm create-md clusterdb
drbdadm up clusterdb
systemctl start drbd
systemctl enable drbd
systemctl status drbd
```

**initiate the cluster on node1**

```bash
drbdadm -- --overwrite-data-of-peer primary clusterdb
```

_**check the drbd sync status both node1 and node2**_

```bash
 cat /proc/drbd
```

_**create the folder both node1 and node2**_

```bash
mkdir /drbd-webdata
mkdir /drbd-dbdata
```

**_lvm configuration change both node1 and node2_**

```bash
vim /etc/lvm/lvm.conf
add : filter = [ "r|/dev/sdb|", "r|/dev/disk/*|", "r|/dev/block/*|", "a|.*|" ]      # near 128 line
edit: write_cache_state = 1 to write_cache_state = 0                                # near 170 line
edit: use_lvmetad = 1 to  use_lvmetad = 0                                           # near 959 line
```

**_update the lvm configuration on node1 and node2_**

```bash
lvmconf --enable-halvm --services --startstopservices
dracut -H -f /boot/initramfs-$(uname -r).img $(uname -r)
reboot
```

**_reconnect both node1 and node2_**

```bash
setenforce 0
cat /proc/drbd
systemctl start pcsd.service
systemctl enable pcsd.service
passwd hacluster
```

**any one of server you can mark as a primary**

```bash
# assume that this is node1
drbdadm primary --force clusterdb
```

**drbd integrate with pcs cluster**

**open drbd primary node terminal**

```bash
pvcreate /dev/drbd0
vgcreate drbd-vg /dev/drbd0
lvcreate --name drbd-webdata --size 5G drbd-vg
lvcreate --name drbd-dbdata --size 5G drbd-vg
mkfs.xfs /dev/drbd-vg/drbd-webdata
mkfs.xfs /dev/drbd-vg/drbd-dbdata
# optional: vgchange -ay drbd-vg   #=> active Volume group
# optional: vgchange -an drbd-vg   #=> Deactive Volume group
pcs cluster auth node1 node2 -u hacluster -p .
pcs cluster setup --name fourtimes node1 node2
pcs cluster start --all
pcs cluster enable --all
pcs property set stonith-enabled=false
pcs property set no-quorum-policy=ignore
pcs cluster cib drbd_cfg
pcs -f drbd_cfg resource create drbd_clusterdb ocf:linbit:drbd drbd_resource=clusterdb
pcs -f drbd_cfg resource master drbd_clusterdb_clone drbd_clusterdb master-max=1 master-node-max=1 clone-max=2 clone-node-max=1 notify=true
pcs cluster cib-push drbd_cfg
pcs resource create lvm ocf:heartbeat:LVM volgrpname=drbd-vg
pcs resource create webdata Filesystem device="/dev/drbd-vg/drbd-webdata" directory="/drbd-webdata" fstype="xfs"
pcs resource create dbdata Filesystem device="/dev/drbd-vg/drbd-dbdata" directory="/drbd-dbdata" fstype="xfs"
pcs resource create virtualip ocf:heartbeat:IPaddr2 ip=192.168.1.155 cidr_netmask=24
# disable httpd or apache2 in both servers
pcs resource create webserver ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf statusurl="http://localhost/server-status"
pcs resource group add resourcegroup virtualip lvm webdata dbdata  webserver
pcs constraint order promote drbd_clusterdb_clone then start resourcegroup  # INFINITY
pcs constraint colocation add resourcegroup  with master drbd_clusterdb_clone INFINITY
pcs resource create ftpserver systemd:vsftpd --group resourcegroup
```

**MySQL integrated with pcs cluster**

```cmd
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm -y
yum install mysql-community-server -y
```

_move cnf file_

```cmd
mv /etc/my.cnf /drbd-dbdata/my.cnf
mkdir -p /drbd-dbdata/data
```

_add below lines to cnf file_

```cmd
vim /drbd-dbdata/my.cnf
```

```cnf
datadir=/drbd-dbdata/data
bind-address=0.0.0.0
```

**initiate the mysql cluster**

```bash
mysql_install_db --no-defaults --datadir=/drbd-dbdata/data
chown -R mysql:mysql /drbd-dbdata/
pcs resource create dbserver ocf:heartbeat:mysql config="/drbd-dbdata/my.cnf" datadir="/drbd-dbdata/data" pid="/var/lib/mysql/mysql.pid" socket="/var/lib/mysql/mysql.sock" user="mysql" group="mysql" additional_parameters="--user=mysql" --group resourcegroup

#pcs mysqlLogs resource
#pcs resource create mysqlLogs Filesystem device="/dev/drbd-vg/drbd-dbdata" directory="/drbd-dbdata/mysqlLogs" fstype="xfs"
```

**mysql service validation**

```bash
mysql –h 192.168.0.200 –u root –p
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'MyDBpassword';
FLUSH PRIVILEGES;
CREATE DATABASE rcmsdata;
```

**drbd issues findings**

**Recover a split brain**

**Secondary node**

```bash
drbdadm secondary all
drbdadm disconnect all
drbdadm -- --discard-my-data connect all
```

**Primary node**

```bash
drbdadm primary all
drbdadm disconnect all
drbdadm connect all
```

**On both**
_Verify the reconnection was successful:_

```cmd
drbd-overview
```

```bash
drbdadm status
cat /proc/drbd
```

optional

**Monitor the fdrbd resources**

```bash
cat <<EOF > /drbd-webdata/crm_logger.sh
#!/usr/bin/env bash
logger -t "ClusterMon-External" "${CRM_notify_node} ${CRM_notify_rsc} \
${CRM_notify_task} ${CRM_notify_desc} ${CRM_notify_rc} \
${CRM_notify_target_rc} ${CRM_notify_status} ${CRM_notify_recipient}";
exit;
EOF

chmod 755 /drbd-webdata/crm_logger.sh
pcs resource create ClusterMon-External ClusterMon user=apache update=10 extra_options="-E /usr/local/bin/crm_logger.sh --watch-fencing" htmlfile=/drbd-webdata/cluster_mon.html pidfile=/var/run/crm_mon-external.pid clone
```

**stonith configuration**

```bash
pcs resource defaults resource-stickiness=100
pcs resource op defaults timeout=240s
pcs stonith describe fence_ipmilan
pcs cluster cib stonith_cfg
pcs -f stonith_cfg stonith create ipmi-fencing fence_ipmilan pcmk_host_list="node1 node2" ipaddr=10.0.0.1 login=testuser passwd=acd123
pcs -f stonith_cfg property set stonith-enabled=true
pcs -f stonith_cfg property
pcs cluster cib-push stonith_cfg --config
pcs cluster stop node2
stonith_admin --reboot node2
```

**reference**

```bash
https://wiki.myhypervisor.ca/books/linux/page/drbd-pacemaker-corosync-mysql-cluster-centos7
http://isardvdi-the-docs-repo.readthedocs.io/en/latest/setups/ha/active_passive/
http://blog.zorangagic.com/2016/02/drbd.html
http://avid.force.com/pkb/articles/en_US/Compatibility/Troubleshooting-DRBD-on-MediaCentral#A
http://sheepguardingllama.com/2011/06/drbd-error-device-is-held-open-by-someone/
https://dev.mysql.com/blog-archive/mysql-now-provides-support-for-drbd/
https://www.lisenet.com/2015/active-passive-cluster-with-pacemaker-corosync-and-drbd-on-centos-7-part-3/
# DRBD-status
https://www.ibm.com/docs/en/psfa/7.2.1?topic=administration-monitor-drbd-status
```

**active-active cluster from active-passive cluster**

Configure SONITH. It will help you to fix this issue. or else it is not possible to complete

![image](https://user-images.githubusercontent.com/57703276/197835585-d9ef7962-023a-4755-9b78-3c6af61ff636.png)

```bash
# MySQL 5.7
pcs resource create dbserver ocf:heartbeat:mysql config="/drbd-dbdata/my.cnf" datadir="/drbd-dbdata/data" pid="/var/lib/mysql/mysql.pid" socket="/var/lib/mysql/mysql.sock" user="mysql" group="mysql" binary=/usr/sbin/mysqld additional_parameters="--user=mysql" --group resourcegroup

mysql_secure_installation
> firstPassword
> firstPassword
mysql -u root -pfirstPassword
ALTER USER 'root'@'localhost' IDENTIFIED BY 'secondPassword';
exit
mysql -u root -psecondPassword
create database rcmsdata;
GRANT ALL ON *.* to root@'%' IDENTIFIED BY 'secondPassword';
mysql -h 192.168.1.180 -u root -psecondPassword
exit
mysql -u root -psecondPassword
CREATE USER 'sqladmin'@'%' IDENTIFIED BY 'dbPassword';
GRANT ALL ON rcmsdata.* to sqladmin@'%';
mysql -u sqladmin -pdbPassword
```
