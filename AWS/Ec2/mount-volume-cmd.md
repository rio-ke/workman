**command line for To mount folder to attached an ebs volume**

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
cd /
```
```cmd
ls -ltrh
```

```bash
# To format the disk use this command
# Do not use this command while restoring snapshot
# /dev/disk_name

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
lsblk
```
```cmd
df -h
```

![Screenshot from 2023-06-25 13-22-32](https://github.com/rio-ke/workman/assets/88568938/6a162914-a74e-4666-a509-b8fa5ba167db)


* Configure automatic mounting (optional): If you want the EBS volume to be automatically mounted when the EC2 instance restarts, you can update the /etc/fstab file. Add an entry for the EBS volume using the device name and mount point, along with the desired file system type and options.
