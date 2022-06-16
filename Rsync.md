## Rsync configuration


* Rsync is used for mirroring, performing backups, or migrating data to other servers. This tool is fast and efficient, copying only the changes from the source and offering customization options. Follow this tutorial to learn how to use rsync with 20 command examples to cover most use-cases in Linux.

  - Copying/syncing to/from another host over any remote shell like ssh, rsh.
  - Copying/Syncing through rsync daemon using TCP.


*_Syntax of rsync:_*

```bash
rsync [options] source [destination]
```

_**rsync command option:**_

 -v, --verbose           increase verbosity
 -r, --recursive         recurse into directories
 -a, --archive           archive mode
 -z, --compress          compress file data during the transfer
 -h, --human-readable    output numbers in a human-readable forma
 -n, --dry-run           perform a trial run with no changes made

----

**_Copy/Sync Files and Directory Locally_**


   * sync a single file on a local machine from one location to another location.

```bash

rsync options source destination

```

**_Copy/Sync Files and Directory Locally_**

```bash
rsync options /source/file_name(option) /destination

rsync -rzavh ~/folder_name/*  ~/backup
```
-----

**_sending files through local machine to remote server_**

*_Syntax of rsync:_*


```bash

rsync local-file user@remote-host:/destination_directory

```
*_Syntax of rsync:_*

```bash
rsync -ravh ~/hardlink/hulk dodo@192.168.0.113:/backup

```

**_Copy/rsync file from Remote server to a Local Machine_**


```bash

rsync -ravbh dodo@192.168.0.113:/home/dodo/backup  /home/user/storage

```

**_Use of –include and –exclude Options_**

























