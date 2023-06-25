**command line for attach an ebs volume**

_To check attach volume_

```cmd
lsblk
```

_To check file type_

```cmd
sudo file -s /dev/xvdk
```
_Create mount folder_
 
```cmd
sudo mkdir -p /webdata
```
```cmd
cd / & ls -ltrh
```

_To  create a file system as xfs_

```cmd
sudo mkfs -t xfs /dev/xvdk
```
_To mount existing folder on partition /dev/xvdk_

```cmd
sudo mount /dev/xvdk /webdata
```
_Check_
 
```cmd
sudo mount -a
```
```cmd
lsblk & df -h
```
