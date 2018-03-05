#!/usr/bin/env bash
# Assumes that jq is install (via brew install jq on macOS)
command -v jq >/dev/null 2>&1 || { echo >&2 "You will need jq in order to use this tool, installing it now"; brew install jq; }

# Export can be found here: https://api.slack.com/methods/users.list/test
# Note that the CSV download (as admin, users page) may be easier to use
# Change this to match your export
JSON_EXPORT=slack_users.json

# Filter json file using '' and -r to only output email addresses and to remove quotes
jq -r '.members[] | select(.deleted == false) | .profile.email'
