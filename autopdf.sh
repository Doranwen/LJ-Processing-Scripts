#!/bin/bash

# loop that goes through each subfolder
for d in */ ; do
    echo "Beginning to process $d..."
    cd "$d"
# loop that looks for each html file in the directory and converts it to a pdf file in the same directory
    for f in *.html; do
        ../html2pdf -p "Letter" "$f" ./"$f".pdf &>>../output.log
    done
    cd ..
    echo "Finished processing $d!"
done
