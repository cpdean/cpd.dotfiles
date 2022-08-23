#!/usr/bin/env bash
source $HOME/.jirapass

RAW_QUERY="assignee in ($USER_ID) and status != \"Completed\" and status != \"Closed\" and status != \"Done\" AND status != \"Will not do\" AND created >= -150d order by created DESC"

QUERY=$(echo "${RAW_QUERY}" | python3 -c "import sys, urllib.parse as p; print(p.urlencode({'jql': sys.stdin.read().strip()}))")

CACHE=~/.my-jira-cache
if [[ -f  $CACHE ]]; then
    cat $CACHE
else
    curl \
        -s \
        -u $USER:$TOKEN \
        -X GET \
        -H "Content-Type: application/json" \
        https://$HOST/rest/api/2/search?$QUERY |
        jq -r '.issues[] | "\(.key)\tJIRA: \(.fields.summary)"'
fi

$(curl \
    -s \
    -u $USER:$TOKEN \
    -X GET \
    -H "Content-Type: application/json" \
    https://$HOST/rest/api/2/search?$QUERY |
    jq -r '.issues[] | "\(.key)\tJIRA: \(.fields.summary)"' > ~/.my-jira-cache &)
