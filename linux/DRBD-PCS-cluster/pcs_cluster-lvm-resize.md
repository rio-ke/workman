
**_how to increase the pcs lvm volume_**

```key
lvextend  -L+1G /dev/drbd-vg/drbd-webdata
# ext4 volume
resize2fs /dev/drbd-vg/drbd-webdata
# xfs volume
xfs_growfs /dev/drbd-vg/drbd-webdata
```
