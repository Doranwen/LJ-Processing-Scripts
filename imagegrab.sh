#!/bin/bash

# loop that goes through each subfolder
for d in */ ; do
    echo "Beginning to process $d..."
    cd "$d" || exit
# create picture links folder for txt files & temp folder for temp files
    mkdir ImageLinks
    mkdir ../temp
# loop that looks for each html file in the directory and performs desired tasks
    for f in *.html; do
        echo "Beginning to process $f..."
# set post name as variable
        post=$(basename "$f" .html)
# extract urls and dump into txt file in folder
                grep -oP 'src="\K[^"?]+|src='\''\K[^'\''?]+|background: url\(\K[^)]+|background-image: url\(\K[^)]*' "$f" > ImageLinks/"$post".txt
# check if there are Photobucket urls in the txt file, and run loop if yes
        if grep -q "photobucket" ImageLinks/"$post".txt; then
# extract Photobucket urls from txt file to temporary file
            grep "photobucket" ImageLinks/"$post".txt | sort -u > temp.txt
# strip bad strings from urls & fix s to i, pbr to i, and add missing img
            sed 's/\~.*//' temp.txt | sed 's|://s|://i|' | sed 's|://pbr|://i|' | sed 's|://photobucket|://img\.photobucket|' > temp1.txt
# run gallery-dl on Photobucket urls
            ../gallery-dl.bin --sleep 0.0-0.5 -i temp1.txt
# remove temporary file
            rm temp1.txt
# check if directory already exists & remove directlink
            if [ -d "$post" ]; then
                mv directlink/* "$post"
                rmdir directlink
            else
# rename download folder to the post number
                mv directlink "$post"
            fi
# move temp file to where it can be collected
            mv temp.txt ../temp/photobucket-"$post".txt
        fi
# check if there are Livejournal hosted urls in the txt file, and run loop if yes
        if grep -Eq "https://imgprx.livejournal.net/|https://pics.livejournal.com/|https://ic.pics.livejournal.com/|https://l-files.livejournal.net/vgift/" ImageLinks/"$post".txt; then
# extract LJ urls from txt file to temporary file
            grep -E "https://imgprx.livejournal.net/|https://pics.livejournal.com/|https://ic.pics.livejournal.com/|https://l-files.livejournal.net/vgift/" ImageLinks/"$post".txt | sort -u > temp.txt
# create directory for pictures if it doesn't already exist
            mkdir -p "$post"
# loop through each url
            while read -r ljlink; do
# check if pic is imgprx.livejournal.net
                if (echo "$ljlink" | grep -Eq "https://imgprx.livejournal.net"); then
# extract real link
                    reallink=$(curl -Ls -o /dev/null -w %{url_effective} "$ljlink")
# save real link
                    echo "$reallink" >> imgprx.txt
# strip real link of any strings with ?
                    redirect=$(echo "$reallink" | sed 's/\?.*//')
# check if link is for Photobucket
                    if [[ "$redirect" == *"photobucket"* ]]; then
# strip bad strings from urls & fix s to i, pbr to i, and add missing img
                        fixedlink=$(echo "$redirect" | sed 's/\~.*//' | sed 's|://s|://i|' | sed 's|://pbr|://i|' | sed 's|://photobucket|://img\.photobucket|')
# run gallery-dl on Photobucket urls
                        (cd "$post" && ../../gallery-dl.bin --sleep 0.0-0.5 "$fixedlink")
