#!/bin/bash

# Get host name
host_name=$(hostname)

# Get OS information
os_info=$(grep -E '^(NAME|VERSION)=' /etc/os-release | awk -F= '{print $2}' | sed 's/"//g')

# Get hardware make and model
make=$(sudo dmidecode -s system-manufacturer 2>/dev/null)
model=$(sudo dmidecode -s system-product-name 2>/dev/null)

# Display the information
echo "Host Name: $host_name"
echo "Operating System:"
echo "$os_info"
echo "Make: $make"
echo "Model: $model"
