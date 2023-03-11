#!/usr/bin/env bash

# default value to use if none specified
PERCENT=90

# test for command line arguement is present
if [[ $# -le 0 ]]
then
    printf "Using default value for threshold!\n"
# test if argument is an integer
# if it is, use that as percent, if not use default
else
    if [[ $1 =~ ^-?[0-9]+([0-9]+)?$ ]]
    then
        PERCENT=$1
    fi
fi

let "PERCENT += 0"
printf "Threshold = %d\n" $PERCENT

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read -r output;
do
echo $output
    used=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
    disk=$(echo $output | awk '{print $2}')

    if [ $used -ge $PERCENT ]; then
        echo "WARNING: The disk \"$disk\" has used $used% of total available space - Date: $(date)"
    fi
done