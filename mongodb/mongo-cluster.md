## MongoDB Cluster & Replica 
**Replica sets**

* A MongoDB replica set is a group of one or more servers containing the exact copy of the data. While it’s technically possible to have one or two nodes, the recommended minimum is three. A primary node is responsible for providing your application’s read and write operations, while two secondary nodes contain a replica of the data

 ![image](https://github.com/user-attachments/assets/2277a9fa-e2f2-4965-804b-e7814db8e486)

* f a primary node is unavailable, the traffic from the client application is redirected to a new primary node

![image](https://github.com/user-attachments/assets/aadaacea-7db9-4dff-8a1d-924f9b6b13fe)

**Generate the Key File**

* MongoDB requires a key file for authentication between members of the replica set. This key file must be the same on all nodes (servers) in the replica set.
* We have create key file in primary and scp to all the secondary server nodes.

_To generate the key file_

```cmd
openssl rand -base64 756 > /etc/mongo-cluster-key
```
_File permissions_

```cmd
sudo chmod 400 /etc/mongo-cluster-key
sudo chown mongodb:mongodb /etc/mongo-cluster-key
```

_Configure the Key File in MongoDB_

```cmd
sudo vim /etc/mongod.conf
```
```yml
security:
  keyFile: /etc/mongo-keyfile
```
```cmd
sudo systemctl restart mongod
```

**Steps for replica**

 _Initiating cluster via command-line_ (optional)

 ```cmd
mongod --configsvr --replSet <configReplSetName> --dbpath <path> --port 27019 --bind_ip localhost,<hostname(s)|ip address(es)>
mongod --configsvr --replSet clus-name --dbpath /.../.../dbdata --port 27019 --bind_ip localhost
```
```cmd
mongod --configsvr --replSet configReplSet --dbpath /var/lib/mongo-config --port 27019 --bind_ip localhost
```

_Initiating cluster via conf-file_

* MongoDB Configuration Files (/etc/mongod.conf) on both servers to enable replica sets

```cmd
sudo vim /etc/mongod.conf
```

* Locate the replication section and enable the replica set by adding it.

```yml
replication:
  replSetName: "rcms-org-clus"
```

```cmd
sudo systemctl restart mongod
```

```cmd
sudo ufw disable
```
```cmd
mongosh
```

```javascript
rs.initiate({
  _id :  "rcms-org-clus",
  members: [
    { _id:  0, host:  "mongodb0.10.0.0.36:27017" },
    { _id:  1, host:  "mongodb1.10.0.0.4:27017" },
    { _id:  2, host:  "ip-mongodb2.10.0.0.7:27017" }
  ]
})
```
_View the replica set configuration_

```javascript
rs.conf()
```
_Ensure that the replica set has a primary_

```javascript
rs.status()
```

