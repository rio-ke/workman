## Boot Pendrive with dd commands in LInux termianl


- First Format the pendrive in windows laptop

- The check pendrive in lunux lap for disk partition

```cmd
lsblk
```
* if its in -> sdb -> sdb1

- Delete extra sdb1 partion

```cmd
sudo fdisk /dev/sdb
```
```bash
m        # for help

d        # delete partition

w        # save and exit
```

Then

- Unplug the pendrive and reinsert it

```cmd
lsblk
```

- Now go to OS dir path

```bash
cd /home/user/OS_folder_name/
```

- Then copy the OS_name

```cmd
COPY #kali-linux-2023.1-installer-everything-amd64.iso
```
- Execute the cmd below

```cmd
dd if=kali-linux-2023.1-installer-everything-amd64.iso of=/dev/sdb conv=fsync bs=4M
```
