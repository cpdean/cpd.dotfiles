#!/usr/bin/env bash

# usage: open_in_github.sh ABS_FILE_PATH LINE_START [LINE_END]

# requires the github cli tool
# brew install gh

GITROOT=$(git rev-parse --show-toplevel)
FILEPATH=$1
LINE=$2
LINE_END=$3

# chop the git root off so we only get paths relevant to the repo
REPO_PATH=$(echo $FILEPATH | sed "s:$GITROOT::")
LOCATION=$LINE
if [ -n "$LINE_END" ]; then
    LOCATION="$LOCATION-$LINE_END"
fi

gh browse $REPO_PATH:$LOCATION
