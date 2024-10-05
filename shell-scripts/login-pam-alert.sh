#!/bin/env bash

set -x

#Change these two lines:
sender="kendanicrio@gmail.com"
recepient="riochamp3603@gmail.com"

if [ "$PAM_TYPE" != "close_session" ]; then
    host="`hostname`"
    subject="SSH Login: $PAM_USER from $PAM_RHOST on $host"
    # Message to send, e.g. the current environment variables.
    message="`env`"
    echo "$message" | mailx -r "$sender" -s "$subject" "$recepient"
fi
