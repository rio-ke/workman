**To check the docker details in localserver use this commands**

_To check container_ip_

```cmd
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name or ip
```
