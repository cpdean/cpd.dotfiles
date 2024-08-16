#!/usr/bin/env bash -e

# file in the form of
#JIRA_HOST=yourcompany.atlassian.net
#JIRA_TOKEN=token # mint one at https://id.atlassian.com/manage-profile/security/api-tokens
#JIRA_USER=jira email i think
# find userid by using the query builder and then switch to raw. then look at the query parms in the url
#JIRA_USER_ID=some number
source $HOME/.jirapass

RAW_QUERY="assignee in ($JIRA_USER_ID) and status != \"Completed\" and status != \"Closed\" and status != \"Done\" AND status != \"Will not do\" AND created >= -150d order by created DESC"

QUERY=$(echo "${RAW_QUERY}" | python3 -c "import sys, urllib.parse as p; print(p.urlencode({'jql': sys.stdin.read().strip()}))")

CACHE=~/.my-jira-cache
if [[ -f  $CACHE ]]; then
    cat $CACHE
else
    curl \
        -s \
        -u $JIRA_USER:$JIRA_TOKEN \
        -X GET \
        -H "Content-Type: application/json" \
        https://$JIRA_HOST/rest/api/2/search?$QUERY |
        jq -r '.issues[] | "\(.key)\tJIRA: \(.fields.summary)"'
fi

$(curl \
    -s \
    -u $JIRA_USER:$JIRA_TOKEN \
    -X GET \
    -H "Content-Type: application/json" \
    https://$JIRA_HOST/rest/api/2/search?$QUERY |
    jq -r '.issues[] | "\(.key)\tJIRA: \(.fields.summary)"' > ~/.my-jira-cache &)
