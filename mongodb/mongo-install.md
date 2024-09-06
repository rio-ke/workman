## MongoDB

**Install mongodb in `ubuntu22`**

```cmd
# Import the MongoDB public GPG key:
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -

# Create the `/etc/apt/sources.list.d/mongodb-org-7.0.list` file for Ubuntu:
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update the packages list:
sudo apt-get update

# Install MongoDB, including the client tools:
sudo apt-get install -y mongodb-org
```
**Verify Installation**

```cmd
mongo --version
```
**systemd_service**

```cmd
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
```

**To enter mongo-server**

```cdm
sudo mongosh
```

* To check basics commands in mongoDB 

_List All Databases_
```shell
show db;
```
```shell
use admin;
```
```shell
show users;
```

**Configure MongoDB**

```cmd
sudo mv /etc/mongod.conf /etc/mongod.conf.org
```
```cmd
sudo vim /etc/mongod.conf
```
```shell
net:
  bindIp: 0.0.0.0  # Allow connections from any IP address
```
_Enable Authentication: To secure your MongoDB instance, you can enable authentication_

```shell
security:
  authorization: enabled
```

_Restart mongo service_
```cmd
sudo systemctl restart mongod
```
