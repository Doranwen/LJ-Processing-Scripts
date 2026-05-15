# LJ-Processing-Scripts
A collection of scripts for processing downloaded livejournals (converting html to pdf, saving images, extracting links, zipping folders, and downloading photo album images).  These are designed to run on Linux.

## General Setup & Required Programs
Under one folder, create subfolder "Text4AT" as well as at least one other subfolder to put the scripts into.  I recommend a separate subfolder each for pdf processing, image processing, link extraction / zipping, and photo album image downloading.

Under the "Text4AT" folder, create the following folders:  "AllLinks", "LJlinks", and "Names".  I recommend also creating folders "Imgur", "Other", and "Photobucket" to move the resulting text files into.

Curl and wget must be installed.

Place gallery-dl.bin in the image processing folder:  https://github.com/mikf/gallery-dl

Add a .conf file for gallery-dl and modify the base-directory line so it reads `"base-directory": "./",`

Place html2pdf in the pdf processing folder and make sure it has a headless browser installed:  https://github.com/vermaysha/html2pdf

## Usage for autopdf, imagegrab, and extractlinks
1.  Take downloaded livejournal inside folder (named by the journal's name) and place that folder in the pdf processing folder.
2.  Run autopdf.sh from the pdf processing folder.
3.  Move LJ folder to image processing folder.
4.  Run imagegrab.sh from the image processing folder.
5.  Move LJ folder to link extraction folder.
6.  Run extractlinks.sh from the link extraction folder.
7.  (Optionally) Also run autozip.sh from the link extraction folder, and move resulting zip where you want it.
8.  Tidy up the results by moving the imgur and other links files under "Text4AT" to the appropriate subfolders.

## End Result
You should end up with a folder that has a pdf for every html file, a subfolder for each post with any images besides LJ userpics, a subfolder for all userpics (from every comment and post), and a subfolder called "ImageLinks", in which the link to every embedded image on every post should be recorded in a a txt file per post.

You should end up with txt files under "Text4AT" beginning with "imgur-", "other-", and "photobucket-".  There should be one "other-" file for each LJ name, and "photobucket-" files will occur the vast majority of the time, but files beginning with "imgur-" will be less likely; they should only appear for LJs which had embedded imgur files in them.

You should also end up with txt files under "AllLinks", "LJlinks", and "Names" for many LJs.  Nearly all LJs should have corresponding files in "AllLinks" and all will have files for "LJlinks", but fewer may have files in "Names".

## Explanation of Results
The files beginning with "imgur-" list every embedded pic link for Imgur which appeared in that LJ.

The files beginning with "photobucket-" list every embedded pic link for Photobucket which appeared in that LJ.

The files beginning with "other-" list every embedded pic link for sites other than Imgur and Photobucket, which appeared in that LJ.

The files in "AllLinks" contain all regular links (not embedded pictures) to sites other than LiveJournal.  (Note that LJ referers have been stripped.)

The files in "LJlinks" contain all links with "livejournal" in the url somewhere.  This includes links within the same LJ.

The files in "Names" contain the names of all journals which had specific posts *linked to* from that LJ.  This can be useful in the example of a fic or icon community, to get a list of the personal journals to which people posted their fics and graphics.

## Usage for photodl
1.  Install DownThemAll! (or other similar extension) in your browser.
2.  Visit the url for a LJ photo album.
3.  Launch downloading window for the extension, and filter by "mode=view".  It should select a set of urls that all look like this:  `https://username.livejournal.com/photo/album/idnumber/?mode=view&id=photoid` where `username` is the username for that LJ user, `idnumber` is the specific numeric string for that photo album, and `photoid` is the specific numeric string for each individual photo in that album.  The `photoid` is the part that will be different for each of the links.
4.  Download them, making sure to auto-rename conflicting files (it will try to name each html file as `idnumber` which is obviously the same for every photo in that album).
5.  Create a folder using the album's name (no spaces!) as the folder name.
6.  Move the downloaded files into that folder, and move that folder as a subfolder of the photo album image downloading folder.
7.  Run photodl.sh from the photo album image downloading folder.

For each subfolder of photo album html files, it should automatically extract all the links of the photos in that album and put them in a txt file, delete the html files, and download all the images from the links in the txt file.

## Questions & Explanations
### Q:  Why do the "AllLinks" and such files go in their own folder but the "imgur-", "photobucket-", and "other-" files don't?
A:  I wanted to be able to easily track which folders in a batch had finished image processing.  During periods of long downloading of files (such as userpics) it can be impossible to tell which LJ is being worked on.  Looking in the Text4AT folder makes it abundantly clear; the next folder alphabetically after the final "other-" file is the one currently being worked on.

### Q:  My LJlinks folder is empty!  All the rest work.  What do I do?
A:  Rename "LJlinks" to "Ljlinks" and edit your copy of extractlinks.sh accordingly.  This fixed the issue for one computer I tried it on.

### Q:  The script only works on one folder and then quits!
A:  Check that the file path has no spaces in it.  Having spaces in the file path (even if it's a folder or two above the one you're working in) can cause issues.
