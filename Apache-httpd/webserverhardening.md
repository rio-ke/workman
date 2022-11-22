#  Apach-httpd Web Server Hardening

**install apache2 in linux systemc**

```bash
sudo apt update
sudo apt install apache2 -y
sudo yum install httpd -y
```

**service handling process**

_This command can be used to start the service and check its status._

sudo systemctl start apache2
sudo systemctl status apache2



**create a document root directory**

```bash
mkdir -p /var/www/html/domain-name/index.html
```



$$
Confirguration-for-Apache2-Hardening
$$

**apache2-httpd configuration file location**

```bash
sudo vim /etc/httpd/conf/httpd.conf (centOS)
    
sudo vim /etc/apache2/apache2.conf (Ubuntu)
```


1. **_Hiding Server Version Banner_**


        * Go to /etc/apache/ conf folder
        * Modify httpd.conf by using the vim editor
        * Add the following directives to configuration

```bash  
ServerTokens Prod
ServerSignature Off
```

* Restart apache
