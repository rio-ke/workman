#!/user/bin/env bash

# finding unique element in a string

set -x

my_string="ACBIROMNBV"

echo $my_string | grep -o "." | uniq
