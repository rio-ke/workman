# How to increase Swap Memory in CentOS 7


* Create swapfile-additional file with dd command in / (root). 
* You can select any other partition but it should be mounted (For eg. /opt, /usr ,/NewMountedPartition)

```cmd
dd if=/dev/zero of=/swapfile-additional bs=1M count=4048
```
- dd = It is a unix command used for convert and copy a file
- if = read from FILE instead of stdin
- /dev/zero = /dev/zero is a special file in Unix-like operating systems that provides as many null characters (ASCII NUL, 0x00) as are read from it
of = write to FILE instead of stdout
/swapfile-additional = file named swapfile-additional will be created in /
- bs = Read and write bytes at a time but if you do not mention MB or GB like only number it will read as bytes. for eg. bs=1024 means 1024 bytes
- count = Copy input blocks in our case it is 1024 (1M * 4048 = 4GB)

### Run mkswap command to make swap area

```cmd
mkswap /swapfile-additional
```
### Change the permission of file swapfile-additional

```cmd
chmod 600 /swapfile-additional
```

### Permanent mounting the swap space by editing the /etc/fstab file .

Use your file editor, I generally use vi editor.

```cmd
vi /etc/fstab
```

- Paste below given content in /etc/fstab file

```cmd
/swapfile-additional swap swap    0   0
```

### Now mount the swap area, run below given command.

```cmd
mount -a
```

### Enable the swap area

```cmd
swapon -a
```

### Check the number swap space mounted on your system

```cmd
swapon -s
```

### To check how much is swap space available on system. Run below given command

```cmd
free -m
```
