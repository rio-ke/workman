## squid configuration

```cnf
# proxy-port
http_port 3128
http_access allow localhost
http_access allow localnet
http_access allow all
visible_hostname demo
acl localnet src your_ip_address
```
