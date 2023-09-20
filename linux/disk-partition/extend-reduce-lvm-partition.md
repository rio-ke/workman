## How to Extend/Reduce LVM’s (Logical Volume Management) in Linux

- [ ] To reduce the size of a mounted folder in LVM and allocate the freed space to a new folder

* `Backup Your Data`: Before making any changes, ensure you have a backup of all the data in the mounted folder. Data loss is possible when resizing filesystems

_Unmount the Filesystem_

```cmd
umount /path/to/mounted_folder
```
_`Resize the Logical Volume`_

- Use the lvresize command to reduce the size of the logical volume. In your case, you want to reduce it from 100 GB to 80 GB

```cmd
lvresize -L -20G /dev/vg_name/lv_name
```

_`Resize the Filesystem`_

- After resizing the logical volume, you must resize the filesystem to match the new size. The command to do this depends on the filesystem type. _`For ext4`_, you can use:

```cmd
resize2fs /dev/vg_name/lv_name
```
_`For-XFS`_

```cmd
xfs_growfs /path/to/mounted_folder
```

_**Create a New Logical Volume**_

- Use the freed 100 GB to create a new logical volume. First, create a new logical volume within the same volume group

```cmd
lvcreate -L 100G -n new_lv_name vg_name
```

_Create a Filesystem on the New Logical Volume_

- Create a filesystem on the new logical volume. For example, for ext4

 ```cmd
mkfs.ext4 /dev/vg_name/new_lv_name
```
_Mount the New Logical Volume_

* Mount the new logical volume to your desired location

```cmd
mount /dev/vg_name/new_lv_name /path/to/new_mounted_folder
```
_Update /etc/fstab_ 

- To ensure the new logical volume is mounted at boot, update your /etc/fstab file with the appropriate entry. Add a line

```cmd
/dev/vg_name/new_lv_name   /path/to/new_mounted_folder   ext4    defaults    0 0
```



Reference
---

[centos](https://www.tecmint.com/extend-and-reduce-lvms-in-linux/)

[ubuntu](https://packetpushers.net/ubuntu-extend-your-default-lvm-space/#:~:text=To%20use%20up%20that%20free,to%20make%20sure%20it%20changed.)


