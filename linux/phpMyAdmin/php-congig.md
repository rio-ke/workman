   77  sudo apt install -y phpmyadmin
   78  phpmyadmin --version
   79  cd /etc/phpmyadmin/
   80  ll
   81  cd 
   82  cd /etc/apache2/
   83  ll
   84  cd conf-available/
   85  ll
   86  cd
   87  cd /etc/phpmyadmin/
   88  cd
89  sudo apt remove phpmyadmin
90  sudo apt install -y phpmyadmin
91  cd /etc/phpmyadmin/
92  sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
93  sudo a2enconf phpmyadmin.conf
sudo systemctl restart apache2
curl ifconfig.me
ll
sudo cat config-db.php 
sudo vim config-db.php 
sudo systemctl reload apache2.service 
