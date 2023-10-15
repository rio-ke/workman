$$SCP$$

---

SCP (Secure Copy Protocol) is a network protocol used to securely copy files/folders between Linux (Unix) systems on a network.SCP protects your data while copying across an SSH (Secure Shell) connection by encrypting the files and the passwords. 
Therefore, even if the traffic is intercepted, the information is still encrypted.


_**SCP Uses:**_


 * Copying files from a local host to a remote host.
 
 * Copying files from a remote host to a local host.
 
 * Copying files between two remote servers.


_**Syntax**_

```bash

scp <option> source_file_name username@destination_host:destination_folder

```

_**SCP Command Options**_

* -C	Enable compression.
* -d	Copy the file, only if the destination directory already exists.
* -h	Show a list of command options.
* -r	Copy recursively.
* -u	Delete the source file once the copy is complete.
* -v	Enable verbose mode,



_**Copy a File from a Local Host to the Remote Server**_

* Push Method - File is transmitted from `localhost to remote server` 

```bash 

scp /home/source_dir/  username@ip:/home/Destination Dir

```

* Pull Method - File is receive from `remote server to localhost`

```bash

scp remote ip:/home/source_dir/  home/Destination_dir 

```

In this scenario, I'll copy the localhost `backup` folder to the server side.

```bash

scp -r home/Desktop/backup remote ip:/home/remote_dir/

```

for More scp command option given to below

---

_**Copy a File from One Remote Server to Another**_


* Push Method - File is transmitted from `user to remote server` 
 
```bash

scp username@userip:home/Source_dir/sample_example.txt  root@remoteip:/home/Destination_dir/

```
* Pull Method - File is receive from `remote server to user`
 
```bash
scp root@remoteip:/home/source_dir/sample_example.txt username@userip:home/Destination_dir/
```
```cmd
scp -r user1@remote_server1:/path/to/source_folder user2@remote_server2:/path/to/destination_folder
```

* If you Ignore Hostkey checking use this option **`-o StrictHostKeyChecking=no`**

```bash

scp -o StrictHostKeyChecking=no root@remoteip:/home/source_dir/sample_example.txt username@userip:home/Destination_dir/

```

_**copy local to AWS**_

```cmd
scp -i /path/to/your/private-key.pem -r /path/to/local/files ubuntu@ec2-instance-public-ip:/path/on/ec2/instance
```

**remote to aws**

```cmd
scp -i /path/to/your/private-key.pem -r user@remote-server:/path/to/remote/files /path/on/ec2/instance
```

_remote to aws ec2 with local help_

- [ ] Copy the File from the Remote Server to Your Local Machine (In local machine) :

```cmd
scp user@remote-server-ip:/path/to/remote/file /path/on/local/server
```
- [ ] Copy the File from Your Local Machine to Your AWS EC2 Instance:

```cmd
scp -i /path/to/aws/key.pem /path/on/local/server/file ubuntu@ec2-instance-ip:/path/on/ec2/
```

