**Create the Admin User**

```bash
mongosh
```
```bash
use admin;
```
```JavaScript
db.createUser({
  user: "admin",
  pwd: passwordPrompt(),  // You can use a string password instead of passwordPrompt()
  roles: [
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "readWriteAnyDatabase", db: "admin" },
    { role: "dbAdminAnyDatabase", db: "admin" },
    { role: "root", db: "admin" }  // Optional, full root-level access
  ]
})
```
_Output_
![Image](https://github.com/user-attachments/assets/021a40f9-d3e0-42f8-abc6-ebe5fd33322b)

```cmd
sudo vim /etc/mongod.conf
```
_Add the lines_

```bash
security:
  authorization: enabled
```
```cmd
sudo systemctl restart mongod
```
```cmd
mongosh -u admin -p --authenticationDatabase "admin"
```

![Image](https://github.com/user-attachments/assets/f26cb5fe-2f68-4991-97eb-f2e0c6756728)

--------------------
### MongoDB Shell access

**_Create a Database_**

```JavaScript
use rcmsdata;
```
**_Create a User for the Database and add privileges_**

```JavaScript
use admin;
```
```JavaScript
db.createUser({
  user: "kendanic",
  pwd: "Ken@1234"
  roles: [ { role: "readWrite", db: "rcmsdata" } ]
})
```
_Output_
![Image](https://github.com/user-attachments/assets/27636f6d-4dcc-4805-8b04-171e13328589)

**_Create a Collection_**

```JavaScript
db.createCollection("dailycollect")
```
```JavaScript
db.getCollectionNames() // or show collections
```
_Output_
![Image](https://github.com/user-attachments/assets/6ad1ec63-afb7-475e-aab5-b68386dd5624)

**_Insert Data into the Collection_**

* To insert data (documents) into dailycollect, use the insertOne or insertMany 

**`Insert a Single Document`**

```JavaScript
db.dailycollect.insertOne({
  name: "Rio J",
  age: 25,
  email: "rio-ke@example.com"
})
```
_Output_
![Image](https://github.com/user-attachments/assets/88f01f43-1f9c-4f75-aa8b-f5eca6349ee8)

`**Insert Multiple Documents**`

```JavaScript
db.myCollection.insertMany([
  { name: "Abc", age: 25, email: "abc@example.com" },
  { name: "Bca", age: 26, email: "bca@example.com" },
  { name: "Cab", age: 27, email: "cab@example.com" }
])
```
_Output_
![Image](https://github.com/user-attachments/assets/41e26a79-4929-4b1f-8924-5d19d46d53a6)

_**View All Documents in the Collection**_

```JavaScript
db.dailycollect.find().pretty()
```
_Output_
![Image](https://github.com/user-attachments/assets/051da06c-bbe2-4afb-bb53-aa0cc5e43495)

_**Update Documents**_

```JavaScript
db.dailycollect.updateOne(
  { name: "Abc" }, 
  { $set: { email: "updated-one@example.com" } } 
)
```
_Output_
![Image](https://github.com/user-attachments/assets/3c2f4946-716d-4629-92ae-dacb909dbd93)

_Updated-output_
![Image](https://github.com/user-attachments/assets/5565c143-822e-4f9a-92ba-af578358114c)

**_Update Multiple Documents_**

```JavaScript
db.dailycollect.updateMany(
  { age: { $lt: 27 } }, 
  { $set: { email: "updated-email@example.com" } } 
)
```
_Output_
![Image](https://github.com/user-attachments/assets/69055896-43e0-4baf-947e-d854573ef981)

