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
