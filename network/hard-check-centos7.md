## 

1.lscpu: This command provides detailed information about the CPU architecture, model, cores, threads, and other relevant details.

```cmd
lscpu
```

2. cat /proc/cpuinfo: This command reads the contents of the /proc/cpuinfo file, which contains information about the CPU and its features.

```cmd
cat /proc/cpuinfo
```

3. dmidecode: This command retrieves information from the system DMI (Desktop Management Interface) table, including CPU details.

```cmd
sudo dmidecode -t processor
```
<<<<<<< HEAD

4. To check RAID information, you can use the mdadm command:

* Replace /dev/mdX with the appropriate RAID device path (e.g., /dev/md0).

```cmd
sudo mdadm --detail /dev/mdX
```

5. Additionally, you can examine the /proc/mdstat file for RAID status:

<<<<<<< HEAD
||||||| c87f80a... Update hard-check-centos7.md

4. To check RAID information, you can use the mdadm command:

* Replace /dev/mdX with the appropriate RAID device path (e.g., /dev/md0).

```cmd
sudo mdadm --detail /dev/mdX
```
=======
>>>>>>> parent of c87f80a... Update hard-check-centos7.md
||||||| 04ebc51
=======
```cmd
cat /proc/mdstat
```

6. How to find network card details

```cmd
lspci
```
>>>>>>> 0450db6c264d3691d326a5c044db293c8699b310
