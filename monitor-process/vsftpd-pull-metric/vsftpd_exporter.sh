#!/bin/bash

# Path to the VSFTPD log file
vsftpd_log="/var/log/vsftpd.log"

# Metrics counters
successful_logins=0
failed_logins=0

# Function to parse VSFTPD logs
parse_vsftpd_logs() {
    while read -r log; do
        if [[ $log == *"OK LOGIN"* ]]; then
            ((successful_logins++))
        elif [[ $log == *"FAILED LOGIN"* ]]; then
            ((failed_logins++))
        fi
    done < "$vsftpd_log"
}

# Function to expose metrics
expose_metrics() {
    echo "vsftpd_successful_logins $successful_logins"
    echo "vsftpd_failed_logins $failed_logins"
}

# Main execution
parse_vsftpd_logs
expose_metrics
