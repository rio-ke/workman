## Mount folder

_To check mounted folders and storage_

```cmd 
df -Th 
```
_login as a root user for Authentication_

```cmd
sudo -i
```
_List information about block devices_

```cmd
lsblk
```

_create partitions_

```cmd
fdisk /dev/sdb
```
_Follow the steps:_

1. m (m for help)
2. n   add a new partition
3  1
4. Enter
5. Enter
6. w write table to disk and exit
7. 
--------------------------------------------
_Generic_

-   d   delete a partition
-   F   list free unpartitioned space
-   l   list known partition types
-   n   add a new partition
-   p   print the partition table
-   t   change a partition type
-   v   verify the partition table
-   i   print information about a partition

-------------------------------------------

_Check partitions_

```cmd
lsblk
```

_Create mount folder with `/`_

```cmd
mkdir /mount-folder-name
```
```cmd
mkfs.ext4 /dev/sdb1
```
* mkfs (make-file-system)
* sdb1 (new disk partition)

```cmd
blkid
```
copy the last UUID id 

vim /etc/fstab

paste the copied UUID line here

UUID= xxxxxxxxx   /mount-folder-name  ext4   defult  0  0 

mount -a

df -Th

reboot

df -Th

check partition

To check how many partition availabe 

sudo fdisk -l



https://superuser.com/questions/134734/how-to-mount-a-drive-from-terminal-in-ubuntu
