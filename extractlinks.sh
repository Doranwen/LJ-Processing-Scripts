#!/bin/bash

# loop that goes through each subfolder
for d in */ ; do
    echo "Beginning to process $d..."
    cd "$d" || exit
    folder=$(echo "$d" | sed 's:/*$::')
    urlname=$(echo "$folder" | sed 's/\_/\-/')

# loop that looks for each html file in the directory and performs desired tasks
    for f in *.html; do

# extract links
        grep -Po '(?<=href=")[^"]*' "$f" >> links1.txt
    done

# sort, dedupe, & remove referer
    cat links1.txt  |  sed 's/https\:\/\/www\.livejournal\.com\/away\?to\=//' | sed 's/\%3A/\:/' | sed 's/\%2F/\//' | sort -u > links2.txt

# extract LJ links
    grep "livejournal" links2.txt > ../links3.txt

# extract non-LJ links & 
    grep -v "livejournal" links2.txt > ../alllinks1.txt

# dedupe & remove temp files
    rm links1.txt links2.txt
    cd ..

# remove non-viable links
    grep "http" alllinks1.txt > alllinks2.txt

# move result to holding folder for AT
    mv alllinks2.txt ../Text4AT/AllLinks/"$folder"-alllinks.txt

# extract post links only
    grep 'html' links3.txt > links4.txt

# exclude links within the same LJ
    grep -v -e "$folder" -e "$urlname" links4.txt > links5.txt

# move AT file to holding folder
    mv links3.txt ../Text4AT/LJlinks/"$folder"-ljlinks.txt

# filter to usernames only
    grep -aioPh '((?<=:\/\/)(?!(www|community|users))[^\.]+(?=\.livejournal\.com)|((?<=\?user=)[^&]+)|((?<=:\/\/community\.livejournal\.com\/)[^\/]+)|(?<=livejournal\.com\/users\/)[^\/]+|(?<=livejournal\.com\/community\/)[^\/]+|((?<=:\/\/users\.livejournal\.com\/)[^\/]+))' links5.txt | sed 's/\-/\_/' | sort -u > "$folder"-ljnames.txt

# delete temp files
    rm links4.txt links5.txt alllinks1.txt

# check if links files have anything in them
    if grep -q . "$folder-ljnames.txt"; then

# move files with something in them
        mv "$folder"-ljnames.txt ../Text4AT/Names/"$folder"-ljnames.txt

    else

# delete empty files
        rm "$folder"-ljnames.txt
    fi

done
