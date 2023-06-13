_Docker installation on ubuntu_
---

_The unofficial packages to uninstall are_

    docker.io
    docker-compose
    docker-doc
    podman-docker

* Moreover, Docker Engine depends on containerd and runc. Docker Engine bundles these dependencies as one bundle: containerd.io. If you have installed the containerd or runc previously, uninstall them to avoid conflicts with the versions bundled with Docker Engine.

_Run the following command to uninstall all conflicting packages_

 ```cmd
 for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove $pkg; done
```

_**Setup the repository**_

```bash
  sudo apt update
  sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
```
_**Add Docker’s official GPG key**_

```bash
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg \
      --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
_**set up the stable repository**_

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

_**Install Docker Engine**_

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

_**Start the Docker**_

```bash
sudo systemctl start docker
```

**Stop the Docker**

```bash
sudo systemctl stop docker
```
**Status of the Docker**

```bash
sudo systemctl status docker
```


**Restart the Docker**

```bash
sudo systemctl restart docker
```

**Enable the Docker**
```bash
sudo systemctl enable docker
```
**Add the users into Docker group**

```bash
sudo usermod -aG docker $USER
```
* **reboot the system**

* If you want to avoid typing sudo whenever you run the docker command, add your username to the docker group:

```cmd
sudo usermod -aG docker $(whoami)
```
* You will need to log out of the Droplet and back in as the same user to enable this change.

* If you need to add a user to the docker group that you’re not logged in as, declare that username explicitly using:
```cmd
sudo usermod -aG docker username
```
* **reboot the system**


docker document reference pls visit --> https://docs.docker.com/reference/
