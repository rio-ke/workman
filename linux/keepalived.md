## _keepalived configuration_

* Keepalived is a piece of software which can be used to achieve high availability by assigning two or more nodes a virtual IP and monitoring those nodes, failing over when one goes down. Keepalived can do more, like load balancing and monitoring, but this tutorial focusses on a very simple setup, just IP failove

**_requirments_**

|Ip|OS|Path|Domain_name|
|---|---|---|---|
|192.168.0.101|Ubuntu|/etc/keepalived|fourtimes.ml|
|192.168.0.102|Ubuntu|/etc/keepalived|fourtimes.ml|
|192.168.0.105|Ubuntu|virtual _ip|


**_Installation process_**

---

```conf
sudo apt-get update
sudo apt-get install linux-headers-$(uname -r)
sudo apt-get install keepalived
```

**_Configuration_**

* Now create or edit Keepalived configuration `/etc/keepalived/keepalived.conf` file on LB1

```bash
vim /etc/keepalived/keepalived.conf
```

***Configuration File for MASTER FILE***

```conf

global_defs {
   notification_email {
     sysadmin@fourtimes.ml
     support@fourtimes.ml
   }
   notification_email_from lb1@fourtimes.ml
   smtp_server localhost
   smtp_connect_timeout 30
}

vrrp_instance VI_1 {
    state MASTER
    interface wlp1s0
    virtual_router_id 101
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.10.105/32
    }
}
```

Configuration File for backup file


```conf

global_defs {
   notification_email {
     sysadmin@fourtimes.ml
     support@fourtimes.ml
   }
   notification_email_from lb1@fourtimes.ml
   smtp_server localhost
   smtp_connect_timeout 30
}

vrrp_instance VI_1 {
    state backup
    interface wlp1s0
    virtual_router_id 101
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.10.105/32
    }
}

```

**Start keepalived service**
```bash
sudo service keepalived start
```

* Then, for future reference, configure the apache2 service once more.--> https://github.com/dodo-foundation/linux-learns/blob/main/apache2-vhost-configuration.md


* Host entry:--> `sudo vim /etc/hosts`

```host

192.168.0.101 fourtimes.ml
192.168.0.102 fourtimes.ml
192.168.0.105 fourtimes.ml
```
