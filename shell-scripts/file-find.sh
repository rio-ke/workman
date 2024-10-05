#!/bin/bash

#set -x

search_dir="/home/kali/bash"

file="drun.sh"


if [ ! -d $search_dir ]; then
    echo "Error: Dir $search_dir does not exits"
else
    echo "File $target_file not found in $search_dir" | tee -a /path/to/logfile.log
    exit 1
fi

#search file
found_file=$(find $search_dir -type f -name $file  2>/dev/null)

if [ -n $found_file ]; then
    echo "File found: $found_file"

else
    echo "File $target_file not found in $search_dir"

fi

