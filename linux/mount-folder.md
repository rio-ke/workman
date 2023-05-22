## Mount folder

To check mounted folders and storage

```cmd 
df -Th 
```

sudo -i

lsblk

fdisk /dev/sdb

steps:

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

lsblk

mkdir /mount-folder-name

mkfs.ext4 /dev/sdb1

mkfs (make-file-system)
sdb1 (new disk partition)

blkid

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
