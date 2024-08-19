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

**_PHP-FPM_**

_Install_

```cmd
sudo apt install php-fpm -y
```
_install fpm-modules_

```cmd
sudo apt install php-mysql php-db php-cli php-common php-db php-curl php-zip php-xml -y
```
_Configure Nginx to Use PHP-FPM_

* Add this in vhost conf file 
```cmd
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;

        #fastcgi_buffers 16 16k;
        #fastcgi_buffer_size 32k;
        #fastcgi_connect_timeout 60s;
        #fastcgi_send_timeout 120s;
        #fastcgi_read_timeout 120s;	
        
	    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
```

_check and customize the default fpm pool_
```cmd
sudo vim /etc/php/8.1/fpm/pool.d/www.conf
```
* check below details there..(values are not accurate)

```conf
listen = /var/run/php/php8.1-fpm.sock
listen.owner = www-data
listen.group = www-data 
pm = dynamic 
pm.max_children = 30 
pm.start_servers = 5  
pm.process_idle_timeout = 20s
```
```cmd
sudo systemctl status php8.1-fpm.service
```
```cmd
sudo systemctl reload nginx
```

_Create a PHP Test File_
```cmd
echo "<?php phpinfo(); ?>" | sudo tee /var/www/php-app/info.php
```

**Test webpage**

* Use https:domain.com/info.php

















