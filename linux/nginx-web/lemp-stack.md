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
 
