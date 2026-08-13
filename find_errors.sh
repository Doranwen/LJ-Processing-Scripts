#!/bin/bash

# loop that goes through each subfolder
for d in */ ; do
    echo "Beginning to process $d..."
    cd "$d" || exit
    folder=$(echo "$d" | sed 's:/*$::')

# extract errors
    grep -A 1 "error: 412" image-download-status.log > ../errors.txt
    grep -A 1 "error: 503" image-download-status.log >> ../errors.txt
    cd ..

# check if error file has anything in it
    if grep -q . errors.txt; then

# move files with something in them
        mv errors.txt ../Text4AT/errors-"$folder".txt

    else

# delete empty files
        rm errors.txt
    fi
done
