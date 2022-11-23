#!/usr/bin/env bash

# set -x

#input = hi 
# while [ "$input"  != "bye"]
# do
#             echo "this wish too is late"
# done

INPUT_STRING=hello
while [ "$INPUT_STRING" != "bye" ]
do
  echo "Please type something in (bye to quit)"
  read INPUT_STRING
  echo "You typed: $INPUT_STRING"
done