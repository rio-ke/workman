# 


lsblk

fdisk /dev/sda

m

n

enter
enter
+100G # disk-space need to partition
w

check lsblk

partprobe /dev/sda

lsblk

[refer](https://www.decodingdevops.com/how-to-create-partition-in-linux-step-by-step-centos-redhat-rhel/)
