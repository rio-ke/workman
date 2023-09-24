#!/usr/bin/env bash

# Discover san node
iscsiadm -m discovery -t st -p 192.168.5.221:3260


# Login san with Targetname
iscsiadm -m node --targetname "iqn.1991-10.com.ami:itx3cecef01808a9033:l.radmus" --portal "192.168.5.221:3260" --login

# Sleep time for login to get information
sleep 60

# Get uuid from san

ls -lth /dev/disk/by-uuid

uuid=$(ls -lth /dev/disk/by-uuid | grep b53a796d-edc9-4390-9989-fe06bec1ef6f | awk {'print $9'})

# Mount dicks use uuid
mount -U $uuid /RADMUS
