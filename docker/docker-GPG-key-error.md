
* As an alternative, you can consider using Docker's official package repository for Ubuntu 20.04 LTS (Focal Fossa) since it is a long-term support (LTS) release and generally more stable. To do this, follow these steps:

**Remove any previously attempted Docker installations:**

```cmd
sudo apt remove --purge docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker
```
**Add Docker's official GPG key for the Ubuntu 20.04 repository:**
```cmd
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
**Add the Docker repository for Ubuntu 20.04:**
```cmd
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
**update the server**
```cmd
sudo apt update
```
**Install the docker pakage**
```cmd
sudo apt install docker-ce docker-ce-cli containerd.io -y
```
