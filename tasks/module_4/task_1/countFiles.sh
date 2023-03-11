#!/usr/bin/env bash

if  (($#>0)); then
    dir=$1
else
    read -p "provide a directory " dir
    while [[ -z "$dir" ]]; do
        read -p "I need an answer!"
    done
fi

num=$(find $dir -type f | wc -l)
echo $num