```cnf
<Location />
ProxyPass http://localhost:3000/
ProxyPassReverse http://localhost:3000/
Order allow,deny
Allow from all
</Location>
```

```cmd
sudo a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests
```
