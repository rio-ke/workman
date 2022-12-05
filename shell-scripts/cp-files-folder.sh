#!/user/bin/env bash

set -x

ll /home/rcms-lap-173/Documents | grep -H total | awk -f '{print $ (9)}'

