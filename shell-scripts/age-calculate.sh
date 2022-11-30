#!/usr/bin/env bash

set -x

read -p "enter your birthyear:" yr

printf "%2d\n" $(date -d "-$(date + $yr) year" +$Y)
