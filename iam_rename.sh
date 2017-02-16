#!/bin/env bash

## Rename IAM user(s) in AWS for a specific profile

OLDIAM=$1
NEWIAM=$2
PROFILE=$3

aws iam update-user --user-name $OLDIAM --new-user-name $NEWIAM --profile $PROFILE
