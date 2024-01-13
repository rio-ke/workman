$$To-install-Docker-Compose-as-a binary-on-Linux-ubuntu$$

**_Download the Docker Compose binary_**

```cmd
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

**_Make the binary executable_**

```cmd
sudo chmod +x /usr/local/bin/docker-compose
```
_Check installation_

```cmd
docker-compose --version
```
