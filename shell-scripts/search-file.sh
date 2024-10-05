#!/bin/bash

#set -x

search_dir="/home/kali/bash"
file="wrongname.txt"
#log_file="$HOME/bash/logfile.log" 

if [ ! -d "$search_dir" ]; then
    echo "Error: Dir $search_dir does not exits"
    exit 1
fi

#search file
found_file=$(find "$search_dir" -type f -name "$file"  2>/dev/null)

if [ -n "$found_file" ]; then
    echo "File found: $found_file"

else
    # Log the message if the file isn't found
    echo "File $file not found in $search_dir" | tee -a "$log_file"
    exit 1 
fi
