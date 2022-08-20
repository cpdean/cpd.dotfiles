#!/usr/bin/env bash
source $HOME/.jirapass

QUERY=jql=not+%28status+%3D++Done%29+AND+assignee+in+%28$USER_ID%29

curl \
    -s \
    -u $USER:$TOKEN \
    -X GET \
    -H "Content-Type: application/json" \
    https://$HOST/rest/api/2/search?$QUERY |
    jq -r '.issues[] | "\(.key)\tJIRA: \(.fields.summary)"'
