#!/bin/bash

LOG_FILE="/var/log/vsftpd.log"
TARGET_USER="desired_username"

LAST_USER=$(grep "OK LOGIN" "$LOG_FILE" | tail -n 1 | awk '{print $8}')

if [ -n "$LAST_USER" ]; then
    if [ "$LAST_USER" == "$TARGET_USER" ]; then
        # Send to Slack using a webhook or another method
        # Example: slack-cli or curl with Slack API
        echo "Target user $TARGET_USER logged in!" | slack-cli [slack-webhook-url]
    fi
fi
