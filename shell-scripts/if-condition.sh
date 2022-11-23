#!/usr/bin/env bash

set -x

var=5

if [ $var != 10 ]; then
    echo "correct"
else
    echo "wrong"
fi