# check if directory already exists & remove directlink
                        if [ -d "$post" ]; then
                            mv directlink/* "$post"
                            rmdir directlink
                        else
# rename download folder to the post number
                            mv directlink "$post"
                        fi
# check if link is for imgprx
                    elif (echo "$redirect" | grep -Eq "https://imgprx.livejournal.net"); then
# extract pic name
                        ljimg=$(echo "$redirect" | sed -E 's/.*(..........)/\1/' | sed -E 's/\-/\_/')
# download link
                        (cd "$post" && curl -fL --output "$ljimg" "$redirect")
# add extension
                        (cd "$post" && mv "$ljimg" "$ljimg.$(grep "^$(file --brief --mime-type "$ljimg")[[:space:]]" /etc/mime.types | sed 's/.*[[:space:]]//')")
                    else
# download link
                        (cd "$post" && wget --content-disposition "$redirect")
                    fi
# check if pic is pics.livejournal.com or ic.pics.livejournal.com
                elif (echo "$ljlink" | grep -Eq "pics.livejournal.com"); then
# get largest version of pic
                    bigimg=$(echo "$ljlink" | sed 's,/s[0-9]*x[0-9]*$,,')
# fix filename
                    ljimg=$(echo "$bigimg" | sed 's/.*https\:\/\/pics.livejournal.com\///' | sed 's/.*https\:\/\/ic.pics.livejournal.com\///' | sed 's/\//-/g')      
# download link
                    (cd "$post" && curl -fL --output "$ljimg" "$bigimg")              
                else
# if pic is l-files.livejournal.net, extract pic name
                    ljimg=$(echo "$ljlink" | sed 's/^.\{38\}//' | sed 's/\//-/g')
# download link
                    (cd "$post" && curl -fL --output "$ljimg" "$ljlink")
# add extension
                    (cd "$post" && mv "$ljimg" "$ljimg.$(grep "^$(file --brief --mime-type "$ljimg")[[:space:]]" /etc/mime.types | sed 's/.*[[:space:]]//')")
                fi
# sleep to avoid ip bans
                sleep 1
            done <temp.txt
# move any gallery-dl files into main post folder and remove unnecessary folder
            (cd "$post" && mv directlink/* . && rmdir directlink)
# move temp files to where they can be collected
            mv temp.txt ../temp/lj1-"$post".txt
            cp imgprx.txt ImageLinks/"$post"-redirect.txt
            mv imgprx.txt ../temp/redirect-"$post".txt
        fi
# check if there are Imgur hosted urls in the txt file, and run loop if yes
        if grep -Eq "imgur.com" ImageLinks/"$post".txt; then
# extract LJ urls from txt file to temporary file
            grep -E "imgur.com" ImageLinks/"$post".txt | sort -u > temp.txt
# create directory for pictures if it doesn't already exist
            mkdir -p "$post"
# loop through each url
            while read -r imglink; do
# extract userpic name
                imgurimg=$(echo "$imglink" | sed 's@.*https\?\://\(i.\)\?imgur.com/@@i' | sed 's@/@-@g')
# download link
                (cd "$post" && curl -fL --output "$imgurimg" "$imglink")
# sleep to avoid ip bans
                sleep 1
            done <temp.txt
# move temp file to where it can be collected
        mv temp.txt ../temp/imgur-"$post".txt
        fi
# check if there are Flickr hosted urls in the txt file, and run loop if yes
        if grep -Eq "flickr.com" ImageLinks/"$post".txt; then
# extract LJ urls from txt file to temporary file
            grep -E "flickr.com" ImageLinks/"$post".txt | sort -u > temp.txt
# create directory for pictures if it doesn't already exist
            mkdir -p "$post"
# loop through each url
            while read -r flickrlink; do
# download link
                (cd "$post" && wget --content-disposition "$flickrlink")
# sleep to avoid ip bans
                sleep 1
            done <temp.txt
# move temp file to where it can be collected
        mv temp.txt ../temp/flickr-"$post".txt
        fi
    done
# combine all txt files in picture posts, sort unique, and dump to temporary file
    cat ImageLinks/*.txt | sort -u > temp.txt || exit
# extract LiveJournal userpics to temporary file
    grep "l-userpic.livejournal.com" temp.txt > temp2.txt
# create directory for userpics
    mkdir "userpics"
# loop through each userpic link
    while read -r ulink; do
# extract userpic name
        userpic=$(echo "$ulink" | sed 's/.*https\:\/\/l-userpic.livejournal.com\///' | sed 's/\//-/g')
# download each link
        (cd userpics && curl -fL --output "$userpic" "$ulink")
# sleep to avoid ip bans
        sleep 1
    done <temp2.txt
# fix userpic extensions & remove bogus files
    (cd userpics && for f in *; do mv "$f" "$f.$(grep "^$(file --brief --mime-type "$f")[[:space:]]" /etc/mime.types | sed 's/.*[[:space:]]//')"; done && rm *.gz)
# trim trailing slash
    dtrimmed=$(echo "$d" | sed 's:/*$::')
# remove temporary file
    rm temp.txt
# move temp file to where it can be collected
    mv temp2.txt ../temp/lj2-"$dtrimmed".txt
# check if there are Imgur hosted urls in the temp folder, and run loop if yes
    if test -n "$(find ../temp/ -maxdepth 1 -name 'imgur*' -print -quit)"; then
# combine Imgur links
        (cd ../temp/ && cat imgur-* | sort -u > ../../Text4AT/imgur-"$dtrimmed".txt)
# remove Imgur files
        (cd ../temp/ && rm imgur-*)
    fi
# check if there are Photobucket hosted urls in the temp folder, and run loop if yes
    if test -n "$(find ../temp/ -maxdepth 1 -name 'photobucket*' -print -quit)"; then
# combine Imgur links
        (cd ../temp/ && cat photobucket-* | sort -u > ../../Text4AT/photobucket-"$dtrimmed".txt)
# remove Imgur files
        (cd ../temp/ && rm photobucket-*)
    fi
# combine other links
    (cd ../temp/ && cat ./* | sort -u > ../../Text4AT/other-"$dtrimmed".txt)
# remove empty directories and files inside LJ folder
    find . -type f -empty -print -delete -o -type d -empty -print -delete
# move back to main folder where script lives
    cd ..
# remove temp folder & files inside
    rm -rf temp
    echo "Finished processing $d!"
done
