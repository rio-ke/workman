## LEMP Stack Documentation 

**`Prerequisites`**
- An Ubuntu:latest server
- Ngnix
- Php-fpm
- Mysql-server

**_Install Nginx**_

```cmd
sudo apt update
sudo apt install nginx -y
```
_Enable-service_

```cmd
sudo systemctl start nginx
sudo systemctl enable nginx
```

**Configure Nginx**

_Create a root directory_

```cmd
sudo mkdir -p /var/www/your_domain
sudo chown -R $USER:$GROUP /var/www/php-app
sudo chmod -R 775 /var/www/php-app
```

> remove default nginx config 
```cmd
sudo rm -rf /etc/nginx/sites-enabled
sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.org
```
**ssl-cert-insert**

* Obtain SSL Certificates
* Upload Certificates to Your Server
* Set File Permissions
* Configure Nginx for SSL

**CONF**

```cmd
sudo vim /etc/ngnix/conf.d/vhost.conf
```
```conf
server {
    listen 80;
    server_name your_domain.com;

    # Redirect HTTP to HTTPS
    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name your_domain.com;

    # Define the document root and other configurations
    root /var/www/your_site;
    index index.html;
    ssl_certificate /etc/nginx/ssl/radianterp.in/certificate.crt;
    ssl_certificate_key /etc/nginx/ssl/radianterp.in/private.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_session_tickets off;

    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;

    access_log /var/log/nginx/demo.radianterp.in.access.log custom;
    error_log /var/log/nginx/demo.radianterp.in.error.log;

    location /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location / {
        try_files $uri $uri/ =404;
    }
}
```
_Test Your Nginx Configuration_
```cmd
sudo nginx -t
```_
Service Restart_
```cmd
sudo systemctl restart nginx
```














