**_Method#1_**

Install phpmyadmin
```cmd
sudo apt install phpmyadmin -y
```
-  Choose either Apache for your preferred web server

- Create a symbolic link (Optional): If you chose Apache as your web server during the phpMyAdmin installation, it should automatically create the necessary configuration. However, if you want to create a symbolic link, you can do it as follows:

```cmd
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
```
_Enable PHP extensions_
```cmd
sudo phpenmod mysqli && sudo phpenmod gd
```
_Restart webserver_
```cmd
sudo systemctl restart apache2.service
```
_Check in browser_

```bsdh
http://192.168.1.2/phpmyadmin
```

_**method#2**_

* Download the phpmyadmin file,
* Extract the file in server,
* change the name and move to webserver document root location 

_**method#3**_

```bash
sudo apt install -y phpmyadmin
phpmyadmin --version
cd /etc/phpmyadmin/
ll
cd 
cd /etc/apache2/
ll
cd conf-available/
ll
cd
cd /etc/phpmyadmin/
cd
sudo apt remove phpmyadmin
sudo apt install -y phpmyadmin
cd /etc/phpmyadmin/
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin.conf
sudo systemctl restart apache2
curl ifconfig.me
ll
sudo cat config-db.php 
sudo vim config-db.php 
sudo systemctl reload apache2.service 
```

