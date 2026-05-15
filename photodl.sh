#!/bin/bash

# loop that goes through each subfolder
for d in */ ; do
    echo "Beginning to process $d..."
    cd "$d" || exit
# loop that looks for each html file in the directory and performs desired tasks
    for f in *.html; do
# extract urls and dump into txt file in folder
        grep "og:image" "$f" | grep -oP 'content="\K[^"?]+' >> PhotoLinks.txt
    done
# download images 
    wget -w 2 -i PhotoLinks.txt
# delete html files
    find . -name "*.html" -type f -delete
# change directory
    cd ..
done
