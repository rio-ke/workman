ALL the docker vloume commands
---

* `Note` adding volume name we cannot give [-,*,/] these variables in command
```cmd
docker volume create my_config_volume
```

```cmd
docker volume create --driver local \
  --opt type=none \
  --opt device=/etc/httpd-conf/test002.conf \
  --opt o=bind my_apache_config_file
```
