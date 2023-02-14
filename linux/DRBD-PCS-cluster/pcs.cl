pvcreate /dev/drbd0
vgcreate drbd-vg /dev/drbd0
lvcreate --name drbd-webdata --size 3G drbd-vg
lvcreate --name drbd-dbdata --size 3G drbd-vg
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
pcs resource create virtualip ocf:heartbeat:IPaddr2 ip=192.168.1.200 cidr_netmask=24
pcs resource create webserver ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf statusurl="http://localhost/server-status"
pcs resource group add resourcegroup virtualip lvm webdata dbdata  webserver
pcs constraint order promote drbd_clusterdb_clone then start resourcegroup  # INFINITY
pcs constraint colocation add resourcegroup  with master drbd_clusterdb_clone INFINITY
pcs resource create ftpserver systemd:vsftpd --group resourcegroup