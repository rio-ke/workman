
$$How-to-increase-the pcs-lvm-volume$$

```shell
lvextend  -L+1G /dev/drbd-vg/drbd-webdata
# ext4 volume
resize2fs /dev/drbd-vg/drbd-webdata
# xfs volume
xfs_growfs /dev/drbd-vg/drbd-webdata
```
