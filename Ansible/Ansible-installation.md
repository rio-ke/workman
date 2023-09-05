```badh
#! /bin/bash
apt install software-properties-common
add-apt-repository ppa:deadsnakes/ppa
apt install python3.11 -y
sudo update-alternatives - install /usr/bin/python python /usr/bin/python3.11 1
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y
sudo apt update
ansible - version
```
* Jenkins installed

```bash
#! /bin/bash
# For Ubuntu 22.04
# Intsalling Java
apt update -y
apt install openjdk-11-jre -y
java - version
# Installing Jenkins
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y

```
