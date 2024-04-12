#!/bin/bash

# Path to the file where the last execution timestamp is stored
LAST_EXECUTION_FILE="/path/to/last_execution.txt"

# Get the current date
CURRENT_DATE=$(date +%s)

# Check if the last execution file exists
if [ -f "$LAST_EXECUTION_FILE" ]; then
    # Read the last execution timestamp from the file
    LAST_EXECUTION=$(cat "$LAST_EXECUTION_FILE")

    # Calculate the difference in days between the current date and the last execution date
    DAYS_DIFF=$(( ($CURRENT_DATE - $LAST_EXECUTION) / (60 * 60 * 24) ))

    # Check if 15 days have passed since the last execution
    if [ $DAYS_DIFF -ge 15 ]; then
        # Update the last execution timestamp
        echo "$CURRENT_DATE" > "$LAST_EXECUTION_FILE"

        # Perform the task (e.g., run ClamAV scan)
        /usr/bin/freshclam
        /usr/bin/clamscan -r /path/to/scan
    fi
else
    # If the last execution file doesn't exist, create it and perform the task
    echo "$CURRENT_DATE" > "$LAST_EXECUTION_FILE"
    /usr/bin/freshclam
    /usr/bin/clamscan -r /path/to/scan
fi

