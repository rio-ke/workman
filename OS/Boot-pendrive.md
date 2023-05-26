$Boot-Pendrive-with-dd-commands-in-LInux-termianl$

* First Format the pendrive in windows laptop

the check pendrive in lunux lap for disk partition

with cmd

lsblk

if its in -> sdb -> sdb1

u should delete the sdb1 partion with

sudo fdisk /dev/sdb

m

d

w

then

unplug the pendrive and reinsert it and

lsblk

now go to OS dir

/home/user/OS_folder_name/

then copy the OS_name

kali-linux-2023.1-installer-everything-amd64.iso

execute the cmd below

dd if=kali-linux-2023.1-installer-everything-amd64.iso of=/dev/sdb conv=fsync bs=4M

