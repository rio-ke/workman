# Enable PHP-FPM Status Page for `Browser`

_Php-fpm Pool Configuration File_

```cmd
sudo vim /etc/php/8.1/fpm/pool.d/www.conf
```

_Edit the Configuration_

```ini
pm.status_path = /status
```

_Restart php-fpm_

```cmd
sudo systemctl restart php8.1-fpm
```

_configure Nginx vhost conf-file_

```cmd
sudo vim /etc/nginx/sites-available/vhost.conf
```
```cnf
location ~ ^/(status|ping)$ {
    access_log off;
    allow all;   #127.0.0.1 for localhost
    deny all;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_pass unix:/run/php/php8.1-fpm.sock;
}
```

_Restart ngnix service_

```cmd
sudo systemctl restart nginx
```

* Now check the domain status

```bash
https://demo.radianterp.in/status
```

![image](https://github.com/user-attachments/assets/b7a366ce-ebcd-4f8c-bfbb-ec8bf5e90a61)



