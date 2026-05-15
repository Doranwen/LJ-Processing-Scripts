#!/bin/bash

# loop that goes through each subfolder
for d in */ ; do
    echo "Beginning to process $d..."
    cd "$d" || exit
# Derive album name
    dtrimmed=$(echo "$d" | sed 's:/*$::')
# create folder for pictures
    mkdir ../temp
# loop that looks for each html file in the directory and performs desired tasks
    for f in *.html; do
# extract urls and dump into txt file in folder
        grep "og:image" "$f" | grep -oP 'content="\K[^"?]+' >> PhotoLinks.txt
    done
# move PhotoLinks file
    mv PhotoLinks.txt ../temp/PhotoLinks.txt
# change directory
    cd ..
# delete original directory and html files
    rm -rf "$d"
# rename temp directory
    mv "temp" "$dtrimmed"
# change directory
    cd "$dtrimmed"
# download images 
    wget -w 2 -i PhotoLinks.txt
# change directory
    cd ..
done

