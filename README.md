# LJ-Processing-Scripts
A collection of scripts for processing downloaded livejournals (converting html to pdf, saving images, extracting links, zipping folders).  These are designed to run on Linux.

## General Setup & Required Programs
Under one folder, create subfolder "Text4AT" as well as at least one other subfolder to put the scripts into.  I recommend a separate subfolder each for pdf processing, image processing, and link extraction / zipping.
Under the "Text4AT" folder, create the following folders:  "AllLinks", "LJlinks", and "Names".  I recommend also creating folders "Imgur" and "Other" to move the completed scripts into.
Curl must be installed.
Place gallery-dl.bin in the image processing folder:  https://github.com/mikf/gallery-dl
Add a .conf file for gallery-dl and modify the base-directory line so it reads `"base-directory": "./",`
Place html2pdf in the pdf processing folder and make sure it has a headless browser installed:  https://github.com/vermaysha/html2pdf

## Usage
1.  Take downloaded livejournal inside folder (named by the journal's name) and place that folder in the pdf processing folder.
2.  Run autopdf.sh from the pdf processing folder.
3.  Move LJ folder to image processing folder.
4.  Run imagegrab.sh from the image processing folder.
5.  Move LJ folder to link extraction folder.
6.  Run extractlinks.sh from the link extraction folder.
7.  (Optionally) Also run autozip.sh from the link extraction folder, and move resulting zip where you want it.
8.  Tidy up the results by moving the imgur and other links files under "Text4AT" to the appropriate subfolders.

## End Result
You should end up with a folder that has a pdf for every html file, a subfolder for each post with any images besides LJ userpics, a subfolder for all userpics (from every comment and post), and a subfolder caled "ImageLinks", in which the link to every embedded image on every post should be recorded in a a txt file per post.
You should end up with txt files under "Text4AT" beginning with "imgur-" and "other-".  There should be one "other-" file for each LJ name, but files beginning with "imgur-" will be less likely; they should only appear for LJs which had embedded imgur files in them.
You should also end up with txt files under "AllLinks", "LJlinks", and "Names" for many LJs.  Most LJs should have corresponding files in "AllLinks" and "LJlinks" but fewer may have files in "Names".

## Explanation of Results
The files beginning with "imgur-" list every embedded pic link for imgur which appeared in that LJ.
The files beginning with "other-" list every embedded pic link for sites other than imgur, which appeared in that LJ.
The files in "AllLinks" contain all regular links (not embedded pictures) to sites other than LiveJournal.  (Note that LJ referers have been stripped.)
The files in "LJlinks" contain all links with "livejournal" in the url somewhere.  This includes links within the same LJ.
The files in "Names" contain the names of all journals which were *linked to* from that LJ.  This can be useful in the example of a fic or icon community, to find the personal journals to which people posted their fics and graphics.

## Questions & Explanations
### Q:  Why do the "AllLinks" and such files go in their own folder but the "imgur-" and "other-" files don't?
A:  I wanted to be able to easily track which folders in a batch had finished image processing.  During periods of long downloading of files (such as userpics) it can be impossible to tell which LJ is being worked on.  Looking in the Text4AT foler makes it abundantly clear; the next folder alphabetically after the final "other-" file is the one currently being worked on.

### Q:  My LJlinks folder is empty!  All the rest work.  What do I do?
A:  Rename "LJlinks" to "Ljlinks" and edit your copy of imagegrab.sh accordingly.  This fixed the issue for one computer I tried it on.
