#!/usr/bin/env bash

#set -x

city1="chennai"
city2="mumbai"

if [[ $city1=="y" || $city2=="Y" ]]
then
    echo "go to near by place"
else
    echo "go to another place"
fi

####task 2
num=20
 
if [ $((num % 2)) == 0 ] || [ $((num % 5)) == 0 ];
then
    echo "$num is even or divisible by 5."
else
    echo "$num is not even or disible by 5."
fi


###task3

#!/bin/bash
read x
if [ $x="102" ] || [ $x="103"]
then
   echo "YES"
else
   echo "NO"
fi

####task4

#!/bin/bash

set -x

read x
if [[ $x="Y" ||  $x="y" ]]
then
echo "YES"
else
echo "NO"
fi