## To check disk partition on node

**_how to find mount folder in file-system_**

```bash
find /mnt
```

_**how to get an overview of filesystems**_

```cmd
lsblk --fs
```

```cmd
fdisk -l
```

_to find UUID id in `ubuntu`_

```bash
blkid
```

```bash
sudo gdisk
```

```bash
sudo cdisk
```

```bash
sudo gdisk -l /dev/sda
```
