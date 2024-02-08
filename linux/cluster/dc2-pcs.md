pcs resource create webserver ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf statusurl="https://nrazindbs.radianterp.in/server-status"


```bash
#dc2
pcs status
pcs resource ungroup  radiantgroup
pcs resource group add radiantgroup virtualip lvm webfsone  webfstwo  webfsthree webserver dbserver
pcs constraint order promote drbd_clusterdb_clone then start radiantgroup
pcs constraint colocation add radiantgroup  with master drbd_clusterdb_clone INFINITY
pcs status
```

**_order_**

```bash
virtualip lvm webfsone  webfstwo  webfsthree webserver dbserver
```

* * If any one the resources is blocked plz restart the servers with standby

**_dc1_**
```bash
pcs resource group add resourcegroup virtualip lvm webdata dbdata  webserver
pcs resource group update resourcegroup virtualip lvm webdata dbdata  webserver
pcs constraint colocation add resourcegroup  with master drbd_clusterdb_clone INFINITY
```
