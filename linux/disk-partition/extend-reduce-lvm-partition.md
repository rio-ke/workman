## How to Extend/Reduce LVM’s (Logical Volume Management) in Linux

* - [ ] To reduce the size of a mounted folder in LVM and allocate the freed space to a new folder

* `Backup Your Data`: Before making any changes, ensure you have a backup of all the data in the mounted folder. Data loss is possible when resizing filesystems

_Unmount the Filesystem_

```cmd
umount /path/to/mounted_folder
```
`Resize the Logical Volume`: 

- Use the lvresize command to reduce the size of the logical volume. In your case, you want to reduce it from 100 GB to 80 GB

```cmd
lvresize -L -20G /dev/vg_name/lv_name
```

`Resize the Filesystem`:
- After resizing the logical volume, you must resize the filesystem to match the new size. The command to do this depends on the filesystem type. _`For ext4`_, you can use:

```cmd
resize2fs /dev/vg_name/lv_name
```
_For XFS_
```cmd
xfs_growfs /path/to/mounted_folder
```



















[centos](https://www.tecmint.com/extend-and-reduce-lvms-in-linux/)
[ubuntu](https://packetpushers.net/ubuntu-extend-your-default-lvm-space/#:~:text=To%20use%20up%20that%20free,to%20make%20sure%20it%20changed.)


