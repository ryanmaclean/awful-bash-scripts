#!/usr/bin/env bash

## Rename IAM user(s) in AWS for a specific profile

## Takes three arguments, in order, like `iam_rename.sh jill.thornton jill.smith test-env`
## Check that we have the right amount of arguments (3)
if test "$#" -ne 3; then
    echo "Missing either the old IAM name, new IAM name or AWS profile"
    echo "example - iam_rename.sh jill.thornton jill.smith test-env"
fi

## Defining vars so one-liner is easier to read
OLDIAM=$1
NEWIAM=$2
PROFILE=$3

## The one-liner itself, if you're just changing one user, 
## updating and pasting this line may be the fastest approach.
aws iam update-user --user-name $OLDIAM --new-user-name $NEWIAM --profile $PROFILE
