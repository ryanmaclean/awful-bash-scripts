#!/bin/env bash

## Rename IAM user(s) in AWS for a specific profile

## Takes three arguments, in order, like `iam_rename.sh jill.thornton jill.smith test-env`

OLDIAM=$1
NEWIAM=$2
PROFILE=$3

aws iam update-user --user-name $OLDIAM --new-user-name $NEWIAM --profile $PROFILE
