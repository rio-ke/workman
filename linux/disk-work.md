# wipefs device or resource busy





_error_
 * Can't initialize physical volume "/dev/drbd0" of volume group "drbd-vg" without -ff
  /dev/drbd0: physical volume not initialized.
  
 * A volume group called drbd-vg already exists.

 * wipefs: error: /dev/drbd0: probing initialization failed: Read-only file system

 * wipefs: error: /dev/sdb: probing initialization failed: Device or resource busy


```cmd
wipefs -af /dev/sdb
```


