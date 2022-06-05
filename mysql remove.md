##First make sure that MySQL service is stopped.

~~~bash
sudo systemctl stop mysql
~~~


**Remove MySQL related all packages completely.**

~~~bash
sudo apt-get purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
~~~~

**Remove MySQL configuration and data. If you have changed database location in your MySQL configuration, you need to replace /var/lib/mysql according to it.**

~~~~bash
sudo rm -rf /etc/mysql /var/lib/mysql
~~~~


* (Optional) Remove unnecessary packages.

~~~bash
sudo apt autoremove
~~~

* (Optional) Remove apt cache.

~~~bash
sudo apt autoclean
~~~
