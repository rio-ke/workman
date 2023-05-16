#!/bin/bash
cores=$(nproc) 
load=$(awk '{print $3}'< /proc/loadavg)
echo | awk -v c="${cores}" -v l="${load}" '{print "relative load is " l*100/c "%"}'
