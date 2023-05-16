#!/usr/bin/env bash
for user in $(cut -f1 -d: /etc/passwd)
do
    echo $user
    echo "-------"
    crontab -u $user -l | grep -v "#"
    echo " "
done
