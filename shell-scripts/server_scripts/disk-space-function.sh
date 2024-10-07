#!/bin/bash

# disk_alert() {

#     threshold=${1:-80}
#     logfile="/var/log/disk_space.log"
    
#     usage=$(df -h / | grep '/' | awk '{ print $5 }' | sed 's/%//')

#     if [ $usage -gt $threshold ]; then
#         echo "Warrning mesg: Disk usgae gone upto $usage%"
#     else
#         echo "Its below ${threshold}"

#     fi
# }


# disk_alert 6


#!/bin/bash

# Function to check disk space and generate an alert
check_disk_space() {
    local threshold=${1:-80}  # Custom threshold or default to 80%
    local usage=$(df -h / | grep "/" | awk '{ print $5 }' | sed 's/%//')

    # Compare usage against the threshold
    if [ "$usage" -gt "$threshold" ]; then
        # Display notification using notify-send for GUI environments
        if command -v notify-send &> /dev/null; then
            notify-send "Disk Space Warning" "Disk space is critically high: ${usage}% (Threshold: $threshold%)"
        fi

        # Send system-wide message using wall (all logged-in users will see it)
        echo "Warning: Disk space is ${usage}% on the system!" | wall

        # Optional: Play a beep sound (if terminal supports it)
        echo -e "\a"

        echo "Current disk space is ${usage}% - Alert generated!"
    else
        echo "Disk space is normal: ${usage}%"
    fi
}

# Call the function with a custom threshold (optional)
check_disk_space 5
