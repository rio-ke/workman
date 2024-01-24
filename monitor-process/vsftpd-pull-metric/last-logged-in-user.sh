#!/bin/bash

LOG_FILE="/var/log/vsftpd.log"
LAST_USER=$(grep "OK LOGIN" "$LOG_FILE" | tail -n 1 | awk '{print $8}')

if [ -n "$LAST_USER" ]; then
    # Send to Slack using a webhook or another method
    # Example: slack-cli or curl with Slack API
    echo "Last logged-in user: $LAST_USER" | slack-cli [slack-webhook-url]
fi
