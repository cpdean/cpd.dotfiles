#!/usr/bin/env bash

# USAGE github-url ABSOLUTE_PATH_TO_FILE SELECTION_DESC
# prints the url to display the selected lines in a web browser
# SELECTION_DESC the kakoune variable, ${kak_selection_desc}, which describes the start/end of the selection
# in the form of anchor_line,anchor_column.cursor_line,cursor_column, like 44,0.89,3

# extra / at the end so the later subst removes it from the front
GITROOT="$(git rev-parse --show-toplevel)/"
FILEPATH=${1/$GITROOT/}
SHA=$(git rev-parse head)

# use this mess of a regex to split the coords into capture groups, then pick the group you want
ANCHORLINE=$(echo $2 | sed "s_\([0-9]*\)\.\([0-9]*\),\([0-9]*\)\.\([0-9]*\)_\1_")
CURSORLINE=$(echo $2 | sed "s_\([0-9]*\)\.\([0-9]*\),\([0-9]*\)\.\([0-9]*\)_\3_")

# set the line ranges
# make sure the order is correct (kakoune's anchor/cursor positions may be flipped)
STARTLINE=$(($ANCHORLINE > $CURSORLINE ? $CURSORLINE : $ANCHORLINE))
ENDLINE=$(($ANCHORLINE > $CURSORLINE ? $ANCHORLINE : $CURSORLINE))


# extract the username/reponame from the git remote
# assumes github, sorry :(
# TODO: figure out how to support bitbucket, gitlab, native gitsite stuff
# TODO: figure out how to support https:// remotes. this was only tested on ssh:// urls
URL=$(git remote get-url origin | sed "s_.*github.com.\(.*\)\.git_https://github.com/\1_")

# if the anchor and cursor are on the same line (nothing's selected) tweak the url to only highlight one line
if [[  $STARTLINE == $ENDLINE ]]; then
    echo $URL/blob/$SHA/$FILEPATH#L$STARTLINE
else
    echo $URL/blob/$SHA/$FILEPATH#L$STARTLINE-L$ENDLINE
fi
